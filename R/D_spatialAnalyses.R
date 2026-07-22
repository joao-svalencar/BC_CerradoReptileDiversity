library(sf)

# spatial analyses --------------------------------------------------------
head(list_br)
a <- list_br[,c(4, 5, 7, 8)] #species and cerrado

db_reptiles_br <- merge(db_reptiles_br, a, by = "species", all.x = TRUE)
head(db_reptiles_br)

db_cerrado <- db_reptiles_br[db_reptiles_br$cerrado_sp=="yes",]
#db_cerrado <- db_reptiles_br[db_reptiles_br$cerrado_endemic=="yes",] #for endemics only

length(unique(db_cerrado$species)) #436 species OK
length(unique(db_cerrado$species)) #127 endemic species OK

db_spatial <- sf::st_as_sf(db_cerrado, coords = c("longitude", "latitude"), crs = 4326)
db_spatial <- sf::st_transform(db_spatial, crs = 4674) #SIRGAS

cerrado <- biomes[biomes$Bioma == "Cerrado", ]

#plot(st_geometry(cerrado), col = "lightgrey")

grid <- sf::st_make_grid(
  sf::st_as_sfc(sf::st_bbox(cerrado)),
  cellsize = c(1, 1),
  square = TRUE)

#plot(st_geometry(grid), add = TRUE)

grid_cerrado <- grid[sf::st_intersects(grid, cerrado, sparse = FALSE)]
grid_spatial <- sf::st_sf(geometry = grid_cerrado)

#plot(st_geometry(grid_spatial), add = TRUE)

# total records per grid cell ---------------------------------------------
grid_spatial$total_points <- lengths(st_intersects(grid_spatial, db_spatial))

st_write(grid_spatial, here::here("outputs", "cerrado_records.gpkg"), delete_dsn = TRUE)

# species richness by suborders and total ---------------------------------
grid_spatial$grid_id <- 1:nrow(grid_spatial)
intersection <- sf::st_join(db_spatial, grid_spatial, join = sf::st_intersects)
head(intersection)

attribute_data <- sf::st_drop_geometry(intersection) #speed up data processing
attribute_data <- attribute_data[!is.na(attribute_data$grid_id), ] # remove NAs

split_grid_list <- split(attribute_data, attribute_data$grid_id)

richness_summary <- data.frame(
  grid_id = as.integer(names(split_grid_list)),
  total_richness      = sapply(split_grid_list, function(df) length(unique(df$species))),
  testudines_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Testudines"]))),
  crocodylia_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Crocodylia"]))),
  squamata_richness   = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Squamata"])))
)

final_grid <- merge(grid_spatial, richness_summary, by = "grid_id", all.x = TRUE)

richness_columns <- c("total_richness", "testudines_richness", "crocodylia_richness", "squamata_richness")

for (col in richness_columns) {
  final_grid[[col]][is.na(final_grid[[col]])] <- 0
}

sf::st_write(final_grid, here::here("outputs", "cerrado_reptile_richness.gpkg"), delete_dsn = TRUE)


# endemic species richness versus new endemics species --------------------
richness_summary_endemic <- data.frame(
  grid_id = as.integer(names(split_grid_list)),
  
  # 1. Todas as endêmicas da célula
  total_endemic_richness = sapply(split_grid_list, function(df) {
    length(unique(df$species))
  }),
  
  # 2. Apenas as descritas de 2010 em diante (2010 incluso)
  new_endemic_richness_2010 = sapply(split_grid_list, function(df) {
    length(unique(df$species[df$year >= 2010]))
  })
)

head(richness_summary_endemic)

final_grid <- merge(grid_spatial, richness_summary_endemic, by = "grid_id", all.x = TRUE)

richness_columns <- c("total_endemic_richness", "new_endemic_richness_2010")

for (col in richness_columns) {
  final_grid[[col]][is.na(final_grid[[col]])] <- 0
}

sf::st_write(final_grid, here::here("outputs", "cerrado_endemic_richness.gpkg"), delete_dsn = TRUE)
