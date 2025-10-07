# ==============================================================================
# Script: Compilação Automática do Curso
# Descrição: Compila todos os materiais do curso em diferentes formatos
# Autor: Vinícius Silva Junqueira
# ==============================================================================

# Carregar pacotes necessários
library(rmarkdown)
library(here)
library(purrr)
library(glue)

# ==============================================================================
# CONFIGURAÇÕES
# ==============================================================================

# Diretórios
dir_materiais <- here("materiais")
dir_output <- here("output")

# Criar diretório de output se não existir
if (!dir.exists(dir_output)) {
  dir.create(dir_output, recursive = TRUE)
}

# ==============================================================================
# FUNÇÕES AUXILIARES
# ==============================================================================

#' Compilar arquivo RMarkdown
#'
#' @param arquivo Caminho para o arquivo .Rmd
#' @param formato Formato de saída: "html", "pdf", "all"
#' @param output_dir Diretório para salvar o arquivo gerado
compilar_rmd <- function(arquivo, formato = "html", output_dir = dir_output) {
  
  cat(glue("\n{strrep('=', 70)}\n"))
  cat(glue("Compilando: {basename(arquivo)}\n"))
  cat(glue("Formato: {formato}\n"))
  cat(glue("{strrep('=', 70)}\n\n"))
  
  tryCatch({
    if (formato == "html") {
      render(arquivo, 
             output_format = "html_document",
             output_dir = output_dir)
    } else if (formato == "pdf") {
      render(arquivo, 
             output_format = "pdf_document",
             output_dir = output_dir)
    } else if (formato == "all") {
      render(arquivo, 
             output_format = "all",
             output_dir = output_dir)
    }
    
    cat(glue("✓ Sucesso!\n\n"))
    return(TRUE)
    
  }, error = function(e) {
    cat(glue("✗ Erro: {e$message}\n\n"))
    return(FALSE)
  })
}

#' Limpar arquivos temporários
limpar_temp <- function() {
  arquivos_temp <- c(
    list.files(pattern = "\\.log$"),
    list.files(pattern = "\\.tex$"),
    list.files(pattern = "\\.aux$")
  )
  if (length(arquivos_temp) > 0) {
    file.remove(arquivos_temp)
    cat(glue("Removidos {length(arquivos_temp)} arquivos temporários\n"))
  }
}

# ==============================================================================
# OPÇÕES DE COMPILAÇÃO
# ==============================================================================

#' Opção 1: Compilar TODOS os dias individualmente em AMBOS formatos
compilar_todos_dias_ambos <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  COMPILANDO TODOS OS DIAS - HTML E PDF\n")
  cat(strrep("=", 70), "\n\n")
  
  arquivos <- list.files(dir_materiais, 
                         pattern = "^dia[0-9].*\\.Rmd$", 
                         full.names = TRUE)
  
  for (arquivo in arquivos) {
    cat(glue("\n--- Compilando {basename(arquivo)} ---\n"))
    compilar_rmd(arquivo, formato = "html")
    compilar_rmd(arquivo, formato = "pdf")
  }
  
  limpar_temp()
  
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  TODOS OS DIAS COMPILADOS EM HTML E PDF\n")
  cat(strrep("=", 70), "\n\n")
}

#' Opção 1a: Compilar TODOS os dias individualmente em HTML
compilar_todos_dias_html <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  COMPILANDO TODOS OS DIAS - FORMATO HTML\n")
  cat(strrep("=", 70), "\n\n")
  
  arquivos <- list.files(dir_materiais, 
                         pattern = "^dia[0-9].*\\.Rmd$", 
                         full.names = TRUE)
  
  resultados <- map_lgl(arquivos, ~compilar_rmd(.x, formato = "html"))
  
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat(glue("  RESUMO: {sum(resultados)}/{length(resultados)} arquivos compilados com sucesso\n"))
  cat(strrep("=", 70), "\n\n")
  
  return(resultados)
}

#' Opção 2: Compilar TODOS os dias individualmente em PDF
compilar_todos_dias_pdf <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  COMPILANDO TODOS OS DIAS - FORMATO PDF\n")
  cat(strrep("=", 70), "\n\n")
  
  arquivos <- list.files(dir_materiais, 
                         pattern = "^dia[0-9].*\\.Rmd$", 
                         full.names = TRUE)
  
  resultados <- map_lgl(arquivos, ~compilar_rmd(.x, formato = "pdf"))
  
  limpar_temp()
  
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat(glue("  RESUMO: {sum(resultados)}/{length(resultados)} arquivos compilados com sucesso\n"))
  cat(strrep("=", 70), "\n\n")
  
  return(resultados)
}

#' Opção 3: Compilar PDF ÚNICO (curso completo)
compilar_curso_completo <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  COMPILANDO CURSO COMPLETO - PDF UNICO\n")
  cat(strrep("=", 70), "\n\n")
  
  arquivo_mestre <- here("curso_completo_master.Rmd")
  
  if (!file.exists(arquivo_mestre)) {
    cat("X Erro: arquivo mestre nao encontrado!\n")
    cat(glue("  Esperado em: {arquivo_mestre}\n\n"))
    return(FALSE)
  }
  
  resultado <- compilar_rmd(arquivo_mestre, formato = "pdf", output_dir = here())
  
  limpar_temp()
  
  if (resultado) {
    cat("\n")
    cat(strrep("=", 70), "\n")
    cat("  PDF unico gerado com sucesso!\n")
    cat(glue("  Localizacao: {here('curso_completo_master.pdf')}\n"))
    cat(strrep("=", 70), "\n\n")
  }
  
  return(resultado)
}

#' Opção 4: Compilar um dia específico
compilar_dia_especifico <- function(dia, formato = "html") {
  arquivo <- here("materiais", glue("dia{dia}_*.Rmd"))
  arquivos_encontrados <- Sys.glob(arquivo)
  
  if (length(arquivos_encontrados) == 0) {
    cat(glue("✗ Erro: Dia {dia} não encontrado!\n"))
    return(FALSE)
  }
  
  resultado <- compilar_rmd(arquivos_encontrados[1], formato = formato)
  
  if (formato == "pdf") {
    limpar_temp()
  }
  
  return(resultado)
}

#' Opção 5: Compilar cronograma
compilar_cronograma <- function(formato = "pdf") {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("  COMPILANDO CRONOGRAMA\n")
  cat(strrep("=", 70), "\n\n")
  
  arquivo <- here("cronograma.Rmd")
  
  if (!file.exists(arquivo)) {
    cat("X Erro: cronograma.Rmd nao encontrado!\n\n")
    return(FALSE)
  }
  
  resultado <- compilar_rmd(arquivo, formato = formato, output_dir = here())
  
  if (formato == "pdf") {
    limpar_temp()
  }
  
  return(resultado)
}

# ==============================================================================
# MENU INTERATIVO
# ==============================================================================

menu_principal <- function() {
  cat("\n")
  cat(strrep("=", 70), "\n")
  cat("       COMPILACAO DO CURSO R + GITHUB + IA\n")
  cat(strrep("=", 70), "\n")
  cat("\n")
  cat("Escolha uma opcao:\n\n")
  cat("  1. Compilar TODOS os dias (HTML e PDF)\n")
  cat("  2. Compilar TODOS os dias (apenas HTML)\n")
  cat("  3. Compilar TODOS os dias (apenas PDF)\n")
  cat("  4. Compilar PDF UNICO (curso completo)\n")
  cat("  5. Compilar dia especifico\n")
  cat("  6. Compilar cronograma\n")
  cat("  7. Compilar TUDO (dias HTML+PDF + PDF unico + cronograma)\n")
  cat("  0. Sair\n")
  cat("\n")
  cat(strrep("=", 70), "\n")
  
  opcao <- readline(prompt = "Digite o numero da opcao: ")
  
  switch(opcao,
         "1" = compilar_todos_dias_ambos(),
         "2" = compilar_todos_dias_html(),
         "3" = compilar_todos_dias_pdf(),
         "4" = compilar_curso_completo(),
         "5" = {
           dia <- readline(prompt = "Qual dia (1-5)? ")
           formato <- readline(prompt = "Formato (html/pdf/ambos)? ")
           if (formato == "ambos") {
             compilar_dia_especifico(as.numeric(dia), "html")
             compilar_dia_especifico(as.numeric(dia), "pdf")
           } else {
             compilar_dia_especifico(as.numeric(dia), formato)
           }
         },
         "6" = {
           formato <- readline(prompt = "Formato (html/pdf/ambos)? ")
           if (formato == "ambos") {
             compilar_cronograma("html")
             compilar_cronograma("pdf")
           } else {
             compilar_cronograma(formato)
           }
         },
         "7" = {
           cat("\nCompilando tudo...\n")
           compilar_todos_dias_ambos()
           Sys.sleep(1)
           compilar_curso_completo()
           Sys.sleep(1)
           compilar_cronograma("html")
           compilar_cronograma("pdf")
           cat("\nTudo pronto!\n\n")
         },
         "0" = {
           cat("\nAte logo!\n\n")
           return(invisible(NULL))
         },
         {
           cat("\nX Opcao invalida!\n")
           Sys.sleep(1)
           menu_principal()
         }
  )
}

# ==============================================================================
# USO DIRETO (SEM MENU)
# ==============================================================================

# Descomente a linha desejada para executar diretamente:

# compilar_todos_dias_html()
# compilar_todos_dias_pdf()
# compilar_curso_completo()
# compilar_dia_especifico(1, "html")
# compilar_cronograma("pdf")

# ==============================================================================
# EXECUTAR MENU INTERATIVO
# ==============================================================================

# Execute esta linha para abrir o menu:
# menu_principal()

# ==============================================================================
# EXEMPLOS DE USO NO CONSOLE
# ==============================================================================

# No console R, você pode usar:
#
# source("compilar_materiais.R")  # Carregar funções
# menu_principal()                 # Abrir menu
#
# OU usar diretamente:
# compilar_todos_dias_html()
# compilar_curso_completo()
# compilar_dia_especifico(1, "html")
#
# ==============================================================================

cat("\n✓ Script carregado com sucesso!\n")
cat("  Execute 'menu_principal()' para começar\n")
cat("  ou use as funções diretamente.\n\n")