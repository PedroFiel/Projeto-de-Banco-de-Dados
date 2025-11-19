# 📊 Projeto Final: Engenharia e Análise de Dados - Mercado Financeiro B3

## 🎯 Visão Geral

Este projeto simula um **ciclo completo de engenharia e análise de dados** utilizando exclusivamente **T-SQL** no SQL Server. Nosso objetivo é aplicar conceitos avançados de **modelagem de dados**, **ETL**, **performance**, **segurança** e **análise de negócios** em datasets reais do mercado financeiro brasileiro.

### 📈 Tema Escolhido: Ações B3 por Segmento
**Objetivo:** Transformar dados históricos de 6 segmentos da B3 em insights acionáveis para análise de investimentos e comparação setorial.

**LINK-DATABASE**

-   **[Database](https://www.dadosdemercado.com.br/acoes)**
-   **[GitDatabase](https://github.com/Prog-LucasAlves/PUB_Dados_Financeiros_B3/tree/main/Api)**

**LINK-TRELLO**

-   **[Trello](https://trello.com/invite/b/68a3b8e15572c0cd0c4dfc074/ATTI16230693dc4ec9e91ab724c7eae705643DC6B3A6/projeto-banco-select)**

---

**Segmentos analisados:**
-     **Saneamento**  
-     **Bancos**  
-     **Eletricidade**  
-     **Telecomunicações**  
-     **Commodities**  
-     **Seguros**

---

### 📋 **Gestão & Documentação**
-     Versionamento Git + Kanban de tarefas
-     Plano de análise com perguntas de negócio definidas
-     Dashboard BI *(opcional - Power BI/Tableau)*

---

## 📅 Cronograma de Entregas

### **🚀 Fase 1: Concepção, Análise de Dados e Modelagem** *(Semanas 1-3)*

| Semana | Entrega | Foco |  
|--------|---------|------|
| **Semana 1** | **Kick-off e Análise Exploratória** | Definição do tema, encontrar e analisar o dataset bruto. Criação do repositório/Kanban.  
| **Semana 2** | **Requisitos e Plano de Análise** | Com base na análise, criar o Modelo Lógico e o documento do Plano de Análise, definindo as perguntas de negócio.  
| **Semana 3** | **Modelagem Física** | Finalizar o Modelo Físico com tipos de dados e constraints do SQL Server.  

### **⚙️ Fase 2: Estruturação, ETL e Carga** *(Semanas 4-6)*

| Semana | Entrega | Foco |
|--------|---------|------|
| **Semana 4** | **Construção do Banco (DDL)** | Criar todos os scripts DDL e executar a estrutura do banco.  
| **Semana 5** | **Desenvolvimento do Processo de ETL em T-SQL** | Codificar as Stored Procedures de ETL. Testar a extração e transformação com uma amostra dos dados.  
| **Semana 6** | **Execução do ETL e Consultas Exploratórias** | Executar o ETL completo. Criar consultas DQL para validar a carga e explorar os dados.  

### **🔧 Fase 3: Otimização e Análise** *(Semanas 7-10)*

| Semana | Entrega | Foco |
|--------|---------|------|
| **Semana 7** | **Views e Índices** | Criar views para simplificar a análise e índices para otimizar as futuras consultas analíticas.  
| **Semana 8** | **Stored Procedures Analíticas** | Implementar as Stored Procedures que respondem às perguntas do Plano de Análise, gerando métricas e relatórios.  
| **Semana 9** | **Triggers e Transações (DTL)** | Criar triggers para auditoria/validação e controlar transações.  
| **Semana 10** | **Segurança (DCL)** | Implementar a estratégia de segurança com logins, usuários e perfis.  

### **📋 Fase 4: Finalização e Entrega** *(Semanas 11-13)*

| Semana | Entrega | Foco |
|--------|---------|------|
| **Semana 11** | **Documentação e (Opcional) Dashboard** | Finalizar a documentação. Iniciar a criação do dashboard de BI (opcional).  
| **Semana 12** | **Preparação da Entrega Final** | Gravar o vídeo de demonstração e preparar a apresentação final.  
| **Semana 13** | **Apresentação Final** | Defesa do projeto, demonstrando o processo de ETL e os insights gerados pelas análises.  

---

## 👥 Equipe do Projeto

| Nome | Papel | GitHub |
|------|-------|--------|
| **Pedro** | Arquiteto de Dados | [@PedroFiel](https://github.com/PedroFiel) |
| **Anie** | Analista de Dados | [@anie1herodek](https://github.com/anie1herodek) |
| **Letícia** | Engenheiro de Dados | [@Lehholiveira05](https://github.com/Lehholiveira05) |
| **Danilo** | Engenheiro de Dados | [@DaniloSilva-prog](https://github.com/DaniloSilva-prog) |
| **Leonardo** | Arquiteto de Dados | [@Domds17](https://github.com/Domds17) |
| **Thomas** | Analista de Dados | [@thombellio](https://github.com/thombellio) |

---

## 📂 Estrutura do Repositório

```
📊 Projeto-de-Banco-de-Dados/
├── 📁 dataset/                                               # Conjunto de dados B3
│   ├── 📄 dataset.md                                         # Visão geral do dataset
│   ├── 📁 DadosGerais/                                       # Dados fundamentalistas
│   │   └── _colunas_dados.md                            
│   ├── 📁 FatosRelevantes/                                   # Comunicados ao mercado
│   │   └── _colunas_fatos_relevantes.md
│   ├── 📁 Historico/                                         # Performance mensal
│   │   └── _colunas_historico.md
│   ├── 📁 Precos/                                            # Séries de preços
│   │   └── _colunas_precos.md
│   ├── 📁 Proventos/                                         # Dividendos e JCP
│   │   └── _colunas_proventos.md
│   ├── 📁 Retornos/                                          # Retornos acumulados
│   │   └── _colunas_retornos.md
│   ├── 📁 RiEmpresas/                                        # URLs de RI
│   │   └── colunas_ri_empresas.md
│   └── 📁 Trimestre/                                         # Demonstrações Financeiras
│       └── _colunas_trimestre.md
├── 📁 doc/                                                   # Documentação
│   └── 📄 plano-de-analise-negocio.md                       # Plano de análise
├── 📁 models/                                                # Modelos de dados
│   ├── Dicionário de dados.xlsx
│   ├── Modelo_Fisico.jpg
│   └── Modelo_Logico.jpg
├── 📁 scripts/                                               # Scripts SQL
│   └── Script_Dados.sql
└── 📄 README.md                                              # Este arquivo
```

## 📋 Documentação do Dataset

Cada subdiretório do dataset possui sua própria documentação detalhada:

### 📊 **Modelos de Dados**
-   [Modelo Lógico](models/Modelo_Logico.jpg) - Estrutura conceitual do banco de dados
-   [Modelo Físico](models/Modelo_Fisico.jpg) - Implementação física com tipos e constraints

### 📈 **Dados Fundamentalistas**
-   [Documentação Geral do Dataset](dataset/dataset.md) - Visão completa do conjunto de dados
-   [Dados Gerais](dataset/DadosGerais/_colunas_dados.md) - Indicadores fundamentalistas e de mercado

### 📰 **Comunicados e Relatórios**
-   [Fatos Relevantes](dataset/FatosRelevantes/_colunas_fatos_relevantes.md) - Comunicados oficiais ao mercado
-   [Demonstrações Trimestrais](dataset/Trimestre/_colunas_trimestre.md) - Relatórios financeiros na CVM
-   [Sites de RI](dataset/RiEmpresas/colunas_ri_empresas.md) - Relações com Investidores

### 📊 **Dados de Mercado**
-   [Histórico Mensal](dataset/Historico/_colunas_historico.md) - Performance histórica mensal
-   [Preços Diários](dataset/Precos/_colunas_precos.md) - Cotações e indicadores técnicos
-   [Retornos Acumulados](dataset/Retornos/_colunas_retornos.md) - Performance por período

### 💰 **Proventos**
-   [Dividendos e JCP](dataset/Proventos/_colunas_proventos.md) - Histórico de distribuições

### 📋 **Documentação de Negócio**
-   [Plano de Análise](doc/plano-de-analise-negocio.md) - Requisitos e perguntas de negócio

---

## 📞 Contato

Para dúvidas ou sugestões sobre o projeto, abra uma **issue** neste repositório ou entre em contato com a equipe.

---

<div align="center">

**Disciplina:** Gerenciamento de Banco de Dados    
**Instituição:** Unasp  
**Período:** 2025.2


</div>

