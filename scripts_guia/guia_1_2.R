# Lista dos pacotes essenciais para Data Understanding e Feature Engineering
# Lista dos pacotes essenciais
required_packages <- c("dplyr", "skimr", "stringr", "corrplot", "ggplot2", "ggcorrplot") 

# Instala e carrega os pacotes que não estiverem prontos
for(pkg in required_packages){
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE) 
    library(pkg, character.only = TRUE)
  }
}
# Se este bloco for executado sem erros, o dplyr está carregado.

df_raw <- read.csv("C:/Users/12013/siad-trabalho-resume-dataset/CodigoR/resume_data.csv")

# A função 'na.strings' indica ao R quais strings no ficheiro devem ser interpretadas como NA.
# Incluímos "" (campo vazio), "NULL" e "?" como exemplos comuns de valores omissos.
df_raw <- read.csv("C:/Users/12013/siad-trabalho-resume-dataset/CodigoR/resume_data.csv",
                   header = TRUE, 
                   sep = ",", 
                   stringsAsFactors = FALSE,
                   na.strings = c("", "NULL", "?", "NA", "-")) 

df <- df_raw

df <- df_raw

cat("### 2.1 Exploração Inicial & Dimensão do Dataset ###\n")

cat("Dimensão (Linhas | Colunas):", dim(df), "\n") 

cat("\nEstrutura (Tipos de Variáveis):\n")
str(df)

#install.packages("dplyr")

# Certifique-se que o seu dataset está na variável 'df'
# (Se não estiver, adicione a linha de carregamento: df <- resume_data)

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


# Sumário descritivo expandido (melhor que summary() padrão)
cat("\nSumário Detalhado com skimr::skim():\n")
# O 'skim' já ajuda na identificação dos tipos e NA's (2.2 e 2.4)
skim(df) 



numeric_cols <- names(df)[sapply(df, is.numeric)]
character_cols <- names(df)[sapply(df, is.character)]
cat("\nVariáveis Numéricas:", length(numeric_cols), "\n")
cat("Variáveis Categóricas/Texto:", length(character_cols), "\n")


# --- 2.4 Verificação de Valores Omissos (NA's) ---
cat("\n### 2.4 Verificação de Valores Omissos (NA's) ###\n")

# Cálculo e visualização da percentagem de NA's por coluna
na_percentage <- sapply(df, function(x) mean(is.na(x))) * 100
na_percentage_sorted <- sort(na_percentage[na_percentage > 0], decreasing = TRUE)
cat("Percentagem de NA's por Coluna (Apenas colunas com NA):\n")
print(na_percentage_sorted)



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
# Informação Extra: Outliers no 'Target' devem ser tratados com cautela. 
# Podem ser erros de medição (remover) ou valores raros e importantes (manter/transformar).


df$skills_count <- sapply(df$skills, function(x){
  if(is.na(x) | x == "") return(0)
  x <- gsub("\\[|\\]|'|\"", "", x) 
  length(unlist(strsplit(x, ","))) 
})


df$age_min <- as.numeric(stringr::str_extract(df$age_requirement, "\\d{2}"))
df$age_max <- as.numeric(stringr::str_extract(df$age_requirement, "(?<=to )\\d{2}"))


numeric_df <- df %>% 
  select(where(is.numeric))


cor_matrix <- cor(numeric_df, use = "pairwise.complete.obs")


corr_plot <- ggcorrplot::ggcorrplot(cor_matrix,
                                    type = "lower",        # Mostrar só a parte inferior
                                    lab = TRUE,            # Mostrar valores de correlação
                                    lab_size = 2.5,        # Tamanho dos labels
                                    tl.cex = 8,            # Tamanho do texto das colunas
                                    tl.srt = 45,           # Rotação dos labels
                                    title = "Matriz de Correlação das Variáveis Numéricas")


print(corr_plot)




cor_target <- as.data.frame(cor_matrix["matched_score", ])
colnames(cor_target) <- "Correlação"
cor_target <- cor_target %>%
  arrange(desc(abs(Correlação))) %>% 
  filter(rownames(.) != "matched_score")

cat("\nTop 5 Variáveis mais correlacionadas com 'matched_score':\n")
print(head(cor_target, 5))