## D. Hoevers
## App input preparation file
## loads the data files
## defines the clean data and word prediction functions
library(shiny)
library(stringr)
library(data.table)

# load most common word
com_wrd <- readRDS("data/Most_Common_wrd.rData")

# load SGT n grams
SGT_uni <- data.table(readRDS("data/SGT_uni.rData"))
SGT_bi <- data.table(readRDS("data/SGT_bi.rData"))
SGT_tri <- data.table(readRDS("data/SGT_tri.rData"))
SGT_quad <- data.table(readRDS("data/SGT_quad.rData"))

# load word frequencies
ng_uni_w <- data.table(readRDS("data/ng_uni_w.RData"))
ng_tri_w <- data.table(readRDS("data/ng_tri_w.rData"))
ng_bi_w <- data.table(readRDS("data/ng_bi_w.rData"))
ng_quad_w <- data.table(readRDS("data/ng_quad_w.rData"))

# function to clean input data
cleanData <- function(input_txt){
        tmp <- input_txt
        tmp <- tolower(tmp) ## set to lowercase only
        tmp <- gsub(pattern = "'", replacement = "", tmp) ## remove apostrophe
        tmp <- gsub(pattern = "[[:punct:]]", replacement = " ", tmp) ## remove other punctuation
        tmp <- gsub(pattern = "[[:digit:]]", replacement = " ", tmp) ## remove numbers
        tmp <- gsub(pattern = "[^[:alnum:]]", replacement = " ", tmp) ## remove other alphanumerics
        tmp <- gsub(pattern = "\\s+", replacement = " ", tmp) ## replace any double spaces
        tmp <- str_trim(tmp, side = "both") ## trim whitespace from start and end of string
        return(tmp)
}

# function to predict the next word based on 
word_pred <- function(input_txt){
        
        if (input_txt == ""){
                wrd <- "Enter Text"
        } else {        
                split_txt <- unlist(str_split(input_txt, " "))
                
                w1_in <- split_txt[length(split_txt)]
                w2_in <- split_txt[(length(split_txt)-1)]
                w3_in <- split_txt[(length(split_txt)-2)]
                
                quad_fq_sub <- ng_quad_w[(w3 == w3_in & w2 == w2_in & w1 == w1_in), wi, freq]
                tri_fq_sub <- ng_tri_w[(w2 == w2_in & w1 == w1_in), wi, freq]
                bi_fq_sub <- ng_bi_w[w1 == w1_in, wi, freq]
                
                if(dim(quad_fq_sub)[1] > 0){
                        ln <- dim(quad_fq_sub)[1]
                        p_quad <- vector("numeric", ln)
                        
                        for (i in 1:ln){
                                y <- quad_fq_sub$freq
                                x <- SGT_quad[r == y[i],p]
                                p_quad[i] <- x         
                        }
                        
                        quad_fq_p <- data.table(wi = quad_fq_sub$wi, p = p_quad)
                        wrd_dt <- setorder(quad_fq_p, -p)
                        
                } else if (dim(tri_fq_sub)[1] > 0){              
                        ln <- dim(tri_fq_sub)[1]
                        p_tri <- vector("numeric", ln)
        
                        for (i in 1:ln){
                                y <- tri_fq_sub$freq
                                x <- SGT_tri[r == y[i],p]
                                p_tri[i] <- x         
                        }
                        
                        tri_fq_p <- data.table(wi = tri_fq_sub$wi, p = p_tri)
                        wrd_dt <- setorder(tri_fq_p, -p)
                        wrd <- tri_fq_p[1, wi]
                        
                } else if (dim(bi_fq_sub)[1] > 0){
                        ln <- dim(bi_fq_sub)[1]
                        p_bi <- vector("numeric", ln)
                        
                        for (i in 1:ln){
                                y <- bi_fq_sub$freq
                                x <- SGT_bi[r == y[i],p]
                                p_bi[i] <- x         
                        }

                        bi_fq_p <- data.table(wi = bi_fq_sub$wi, p = p_bi)
                        wrd_dt <- setorder(bi_fq_p, -p)

                } else {
                        wrd_dt <- com_wrd
                }
                
                if(is.null(dim(wrd_dt))){
                        wrd <- wrd_dt
                } else {
                        mx <- max(wrd_dt$p)
                        max_wrd <- wrd_dt[p == mx,]                                
                        
                        if(dim(max_wrd)[1] > 1){
                                ln <- dim(max_wrd)[1]
                                p_uni <- vector("numeric", ln)
                                
                                for (i in 1:ln){
                                        y <- wrd_dt$wi
                                        x <- ng_uni_w[wi == y[i], freq]
                                        z <- SGT_uni[r == x, p]
                                        p_uni[i] <- z
                                }
                                max_wrd <- data.table(max_wrd, p_uni = p_uni)
                                max_wrd <- setorder(max_wrd, -p_uni)
                                wrd <- as.character(max_wrd[1,wi])
                        } else {
                                wrd <- as.character(max_wrd[1,wi])
                        }        
                        
                }
                                
                
        }
        return(wrd)

}
