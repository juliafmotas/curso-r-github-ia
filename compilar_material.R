# 1. LIMPAR EMOJIS
source("limpar_emojis.R")
limpar_todos_rmd()

# 2. TESTAR COMPILAÇÃO
rmarkdown::render("cronograma.Rmd", "html_document")  # Deve funcionar
rmarkdown::render("cronograma.Rmd", "pdf_document")   # Deve funcionar

# 3. COMMIT
git add .
git commit -m "Remove emojis e configura compatibilidade PDF/HTML"
git push

# 4. CRIAR PRÓXIMOS DIAS (sem emojis)
# Eu crio os Dias 2-5 já compatíveis com ambos formatos


# Carregar script de compilação
source("compilar_materiais.R")

# Abrir menu
menu_principal()

# Escolher opção 1: Compilar tudo em HTML e PDF