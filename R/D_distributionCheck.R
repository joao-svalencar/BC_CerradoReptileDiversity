# Script to check and merge distribution information ----------------------
head(db_reptiles)

length(unique(db_reptiles_br$species)) #840/880 species 95.4% - missing 40 species

# check how many Cerrado species are missing ------------------------------

missing <- list_br[!list_br$species %in% unique(db_reptiles_br$species),]
missing #only species not occurring in the Cerrado are missing for the database at the moment (July 10th 2026). a.k.a.: not urgent

list_br$biomes[list_br$species=="Amnesteophis melanauchen"] <- NA
list_br$biomes[list_br$species=="Oxyrhopus occipitalis"] <- NA
list_br$biomes[list_br$species=="Anolis sericeus"] <- NA


# species in the Cerrado not considered in SALVE --------------------------
cerrado_check <- c("Ameivula pyrrhogularis", #ok
  "Amphisbaena darwinii", #ok
  "Colobosauroides cearensis", #ok
  "Micrurus carvalhoi", #ok
  "Oxyrhopus melanogenys") #ok

list_br$cerrado_sp[list_br$species %in% cerrado_check] <- "yes"

# merging testudines distribution from TTWG to SALVE ----------------------
names(db_testudines)
db_testudines <- db_testudines[,c(2,8,9)]

head(db_testudines)
names(db_testudines)[1] <- "species"

head(db_reptiles_br)

db_testudines$order <- "Testudines"

head(list_br)
list_testu <- list_br[list_br$order=="Testudines", c(3,4)]

head(list_testu)

db_testudines <- merge(db_testudines, list_testu, by = "species")

head(db_testudines)
head(db_reptiles_br)

db_testudines <- db_testudines[,c(4,5,1,2,3)]

db_reptiles_br <- rbind(db_reptiles_br, db_testudines) #going to unique.
