###########################################################################
# Description -------------------------------------------------------------
# Script dedicated to harmonize the nomenclature and filter datasets information
###########################################################################

library(letsRept)

###########################################################################
# Brazilian species list --------------------------------------------------
###########################################################################
review <- reptCompare(list_raw_simple$species, filter = "review")
matched <- reptCompare(list_raw_simple$species, filter = "matched")

list_simple_matched <- list_raw_simple[list_raw_simple$species %in% matched,]

# checking unmatched names ------------------------------------------------
sync <- reptSync(review, solveAmbiguity = TRUE, cores = 9)
table(sync$status)

# solving "not_found" -----------------------------------------------------
reptTidySyn(sync, filter = "not_found")

sync$RDB[sync$query=="Dactyloa neglecta"] <- "Anolis neglectus"
list_raw_simple$species[list_raw_simple$species == "Dactyloa neglecta"] <- "Anolis neglectus"
sync$status[sync$query=="Dactyloa neglecta"] <- "updated"

table(sync$status)

# solving "merge" ---------------------------------------------------------
reptTidySyn(sync, filter = "merge")

list_raw_simple[list_raw_simple$species %in% c("Liotyphlops beui", "Liotyphlops sousai", "Liotyphlops ternetzii"),]
list_raw_simple$biomes[list_raw_simple$species=="Liotyphlops ternetzii"] <- "Amazônia, Caatinga, Cerrado, Mata Atlântica, Pantanal"
list_raw_simple <- list_raw_simple[!list_raw_simple$species %in% c("Liotyphlops beui", "Liotyphlops sousai"),]

sync$status[sync$query %in% c("Liotyphlops beui", "Liotyphlops sousai")] <- "updated"

table(sync$status)

# solving ambiguous -------------------------------------------------------
reptTidySyn(sync, filter = "ambiguous")

# Anisolepis undulatus
list_raw_simple[list_raw_simple$species %in% 
                  c("Urostrophus grilli", "Urostrophus longicauda", "Urostrophus undulatus"),]

sync$RDB[sync$query=="Anisolepis undulatus"] <- "Urostrophus undulatus"
list_raw_simple$species[list_raw_simple$species == "Anisolepis undulatus"] <- "Urostrophus undulatus"
sync$status[sync$query=="Anisolepis undulatus"] <- "updated"

# Corallus hortulanus
list_raw_simple[list_raw_simple$species %in% 
                  c("Corallus cookii", "Corallus hortulana"),]

sync$RDB[sync$query=="Corallus hortulanus"] <- "Corallus hortulana"
list_raw_simple$species[list_raw_simple$species == "Corallus hortulanus"] <- "Corallus hortulana"
sync$status[sync$query=="Corallus hortulanus"] <- "updated"

# Leposternon microcephalum
list_raw_simple[list_raw_simple$species %in% 
                  c("Leposternon bagual", "Leposternon microcephalus"),]

sync$RDB[sync$query=="Leposternon microcephalum"] <- "Leposternon microcephalus"
list_raw_simple$species[list_raw_simple$species == "Leposternon microcephalum"] <- "Leposternon microcephalus"
sync$status[sync$query=="Leposternon microcephalum"] <- "updated"

# Norops auratus
list_raw_simple[list_raw_simple$species %in% 
                  c("Anolis auratus", "Anolis tropidonotus"),]

sync$RDB[sync$query=="Norops auratus"] <- "Anolis auratus"
list_raw_simple$species[list_raw_simple$species == "Norops auratus"] <- "Anolis auratus"
sync$status[sync$query=="Norops auratus"] <- "updated"

# Taeniophallus occipitalis
list_raw_simple[list_raw_simple$species %in% 
                  c("Adelphostigma occipitalis", "Adelphostigma quadriocellata", "Eutrachelophis papilio"),]

sync$RDB[sync$query=="Taeniophallus occipitalis"] <- "Adelphostigma occipitalis"
list_raw_simple$species[list_raw_simple$species == "Taeniophallus occipitalis"] <- "Adelphostigma occipitalis"
sync$status[sync$query=="Taeniophallus occipitalis"] <- "updated"

table(sync$status)

# solving updated ---------------------------------------------------------
reptTidySyn(sync, filter = "updated")

# A. ibirajara
list_raw_simple[list_raw_simple$species %in%
                  c("Amphisbaena ibijara", "Amphisbaena frontalis"),]

list_raw_simple$biomes[list_raw_simple$species=="Amphisbaena frontalis"] <- "Amazonia, Caatinga, Cerrado"

list_raw_simple <- list_raw_simple[list_raw_simple$species!="Amphisbaena ibijara", ] #838

# A. lumbricalis
list_raw_simple[list_raw_simple$species %in%
                  c("Amphisbaena lumbricalis", "Amphisbaena carvalhoi"),] #no change required

list_raw_simple <- list_raw_simple[list_raw_simple$species!="Amphisbaena lumbricalis", ] #837


# Amphisbaena trachura
list_raw_simple[list_raw_simple$species %in%
                  c("Amphisbaena trachura", "Amphisbaena darwinii"),] #no change required

list_raw_simple$biomes[list_raw_simple$species=="Amphisbaena darwinii"] <- "Cerrado, Mata Atlântica, Pampa"

list_raw_simple <- list_raw_simple[list_raw_simple$species!="Amphisbaena trachura", ] #836

reptTidySyn(sync, filter = "updated")

# Anisolepis grilli > Urostrophus grilli
list_raw_simple[list_raw_simple$species %in%
                  c("Anisolepis grilli", "Urostrophus grilli"),] 

list_raw_simple$species[list_raw_simple$species=="Anisolepis grilli"] <- "Urostrophus grilli"

# Anisolepis longicauda > Urostrophus longicauda
list_raw_simple[list_raw_simple$species %in%
                  c("Anisolepis longicauda", "Urostrophus longicauda"),] 

list_raw_simple$species[list_raw_simple$species=="Anisolepis longicauda"] <- "Urostrophus longicauda"

#list_raw_simple$species <- sub("^Anisolepis", "Urostrophus", list_raw_simple$species)

# Apostolepis
list_raw_simple$species[list_raw_simple$species=="Apostolepis phillipsi"] <- "Apostolepis phillipsae"

list_raw_simple[list_raw_simple$species %in%
                  c("Apostolepis tertulianobeui", "Apostolepis assimilis"),] # no data change required

list_raw_simple <- list_raw_simple[list_raw_simple$species!="Apostolepis tertulianobeui",] #835

# Chironius
list_raw_simple[list_raw_simple$species %in%
                  c("Chironius dixoni", "Chironius laurenti"),] # no data change required
list_raw_simple$species[list_raw_simple$species=="Chironius dixoni"] <- "Chironius laurenti"
list_raw_simple$species[list_raw_simple$species=="Chironius scurrulus"] <- "Chironius scurrula"

# Corallus
list_raw_simple$species[grep("Corallus", list_raw_simple$species)]

# Dactyloa
list_raw_simple$species[list_raw_simple$species=="Dactyloa dissimilis"] <- "Anolis dissimilis"
list_raw_simple$species[list_raw_simple$species=="Dactyloa nasofrontalis"] <- "Anolis nasofrontalis"
list_raw_simple$species[list_raw_simple$species=="Dactyloa neglecta"] <- "Anolis neglectus"
list_raw_simple$species[list_raw_simple$species=="Dactyloa phyllorhina"] <- "Anolis phyllorhinus"
list_raw_simple$species[list_raw_simple$species=="Dactyloa pseudotigrina"] <- "Anolis pseudotigrinus"
list_raw_simple$species[list_raw_simple$species=="Dactyloa punctata"] <- "Anolis punctatus"
list_raw_simple$species[list_raw_simple$species=="Dactyloa transversalis"] <- "Anolis transversalis"

# Echinantera
list_raw_simple$species[list_raw_simple$species=="Echinanthera amoena"] <- "Amnisiophis amoenus"

# Epictia
list_raw_simple$species[list_raw_simple$species=="Epictia collaris"] <- "Habrophallos collaris"

# Leposternon 
list_raw_simple$species[grep("Leposternon", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species=="Leposternon microcephalum"] <- "Leposternon microcephalus"

# Leptomicrurus
list_raw_simple$species[grep("Leptomicrurus", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species=="Leptomicrurus narducci"] <- "Leptomicrurus narduccii"

# Liotyphlops
list_raw_simple$species[grep("Liotyphlops", list_raw_simple$species)] # fixed before

# Mastigodryas 
list_raw_simple$species[grep("Mastigodryas", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species=="Mastigodryas pleei"] <- "Mastigodryas pleii"

# Norops
list_raw_simple$species[grep("Norops", list_raw_simple$species)]

list_raw_simple$species[list_raw_simple$species=="Norops williamsii"] <- "Anolis sericeus"

list_raw_simple$species[grep("Anolis", list_raw_simple$species)]
list_raw_simple$species <- sub("^Norops", "Anolis", list_raw_simple$species)

# Philodryas
list_raw_simple$species[grep("Philodryas", list_raw_simple$species)]
list_raw_simple$species[grep("Xenoxybelis", list_raw_simple$species)]

list_raw_simple[list_raw_simple$species %in%
                  c("Philodryas georgeboulengeri", "Xenoxybelis boulengeri"),] # no data change required

list_raw_simple$species[list_raw_simple$species=="Philodryas georgeboulengeri"] <- "Xenoxybelis boulengeri"

#Phrynonax
list_raw_simple$species[grep("Phrynonax", list_raw_simple$species)]

list_raw_simple[list_raw_simple$species %in%
                  c("Phrynonax polylepis", "Phrynonax sexcarinatus"),] # no data change required
list_raw_simple$species[list_raw_simple$species=="Phrynonax polylepis"] <- "Phrynonax sexcarinatus"

# Siagonodon
list_raw_simple$species[grep("Siagonodon", list_raw_simple$species)]
list_raw_simple$species[grep("Trilepida", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species=="Siagonodon acutirostris"] <- "Trilepida acutirostris"

# Taoniophallus
list_raw_simple$species[grep("Taeniophallus", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species=="Taeniophallus affinis"] <- "Dibernardia affinis"
list_raw_simple$species[list_raw_simple$species=="Taeniophallus bilineatus"] <- "Dibernardia bilineata"
list_raw_simple$species[list_raw_simple$species=="Taeniophallus persimilis"] <- "Dibernardia persimilis"
list_raw_simple$species[list_raw_simple$species=="Taeniophallus poecilopogon"] <- "Dibernardia poecilopogon"
list_raw_simple$species[list_raw_simple$species=="Taeniophallus quadriocellatus"] <- "Adelphostigma quadriocellata"

# Thamnodynastes
list_raw_simple$species[grep("Thamnodynastes", list_raw_simple$species)]
list_raw_simple$species[list_raw_simple$species %in%
                          c("Thamnodynastes almae", "Thamnodynastes phoenix")] <- sub("^Thamnodynastes", "Dryophylax", list_raw_simple$species[list_raw_simple$species %in%
                                                                                                                                                 c("Thamnodynastes almae", "Thamnodynastes phoenix")])
list_raw_simple$species[list_raw_simple$species=="Thamnodynastes rutilus"] <- "Mesotes rutilus"

# Varzea
list_raw_simple$species[grep("Varzea", list_raw_simple$species)]
list_raw_simple$species <- sub("^Varzea", "Mabuya", list_raw_simple$species)

#Final list: 835 species
compare <- reptCompare(list_raw_simple$species) # all names up to date


write.table(list_raw_simple, here::here("data", "processed", "lists", "salve-taxonomy-reviewed.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)

# filtering in D_rawData_explore_filtering

write.table(list, here::here("data", "processed", "lists", "salve-squamata.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)


# checking Brazilian list according to The Reptile Database ---------------
br_link <- letsRept::reptAdvancedSearch(location = "Brazil", higher = "Squamata") #851 species
br_sp <-letsRept::reptSpecies(br_link, taxonomicInfo = TRUE, cores = 9)

# species in SALVE but not considered to occur in Brazil according to RDB
list[!list$species %in% br_sp$species,]

reptSearch("Apostolepis ambiniger", getRef = TRUE) #remove
reptSearch("Philodryas patagoniensis", getRef = TRUE) #remove
reptSearch("Neusticurus medemi", getRef = TRUE) #keep
reptSearch("Plica plica", getRef = TRUE) #keep

list <- list[!list$species %in% c("Apostolepis ambiniger", "Philodryas patagoniensis"),] #FINAL LIST 790 SQUAMATA

write.table(list, here::here("data", "processed", "lists", "salve-squamata-reviewed.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)

###########################################################################
# Cerrado endemics --------------------------------------------------------
###########################################################################
review <- reptCompare(end$species, filter = "review")

sync <- reptSync(review, solveAmbiguity = TRUE, cores = 9)

sum(sync$RDB %in% end$species) #how many already in the db? a.k.a.: duplicated/synonym

end[end$species %in% sync$RDB,]

sync #delete A. cerradoensis; A tertulianobeui and P. cerradensis (synonyms)

#removing synonymizations
end <- end[!end$species %in% c("Apostolepis cerradoensis", "Apostolepis tertulianobeui", "Phalotris cerradensis"),]

#removing from endemic status
end <- end[!end$species %in% c("Apostolepis barrioi"),]

# updating nomenclature ---------------------------------------------------
end$species[end$species == "Siagonodon acutirostris"] <- "Trilepida acutirostris"
end$species[end$species == "Thamnodynastes rutilus"] <- "Mesotes rutilus"

write.table(end, here::here("data", "processed", "lists", "cerrado_endemics_list.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)

###########################################################################
# ReptTraits --------------------------------------------------------------
###########################################################################

# ReptTraits filtering ----------------------------------------------------
head(repttraits_raw)

#comparing species in datasets
length(repttraits_raw$Species[which(repttraits_raw$Species %in% list$species)]) #781 species
reptCompare(repttraits_raw$Species, list$species, compareDataset = TRUE)

# reviewing nomenclature --------------------------------------------------
review <- reptCompare(repttraits_raw$Species, filter = "review") #178 spp

sync <- reptSync(review, solveAmbiguity = TRUE, cores = 9)

pattern <- paste(list$species, collapse = "|")

repttraits_sync <- sync[grepl(pattern, sync$RDB), ] # selecting from species of interest from synced names
repttraits_sync

repttraits_sync$RDB[repttraits_sync$query == "Leposternon microcephalum"] <- "Leposternon microcephalus"
repttraits_sync$status[repttraits_sync$query == "Leposternon microcephalum"] <- "updated"

repttraits_taxonomy <- repttraits_raw
repttraits_taxonomy <- repttraits_taxonomy[repttraits_taxonomy$Species != "Amphisbaena lumbricalis",]

repttraits_taxonomy$Species[which(repttraits_taxonomy$Species %in% repttraits_sync$query)] <- repttraits_sync$RDB[repttraits_sync$query %in% repttraits_taxonomy$Species[which(repttraits_taxonomy$Species %in% repttraits_sync$query)]]
repttraits_taxonomy$Species[duplicated(repttraits_taxonomy$Species)]
repttraits_taxonomy[repttraits_taxonomy$Species =="Amphisbaena carvalhoi",]
repttraits_taxonomy$Habitat.type[repttraits_taxonomy$Species =="Amphisbaena carvalhoi"] <- "Savanna/Shrubland"

length(repttraits_taxonomy$Species[which(repttraits_taxonomy$Species %in% list$species)]) #789 species

list$species[!list$species %in% repttraits_taxonomy$Species] #Apostolepis quinquelineata

repttraits_br <- repttraits_taxonomy[which(repttraits_taxonomy$Species %in% list$species),] #789 species

write.table(repttraits_br, here::here("data", "processed", "traits", "repttraits-br.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)


###########################################################################
# SquamBase ---------------------------------------------------------------
###########################################################################

# SquamBase filtering -----------------------------------------------------
head(squambase_raw)

#comparing species in datasets
length(squambase_raw$species[which(squambase_raw$species %in% list$species)]) #781 species
letsRept::reptCompare(squambase_raw$species, list$species, compareDataset = TRUE)

# reviewing nomenclature --------------------------------------------------
review <- reptCompare(squambase_raw$species, filter = "review") #182 spp
sync <- reptSync(review, solveAmbiguity = TRUE, cores = 9)

pattern <- paste(list$species, collapse = "|")
squambase_sync <- sync[grepl(pattern, sync$RDB), ] # selecting from species of interest from synced names
squambase_sync

squambase_sync$RDB[squambase_sync$query == "Leposternon microcephalum"] <- "Leposternon microcephalus"
squambase_sync$status[squambase_sync$query == "Leposternon microcephalum"] <- "updated"

squambase_taxonomy <- squambase_raw

squambase_taxonomy$species[which(squambase_taxonomy$species %in% squambase_sync$query)] <- squambase_sync$RDB[squambase_sync$query %in% squambase_taxonomy$species[which(squambase_taxonomy$species %in% squambase_sync$query)]]
squambase_taxonomy$species[duplicated(squambase_taxonomy$species)]
squambase_taxonomy[squambase_taxonomy$species =="Amphisbaena carvalhoi",]

squambase_taxonomy <- squambase_taxonomy[squambase_taxonomy$GARD.id != "R00550",]

length(squambase_taxonomy$species[which(squambase_taxonomy$species %in% list$species)]) #789 species

list$species[!list$species %in% squambase_taxonomy$species] #Apostolepis quinquelineata

squambase_br <- squambase_taxonomy[which(squambase_taxonomy$species %in% list$species),] #789 species


write.table(squambase_br, here::here("data", "processed", "traits", "squambase-br.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)


write.table(list, here::here("data", "processed", "lists", "list_traits.txt"),
            fileEncoding = "UTF8",
            sep= "\t",
            row.names = FALSE)
###########################################################################
# Phylogeny (Title et al. 2024) -------------------------------------------
###########################################################################

library(ape)
library(picante)

tree_raw$tip.label <- gsub("_", " ", tree_raw$tip.label) #substitution of _ to "space" for matching
phylo_spp <- tree_raw$tip.label # 6885


length(phylo_spp[which(phylo_spp%in%unique(list$species))]) #483 species

review <- letsRept::reptCompare(phylo_spp, filter = "review") #264
tree_sync <- letsRept::reptSync(review, solveAmbiguity = TRUE, cores = 9)

table(tree_sync$status)

tree_sync$RDB[which(tree_sync$RDB%in%unique(list$species))]

padrao <- paste(unique(list$species), collapse = "|")
a <- tree_sync[grepl(padrao, tree_sync$RDB), ] # selecting from species of interest from synced names

reptTidySyn(a)

a$RDB[a$query == "Taeniophallus occipitalis"] <- "Adelphostigma occipitalis"
a$status[a$query == "Taeniophallus occipitalis"] <- "updated"

a$RDB[a$query == "Leptodeira polysticta"] <- "Leptodeira annulata"
a$status[a$query == "Leptodeira polysticta"] <- "updated"

a$RDB[a$query == "Leposternon microcephalum"] <- "Leposternon microcephalus"
a$status[a$query == "Leposternon microcephalum"] <- "updated"

reptSearch("Leptodeira annulata") # Leptodeira polysticta ambiguity: not the Brazilian species. Drop.

sum(phylo_spp=="Leptodeira annulata") # already in the tree
sum(phylo_spp=="Adelphostigma occipitalis") # not in the tree
sum(phylo_spp=="Leposternon microcephalus") # not in the tree

phylo_spp[phylo_spp %in% a$RDB]

a <- a[!a$RDB %in% c("Leptodeira annulata", "Liotyphlops ternetzii"),] # dropping species existing in the tree

tree_taxonomy <- tree_raw

tree_taxonomy$tip.label[which(tree_taxonomy$tip.label%in%a$query)] <- a$RDB[a$query %in% tree_taxonomy$tip.label[which(tree_taxonomy$tip.label %in% a$query)]] # updating tip.labels

length(tree_taxonomy$tip.label[which(tree_taxonomy$tip.label %in% unique(list$species))]) #506 species (with updated nomenclature)

#filtering tree:
species_to_keep <- intersect(unique(list$species), tree_taxonomy$tip.label)
tree_pruned <- ape::keep.tip(tree_taxonomy, species_to_keep)

# saving pruned tree with Brazilian species --------------------------------
ape::write.tree(tree_pruned, file = here::here("data", "processed","phylogeny", "title_br.tre"))


###########################################################################
# distribution data (Salve) -----------------------------------------------
###########################################################################

length(unique(db$species)) #793 species
review <- reptCompare(unique(db$species), filter = "review")
sync <- reptSync(review, cores = 9)

reptTidySyn(sync, filter = "not_found")
db$species[db$species == "Dactyloa neglecta"] <- "Anolis neglectus"

reptTidySyn(sync, filter = "merge")
db$species[db$species %in% c("Liotyphlops beui", "Liotyphlops sousai")] <- "Liotyphlops ternetzii"

reptTidySyn(sync, filter = "ambiguous")
db$species[db$species == "Anisolepis undulatus"] <- "Urostrophus undulatus"
db$species[db$species == "Corallus hortulanus"] <- "Corallus hortulana"
db$species[db$species == "Leposternon microcephalum"] <- "Leposternon microcephalus"
db$species[db$species == "Norops auratus"] <- "Anolis auratus"
db$species[db$species == "Taeniophallus occipitalis"] <- "Adelphostigma occipitalis"

reptTidySyn(sync, filter = "updated")

for(i in 1:length(sync$query[sync$status=="updated"]))
{
  db$species[db$species == sync$query[sync$status=="updated"][i]] <- sync$RDB[sync$status=="updated"][i]
}

write.csv(db, here::here("data", "processed", "distribution", "db_reviewed.csv"), row.names = FALSE)

length(unique(db$species)) #787 species
