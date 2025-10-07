# ==============================================================================
# Script: Remover Emojis de Arquivos RMarkdown
# Descrição: Detecta e remove emojis para compatibilidade com PDF
# Autor: Vinícius Silva Junqueira
# ==============================================================================

library(here)
library(purrr)
library(glue)

# ==============================================================================
# FUNÇÕES
# ==============================================================================

#' Detectar emojis em arquivo
#' 
#' @param arquivo Caminho para o arquivo .Rmd
#' @return Lista de linhas com emojis
detectar_emojis <- function(arquivo) {
  linhas <- readLines(arquivo, warn = FALSE, encoding = "UTF-8")
  
  # Regex para emojis (caracteres Unicode fora do ASCII padrão)
  regex_emoji <- "[^\x01-\x7F]"
  
  linhas_com_emoji <- which(grepl(regex_emoji, linhas))
  
  if (length(linhas_com_emoji) > 0) {
    cat(glue("\n📍 Arquivo: {basename(arquivo)}\n"))
    cat(glue("   Encontrados emojis em {length(linhas_com_emoji)} linhas:\n\n"))
    
    for (i in linhas_com_emoji) {
      cat(glue("   Linha {i}: {linhas[i]}\n"))
    }
    cat("\n")
  }
  
  return(linhas_com_emoji)
}

#' Listar emojis comuns para substituição
emojis_comuns <- function() {
  list(
    "🎯" = "OBJETIVO:",
    "✅" = "[OK]",
    "❌" = "[X]",
    "📚" = "MATERIAL:",
    "📊" = "GRAFICO:",
    "📝" = "NOTA:",
    "💡" = "DICA:",
    "⚠️" = "ATENCAO:",
    "🚀" = "INICIO:",
    "🔧" = "FERRAMENTA:",
    "📁" = "PASTA:",
    "📄" = "ARQUIVO:",
    "🐙" = "GITHUB:",
    "🤖" = "IA:",
    "☕" = "INTERVALO:",
    "🏋️" = "EXERCICIO:",
    "🔄" = "WORKFLOW:",
    "⭐" = "*",
    "📌" = "IMPORTANTE:",
    "🎓" = "CURSO:",
    "👨‍🏫" = "INSTRUTOR:",
    "📧" = "Email:",
    "💼" = "LinkedIn:"
  )
}

#' Remover emojis de arquivo
#' 
#' @param arquivo Caminho para o arquivo .Rmd
#' @param criar_backup Se TRUE, cria backup antes de modificar
#' @param substituir_por Lista nomeada de emojis e suas substituições
remover_emojis <- function(arquivo, criar_backup = TRUE, substituir_por = NULL) {
  
  # Ler arquivo
  linhas <- readLines(arquivo, warn = FALSE, encoding = "UTF-8")
  
  # Backup
  if (criar_backup) {
    arquivo_backup <- paste0(arquivo, ".backup")
    writeLines(linhas, arquivo_backup, useBytes = TRUE)
    cat(glue("✓ Backup criado: {basename(arquivo_backup)}\n"))
  }
  
  # Substituições customizadas
  if (!is.null(substituir_por)) {
    for (emoji in names(substituir_por)) {
      linhas <- gsub(emoji, substituir_por[[emoji]], linhas, fixed = TRUE)
    }
  } else {
    # Usar substituições padrão
    subs <- emojis_comuns()
    for (emoji in names(subs)) {
      linhas <- gsub(emoji, subs[[emoji]], linhas, fixed = TRUE)
    }
  }
  
  # Remover qualquer emoji restante (substituir por espaço)
  linhas <- iconv(linhas, "UTF-8", "ASCII", sub = " ")
  
  # Salvar arquivo limpo
  writeLines(linhas, arquivo, useBytes = TRUE)
  cat(glue("✓ Emojis removidos: {basename(arquivo)}\n"))
}

#' Verificar todos os arquivos RMarkdown
verificar_todos_rmd <- function(diretorio = here()) {
  cat("\n═══════════════════════════════════════════════════════════════════\n")
  cat("  VERIFICANDO EMOJIS EM ARQUIVOS .Rmd\n")
  cat("═══════════════════════════════════════════════════════════════════\n")
  
  # Encontrar todos os .Rmd
  arquivos <- list.files(
    diretorio, 
    pattern = "\\.Rmd$", 
    recursive = TRUE, 
    full.names = TRUE
  )
  
  cat(glue("\nEncontrados {length(arquivos)} arquivos .Rmd\n"))
  
  # Verificar cada arquivo
  resultados <- map(arquivos, detectar_emojis)
  
  # Resumo
  total_com_emojis <- sum(map_int(resultados, length) > 0)
  
  cat("═══════════════════════════════════════════════════════════════════\n")
  cat(glue("  RESUMO: {total_com_emojis} arquivos contêm emojis\n"))
  cat("═══════════════════════════════════════════════════════════════════\n\n")
  
  return(invisible(arquivos[map_int(resultados, length) > 0]))
}

#' Limpar todos os arquivos RMarkdown
limpar_todos_rmd <- function(diretorio = here(), criar_backup = TRUE) {
  cat("\n═══════════════════════════════════════════════════════════════════\n")
  cat("  REMOVENDO EMOJIS DE ARQUIVOS .Rmd\n")
  cat("═══════════════════════════════════════════════════════════════════\n\n")
  
  # Encontrar todos os .Rmd
  arquivos <- list.files(
    diretorio, 
    pattern = "\\.Rmd$", 
    recursive = TRUE, 
    full.names = TRUE
  )
  
  cat(glue("Processando {length(arquivos)} arquivos...\n\n"))
  
  # Processar cada arquivo
  walk(arquivos, ~remover_emojis(.x, criar_backup = criar_backup))
  
  cat("\n═══════════════════════════════════════════════════════════════════\n")
  cat("  ✓ TODOS OS ARQUIVOS PROCESSADOS\n")
  cat("═══════════════════════════════════════════════════════════════════\n\n")
  
  if (criar_backup) {
    cat("💡 Dica: Para restaurar backups, renomeie os arquivos .backup\n\n")
  }
}

# ==============================================================================
# MENU INTERATIVO
# ==============================================================================

menu_limpar_emojis <- function() {
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════════\n")
  cat("       GERENCIADOR DE EMOJIS - RMarkdown\n")
  cat("═══════════════════════════════════════════════════════════════════\n")
  cat("\n")
  cat("Escolha uma opção:\n\n")
  cat("  1. Verificar emojis em todos os arquivos\n")
  cat("  2. Remover emojis de todos os arquivos (com backup)\n")
  cat("  3. Remover emojis de todos os arquivos (SEM backup)\n")
  cat("  4. Verificar arquivo específico\n")
  cat("  5. Limpar arquivo específico\n")
  cat("  0. Sair\n")
  cat("\n")
  cat("═══════════════════════════════════════════════════════════════════\n")
  
  opcao <- readline(prompt = "Digite o número da opção: ")
  
  switch(opcao,
         "1" = verificar_todos_rmd(),
         "2" = {
           confirmacao <- readline(prompt = "Confirma remoção de emojis COM backup? (s/n): ")
           if (tolower(confirmacao) == "s") {
             limpar_todos_rmd(criar_backup = TRUE)
           }
         },
         "3" = {
           confirmacao <- readline(prompt = "ATENÇÃO: Remover emojis SEM backup? (s/n): ")
           if (tolower(confirmacao) == "s") {
             limpar_todos_rmd(criar_backup = FALSE)
           }
         },
         "4" = {
           arquivo <- readline(prompt = "Caminho do arquivo: ")
           if (file.exists(arquivo)) {
             detectar_emojis(arquivo)
           } else {
             cat("✗ Arquivo não encontrado!\n")
           }
         },
         "5" = {
           arquivo <- readline(prompt = "Caminho do arquivo: ")
           if (file.exists(arquivo)) {
             backup <- readline(prompt = "Criar backup? (s/n): ")
             remover_emojis(arquivo, criar_backup = (tolower(backup) == "s"))
           } else {
             cat("✗ Arquivo não encontrado!\n")
           }
         },
         "0" = {
           cat("\nAté logo!\n\n")
           return(invisible(NULL))
         },
         {
           cat("\n✗ Opção inválida!\n")
           Sys.sleep(1)
           menu_limpar_emojis()
         }
  )
}

# ==============================================================================
# USO RÁPIDO
# ==============================================================================

# Descomente para usar diretamente:

# Verificar emojis
# verificar_todos_rmd()

# Remover emojis (com backup)
# limpar_todos_rmd(criar_backup = TRUE)

# Menu interativo
# menu_limpar_emojis()

# ==============================================================================

cat("\n✓ Script carregado com sucesso!\n")
cat("  Execute 'menu_limpar_emojis()' para começar\n")
cat("  ou 'verificar_todos_rmd()' para verificar emojis.\n\n")