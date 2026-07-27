library(letsRept)
library(ape)

# checking the match between distribution and phylogeny -------------------
tree_raw$tip.label <- gsub("_", " ", tree_raw$tip.label) #substitution of _ to "space" for matching
phylo_spp <- tree_raw$tip.label


length(phylo_spp[which(phylo_spp%in%unique(list$species))]) #483 species

review <- letsRept::reptCompare(phylo_spp, filter = "review")
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

length(tree_taxonomy$tip.label[which(tree_taxonomy$tip.label %in% unique(list$species))]) #507 species (with updated nomenclature)

#filtering tree:
species_to_keep <- intersect(unique(list$species), tree_taxonomy$tip.label)
tree_pruned <- ape::keep.tip(tree_taxonomy, species_to_keep)

# saving pruned tree with Brazilian species --------------------------------
ape::write.tree(tree_pruned, file = here::here("data", "processed","phylogeny", "title_br.tre"))

tree$tip.label <- gsub("_", " ", tree$tip.label) #fixing names

list_cerrado <- list[list$cerrado_sp=="yes" & list$phylogeny=="yes",]

list_cerrado$habitat_class <- ifelse(is.na(list_cerrado$habitat), NA, 
                             ifelse(grepl("Forest", list_cerrado$habitat), "forest", "open"))

tree_cerrado <- ape::keep.tip(tree, list$species[list$phylogeny=="yes" & list$cerrado_sp=="yes"]) #extracting Cerrado species

#length(tree_cerrado$tip.label)

list_cerrado$habitat_class <- factor(list_cerrado$habitat_class, levels = c("forest", "open"))
table(list_cerrado$cerrado_endemic)

# analyses: phylo clustering vs phylo overdispersion ----------------------
#install.packages("caper")
library(caper)

head(list_cerrado)

#caper format
list_caper <- list_cerrado[, c(1, 11, 16)]
head(list_caper)

list_cerrado$suborder[list_cerrado$suborder =="Amphisbaenia"]  <- "Sauria"
list_sauria <- list_cerrado[list_cerrado$suborder=="Sauria", c(1, 11, 16)]
list_serpentes <- list_cerrado[list_cerrado$suborder=="Serpentes", c(1, 11, 16)]


# Calculating Fritz & Purvis D statistic (endemism) -----------------------
#whole dataset
?comparative.data
comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_caper,
                              names.col = "species")

D_endemism <- phylo.d(data = list_caper,
                      phy = tree_cerrado,
                      names.col = species,
                      binvar = cerrado_endemic)
print(D_endemism)

#sauria
comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_sauria,
                              names.col = "species")

D_endemism_sauria <- phylo.d(data = list_sauria,
                      phy = tree_cerrado,
                      names.col = species,
                      binvar = cerrado_endemic)
print(D_endemism_sauria)

#serpentes
comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_serpentes,
                              names.col = "species")

D_endemism_serp <- phylo.d(data = list_serpentes,
                      phy = tree_cerrado,
                      names.col = species,
                      binvar = cerrado_endemic)
print(D_endemism_serp)

table(list_cerrado$family, list_cerrado$cerrado_endemic)
# Calculating Fritz & Purvis D statistic (habitat) ------------------------

comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_caper,
                              names.col = "species")

D_habitat <- phylo.d(data = list_caper,
                      phy = tree_cerrado,
                      names.col = species,
                      binvar = habitat_class)
print(D_habitat)

#sauria
comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_sauria,
                              names.col = "species")

D_habitat_sauria <- phylo.d(data = list_sauria,
                             phy = tree_cerrado,
                             names.col = species,
                             binvar = habitat_class)
print(D_habitat_sauria)

#serpentes
comp_data <- comparative.data(phy = tree_cerrado,
                              data = list_serpentes,
                              names.col = "species")

D_habitat_serp <- phylo.d(data = list_serpentes,
                           phy = tree_cerrado,
                           names.col = species,
                           binvar = habitat_class)
print(D_habitat_serp)

table(list_cerrado$family, list_cerrado$habitat_class)


# chi-squared -------------------------------------------------------------
table(list_cerrado$cerrado_endemic, list_cerrado$habitat_class)

data <- matrix(c(176, 29, 48, 39),
               nrow = 2,
               dimnames = list(Endemismo = c("No", "Yes"),
                               Habitat = c("Forest", "Open")))

qui2 <- chisq.test(data)

print(qui2)
