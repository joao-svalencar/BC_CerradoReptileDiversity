# SALVE species list manipulation -----------------------------------------
names(list_raw)

list_raw <- list_raw[,c(4:7, 13:14, 16, 22)]
head(list_raw)

names(list_raw) <- c("order", "family", "genus", "species", "evalDate", "threatStatus", "criteria", "biomes")

list_raw <- list_raw[list_raw$order %in% c("Squamata", "Serpentes"),]
list_raw$order[list_raw$order == "Serpentes"] <- "Squamata"

table(list_raw$threatStatus)
list_raw$threatStatus[list_raw$threatStatus=="Menos Preocupante"] <- "LC"
list_raw$threatStatus[list_raw$threatStatus=="Quase Ameaçada"] <- "NT"
list_raw$threatStatus[list_raw$threatStatus=="Vulnerável"] <- "VU"
list_raw$threatStatus[list_raw$threatStatus=="Em Perigo"] <- "EN"
list_raw$threatStatus[list_raw$threatStatus=="Criticamente em Perigo"] <- "CR"
list_raw$threatStatus[list_raw$threatStatus=="Dados Insuficientes"] <- "DD"

write.table(list_raw, here::here("data","processed", "lists", "salve-squamata-simplified.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)

# loading and simplifying SALVE database ----------------------------------
dataFiles <- c(dir(here::here("data", "raw", "distribution", "salve-raw")))
dataFiles <- c(dir(here::here("data", "raw", "distribution", "salve-raw-testudines_crocodylia")))

my_data <- read.csv(here::here("data", "raw", "distribution", "salve-raw-testudines_crocodylia", dataFiles[1]))

for(i in 2:length(dataFiles))
{
  my_data2 <- read.csv(here::here("data", "raw", "distribution", "salve-raw-testudines_crocodylia", dataFiles[i]))
  my_data <- as.data.frame(rbind(my_data, my_data2))
}

names(my_data)

db <- my_data[,c(4,5,7,10,11)]
names(db) <- c("order", "family", "species", "latitude", "longitude")
str(db)
head(db)

unique(db$order)
length(unique(db$species)) 

head(db)
head(db_reviewed)

db_reptiles_br <- rbind(db, db_reviewed)

head(db_reptiles_br)
length(unique(db_reptiles_br$species)) #840
length(list_br$species)

# proceed to select only unique records -----------------------------------
db_reptiles_br$unique <- paste(db_reptiles_br$order,
                               db_reptiles_br$family,
                               db_reptiles_br$species,
                               db_reptiles_br$latitude,
                               db_reptiles_br$longitude, sep=",")

head(db_reptiles_br)

uniquerec <- data.frame(unique(db_reptiles_br$unique)) #Seleciona combinacoes unicas de spp+lat+long da coluna combinada
#140626 unique records

head(uniquerec)

db_unique <- tidyr::separate(data=uniquerec, col="unique.db_reptiles_br.unique.", 
                             into=c("order","family","species", "latitude", "longitude"), sep=",",
                             convert=TRUE) #funcao de separacao

head(db_unique)
db_unique <- db_unique[order(db_unique$species),]

###########################################################################
# save unique records database --------------------------------------------
write.csv(db_unique, here::here("data", "processed","distribution", "reptiles_salve.csv"), row.names = FALSE)
###########################################################################



# loading Micrurus obscurus data from Nogueira et al. 2019 ----------------
mobscurus <- read.csv(here::here("data", "distribution", "added_spp", "m_obscurus_atlas.csv"))
head(mobscurus)
db <- rbind(db, mobscurus) #merging SALVE records with M. obscurus records. total = 181,574 records

# loading Micrurus carvalhoi data from Terribile et al. (2018) ------------
mcarvalhoi <- read.csv(here::here("data", "distribution", "added_spp","m_carvalhoi_terribile.csv"))
head(mcarvalhoi)
db <- rbind(db, mcarvalhoi) # extra records added manually from Pires et al. (2021)

# matching nomenclature with Uetz -----------------------------------------
nomenclature <- list[,c(2, 3)]

length(unique(list$salve)) # one missing species to be processed: Amnesteophis melanauchen
length(unique(db$species))

sum(unique(list$salve) %in% unique(db$species))
sum(unique(db$species) %in% unique(list$salve))

list[which(!unique(list$salve) %in% unique(db$species)),] # missing Amnesteophis melanauchen

unique(db$species)[which(!unique(db$species) %in% unique(list$salve))] # all species in the db are in the SALVE list
unique(db$species)[which(unique(db$species) %in% list$Reptile.Database == 0)] # db species with nomenclature issues according to Uetz (27)

db <- merge(db, nomenclature, by.x="species", by.y="salve", all.x = TRUE) # merging current nomenclature to database

head(db)

###########################################################################
# save short database -----------------------------------------------------
write.table(db, here::here("data", "distribution", "salve-combined", "dbSalve_short.txt"), fileEncoding = "utf-8", sep=",", row.names = FALSE) #seems to work!
###########################################################################

