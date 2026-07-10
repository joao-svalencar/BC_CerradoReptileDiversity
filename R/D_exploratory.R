library(letsRept)
reptCompare(list$species, filter = "review") # all nomenclature up to date

# RDB Brazilian species check ---------------------------------------------
link <- reptAdvancedSearch(location = "Brazil")
br_species <- reptSpecies(link, taxonomicInfo = TRUE, cores = 9)

missing <- br_species[!br_species$species %in% list_br$species,]

# checking which missing species actually occur in BR ---------------------
missing$species

# selecting species to drop from RDB Brazilian list -----------------------
# most are invasive, the other have poor evidence of occurrence in Brazilian territory

br_drop <- c("Anolis porcatus",
             "Anolis sagrei",
             "Bachia alleni",
             "Gekko gecko",
             "Gonatodes concinnatus",
             "Hemidactylus mabouia",
             "Leiosaurus paronae",
             "Lepidodactylus lugubris",
             "Ophiodes vertebralis",
             "Pantherophis guttatus",
             "Pelodiscus sinensis",
             "Phalotris spegazzinii",
             "Plica kathleenae",
             "Trachemys scripta",
             "Trachylepis maculata",
             "Tropidurus guarani",
             "Tropidurus spinulosus",
             "Urotheca multilineata")

missing <- missing[!missing$species %in% br_drop,] #drop from the missing list
br_species <- br_species[!br_species$species %in% br_drop,] # drop from RDB Brazilian list N = 878 species

# check which missing species occur in the Cerrado ------------------------

list_br$cerrado_endemic <- ifelse(list_br$species %in% end$species, "yes", "no") #adding binary endemism information from Vieira-Alencar et al. 2023

list_br$species[list_br$cerrado_endemic == "yes" & list_br$cerrado_sp == "no"]
list_br$cerrado_sp[list_br$cerrado_endemic == "yes" & list_br$cerrado_sp == "no"] <- "yes"

new_species <- data.frame()

toAdd <- data.frame(order = "Squamata",
                    family = "Colubridae",
                    species = "Chironius xaraes",
                    biomes = "Cerrado, Pantanal",
                    cerrado_sp = "yes",
                    cerrado_endemic = "no")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Scincidae",
                    species = "Copeoglossum oreades",
                    biomes = "Cerrado",
                    cerrado_sp = "yes",
                    cerrado_endemic = "yes")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Colubridae",
                    species = "Leptophis mystacinus",
                    biomes = "Cerrado",
                    cerrado_sp = "yes",
                    cerrado_endemic = "yes")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Elapidae",
                    species = "Micrurus janisrozei",
                    biomes = "Caatinga, Cerrado, Mata Atlântica",
                    cerrado_sp = "yes",
                    cerrado_endemic = "no")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Elapidae",
                    species = "Micrurus bonita",
                    biomes = "Caatinga, Cerrado, Mata Atlântica",
                    cerrado_sp = "yes",
                    cerrado_endemic = "no")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Colubridae",
                    species = "Philodryas pseudomamba",
                    biomes = "Caatinga, Cerrado, Mata Atlântica, Pampa, Pantanal",
                    cerrado_sp = "yes",
                    cerrado_endemic = "no")

new_species <- rbind(new_species, toAdd)

toAdd <- data.frame(order = "Squamata",
                    family = "Colubridae",
                    species = "Tantilla selmae",
                    biomes = "Cerrado, Mata Atlântica, Pampa",
                    cerrado_sp = "yes",
                    cerrado_endemic = "no")

new_species <- rbind(new_species, toAdd)
new_species

list_cerrado <- rbind(list_cerrado, new_species)
tail(list_cerrado)
list_cerrado <- list_cerrado[order(list_cerrado$species),] #439

list_br <- rbind(list_br, new_species)


# Inspecting and selecting missing species to add -------------------------
head(list_br)
head(br_species)

br_species <- br_species[,-c(2,4,6,7)]
head(br_species)

br_species$biomes <- NA
br_species$cerrado_sp <- "no"
br_species$cerrado_endemic <- "no"

missing_to_add <- br_species[br_species$species %in% missing$species,]

list_br <- rbind(list_br, missing_to_add)
list_br <- list_br[!duplicated(list_br$species),]


# reviewing Cerrado turtles and tortoises (TTWG 2025) ---------------------
list_br[list_br$order =="Testudines" & list_br$cerrado_sp =="yes",]

drop_cerrado_turtles <- c("Caretta caretta", "Chelonia mnydas", "Dermochelys coriacea", "Eretmochelys imbricata", "Lepidochelys olivacea", "Platemys platycephala")

list_br$cerrado_sp[list_br$species %in% drop_cerrado_turtles] <- "no"

table(list_br$cerrado_sp) # 434/882 = 49.2%

# saving final Brazilian reptile list -------------------------------------
list_br <- list_br[!list_br$species %in% c("Apostolepis ambiniger", "Philodryas patagoniensis"),]


rdb_info <- list_br_rdb[list_br_rdb$species %in% list_br$species, c(2, 3, 5, 6)] #suborder,family, species, year
head(rdb_info)

list_br[!list_br$species %in% rdb_info$species,]

reptSearch("Plica plica") #kept in the Brazilian list
reptSearch("Neusticurus medemi") #kept in the Brazilian list

toAdd <- data.frame(suborder = c("Sauria", "Sauria"),
                    family = c("Tropiduridae", "Gymnophtalmidae"),
                    species = c("Plica plica", "Neusticurus medemi"),
                    year = c("1758", "1981"))

rdb_info <- rbind(rdb_info, toAdd)
rdb_info <- rdb_info[order(rdb_info$species),] #matching list_br 880 species


list_br <- merge(list_br, rdb_info, by = "species")

head(list_br)

list_br <- list_br[,c(2, 7, 8, 1, 9, 4, 5, 6)]

head(list_br)
names(list_br)[3] <- "family"

write.table(list_br, here::here("data", "processed", "lists", "br_reptiles.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)

###########################################################################
# selecting only Cerrado species from the Brazilian list ------------------
###########################################################################

list_cerrado <- list_br[list_br$cerrado_sp =="yes",]

table(list_cerrado$cerrado_endemic) #127/436 = 29.1% reptiles

table(list_cerrado$cerrado_endemic, list_cerrado$order)

127/(127+286) #127/410 = 30.7% Squamata

list_cerrado[list_cerrado$order=="Crocodylia",] # ok
list_cerrado[list_cerrado$order=="Testudines",] # ok

head(list_br)
a <- list_br[,c(4, 7)]

db_reptiles_br <- merge(db_reptiles_br, a, by = "species", all.x = TRUE)
head(db_reptiles_br)

