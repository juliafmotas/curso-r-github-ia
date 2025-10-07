# 01_fundamentos.R  -----------------------------------------------------------
# Curso: Introdução à Programação em R com GitHub, ChatGPT e Claude
# Aula: Dia 1 — Fundamentos e Ambiente de Trabalho
# Autor: Vinícius Silva Junqueira
# Objetivo: Prática guiada com objetos básicos, vetores, data.frames,
#           fatores e exploração inicial do dataset 'palmerpenguins'.
# -----------------------------------------------------------------------------

# IMPORTANTE: Salve este arquivo com codificação UTF-8.
# RStudio: File → Save with Encoding… → UTF-8

# -----------------------------------------------------------------------------
# 0) PREPARO DO AMBIENTE -------------------------------------------------------
# -----------------------------------------------------------------------------

# Dica: execute este script SEÇÃO POR SEÇÃO (Ctrl+Enter) e leia os comentários.

# Se faltar algum pacote, descomente as linhas abaixo para instalar:
# install.packages("palmerpenguins")
# install.packages("dplyr")
# install.packages("here")        # opcional: para caminhos portáveis

library(palmerpenguins)  # dataset didático
library(dplyr, warn.conflicts = FALSE)  # usaremos glimpse()
# library(here)  # opcional (ver seção 6)

# Conferir versão do R e infos do ambiente (opcional)
R.version.string
# sessionInfo()

# -----------------------------------------------------------------------------
# 1) OBJETOS BÁSICOS -----------------------------------------------------------
# -----------------------------------------------------------------------------

# Tipos comuns: numérico (double/integer), lógico (TRUE/FALSE), caractere (string)

x_num  <- 42           # numérico
x_log  <- TRUE         # lógico
x_chr  <- "R é divertido"  # texto (string)

# Ver informações básicas
x_num; x_log; x_chr
class(x_num); typeof(x_num)
class(x_log); typeof(x_log)
class(x_chr); typeof(x_chr)

# Conversões de tipo
as.character(123)
as.numeric("3.14")
as.logical(1)      # 1→TRUE, 0→FALSE

# Valores especiais
1/0      # Inf (infinito)
-1/0     # -Inf
0/0      # NaN (Not a Number)
NA       # Missing (faltante)

# Operações aritméticas básicas
10 + 3
10 - 3
10 * 3
10 / 3
10 ^ 2

# -----------------------------------------------------------------------------
# 2) VETORES E INDEXAÇÃO -------------------------------------------------------
# -----------------------------------------------------------------------------

# Criando vetores
v <- c(10, 20, 30, 40, 50)
v

# Comprimento e resumo
length(v)
sum(v)
mean(v)

# Sequências e repetições
seq(1, 10, by = 2)    # 1, 3, 5, 7, 9
rep(5, times = 3)     # 5, 5, 5

# Indexação por posição (começa em 1 no R)
v[1]      # primeiro elemento
v[2:4]    # do 2 ao 4
v[-1]     # todos, exceto o primeiro

# Indexação lógica
maiores_que_25 <- v > 25
maiores_que_25
v[maiores_que_25]

# Nomes em vetores (opcional)
names(v) <- c("a", "b", "c", "d", "e")
v["c"]

# -----------------------------------------------------------------------------
# 3) LISTAS E DATA.FRAMES ------------------------------------------------------
# -----------------------------------------------------------------------------

# Lista: pode misturar tipos
lst <- list(id = 1, nome = "Ana", aprovado = TRUE)
lst
lst$nome

# Data frame: tabela com colunas possivelmente de tipos diferentes
alunos <- data.frame(
  id    = 1:4,
  nome  = c("Ana", "Bruno", "Caio", "Dani"),
  nota  = c(8.5, 7.2, 9.1, 6.8),
  ativo = c(TRUE, TRUE, FALSE, TRUE),
  stringsAsFactors = FALSE
)

alunos
str(alunos)
nrow(alunos); ncol(alunos); names(alunos)
head(alunos, 2); tail(alunos, 2)

# Acessos
alunos$nome
alunos[ , "nota"]
alunos[1:2, c("nome", "nota")]

# Adicionar coluna
alunos$situacao <- ifelse(alunos$nota >= 7, "Aprovado", "Recuperação")

# -----------------------------------------------------------------------------
# 4) FATORES (CATEGORIAS) ------------------------------------------------------
# -----------------------------------------------------------------------------

# Fator = variável categórica com níveis explícitos
sexo_chr <- c("F", "M", "M", "F", "F")
sexo_fac <- factor(sexo_chr, levels = c("F", "M"))
sexo_fac
levels(sexo_fac)

# Fator ordenado
conceito <- factor(c("B", "A", "C", "A"), levels = c("C", "B", "A"), ordered = TRUE)
conceito
summary(conceito)

# -----------------------------------------------------------------------------
# 5) EXPLORAÇÃO INICIAL: 'palmerpenguins' -------------------------------------
# -----------------------------------------------------------------------------

# O objeto 'penguins' vem no pacote palmerpenguins
# Cada linha é um pinguim e cada coluna é uma variável (espécie, medidas, etc.)

penguins
str(penguins)
dplyr::glimpse(penguins)  # visão moderna
names(penguins)
summary(penguins)

# Quantidade de faltantes por coluna
colSums(is.na(penguins))

# Selecionar algumas colunas de interesse (base R)
peng_min <- penguins[ , c("species", "bill_length_mm", "bill_depth_mm", "flipper_length_mm", "body_mass_g")]
head(peng_min)

# Criar uma nova variável (razão do bico): cuidado com NAs
penguins$raz_bico <- with(penguins, bill_length_mm / bill_depth_mm)

# Estatísticas descritivas simples (ignorando NAs onde necessário)
mean(penguins$flipper_length_mm, na.rm = TRUE)
median(penguins$flipper_length_mm, na.rm = TRUE)

# Tamanho por espécie (contagem de linhas)
table(penguins$species)

# Média do comprimento da nadadeira por espécie (base R)
tapply(penguins$flipper_length_mm, penguins$species, mean, na.rm = TRUE)

# Correlação entre comprimento do bico e da nadadeira (apenas casos completos)
cc <- complete.cases(penguins$bill_length_mm, penguins$flipper_length_mm)
cor(penguins$bill_length_mm[cc], penguins$flipper_length_mm[cc])

# -----------------------------------------------------------------------------
# 6) (OPCIONAL) SALVAR UM CSV COM CAMINHO PORTÁVEL ----------------------------
# -----------------------------------------------------------------------------

# Se usar o pacote 'here', você constrói caminhos independentes de SO.
# Descomente se quiser salvar um CSV com resultados resumidos.

# library(here)
# medias_flipper <- data.frame(
#   especie = names(tapply(penguins$flipper_length_mm, penguins$species, mean, na.rm = TRUE)),
#   media_flipper = as.numeric(tapply(penguins$flipper_length_mm, penguins$species, mean, na.rm = TRUE))
# )
# write.csv(medias_flipper, here::here("output", "tables", "medias_flipper_por_especie.csv"), row.names = FALSE)

# -----------------------------------------------------------------------------
# 7) EXERCÍCIOS GUIADOS (preencha abaixo) -------------------------------------
# -----------------------------------------------------------------------------

# 7.1) Crie um vetor numérico com 6 elementos e:
#   a) calcule média e desvio-padrão
#   b) selecione apenas os elementos maiores que a média

# v_seu <- c(...)
# media_v <- ...
# sd_v    <- ...
# v_maiores <- ...

# 7.2) No data.frame 'alunos' criado acima,
#   a) mude o nome da coluna 'nota' para 'nota_final'
#   b) crie uma coluna lógica 'honra' TRUE se nota_final >= 9

# names(alunos)[names(alunos) == "nota"] <- "nota_final"
# alunos$honra <- ...

# 7.3) Usando 'penguins':
#   a) Conte quantos NAs existem em 'body_mass_g'
#   b) Calcule a mediana de 'body_mass_g' por espécie (ignorando NAs)

# nas_body <- ...
# mediana_por_especie <- tapply(...)

# 7.4) Crie a variável 'massa_kg' = body_mass_g/1000 e calcule a média por espécie.

# penguins$massa_kg <- ...
# tapply(...)

# 7.5) Desafio bônus (base R): usando apenas indexação e funções base,
#     produza um 'subconjunto' com pinguins da espécie Adelie com medidas completas
#     nas colunas bill_length_mm, bill_depth_mm, flipper_length_mm.

# adelie <- penguins[penguins$species == "Adelie", ]
# completos <- complete.cases(adelie$bill_length_mm, adelie$bill_depth_mm, adelie$flipper_length_mm)
# adelie_completo <- adelie[completos, ]
# head(adelie_completo)

# -----------------------------------------------------------------------------
# 8) FINALIZAÇÃO ---------------------------------------------------------------
# -----------------------------------------------------------------------------

# Dica: salve este arquivo (UTF-8) e faça seu primeiro commit:
# git add scripts/01_fundamentos.R
# git commit -m "Fundamentos do R — prática guiada (Dia 1)"
# git push origin main

# Fim do script ---------------------------------------------------------------
