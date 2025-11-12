# 🧠 Projeto SIAD – Previsão de `matched_score`

### 0. Estrutura do Repositório
```bash
├── data/
│   └── resume_data.csv              # Dataset utilizado
├── R/
│   ├── 01_data_understanding.R      # Análise exploratória
│   ├── 02_data_preparation.R        # Preparação e limpeza
│   ├── 03_modeling.R                # Modelação
│   ├── 04_evaluation.R              # Avaliação de resultados
│   └── 05_deployment.R              # Funções e modelo final
├── results/
│   ├── metrics.csv                  # Métricas de desempenho
│   ├── feature_importance.png       # Importância das variáveis
│   └── predictions_vs_actual.png    # Gráfico real vs previsto
├── modelo_final.rds                 # Modelo treinado
└── README.md                        # Descrição do projeto
```

## 📋 Descrição do Projeto
Este projeto foi desenvolvido no âmbito da unidade curricular **Sistemas Inteligentes de Apoio à Decisão (SIAD)**, sob orientação do **Prof. Sérgio Moro**.  
O objetivo é aplicar a metodologia **CRISP-DM** para desenvolver um modelo de **aprendizagem supervisionada** em **R**, capaz de **prever o valor da variável `matched_score`** com base nas restantes variáveis do dataset.

---

## 🧩 Metodologia – CRISP-DM

O projeto segue as seis fases da metodologia **CRISP-DM (Cross Industry Standard Process for Data Mining)**:

~~### 1. Business Understanding~~
~~- 1.1 Definição do problema: prever `matched_score` a partir de características do dataset.~~
~~- 1.2 Tipo de problema: **Regressão supervisionada**.~~
~~- 1.3 Benefício esperado: apoiar processos de decisão relacionados com a qualidade do “matching” entre entidades.~~
~~- 1.4 Variável dependente: `matched_score`.~~

---

### 2. Data Understanding (até quinta)
- 2.1 Carregamento e exploração inicial dos dados (`read.csv`, `str`, `summary`, `skimr::skim`). [R & RELATÓRIO]
- 2.2 Identificação de variáveis numéricas e categóricas. [RELATÓRIO]
- 2.3 Análise da distribuição de `matched_score` (histogramas, boxplots). [R & RELATÓRIO]
- 2.4 Verificação de **valores omissos** e **outliers**. [R & RELATÓRIO]
- 2.5 Análise de correlações (`cor`, `corrplot`, `ggcorrplot`). [R & RELATÓRIO]

---

### 3. Data Preparation
- 3.1 Tratamento de valores em falta (remoção ou imputação).
- 3.2 Codificação de variáveis categóricas (`factor`, `caret::dummyVars`).
- 3.3 Normalização / padronização de variáveis numéricas (`scale`).
- 3.4 Seleção e engenharia de atributos (feature engineering).
- 3.5 Divisão dos dados em **treino (80%)** e **teste (20%)**:
  ```r
  set.seed(123)
  index <- caret::createDataPartition(data$matched_score, p=0.8, list=FALSE)
  train <- data[index, ]
  test  <- data[-index, ]

### 4. Modeling
Treino de vários modelos supervisionados:
- 4.1 Regressão Linear (lm)
- 4.2 Random Forest (randomForest)
- 4.3 Gradient Boosting (xgboost)
- 4.4 Regressão Regularizada (glmnet)

Utilização de validação cruzada com caret::trainControl().

Comparação dos modelos com base em métricas de regressão (RMSE, MAE, R²). [R & REALTÓRIO]

Justificação da escolha do modelo final. [RELATÓRIO]

### 5. Evaluation [R & RELATÓRIO]
Avaliação do modelo final com dados de teste:
- 5.1 predictions <- predict(model_rf, newdata=test)
- 5.2 caret::postResample(predictions, test$matched_score)

Visualização:
- 5.3 Gráfico de valores reais vs. previstos.
- 5.4 Análise de resíduos.

Comparação dos desempenhos dos modelos testados.

### 6. Deployment [R & RELATÓRIO]
Guardar o modelo final para utilização futura:
- 5.1 saveRDS(model_rf, "modelo_final.rds")

Criar uma função de previsão:
- 5.2 prever_score <- function(novo_dado) {
  modelo <- readRDS("modelo_final.rds")
  predict(modelo, newdata = novo_dado)
}

Descrição de possíveis formas de integração do modelo num sistema real (API, dashboard, etc.).

### 7. Tecnologias e Pacotes Utilizados
Linguagem: R
Principais pacotes:
tidyverse
caret
randomForest
xgboost
glmnet
ggplot2
corrplot
skimr
