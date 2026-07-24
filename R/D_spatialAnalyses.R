library(sf)

# spatial analyses --------------------------------------------------------
head(list_br)

toFilter <- list_br[,c(2, 5, 6, 8, 9)]
head(toFilter)

db_reptiles_br <- merge(db_reptiles_br, toFilter, by = "species", all.x = TRUE)
head(db_reptiles_br)

db_cerrado <- db_reptiles_br[db_reptiles_br$cerrado_sp=="yes",]

length(unique(db_cerrado$species)) #438 species OK
length(unique(db_cerrado$species[db_cerrado$cerrado_endemic=="yes"])) #127 endemic species OK

db_spatial <- sf::st_as_sf(db_cerrado, coords = c("longitude", "latitude"), crs = 4326)
db_spatial <- sf::st_transform(db_spatial, crs = 4674) #SIRGAS

cerrado <- biomes[biomes$Bioma == "Cerrado", ] #extract Cerrado limits

#creating general grid (check if in this step we can make it as sf class directly)
grid <- sf::st_make_grid(
  sf::st_as_sfc(sf::st_bbox(cerrado)),
  cellsize = c(1, 1),
  square = TRUE)


grid_cerrado <- grid[sf::st_intersects(grid, cerrado, sparse = FALSE)] #selecting only grid cells intersecting the Cerrado
class(grid_cerrado)

grid_spatial <- sf::st_sf(geometry = grid_cerrado) #converting to sf
class(grid_spatial)

# intersecting grid and species records -----------------------------------
grid_spatial$grid_id <- 1:nrow(grid_spatial)
intersection <- sf::st_join(db_spatial, grid_spatial, join = st_intersects)

attribute_data <- sf::st_drop_geometry(intersection)
attribute_data <- attribute_data[!is.na(attribute_data$grid_id), ]

split_grid_list <- split(attribute_data, attribute_data$grid_id)

# species records ---------------------------------------------------------
records_summary <- data.frame(
  grid_id = as.integer(names(split_grid_list)),
  
  total_records          = sapply(split_grid_list, nrow),
  
  endemic_records        = sapply(split_grid_list, function(df) sum(df$cerrado_end == "yes", na.rm = TRUE)),
  non_endemic_records    = sapply(split_grid_list, function(df) sum(df$cerrado_end == "no", na.rm = TRUE)),
  
  testudines_total       = sapply(split_grid_list, function(df) sum(df$order == "Testudines", na.rm = TRUE)),
  crocodylia_total       = sapply(split_grid_list, function(df) sum(df$order == "Crocodylia", na.rm = TRUE)),
  squamata_total         = sapply(split_grid_list, function(df) sum(df$order == "Squamata", na.rm = TRUE)),
  
  amphisbaenia   = sapply(split_grid_list, function(df) sum(df$suborder == "Amphisbaenia", na.rm = TRUE)),
  sauria         = sapply(split_grid_list, function(df) sum(df$suborder == "Sauria", na.rm = TRUE)),
  serpentes      = sapply(split_grid_list, function(df) sum(df$suborder == "Serpentes", na.rm = TRUE))
)

final_grid_records <- merge(grid_spatial, records_summary, by = "grid_id", all.x = TRUE)

cols_to_zero_rec <- setdiff(names(records_summary), "grid_id")

for (col in cols_to_zero_rec) {
  final_grid_records[[col]][is.na(final_grid_records[[col]])] <- 0
}

st_write(final_grid_records, here::here("outputs", "shapes", "cerrado_reptile_records.gpkg"), delete_dsn = TRUE)

# species richness --------------------------------------------------------
richness_summary <- data.frame(
  grid_id = as.integer(names(split_grid_list)),
  total_richness      = sapply(split_grid_list, function(df) length(unique(df$species))),
  testudines_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Testudines"]))),
  crocodylia_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Crocodylia"]))),
  squamata_richness   = sapply(split_grid_list, function(df) length(unique(df$species[df$order == "Squamata"]))),
  endemic_richness   = sapply(split_grid_list, function(df) length(unique(df$species[df$cerrado_end == "yes"]))),
  new2002_endemic_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$year >= 2002]))),
  new2010_endemic_richness = sapply(split_grid_list, function(df) length(unique(df$species[df$year >= 2010])))
)

final_grid_richness <- merge(grid_spatial, richness_summary, by = "grid_id", all.x = TRUE)

cols_to_zero_rich <- setdiff(names(richness_summary), "grid_id")

for (col in cols_to_zero_rich) {
  final_grid_richness[[col]][is.na(final_grid_richness[[col]])] <- 0
}

sf::st_write(final_grid_richness, here::here("outputs", "shapes", "cerrado_reptile_richness.gpkg"), delete_dsn = TRUE)
