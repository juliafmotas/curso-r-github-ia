setwd('./materiais/')
bookdown::render_book("index.Rmd", "bookdown::pdf_book")

setwd('./materiais/')

# Para formato GitBook (recomendado para web)
bookdown::render_book("index.Rmd", "bookdown::gitbook")

# OU para formato BS4 (Bootstrap 4 - mais moderno)
# bookdown::render_book("index.Rmd", "bookdown::bs4_book")

# Após renderizar
file.rename("materiais/_book", "docs")