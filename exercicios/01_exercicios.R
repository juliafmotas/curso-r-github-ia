# Exercícios — Dia 1 (Fundamentos) -------------------------------------------
# Instruções
# - Salve cada bloco abaixo como um arquivo .R separado dentro da pasta: exercicios/
# - Codificação: UTF-8 (RStudio: File → Save with Encoding… → UTF-8)
# - Execute no RStudio (Ctrl/Cmd + Enter). Preencha os trechos marcados com TODO.
# - Não há dependências externas, exceto onde indicado (palmerpenguins, here, readr).
# -----------------------------------------------------------------------------

###############################################################################
# Arquivo: exercicios/ex01_vetores_basicos.R
###############################################################################
# Objetivo: Criar vetores, calcular medidas-resumo e filtrar por condição.

# 1) Crie um vetor numérico com 8 valores quaisquer
v <- c(10, 3, 7, 15, 22, 8, 11, 5)  # TODO: você pode alterar esses valores

# 2) Calcule média, mediana e desvio-padrão
media_v  <- mean(v)        # TODO (ok alterar v)
mediana_v<- median(v)      # TODO
sd_v     <- sd(v)          # TODO

# 3) Crie um novo vetor apenas com os valores acima da média
acima_media <- v[v > media_v]   # TODO

# 4) Imprima resultados
cat("Média:", media_v, "\nMediana:", mediana_v, "\nDesvio:", sd_v, "\n")
cat("Valores acima da média:", acima_media, "\n")

# (Opcional) Autochecagem simples
stopifnot(is.numeric(media_v), length(acima_media) <= length(v))


###############################################################################
# Arquivo: exercicios/ex02_indexacao_e_filtros.R
###############################################################################
# Objetivo: Praticar indexação por posição, nome e condição.

# Vetor base
w <- c(4, 9, 2, 12, 7, 15, 1)

# 1) Selecione o 1º e o 3º elementos
sel_1_3 <- w[c(1, 3)]  # TODO

# 2) Selecione do 2º ao 5º elemento
sel_2a5 <- w[2:5]      # TODO

# 3) Selecione todos, exceto o 4º
sem_4   <- w[-4]       # TODO

# 4) Filtre apenas valores maiores que 8
maior_8 <- w[w > 8]    # TODO

print(list(sel_1_3 = sel_1_3, sel_2a5 = sel_2a5, sem_4 = sem_4, maior_8 = maior_8))


###############################################################################
# Arquivo: exercicios/ex03_listas_e_dataframes.R
###############################################################################
# Objetivo: Construir listas e data.frames; acessar e criar colunas.

# 1) Crie uma lista com campos id, nome, aprovado
registro <- list(id = 1, nome = "Ana", aprovado = TRUE)  # TODO

# 2) Crie um data.frame com 4 linhas (id, nome, nota, ativo)
alunos <- data.frame(
  id    = 1:4,
  nome  = c("Ana", "Bruno", "Caio", "Dani"),
  nota  = c(8.5, 7.2, 9.1, 6.8),
  ativo = c(TRUE, TRUE, FALSE, TRUE),
  stringsAsFactors = FALSE
)

# 3) Acesse apenas a coluna nome
so_nomes <- alunos$nome  # TODO

# 4) Crie coluna situacao: nota >= 7 → "Aprovado"; senão "Recuperação"
alunos$situacao <- ifelse(alunos$nota >= 7, "Aprovado", "Recuperação")  # TODO

print(alunos)


###############################################################################
# Arquivo: exercicios/ex04_fatores.R
###############################################################################
# Objetivo: Trabalhar com fatores (categóricos) e fatores ordenados.

# 1) Construa um fator de sexo com níveis F e M (nessa ordem)
sexo_chr <- c("F", "M", "M", "F", "F")
sexo_fac <- factor(sexo_chr, levels = c("F", "M"))  # TODO

# 2) Crie um fator ordenado de conceitos: C < B < A
conceitos <- c("B", "A", "C", "A", "B")
conceito_ord <- factor(conceitos, levels = c("C", "B", "A"), ordered = TRUE)  # TODO

summary(conceito_ord)


###############################################################################
# Arquivo: exercicios/ex05_io_encoding_e_here.R
###############################################################################
# Objetivo: Ler/escrever arquivos com encoding correto e caminhos portáveis.
# Requisitos: install.packages("here"); install.packages("readr")

# Descomente as linhas abaixo para executar de verdade:
# library(here)
# library(readr)

# 1) Monte um caminho portável para um CSV em data/raw/dados.csv
# caminho <- here::here("data", "raw", "dados.csv")  # TODO

# 2) Leia o CSV em UTF-8 (ajuste se seu arquivo estiver em Latin1)
# dados <- readr::read_csv(caminho, locale = readr::locale(encoding = "UTF-8"))
# View(dados)  # opcional no RStudio

# 3) Exporte dados para output/tables/resultado.csv em UTF-8
# readr::write_csv(dados, here::here("output", "tables", "resultado.csv"))


###############################################################################
# Arquivo: exercicios/ex06_palmerpenguins_exploracao.R
###############################################################################
# Objetivo: Explorar o dataset palmerpenguins e criar colunas derivadas.
# Requisitos: install.packages("palmerpenguins")

# Descomente para executar:
# library(palmerpenguins)
# library(dplyr)

# 1) Inspecione nomes e estrutura
# names(penguins)
# str(penguins)
# dplyr::glimpse(penguins)

# 2) Conte NAs por coluna
# colSums(is.na(penguins))

# 3) Crie a coluna massa_kg = body_mass_g/1000
# penguins$massa_kg <- penguins$body_mass_g / 1000

# 4) Calcule a média de flipper_length_mm por espécie (ignore NAs)
# medias_flipper <- tapply(penguins$flipper_length_mm, penguins$species, mean, na.rm = TRUE)
# print(medias_flipper)

# 5) (Desafio) Crie raz_bico = bill_length_mm/bill_depth_mm e
#    mostre as 6 primeiras linhas apenas com species, raz_bico e massa_kg
# penguins$raz_bico <- with(penguins, bill_length_mm / bill_depth_mm)
# subset_out <- penguins[, c("species", "raz_bico", "massa_kg")]
# head(subset_out)


###############################################################################
# Dica de organização
###############################################################################
# - Mantenha todos os arquivos acima dentro de exercicios/ (um .R por exercício).
# - Para enviar ao seu fork no GitHub:
#   git add exercicios/
#   git commit -m "Exercícios Dia 1 — fundamentos"
#   git push origin main
