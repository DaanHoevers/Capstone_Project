## D. Hoevers
## Use sample and Simple Good Turing method to determine probabilities for the frequencies 
## from MileStone to Final Project

# file path
file_path <- "C:/Users/dhoevers/Documents/03. Knowledge/01. Data Science/09.Capstone/Capstone_Project/00_Preparation_Functions/"

# source sample; only required in case new txt to be created
source(paste0(file_path, "Sample_Creation.R"))
# source("C:/Users/dhoevers/Documents/03. Knowledge/01. Data Science/09.Capstone/Capstone_Project/00_Preparation_Functions/Sample_Creation.R")

# source functions:
# SGT_func()
# P_zero()
source(paste0(file_path, "Simple_Good_Turing.R"))
# source("C:/Users/dhoevers/Documents/03. Knowledge/01. Data Science/09.Capstone/Capstone_Project/00_Preparation_Functions/Simple_Good_Turing.R")

## ------------------ Create Simple Good Turing Files

# read tables 1%
ng_uni <- readRDS(paste0(file_path, "ng_uni_1.rData"))
ng_bi <- readRDS(paste0(file_path, "ng_bi_1.rData"))
ng_tri <- readRDS(paste0(file_path, "ng_tri_1.rData"))
ng_quad <- readRDS(paste0(file_path,"ng_quad_1.rData"))

## create Simple Good Turing
# uni
SGT_uni <- SGT_func(ng_uni)             # create SGT
P0 <- P_zero(SGT_uni)                   # P_zero
sum(SGT_uni$n * SGT_uni$p) + P0 == 1    # check 

# bi
SGT_bi <- SGT_func(ng_bi)                # create SGT
P0 <- P_zero(SGT_bi)                    # P_zero
sum(SGT_bi$n * SGT_bi$p) + P0 == 1      # check 

# tri
SGT_tri <- SGT_func(ng_tri)               # create SGT
P0 <- P_zero(SGT_tri)                   # P_zero
sum(SGT_tri$n * SGT_tri$p) + P0 == 1    # check 

# quad
SGT_quad <- SGT_func(ng_quad)               # create SGT
P0 <- P_zero(SGT_quad)                   # P_zero
sum(SGT_quad$n * SGT_quad$p) + P0 == 1    # check

# create only relevant columns
x1 <- SGT_uni[,c(1,2,9), with = FALSE]
x2 <- SGT_bi[,c(1,2,9), with = FALSE]
x3 <- SGT_tri[,c(1,2,9), with = FALSE]
x4 <- SGT_quad[,c(1,2,9), with = FALSE]

# set new file path
file_path_n <- "C:/Users/dhoevers/Documents/03. Knowledge/01. Data Science/09.Capstone/Capstone_Project/02_Final_Project/data/"

# save SGT tables
saveRDS(x1, paste0(file_path_n, "SGT_uni.RData"))
saveRDS(x2, paste0(file_path_n, "SGT_bi.RData"))
saveRDS(x3, paste0(file_path_n, "SGT_tri.RData"))
saveRDS(x4, paste0(file_path_n, "SGT_quad.RData"))

## ------------------ Determine Most Common word
mx <- x1[p == max(x1$p),]
com_wrd <- ng_uni[ng_uni$freq == mx[,r],][1]
com_wrd <- as.character(com_wrd$words)
saveRDS(com_wrd, paste0(file_path_n, "Most_Common_wrd.RData"))

## ------------------ Create Word Frequency Files

#
ng_uni_w <- data.table(wi = ng_uni$words, freq = ng_uni$freq)

# split bigram
bi_split <- data.table(str_split_fixed(ng_bi$words, " ",2))
# new bigram
ng_bi_w <- data.table(w1 = bi_split$V1, wi = bi_split$V2, freq = ng_bi$freq)

# split trigram
tri_split <- data.table(str_split_fixed(ng_tri$words, " ",3))
# rename column names
setnames(tri_split, c("w2", "w1", "wi"))
# new trigram
ng_tri_w <- data.table(tri_split, freq = ng_tri$freq)

# split quadgram
quad_split <- data.table(str_split_fixed(ng_quad$words, " ",4))
# rename column names
setnames(quad_split, c("w3","w2", "w1", "wi")) 
# new quadgram
ng_quad_w <- data.table(quad_split, freq = ng_quad$freq)

## remove singletons
ng_uni_w <- ng_uni_w[freq != 1, ]
ng_bi_w <- ng_bi_w[freq != 1, ]
ng_tri_w <- ng_tri_w[freq != 1, ]
ng_quad_w <- ng_quad_w[freq != 1, ]

## remove freq 2 in quad
ng_uni_w <- ng_uni_w[freq != 2, ]
ng_bi_w <- ng_bi_w[freq != 2, ]
ng_tri_w <- ng_tri_w[freq != 2, ]
ng_quad_w <- ng_quad_w[freq != 2, ]

# save word freq tables
saveRDS(ng_uni_w, paste0(file_path_n, "ng_uni_w.RData"))
saveRDS(ng_bi_w, paste0(file_path_n, "ng_bi_w.RData"))
saveRDS(ng_tri_w, paste0(file_path_n,"ng_tri_w.RData"))
saveRDS(ng_quad_w, paste0(file_path_n,"ng_quad_w.RData"))

