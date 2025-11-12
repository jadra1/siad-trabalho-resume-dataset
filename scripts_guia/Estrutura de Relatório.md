Título do Projeto: Aplicação da Metodologia CRISP-DM para Previsão do matched_score em R
[Capa]

Instituição: [Nome da Universidade/Faculdade]

Unidade Curricular: Sistemas Inteligentes de Apoio à Decisão (SIAD)

Docente Responsável: Prof. Sérgio Moro

Autor(es): [Seu Nome / Nome dos Elementos do Grupo]

Data: [Mês e Ano de Entrega]

Índice
Introdução

Metodologia (CRISP-DM) 
2.1. Fase 1: Business Understanding 
2.2. Fase 2: Data Understanding 
2.3. Fase 3: Data Preparation 
2.4. Fase 4: Modeling 
2.5. Fase 5: Evaluation 
2.6. Fase 6: Deployment

Resultados e Análise 
3.1. Análise Exploratória (Fase 2) 
3.2. Pré-processamento e Feature Engineering (Fase 3) 
3.3. Comparação e Seleção de Modelos (Fases 4 e 5)

Conclusão e Trabalho Futuro

Referências

Apêndice A: Código R

1. Introdução
Contexto: Apresente a importância da UC SIAD e a relevância de aplicar a metodologia CRISP-DM para garantir a qualidade do projeto de Data Mining.

Objetivo: Clarifique o objetivo central: construir um modelo de Regressão Supervisionada para prever o valor contínuo da variável matched_score.

Estrutura: Breve descrição da organização do relatório (seguindo as 6 fases).

2. Metodologia (CRISP-DM)
2.1. Fase 1: Business Understanding
(O que escrever no Relatório)

Problema de Negócio: Defina que o problema consiste em quantificar a qualidade do "match" (e.g., entre um currículo e uma vaga).

Objetivo de Data Mining: Declarar explicitamente: Prever matched_score.

Tipo de Modelo: Confirmar que o problema é de Regressão Supervisionada.

Benefício Esperado: O modelo pode ser usado para filtrar ou priorizar "matches", otimizando o processo de decisão.

2.2. Fase 2: Data Understanding
(O que escrever no Relatório)

Carregamento e Estrutura: Descreva a dimensão do dataset (Nº Linhas x Nº Colunas). Apresente um resumo dos tipos de variáveis (obtido via skimr::skim).

Análise de matched_score:

Comente a forma da distribuição (simetria, assimetria). Inclua o Histograma e Boxplot gerados.

Mencione a presença e o número de outliers detetados pelo critério IQR na variável dependente.

Qualidade dos Dados: Apresente as colunas com a maior percentagem de valores omissos (NA), indicando que estas serão tratadas na Fase 3.

Correlações: Discuta a Matriz de Correlação (incluir figura). Identifique as variáveis numéricas que mostram as relações mais fortes (positivas ou negativas) com o matched_score.

2.3. Fase 3: Data Preparation
(O que escrever no Relatório)

Tratamento de NAs: Descreva a sua estratégia (p. ex., remover variáveis com mais de X% de NAs, imputar a mediana/moda nas restantes, ou remover as linhas com NA na variável dependente).

Feature Engineering:

Detalhe as novas features criadas (e.g., skills_count, text_length_total, age_min/age_max). Justifique por que estas novas variáveis podem ser preditivas.

Codificação: Explique a conversão de colunas character para factor e como as variáveis categóricas serão tratadas para a modelagem (e.g., One-Hot Encoding usando caret::dummyVars).

Normalização/Padronização: Mencione se aplicou scale ou normalize às variáveis numéricas para evitar que escalas diferentes distorçam o modelo.

Divisão dos Dados: Confirme a divisão em Treino (80%) e Teste (20%) usando set.seed(123) para reprodutibilidade.

2.4. Fase 4: Modeling
(O que escrever no Relatório)

Modelos Selecionados: Indique os modelos escolhidos: Regressão Linear (lm), Random Forest (randomForest), Gradient Boosting (xgboost), Regressão Regularizada (glmnet).

Estratégia de Treino: Explique o uso da Validação Cruzada (caret::trainControl) para otimizar os modelos e evitar overfitting.

Treino: Mencione o uso da função caret::train e os hiperparâmetros ajustados (se aplicável).

2.5. Fase 5: Evaluation
(O que escrever no Relatório)

Métricas: Liste as métricas de regressão usadas (RMSE, MAE, R 
2
 ) e o que cada uma representa.

Dica: O RMSE é geralmente a métrica chave.

Comparação: Inclua uma tabela comparativa com os resultados das métricas para todos os modelos no conjunto de Teste.

Escolha Final: Justifique a escolha do modelo final (geralmente o que tiver o menor RMSE e o maior R 
2
  no dataset de teste).

Análise de Resíduos: Inclua o gráfico de Resíduos vs. Valores Previstos do modelo final para verificar a homocedasticidade e o viés.

2.6. Fase 6: Deployment
(O que escrever no Relatório)

Modelo Persistente: Descreva como o modelo final foi guardado (saveRDS) para ser usado em produção.

Função de Previsão: Mencione a criação de uma função de previsão (prever_score) que encapsula o modelo, facilitando a sua integração.

Integração: Sugira formas credíveis de deployment:

API REST: Permitir que outras aplicações consultem o modelo em tempo real.

Dashboard: Integrar a previsão num painel de controlo (e.g., Shiny) para apoiar a decisão humana.

3. Resultados e Análise
Secções Detalhadas: Utilize esta secção para mostrar e comentar os resultados (gráficos, tabelas) gerados nas Fases 2, 3, 4 e 5.

4. Conclusão e Trabalho Futuro
Conclusão: Reafirme se o objetivo do projeto foi atingido e quais as implicações práticas.

Trabalho Futuro: Sugira melhorias (e.g., testar redes neuronais, realizar clustering para segmentar os dados, ou obter dados adicionais).

5. Referências
[Citações segundo norma académica (e.g., APA).]

6. Apêndice A: Código R
[Inserir o código completo e devidamente comentado dos ficheiros 01_data_understanding.R e 02_data_preparation.R.]