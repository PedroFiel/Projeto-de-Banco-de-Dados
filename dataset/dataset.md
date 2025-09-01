# 📊 Estrutura de Dados - Documentação Completa B3

## 📁 Visão Geral do Dataset

Este diretório contém um conjunto abrangente de dados do mercado financeiro brasileiro (B3), organizado em 8 subdiretórios temáticos. O dataset cobre aproximadamente 400-500 empresas listadas, com dados históricos desde 2010 até 2025, fornecendo uma base sólida para análises fundamentalistas, quantitativas e de mercado.

## 📂 Estrutura de Diretórios

### 1️⃣ **DadosGerais/**
- **Conteúdo**: Dados fundamentalistas e indicadores de mercado
- **Arquivos**: 2 (dados.csv + documentação)
- **Registros**: 402 empresas
- **Métricas**: 43 indicadores por empresa
- **Documentação**: `_colunasbd.md`

### 2️⃣ **FatosRelevantes/**
- **Conteúdo**: Comunicados oficiais ao mercado
- **Arquivos**: 488 CSVs (um por empresa)
- **Registros**: 5-102 fatos por empresa
- **Período**: Até agosto/2025
- **Documentação**: `_colunas_fatos_relevantes.md`

### 3️⃣ **Historico/**
- **Conteúdo**: Performance mensal histórica
- **Arquivos**: 431 CSVs (um por empresa)
- **Registros**: Retornos mensais desde 2000
- **Métricas**: 12 meses + retorno anual
- **Documentação**: `_colunas_historico.md`

### 4️⃣ **Precos/**
- **Conteúdo**: Séries temporais de preços diários
- **Arquivos**: 407 CSVs (um por empresa)
- **Registros**: 346 pregões por arquivo
- **Métricas**: OHLCV + indicadores técnicos
- **Documentação**: `_colunas_precos.md`

### 5️⃣ **Proventos/**
- **Conteúdo**: Histórico de dividendos e JCP
- **Arquivos**: 435 CSVs (um por empresa)
- **Registros**: Varia por empresa
- **Tipos**: Dividendos, JCP, Bonificações
- **Documentação**: `_colunas_proventos.md`

### 6️⃣ **Retornos/**
- **Conteúdo**: Retornos acumulados por período
- **Arquivos**: 4 CSVs (15d, 30d, 45d, 60d)
- **Registros**: 404 empresas por arquivo
- **Métricas**: Retorno total no período
- **Documentação**: `_colunas_retornos.md`

### 7️⃣ **RiEmpresas/**
- **Conteúdo**: URLs de Relações com Investidores
- **Arquivos**: 1 CSV (ri_empresas.csv)
- **Registros**: 427 empresas
- **Dados**: Código + URL do RI
- **Documentação**: `_colunas_ri_empresas.md`

### 8️⃣ **Trimestre/**
- **Conteúdo**: Demonstrações Financeiras Trimestrais
- **Arquivos**: 488 CSVs (um por empresa)
- **Registros**: ~60 trimestres por empresa
- **Links**: DFs + Press Releases na CVM
- **Documentação**: `_colunas_trimestre.md`

## 📊 Estatísticas Gerais

### **Cobertura de Empresas**
- 🏢 **Total de Empresas**: ~400-500
- 📅 **Período Histórico**: 2000-2025
- 📈 **Frequência**: Diária a Trimestral
- 📊 **Dados Totais**: ~2.255 arquivos CSV