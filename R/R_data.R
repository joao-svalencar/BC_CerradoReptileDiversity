#list_raw <- read.csv(here::here("data", "raw", "lists", "salve-publico-exportacao-fichas-planilha28-06-2026-20-49-24.csv"), encoding = "UTF8") 
#list_simple <- read.table(here::here("data", "processed", "lists", "salve-simplified.txt"), h = T, sep = "\t")
#list_br <- read.table(here::here("data", "processed", "lists", "salve-taxonomy-reviewed.txt"), h = T, sep = "\t")

#list <- read.table(here::here("data", "processed", "lists", "salve-squamata-reviewed.txt"), h = T, sep = "\t") #790 29-06
list <- read.table(here::here("data", "processed", "lists", "list_traits.txt"), h = T, sep = "\t") #790 29-06
end <- read.table(here::here("data", "processed", "lists", "cerrado_endemics_list.txt"), h = T, sep = "\t") #125 29-06

#repttraits_raw <- read.csv(here::here("data", "raw","traits", "repttraits-raw.csv"))
#squambase_raw <- read.csv(here::here("data", "raw","traits", "squambase-raw.csv"))

repttraits_br <- read.table(here::here("data", "processed","traits", "repttraits-br.txt"), header = TRUE) #790 29-06
squambase_br <- read.table(here::here("data", "processed","traits", "squambase-br.txt"), header = TRUE) #790 29-06

#traits <- read.table(here::here("data", "processed", "traits", "traits_merge.csv"), header = TRUE, sep = ",")

#tree_raw <- ape::read.tree(here::here("data", "raw","phylogeny", "main_title.tre")) #phylogenetic tree (title et al 2024)
tree <- ape::read.tree(here::here("data", "processed","phylogeny", "title_br.tre")) #pruned to SALVE species

# distribution ------------------------------------------------------------
#db <- read.table(here::here("data", "processed", "distribution", "salve-combined.csv"), header = TRUE, sep = ",")
db_reviewed <- read.table(here::here("data", "processed", "distribution", "db_reviewed.csv"), header = TRUE, sep = ",")

# shapes ------------------------------------------------------------------
brazil <- sf::st_read(here::here("data", "raw", "shapes", "brazil.shp"))
biomas <- sf::st_read(here::here("data", "raw", "shapes", "biomas.shp"))
#grid <- sf::st_read(here::here("data", "processed", "shapes", "grid.shp"))


# outputs -----------------------------------------------------------------
pa <- read.csv(here::here("outputs", "pa_matrix.csv"), row.names = 1, check.names = FALSE)
coords <- read.csv(here::here("outputs", "coords.csv"), row.names = 1, check.names = FALSE)
grid_pa <- sf::st_read(here::here("data", "processed", "shapes", "grid_pa.shp"))
out_single_site <- readRDS(here::here("outputs", "sbears_single.rds"))

