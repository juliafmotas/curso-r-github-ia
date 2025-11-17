setwd('/Users/viniciusjunqueira/Library/CloudStorage/OneDrive-Pessoal/Cursos/curso-r-github-ia/materiais')

bookdown::render_book("index.Rmd", "bookdown::pdf_book")

# Para formato GitBook (recomendado para web)
bookdown::render_book("index.Rmd", "bookdown::gitbook")

system('cp -rf materiais/_book/* docs/')

# Verificar se a pasta docs existe e tem arquivos
list.files("docs")

# No R, na raiz do projeto
file.create(".nojekyll")
