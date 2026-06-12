#list_raw <- read.csv(here::here("data", "raw", "lists", "salve-publico-exportacao-fichas-planilha26-03-2026-13-05-15.csv"), encoding = "UTF8") 
#list_simple <- read.table(here::here("data", "processed", "lists", "salve-squamata-simplified.txt"), h = T, sep = "\t")

list <- read.table(here::here("data", "processed", "lists", "salve-squamata-taxonomy-reviewed.txt"), h = T, sep = "\t")
end <- read.table(here::here("data", "raw", "lists", "endemics.csv"), h = T, sep = ",")

#tree_raw <- ape::read.tree(here::here("data", "raw","phylogeny", "main_title.tre")) #phylogenetic tree (title et al 2024)
#tree_pruned <- ape::read.tree(here::here("data", "processed","phylogeny", "title_br.tre")) #pruned to SALVE species
tree <- ape::read.tree(here::here("data", "processed","phylogeny", "title_br.tre")) #pruned to SALVE species

#repttraits_raw <- read.csv(here::here("data", "raw","traits", "repttraits-raw.csv"))
#squambase_raw <- read.csv(here::here("data", "raw","traits", "squambase-raw.csv"))

repttraits_br <- read.table(here::here("data", "processed","traits", "repttraits-br.txt"), header = TRUE)
squambase_br <- read.table(here::here("data", "processed","traits", "squambase-br.txt"), header = TRUE)

traits <- read.table(here::here("data", "processed", "traits", "traits_merge.csv"), header = TRUE, sep = ",")

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

