library(httr)
library(stringr)
library(dplyr)
library(purrr)
library(readr)

# 1. Seu vetor com as espécies de interesse
# Importante: Use exatamente o formato "Genero.epiteto"
especies_interesse <- list_br$species[list_br$order=="Testudines"]
especies_interesse <- gsub(pattern = " ", replacement = ".", x = especies_interesse)

# 2. Criar a função que raspa e estrutura os dados de UMA espécie
raspar_especie <- function(nome_especie) {
  cat("Raspando dados de:", nome_especie, "...\n")
  
  # Monta a URL dinâmica
  url_js <- paste0("http://emys.geo.orst.edu/Entry3/jss/", nome_especie, ".js")
  
  # Faz a requisição
  resposta <- GET(url_js)
  
  Sys.sleep(2)
  
  # Verifica se a página realmente existe (evita travar o código se errar o nome)
  if (status_code(resposta) != 200) {
    warning(paste("Espécie não encontrada ou erro no link:", nome_especie))
    return(NULL)
  }
  
  texto_js <- content(resposta, as = "text", encoding = "UTF-8")
  
  # Captura os blocos 'title'
  blocos_title <- str_extract_all(texto_js, 'title:\\s*"([^"]+)"')[[1]]
  
  if (length(blocos_title) == 0) {
    warning(paste("Nenhum dado encontrado no arquivo de:", nome_especie))
    return(NULL)
  }
  
  conteudo_limpo <- str_remove_all(blocos_title, '^title:\\s*"|"$')
  
  # Função interna para processar cada linha do 'title'
  processar_linha <- function(texto) {
    elementos <- str_split(texto, "<br>")[[1]]
    elementos <- elementos[str_detect(elementos, "=")]
    chaves <- str_split_i(elementos, "=", 1)
    valores <- str_split_i(elementos, "=", 2)
    as.list(setNames(valores, chaves))
  }
  
  # Cria o dataframe da espécie atual
  df_especie <- map_dfr(conteudo_limpo, processar_linha)
  
  # Adiciona uma coluna identificando a qual espécie esses pontos pertencem
  df_especie <- df_especie %>% 
    mutate(especie_buscada = nome_especie)
  
  return(df_especie)
}

# 3. Rodar a função para todas as espécies do vetor e unificar os resultados
# O map_dfr roda a função para cada item do vetor e já empilha tudo em um tabelão
tabela_consolidada <- map_dfr(especies_interesse, raspar_especie)
mesohogei <- map_dfr(b, raspar_especie)

tabela_consolidada <- rbind(mesohogei, tabela_consolidada)

write.csv(tabela_consolidada, here::here("data", "raw", "distribution", "testudines.csv"), row.names = FALSE)
