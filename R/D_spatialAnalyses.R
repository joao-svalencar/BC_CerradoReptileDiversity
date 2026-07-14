library(sf)

# spatial analyses --------------------------------------------------------
head(list_br)
a <- list_br[,c(4, 7)] #species and cerrado

db_reptiles_br <- merge(db_reptiles_br, a, by = "species", all.x = TRUE)
head(db_reptiles_br)

db_cerrado <- db_reptiles_br[db_reptiles_br$cerrado_sp=="yes",]
length(unique(db_cerrado$species)) #436 species OK

db_spatial <- sf::st_as_sf(db_cerrado, coords = c("longitude", "latitude"), crs = 4326)
db_spatial <- sf::st_transform(db_spatial, crs = 4674) #SIRGAS

cerrado <- biomas[biomas$Bioma == "Cerrado", ]

#plot(st_geometry(cerrado), col = "lightgrey")

grid <- sf::st_make_grid(
  sf::st_as_sfc(sf::st_bbox(cerrado)),
  cellsize = c(0.5, 0.5),
  square = TRUE)

#plot(st_geometry(grid), add = TRUE)

grid_cerrado <- grid[sf::st_intersects(grid, cerrado, sparse = FALSE)]
grid_spatial <- sf::st_sf(geometry = grid_cerrado)

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
