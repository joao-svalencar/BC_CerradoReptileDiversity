library(sf)
# spatial analyses --------------------------------------------------------

# converting to spatial data ----------------------------------------------
db_phyl <- db_reviewed[db_reviewed$species %in% traits$species[traits$phylogeny=="yes"],]

length(unique(db_phyl$species)) #505 species
head(db_phyl)

db_spatial <- sf::st_as_sf(db_phyl, coords = c("longitude", "latitude"), crs = 4326)

grid <- sf::st_make_grid(
  sf::st_as_sfc(sf::st_bbox(brazil)),
  cellsize = c(1, 1),
  square = TRUE)

grid <- sf::st_sf(id = 1:length(grid), geometry = grid)

#plot(st_geometry(grid))
#plot(st_geometry(brazil), add = TRUE)

intersection <- sf::st_join(db_spatial, grid, join = sf::st_intersects)
head(intersection)

df <- intersection[!is.na(intersection$id), ]

tab <- table(df$id, df$species)

pa <- (tab > 0) * 1
pa[1:10,1:5]

rownames(pa) #"id"
ids_pa <- as.integer(rownames(pa))
grid_pa <- grid[grid$id %in% ids_pa, ]

plot(st_geometry(brazil))
plot(st_geometry(grid_pa), add = TRUE)
plot(st_centroid(grid_pa)[1:10,], add = TRUE, size = .1)


cent <- sf::st_centroid(grid_pa) #creates centroids
coords <- data.frame(id = grid_pa$id,
                     longitude = sf::st_coordinates(cent)[,1],
                     latitude = sf::st_coordinates(cent)[,2])
head(coords)
pa[1:10, 1:5]

?write.csv
write.csv(pa, here::here("outputs", "pa_matrix.csv"), row.names = TRUE) #export pa_matrix
write.csv(coords, here::here("outputs", "coords.csv"), row.names = FALSE) #export pa_matrix
st_write(grid_pa, here::here("data", "processed", "shapes", "grid_pa.shp"), delete_layer = TRUE) #export grid
