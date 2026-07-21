library(sf)


# renaming biomes dataset (EN) --------------------------------------------
head(biomes)
biomes$Bioma <- c("Amazon", "Caatinga", "Cerrado", "Atlantic Forest", "Pampa", "Pantanal")

# for full database, go directly to line 16

# squamate dataset --------------------------------------------------------
head(db_reptiles_br)
db_squam <- db_reptiles_br[db_reptiles_br$order =="Squamata",]
length(unique(db_squam$species)) #798 species in the dataset: missing 39 in comparison with spp list

# conversion to spatial object (modify accordingly) -----------------------
db_spatial <- sf::st_as_sf(db_reptiles_br, coords = c("longitude", "latitude"), crs = 4326) #for reptiles
db_spatial <- sf::st_as_sf(db_squam, coords = c("longitude", "latitude"), crs = 4326) #for squamata only

db_spatial <- sf::st_transform(db_spatial, crs = 4674) #SIRGAS

sf::sf_use_s2(FALSE)
intersection <- sf::st_join(db_spatial, biomes, join = sf::st_intersects)
sf::sf_use_s2(TRUE)

df_biomes <- sf::st_drop_geometry(intersection)
df_biomes <- df_biomes[!is.na(df_biomes$Bioma), ]


# contingence table -------------------------------------------------------

counts_table <- table(df_biomes$Bioma, df_biomes$species)
counts_matrix <- as.matrix(counts_table)
#counts_matrix[, 1:5]

pa_matrix <- counts_matrix
pa_matrix[pa_matrix >0] <- 1

pa_matrix <- as.matrix(as.data.frame.matrix(pa_matrix))
#pa_matrix[, 1:5]

# prop_matrix -------------------------------------------------------------
prop_matrix <- sweep(counts_matrix, 2, colSums(counts_matrix), "/")
prop_matrix[is.na(prop_matrix)] <- 0

prop_matrix <- as.matrix(as.data.frame.matrix(prop_matrix))
prop_matrix[,1:5]

# analyses ----------------------------------------------------------------
library(vegan)

#jaccard to calculate the distance/similarity amongst biomes
dist_pa <- vegdist(pa_matrix, method = "jaccard")
sim_pa <- as.matrix(1- dist_pa)
sim_pa <- (round(sim_pa, digits = 3))

sim_pa <- cbind(sim_pa, TOTAL = rowSums(sim_pa))
sim_pa

write.csv(sim_pa, here::here("outputs", "table 1_reptWDC.csv"))
#write.csv(sim_pa, here::here("outputs", "table S1_squamWDC.csv"))

# NDMS with prop matrix
nmds_res <- metaMDS(prop_matrix, distance = "bray", k = 2, trymax = 100)
nmds_res$stress #below 0.2 means good ordering



