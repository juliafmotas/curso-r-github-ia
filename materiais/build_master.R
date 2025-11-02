# install.packages("qpdf")

library(qpdf)

setwd('./materiais/')

pdf_combine(
  input = c("capa.pdf"
            ,"sobre_mim.pdf"
            ,"introducao.pdf"
            ,"cronograma.pdf"
            ,"dia1_fundamentos.pdf"
            ,"dia2_logica_funcoes.pdf"
            ,"dia3_manipulacao.pdf"
            ,"dia4_ia.pdf"),
  output = "Curso_Completo_R_GitHub_IA.pdf"
)
