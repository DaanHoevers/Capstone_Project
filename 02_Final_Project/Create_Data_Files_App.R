## D. Hoevers
## Use sample and Simple Good Turing method to determine probabilities for the frequencies 
## from MileStone to Final Project

# source sample; only required in case new txt to be created
source("Sample_Creation.R")

# source functions:
# SGT_func()
# P_zero()
source("Simple_Good_Turing.R")

## ------------------ Create Simple Good Turing Files

# read tables 1%
ng_uni <- readRDS("ng_uni_1.rData")
ng_bi <- readRDS("ng_bi_1.rData") 
ng_tri <- readRDS("ng_tri_1.rData")
ng_quad <- readRDS("ng_quad_1.rData")

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

# save SGT tables
saveRDS(x1, "SGT_uni.rData")
saveRDS(x2, "SGT_bi.rData")
saveRDS(x3, "SGT_tri.rData")
saveRDS(x4, "SGT_quad.rData")

## ------------------ Determine Most Common word
mx <- x1[p == max(x1$p),]
com_wrd <- ng_uni[ng_uni$freq == mx[,r],][1]
saveRDS(com_wrd, "Most_Common_wrd.rData")

## ------------------ Create Word Frequency Files

#
ng_uni_w <- data.table(wi = ng_uni$words, wi = bi_split$V2, freq = ng_bi$freq)

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

# save word freq tables
saveRDS(ng_bi_w, "ng_bi_w.rData")
saveRDS(ng_tri_w, "ng_tri_w.rData")
saveRDS(ng_quad_w, "ng_quad_w.rData")