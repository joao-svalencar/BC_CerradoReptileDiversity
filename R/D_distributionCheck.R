# Script to check and merge distribution information ----------------------
head(db_reptiles)

length(unique(db_reptiles$species)) #842/882 species % - missing 40 species

# check how many Cerrado species are missing ------------------------------

missing <- list_br[!list_br$species %in% unique(db_reptiles$species),] #only species not occurring in the Cerrado


