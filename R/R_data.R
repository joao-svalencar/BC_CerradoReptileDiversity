#list_raw <- read.csv(here::here("data", "raw", "lists", "salve-publico-exportacao-fichas-planilha28-06-2026-20-49-24.csv"), encoding = "UTF8") #requires namenclature harmonization
#list_simple <- read.table(here::here("data", "processed", "lists", "salve-simplified.txt"), h = T, sep = "\t") #requires namenclature harmonization
#list <- read.table(here::here("data", "processed", "lists", "salve-taxonomy-reviewed.txt"), h = T, sep = "\t") #835 29-06

list_br <- read.table(here::here("data", "processed", "lists", "br_reptiles.txt"), h = T, sep = "\t")

#end <- read.table(here::here("data", "processed", "lists", "cerrado_endemics_list.txt"), h = T, sep = "\t") #125 29-06 from Vieira-Alencar et al 2023 with current nomenclature

#tree_raw <- ape::read.tree(here::here("data", "raw","phylogeny", "main_title.tre")) #phylogenetic tree (title et al 2024)
tree <- ape::read.tree(here::here("data", "processed","phylogeny", "title_br.tre")) #pruned to SALVE species

# distribution ------------------------------------------------------------
#db <- read.table(here::here("data", "processed", "distribution", "salve-combined.csv"), header = TRUE, sep = ",")
db_reviewed <- read.table(here::here("data", "processed", "distribution", "db_reviewed.csv"), header = TRUE, sep = ",")

# shapes ------------------------------------------------------------------
brazil <- sf::st_read(here::here("data", "raw", "shapes", "brazil.shp"))
biomas <- sf::st_read(here::here("data", "raw", "shapes", "biomas.shp"))
#grid <- sf::st_read(here::here("data", "processed", "shapes", "grid.shp"))
