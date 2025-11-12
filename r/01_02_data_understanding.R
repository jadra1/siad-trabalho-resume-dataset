########################################################
# === FASE 1: BUSINESS UNDERSTANDING (CRISP-DM) ===
########################################################
# 1.1 Definição do Problema: Prever o 'matched_score' (Qualidade do Matching).
# 1.2 Tipo de Problema: Regressão Supervisionada (Previsão de um valor contínuo).
# 1.3 Benefício Esperado: Otimizar processos de decisão sobre a alocação de recursos e qualidade de dados.
# 1.4 Variável Dependente (Target): 'matched_score'.
#
# INFORMAÇÃO EXTRA: A métrica de avaliação típica para regressão será o RMSE 
# (Root Mean Square Error) ou o R-Quadrado, a ser definido na Fase 4 (Modelagem).

# --- 1.1 Preparação do ambiente e pacotes necessários ---
########################################################

# Lista dos pacotes essenciais para Data Understanding e Feature Engineering
required_packages <- c("dplyr","skimr", "stringr", "corrplot", "dplyr", "ggplot2", "ggcorrplot") 

#Pacote,Função Principal (O que faz)
#dplyr,"⚙️ Manipulação de Dados. Permite filtrar linhas, selecionar colunas, agrupar, resumir e transformar dados de forma rápida e intuitiva. É essencial para o pré-processamento."
#skimr,"📖 Sumário Rápido/Descritivo. Gera um resumo estatístico detalhado de todas as variáveis do dataset (contagem de NAs, média, desvio padrão, distribuição), muito mais completo que o summary() padrão."
#stringr,"📝 Manipulação de Texto. Simplifica operações com strings (texto), como extrair padrões, substituir caracteres, contar palavras ou limpar dados textuais (útil no seu Feature Engineering)."
#corrplot,🎨 Visualização de Correlações. Cria gráficos coloridos e visualmente apelativos (heatmaps circulares ou quadrados) de matrizes de correlação.
#ggplot2,"📈 Criação de Gráficos (Avançado). É o pacote padrão para criar visualizações de dados profissionais e altamente personalizáveis (histogramas, boxplots, scatter plots), usando uma sintaxe de camadas."
#ggcorrplot,"📊 Plotagem de Correlações no ggplot2. Permite criar gráficos de matriz de correlação no estilo do ggplot2, o que oferece mais opções de personalização e integração com outros gráficos desse pacote."

# Instala e carrega pacotes
for(pkg in required_packages){
  if (!require(pkg, character.only = TRUE)) {
     install.packages(pkg, dependencies = TRUE) # Instalar
    library(pkg, character.only = TRUE)
  }
}

# Carregamento do dataset (SUBSTITUIR pelo seu caminho/objeto)
# df_raw <- read.csv("caminho/para/o/seu/ficheiro.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
# Exemplo assumindo que o objeto 'resume_data' já existe:
# A função 'na.strings' indica ao R quais strings no ficheiro devem ser interpretadas como NA.
# Incluímos "" (campo vazio), "NULL" e "?" como exemplos comuns de valores omissos.
# Adapta a teu diretório
df_raw <- read.csv("C:/Users/siad-trabalho-resume-dataset/CodigoR/resume_data.csv",
                   header = TRUE, 
                   sep = ",", 
                   stringsAsFactors = FALSE,
                   na.strings = c("", "NULL", "?", "NA", "-")) 

df <- df_raw

df_raw <- resume_data 
df <- df_raw # Cópia para manipulação (boa prática)


########################################################
# === FASE 2: DATA UNDERSTANDING (CRISP-DM) ===
########################################################

# --- 2.1 Carregamento e Exploração Inicial dos Dados ---
cat("### 2.1 Exploração Inicial & Dimensão do Dataset ###\n")

# Dimensão do Dataset
cat("Dimensão (Linhas | Colunas):", dim(df), "\n") 
# Informação Extra: O número de linhas é vital para avaliar se a remoção de NA's é viável.
# Resposta: Dimensão (Linhas | Colunas): 9544 35 

# Estrutura e tipos de variáveis
cat("\nEstrutura (Tipos de Variáveis):\n")
str(df)
### 2.2 Tabela de Estrutura e Tipos de Dados ###
df_estrutura <- data.frame(
  Variavel = names(df),
  Tipo_de_Dados = sapply(df, class), # Extrai o tipo de dado de cada coluna
  Valores_Unicos = sapply(df, function(x) length(unique(x))), # Conta o número de valores únicos
  row.names = NULL
)

# Padronizar os Tipos de Dados para o Relatório
df_estrutura$Tipo_de_Dados[df_estrutura$Tipo_de_Dados == "character"] <- "Texto/Carácter"
df_estrutura$Tipo_de_Dados[df_estrutura$Tipo_de_Dados %in% c("factor", "logical")] <- "Categórica (Factor/Lógico)"
df_estrutura$Tipo_de_Dados[df_estrutura$Tipo_de_Dados %in% c("numeric", "integer")] <- "Numérica"

# Ordenar e apresentar a tabela (usa o dplyr carregado)
df_estrutura_ordenada <- df_estrutura %>%
  arrange(Tipo_de_Dados, Variavel)

cat("### 2.2 Tabela de Estrutura e Tipos de Dados ###\n")
print(df_estrutura_ordenada)

# Resumo para o Relatório
cat("\n### Contagem de Tipos de Dados (Resumo) ###\n")
df_estrutura_ordenada %>%
  group_by(Tipo_de_Dados) %>%
  summarise(Contagem = n()) %>%
  arrange(desc(Contagem))

#Respota
                              Variavel  Tipo_de_Dados Valores_Unicos
1                        matched_score       Numérica            345
2                  X.job_position_name Texto/Carácter             28
3                              address Texto/Carácter             29
4                      age_requirement Texto/Carácter             15
5                     career_objective Texto/Carácter            172
6              certification_providers Texto/Carácter             50
7                 certification_skills Texto/Carácter             33
8                         company_urls Texto/Carácter             17
9                         degree_names Texto/Carácter            181
10            educationaL_requirements Texto/Carácter             20
11        educational_institution_name Texto/Carácter            329
12                 educational_results Texto/Carácter             79
13                           end_dates Texto/Carácter            247
14            experiencere_requirement Texto/Carácter             18
15                        expiry_dates Texto/Carácter             12
16     extra_curricular_activity_types Texto/Carácter             87
17 extra_curricular_organization_links Texto/Carácter             10
18 extra_curricular_organization_names Texto/Carácter             90
19                         issue_dates Texto/Carácter             31
20                           languages Texto/Carácter             19
21                           locations Texto/Carácter             87
22              major_field_of_studies Texto/Carácter            211
23                        online_links Texto/Carácter              8
24                       passing_years Texto/Carácter            150
25                           positions Texto/Carácter            302
26          professional_company_names Texto/Carácter            200
27                  proficiency_levels Texto/Carácter             23
28                related_skils_in_job Texto/Carácter            299
29                    responsibilities Texto/Carácter             28
30                  responsibilities.1 Texto/Carácter             28
31                        result_types Texto/Carácter             31
32                      role_positions Texto/Carácter             92
33                              skills Texto/Carácter            341
34                     skills_required Texto/Carácter             24
35                         start_dates Texto/Carácter            253

# Sumário descritivo expandido (melhor que summary() padrão)
cat("\nSumário Detalhado com skimr::skim():\n")
# O 'skim' já ajuda na identificação dos tipos e NA's (2.2 e 2.4)
skim(df) 

#Resposta
── Data Summary ────────────────────────
                           Values
Name                       df    
Number of rows             9544  
Number of columns          35    
_______________________          
Column type frequency:           
  character                34    
  numeric                  1     
________________________         
Group variables            None  

── Variable type: character ─────────────────────────────────────────────────────────────────────────────────────
   skim_variable                       n_missing complete_rate min  max empty n_unique whitespace
 1 address                                     0             1   0  110  8760       29          0
 2 career_objective                            0             1   0 1425  4804      172          0
 3 skills                                      0             1   0 3104    56      341          0
 4 educational_institution_name                0             1   0  212    84      329          0
 5 degree_names                                0             1   0  472    84      181          0
 6 passing_years                               0             1   0  121    84      150          0
 7 educational_results                         0             1   0  102    84       79          0
 8 result_types                                0             1   0   94    84       31          0
 9 major_field_of_studies                      0             1   0  260    84      211          0
10 professional_company_names                  0             1   0  266    84      200          0
11 company_urls                                0             1   0  277    84       17          0
12 start_dates                                 0             1   0  129    84      253          0
13 end_dates                                   0             1   0  133    84      247          0
14 related_skils_in_job                        0             1   0 1138    84      299          0
15 positions                                   0             1   0  293    84      302          0
16 locations                                   0             1   0  152    84       87          0
17 responsibilities                            0             1  72  587     0       28          0
18 extra_curricular_activity_types             0             1   0  123  6118       87          0
19 extra_curricular_organization_names         0             1   0  186  6118       90          0
20 extra_curricular_organization_links         0             1   0   42  6118       10          0
21 role_positions                              0             1   0  236  6118       92          0
22 languages                                   0             1   0   43  8844       19          0
23 proficiency_levels                          0             1   0   82  8844       23          0
24 certification_providers                     0             1   0  273  7536       50          0
25 certification_skills                        0             1   0  272  7536       33          0
26 online_links                                0             1   0  108  7536        8          0
27 issue_dates                                 0             1   0  108  7536       31          0
28 expiry_dates                                0             1   0  108  7536       12          0
29 X.job_position_name                         0             1  10   87     0       28          0
30 educationaL_requirements                    0             1  15  127     0       20          0
31 experiencere_requirement                    0             1   0   18  1364       18          0
32 age_requirement                             0             1   0   21  4087       15          0
33 responsibilities.1                          0             1  72  587     0       28          0
34 skills_required                             0             1   0  163  1701       24          0

── Variable type: numeric ───────────────────────────────────────────────────────────────────────────────────────
  skim_variable n_missing complete_rate  mean    sd p0   p25   p50   p75 p100 hist 
1 matched_score         0             1 0.661 0.167  0 0.583 0.683 0.793 0.97 ▁▂▂▇▆

# --- 2.2 Identificação de Variáveis (Confirmada pelo skimr::skim) ---
numeric_cols <- names(df)[sapply(df, is.numeric)]
character_cols <- names(df)[sapply(df, is.character)]
cat("\nVariáveis Numéricas:", length(numeric_cols), "\n")
cat("Variáveis Categóricas/Texto:", length(character_cols), "\n")
#Resposta
Variáveis Numéricas: 1 
Variáveis Categóricas/Texto: 34 

# --- 2.4 Verificação de Valores Omissos (NA's) ---
cat("\n### 2.4 Verificação de Valores Omissos (NA's) ###\n")

# Cálculo e visualização da percentagem de NA's por coluna
na_percentage <- sapply(df, function(x) mean(is.na(x))) * 100
na_percentage_sorted <- sort(na_percentage[na_percentage > 0], decreasing = TRUE)
cat("Percentagem de NA's por Coluna (Apenas colunas com NA):\n")
print(na_percentage_sorted)
#Resposta
#Percentagem de NA's por Coluna (Apenas colunas com NA):
                          languages                  proficiency_levels                             address 
                         92.6655490                          92.6655490                          91.7854149 
            certification_providers                certification_skills                        online_links 
                         78.9606035                          78.9606035                          78.9606035 
                        issue_dates                        expiry_dates     extra_curricular_activity_types 
                         78.9606035                          78.9606035                          64.1031014 
extra_curricular_organization_names extra_curricular_organization_links                      role_positions 
                         64.1031014                          64.1031014                          64.1031014 
                   career_objective                     age_requirement                     skills_required 
                         50.3352892                          42.8227158                          17.8227158 
           experiencere_requirement        educational_institution_name                        degree_names 
                         14.2917016                           0.8801341                           0.8801341 
                      passing_years                 educational_results                        result_types 
                          0.8801341                           0.8801341                           0.8801341 
             major_field_of_studies          professional_company_names                        company_urls 
                          0.8801341                           0.8801341                           0.8801341 
                        start_dates                           end_dates                related_skils_in_job 
                          0.8801341                           0.8801341                           0.8801341 
                          positions                           locations                              skills 
                          0.8801341                           0.8801341                           0.5867561 

# Informação Extra: Colunas com mais de 70% de NA's são fortes candidatas a serem removidas 
# na próxima fase (Data Preparation) devido ao baixo poder informativo.

# --- 2.3 Análise da Distribuição de 'matched_score' (Target) e Outliers ---
cat("\n### 2.3 Análise da Variável Dependente: matched_score ###\n")

# Garantir que é numérica para análise
df$matched_score <- as.numeric(df$matched_score) 

# Histograma da Distribuição
dist_hist <- ggplot(df, aes(x = matched_score)) +
  geom_histogram(bins = 30, fill = "#0072B2", color = "white") +
  labs(title = "Distribuição de matched_score", x = "matched_score", y = "Frequência") +
  theme_minimal()
print(dist_hist)

# Boxplot para Outliers
dist_box <- ggplot(df, aes(y = matched_score)) +
  geom_boxplot(fill = "#D55E00") +
  labs(title = "Boxplot de matched_score", y = "matched_score") +
  theme_minimal()
print(dist_box)

# Deteção de Outliers via IQR (2.4)
outliers_iqr <- boxplot.stats(df$matched_score)$out
cat("Número de Outliers detectados em matched_score (IQR):", length(outliers_iqr), "\n")
#Resposta
Número de Outliers detectados em matched_score (IQR): 114 

# Informação Extra: Outliers no 'Target' devem ser tratados com cautela. 
# Podem ser erros de medição (remover) ou valores raros e importantes (manter/transformar).

# --- 2.5 Análise de Correlações ---
cat("\n### 2.5 Análise de Correlações ###\n")

# 2.5.1. Feature Engineering Inicial (Criação de Numéricas a partir de Texto para a Correlação)
# O seu código de Feature Engineering é crucial aqui. Mantê-lo e refinar:

# Contagem de skills (simples)
df$skills_count <- sapply(df$skills, function(x){
  if(is.na(x) | x == "") return(0)
  x <- gsub("\\[|\\]|'|\"", "", x) 
  length(unlist(strsplit(x, ","))) 
})

# Extrair idades min/max
df$age_min <- as.numeric(stringr::str_extract(df$age_requirement, "\\d{2}"))
df$age_max <- as.numeric(stringr::str_extract(df$age_requirement, "(?<=to )\\d{2}"))

# 2.5.2. Seleção de Colunas Numéricas para Correlação
# Usamos o 'where' do dplyr para ser mais robusto
numeric_df <- df %>% 
  select(where(is.numeric))

# 2.5.3. Cálculo da Matriz de Correlação
cor_matrix <- cor(numeric_df, use = "pairwise.complete.obs")

# 2.5.4. Plot da Matriz de Correlação
corr_plot <- ggcorrplot::ggcorrplot(cor_matrix,
                                    type = "lower",        # Mostrar só a parte inferior
                                    lab = TRUE,            # Mostrar valores de correlação
                                    lab_size = 2.5,        # Tamanho dos labels
                                    tl.cex = 8,            # Tamanho do texto das colunas
                                    tl.srt = 45,           # Rotação dos labels
                                    title = "Matriz de Correlação das Variáveis Numéricas")
print(corr_plot)

# 2.5.5. Foco nas Correlações com o Target ('matched_score')
cor_target <- as.data.frame(cor_matrix["matched_score", ])
colnames(cor_target) <- "Correlação"
cor_target <- cor_target %>%
  arrange(desc(abs(Correlação))) %>% 
  filter(rownames(.) != "matched_score")

cat("\nTop 5 Variáveis mais correlacionadas com 'matched_score':\n")
print(head(cor_target, 5))

# Informação Extra: Correlações fortes (p.ex., > 0.7) entre variáveis independentes 
# (X1 e X2) indicam **Multicolinearidade**, o que pode afetar modelos lineares (como Regressão Linear).
# Deve-se considerar remover uma das variáveis correlacionadas.