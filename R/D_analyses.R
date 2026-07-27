library(sf)
library(vegan)
library(ggplot2)

# renaming biomes dataset (EN) --------------------------------------------
head(biomes)
biomes$Bioma <- c("Amazon", "Caatinga", "Cerrado", "Atlantic Forest", "Pampa", "Pantanal")

# squamate dataset --------------------------------------------------------
head(db_reptiles_br)
db_squam <- db_reptiles_br[db_reptiles_br$order =="Squamata",] #filtering dataset for only squamata species
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

write.csv(sim_pa, here::here("outputs", "tables", "table 1_reptWDC.csv"))
#write.csv(sim_pa, here::here("outputs", "tables", "table S1_squamWDC.csv"))

# NDMS with prop matrix
nmds_res <- metaMDS(prop_matrix, distance = "bray", k = 2, trymax = 100)
nmds_res$stress #below 0.2 means good ordering #go to S_ndms for NDMS Figure

# calculating weighted  degree centrality (WDC) ---------------------------
wdc <- function(pa_matrix, interest_bioma = "Cerrado") {
  biomes <- rownames(pa_matrix)
  total_jaccard <- 0
  
  interest_vector <- pa_matrix[interest_bioma, ]
  
  for (b in biomes) {
    if (b != interest_bioma) {
      neighbor_vector <- pa_matrix[b, ]
      
      # Jaccard: intersection / union
      intersection <- sum(interest_vector == 1 & neighbor_vector == 1)
      union       <- sum(interest_vector == 1 | neighbor_vector == 1)
      
      jaccard <- intersection / union
      total_jaccard <- total_jaccard + jaccard
    }
  }
  return(total_jaccard)
}

# permutation test --------------------------------------------------------
observed_sharing_cerrado <- wdc(pa_matrix, "Cerrado")
cat("Observed sharing in Cerrado (Sum of Bray-Curstis indices):", observed_sharing_cerrado, "\n")

set.seed(42)
n_permutations <- 10000

null_sharing_cerrado <- numeric(n_permutations)

# generates null models
null_models <- nullmodel(pa_matrix, method = "swap")
simulated_matrices <- simulate(null_models, nsim = 10000)

# apply function wdc to the 10,000 simulated matrices (dimension 3)
null_sharing_cerrado <- apply(simulated_matrices, 3, wdc, interest_bioma = "Cerrado")

# simulated wdc summary
print(summary(null_sharing_cerrado))

# calculating p-value
p_value <- sum(null_sharing_cerrado >= observed_sharing_cerrado) / 10000
cat("\n Permutation test p-value (Swap):", p_value, "\n")

# to create figure S1: histogram of simulated wdcs + observed Cerrado wdc
df_null <- data.frame(wdc = null_sharing_cerrado)

figS1 <- ggplot(df_null, aes(x = wdc)) +
  geom_histogram(bins = 30, fill = "lightblue", color = "white") +
  geom_vline(xintercept = observed_sharing_cerrado, 
             color = "red", linetype = "dashed", size = 1) +
  coord_cartesian(xlim = c(min(c(null_sharing_cerrado, observed_sharing_cerrado)) - 0.001,
                           max(c(null_sharing_cerrado, observed_sharing_cerrado)) * 1.01)) +
  labs(
    title = "Permutation Test (Swap)",
    x = "Weighted Degree Centrality (WDC)",
    y = "Frequency"
  ) +
  theme_classic()

figS1

ggsave("Fig S1.png",
       device = png,
       plot = figS1,
       path = here::here("outputs", "figures"),
       width = 180,
       height = 100,
       units = "mm",
       dpi = 1000,
)
