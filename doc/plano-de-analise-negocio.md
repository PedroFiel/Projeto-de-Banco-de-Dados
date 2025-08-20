# 📊 Projeto Final — Mercado Financeiro B3  
**Disciplina:** Engenharia e Análise de Dados com T-SQL  
**Semana 2 — Requisitos & Plano de Análise**

---

## 1) Tema, Escopo e Fontes

**Tema:**  
Ações listadas na **B3**, com foco em 6 segmentos:  
- **Saneamento**  
- **Bancos**  
- **Eletricidade**  
- **Telecomunicações**  
- **Commodities**  
- **Seguros**

**Escopo:**  
Comparar desempenho histórico, valuation, dividendos e recomendações de analistas.  
Gerar rankings por segmento e cruzar os indicadores financeiros mais relevantes.

**Fontes candidatas:**  
- Séries históricas de preços (cotações diárias).  
- Proventos (dividendos, JCP, bonificações).  
- Demonstrativos financeiros (PL, EBITDA, Patrimônio, Dívida, Ações).  
- Recomendações de analistas.  

---

## 2) Requisitos de Negócio

O banco deve responder a perguntas como:  
- **Preço & retornos:** preço atual, máximas/mínimas, valorização em 12m, liquidez média.  
- **Valuation:** P/L, P/VP, EV/EBITDA, MarketCap, Patrimônio Líquido.  
- **Dividendos:** Dividend Yield 12m, total pago, frequência de distribuição.  
- **Setor:** segmentação em 6 grupos e comparação intra/intersegmentos.  
- **Recomendações:** quais empresas foram mais recomendadas por analistas e com maior acurácia.  

---

## 3) Plano de Análise — Perguntas de Negócio

Temos **18 perguntas específicas** (3 por segmento × 6) + **5 transversais** comparando todos os segmentos.

### A) Saneamento (ex.: CSMG3, SAPR11, SBSP3)
1. Qual empresa teve maior **Dividend Yield 12m** e como evoluiu no período?  
2. Quem obteve o **maior retorno ajustado ao risco** (retorno/volatilidade)?  
3. Ranking de **P/VP e EV/EBITDA** — existe alguma empresa "barata" frente ao setor?  

### B) Bancos (ex.: BBAS3, ITUB4, BBDC4)
1. **Banco do Brasil vs Itaú:** quem pagou mais dividendos e quem valorizou mais em 12m?  
2. Quem tem maior **liquidez média (63 dias)** e melhor momentum recente?  
3. Qual banco foi mais **recomendado por analistas** nos últimos 3 anos?  

### C) Eletricidade (ex.: TAEE11, EQTL3, NEOE3)
1. Qual empresa apresenta mais **previsibilidade em proventos** (mapa de dividendos)?  
2. Qual está mais **abaixo da máxima histórica** (potencial de recuperação)?  
3. Relação entre **EV/EBITDA e performance 12m**: múltiplos baixos indicaram valorização?  

### D) Telecomunicações (ex.: VIVT3, TIMS3, OIBR3)
1. Qual empresa combina **DY elevado** com **payout sustentável**?  
2. Variação do **Market Cap em 36m**: houve reprecificação do mercado?  
3. Quem está no **"melhor ponto de compra"** segundo P/L e P/VP?  

### E) Commodities (ex.: VALE3, KLBN11, SUZB3, PETR4)
1. Qual entregou maior **retorno total (preço + dividendos)** em 12m?  
2. Relação entre **EV/EBITDA e ciclo**: múltiplos comprimidos anteciparam valorização?  
3. Comparativo entre pares (ex.: VALE3 vs KLBN11): quem teve mais consistência de retornos?  

### F) Seguros (ex.: BBSE3, PSSA3, SULA11)
1. Qual seguradora distribuiu mais **dividendos em 12m** e com maior frequência?  
2. Qual apresenta melhor **P/L e P/VP** em relação à média do setor?  
3. Qual seguradora teve mais **recomendações Buy** e maior valorização subsequente?  

### G) Perguntas Transversais (todos os segmentos)
1. Qual segmento teve **melhor retorno médio 12m** e maior **DY médio**?  
2. Qual segmento apresentou a maior **liquidez agregada** (R$ médio negociado)?  
3. Comparativo de **valuation médio (P/L, P/VP, EV/EBITDA)** entre segmentos.  
4. **Top 5 empresas por DY 12m:** quantas pertencem a cada segmento?  
5. Ranking do **"melhor momento de compra"** (score acadêmico ponderando P/VP, EV/EBITDA, DY, momentum, liquidez).  
