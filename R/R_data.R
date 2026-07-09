#list_raw <- read.csv(here::here("data", "raw", "lists", "salve-publico-exportacao-fichas-planilha28-06-2026-20-49-24.csv"), encoding = "UTF8") #requires namenclature harmonization
#list_simple <- read.table(here::here("data", "processed", "lists", "salve-simplified.txt"), h = T, sep = "\t") #requires namenclature harmonization
#list <- read.table(here::here("data", "processed", "lists", "salve-taxonomy-reviewed.txt"), h = T, sep = "\t") #835 29-06

list_br <- read.table(here::here("data", "processed", "lists", "br_reptiles.txt"), h = T, sep = "\t")

#end <- read.table(here::here("data", "processed", "lists", "cerrado_endemics_list.txt"), h = T, sep = "\t") #125 29-06 from Vieira-Alencar et al 2023 with current nomenclature

# distribution ------------------------------------------------------------
#db_reviewed <- read.table(here::here("data", "processed", "distribution", "db_reviewed.csv"), header = TRUE, sep = ",") #only squamata: nomenclature ok
db_reptiles <- read.table(here::here("data", "processed","distribution", "reptiles_salve.csv"), header = TRUE, sep = ",") #"all" BR reptiles: nomenclature ok

# shapes ------------------------------------------------------------------
brazil <- sf::st_read(here::here("data", "raw", "shapes", "brazil.shp"))
biomas <- sf::st_read(here::here("data", "raw", "shapes", "biomas.shp"))
#grid <- sf::st_read(here::here("data", "processed", "shapes", "grid.shp"))

