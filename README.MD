# Data Pipeline: PostgreSQL, Python, dbt e Airflow

Este projeto implementa um pipeline de dados completo para ingestão, tratamento e orquestração de dados. Utilizando as melhores práticas de engenharia de dados, como containerização, ingestão programática com Python, modelagem em camadas com o **esquema Medallion (bronze → silver → gold)** via `dbt`, e automação com **Apache Airflow**.

## Estrutura do Projeto
O projeto foi estruturado em três etapas:

1. **Banco de Dados PostgreSQL** com Docker Compose  e **Ingestão de dados via SQLAlchemy** com Python. [Repositório Etapa 1](https://github.com/diogo-minoru/projeto_airflow_dbt_local_setup)
2. **Modelagem dos dados com dbt** e o esquema Medallion. [Repositório Etapa 2](https://github.com/diogo-minoru/projeto_airflow_dbt_data_warehouse)
3. **Orquestração completa com Apache Airflow.** [Repositório Etapa 3](https://github.com/diogo-minoru/projeto_airflow_dbt_airflow)
4. **Análise dos dados com Power BI.** [Dashboard] ()

## Etapa 2 - Modelagem dos dados com dbt e o esquema Medallion

O **dbt** é uma ferramenta moderna de transformação de dados que permite criar pipelines de dados de forma declarativa, utilizando SQL e princípios de engenharia de software, como versionamento, modularização e testes.  
Com o dbt, é possível transformar dados brutos em modelos analíticos confiáveis, seguindo boas práticas como:

- **Modelagem modular:** os modelos são construídos em camadas reutilizáveis.  
- **Versionamento de código:** integração nativa com Git.  
- **Testes de qualidade:** validação de integridade e consistência dos dados.  
- **Documentação automatizada:** geração de documentação interativa dos modelos.

![DBT](/2_data_warehouse/dbt.png)

## Esquema Medallion

O **esquema Medallion** é uma arquitetura de camadas utilizada em Data Lakes e Data Warehouses para organizar e melhorar a qualidade dos dados à medida que eles avançam pelo pipeline de transformação.  
As camadas principais são:

1. **Bronze:**  
   Contém os dados brutos, exatamente como foram extraídos das fontes.  
   - Exemplo: logs, arquivos CSV, dados de APIs.  

2. **Silver:**  
   Dados já tratados e limpos, prontos para serem utilizados em análises exploratórias.  
   - Exemplo: normalização de campos, remoção de duplicatas.  

3. **Gold:**  
   Dados analíticos e agregados, prontos para consumo por dashboards, relatórios ou modelos de machine learning.  
   - Exemplo: métricas de negócio, KPIs e dados altamente transformados.

Essa abordagem facilita a governança e rastreabilidade dos dados, além de permitir que cada camada seja validada antes de avançar para a próxima.

![Medallion](/2_data_warehouse/medallion.png)

### **Estrutura do projeto:**
Abaixo, segue a estrutura das pastas, criado pelo próprio dbt pelo comando `dbt init`. Para organizar as transformações de forma clara e escalável, foi adotado o esquema Medallion dentro da pasta models:

```bash
2_data_warehouse/
├── logs/
│   └── dbt.log
├── projeto_airflow_dbt/
│   └── macros/
│       └── generate_schema_name.py
│   └── models/
│       └── bronze.py
│       └── silver.py
│       └── gold.py
├── packages.yml
├── package-lock.yml
└── dbt_project.yml
```

### **Descrição do modelo**
Os dados utilizados consiste em dados de demonstração do modelo Contoso, disponibilizado pela [Microsoft](https://github.com/sql-bi/Contoso-Data-Generator-V2).


**Diagrama Entidade Relacionamento Antes do ETL**
![ERD](/2_data_warehouse/erd_antes.png)

**Principais transformações realizadas**
1. **Conversão dos valores dos pedidos**
A tabela de `orders` (pedidos) contém diferentes moedas de acordo com a moeda utilizada pelo cliente no pagamento, portanto, foi realizado a conversão dos valores dos pedidos contidos na tabela `orderrows` para a moeda USD, criando novas colunas `total_net_order_usd`, `total_net_cost_usd` e `total_net_profit_usd` para a tabela `orderrows`.

**Arquivo `orderrows_silver.sql` do modelo.**
```sql
select 
    a.OrderKey,
	a.LineNumber,
	a.ProductKey,
	a.Quantity,
	a.NetPrice,
	a.UnitCost,
	(a.quantity * a.netprice) * c.exchange as total_net_order_usd,
	(a.quantity * a.unitcost) * c.exchange as total_net_cost_usd,
	((a.quantity * a.netprice) - (a.quantity * a.unitcost)) * c.exchange as total_net_profit_usd
	from {{ref("orderrows_bronze")}} a
    join {{ref("orders_bronze")}} b on a.orderkey = b.orderkey
    join {{ref("currencyexchange_bronze")}} c on b.orderdate = c.date and b.currencycode = c.fromcurrency
where c.tocurrency = 'USD'
```

2. **Criação de faixas de idade para a idade dos cliente**
Agrupando cada cliente em faixas etárias para análise de perfil de cliente.

```sql
select 
    CustomerKey,
    GivenName,
    Surname,
    givenname || ' ' || surname as customer_name,
    City,
    StateFull,
    CountryFull,
    Age,
    case when age < 18 then 'Menor que 18 anos'
         when age < 25 then 'Entre 18 e 24'
         when age < 35 then 'Entre 25 e 34'
         when age < 50 then 'Entre 35 e 49'
         when age < 60 then 'Entre 50 e 59'
         else 'Maior que 60' end as age_group
from {{ref("customer_bronze")}}
```

3. **Criação da tabela de datas para.**
Utilizando o pacote de utilizades do dbt `dbt_utils.date_spine`, é possível criar uma tabela de datas, tabela essencial para análise temporal em modelos no Power BI.

**Trecho do código `dates.sql` para geração das datas utilizando os pacotes dbt.**
```sql
{{
    dbt_utils.date_spine(
        datepart = 'day',
        start_date = "MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int - 10, 1, 1)",
        end_date   = "(MAKE_DATE(EXTRACT(YEAR FROM CURRENT_DATE)::int + 1, 12, 31) + 1)"
    )
}}
```

**Diagrama Entidade Relacionamento Depois do ETL**
![ERD](/2_data_warehouse/erd_depois.png)

## Execução do dbt

É possível executar determinadas transformações de acordo com a necessidade, utilizando comandos como `dbt run --select <modelo>`, `dbt seed`, `dbt snapshot` e `dbt test`.

Porém, o comando `dbt build` é uma forma prática de executar todo o pipeline do dbt de ponta a ponta em uma única etapa.Ele é responsável por rodar, na ordem correta:

- dbt seed – Carrega os arquivos CSV da pasta seeds para o banco de dados.
- dbt run – Compila e executa todos os modelos SQL do projeto, construindo as tabelas e views.
- dbt test – Executa todos os testes definidos (genéricos e customizados) para validar os dados.
- dbt snapshot – Cria snapshots (versionamento histórico de dados), caso existam.

[Repositório Etapa 3](https://github.com/diogo-minoru/projeto_airflow_dbt_airflow)