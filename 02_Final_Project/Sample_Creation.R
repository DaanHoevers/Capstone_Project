## D. Hoevers
## Create Sample of Corpus to be used to create model

## load libraries
libs <- c("stringr", "data.table", "tm", "RWeka", "ggplot2", "MASS", "gridExtra")
i <- lapply(libs, require, character.only = TRUE)

## sample size
factor <- 0.01 # 1%

## twitter
con <- file("en_US.twitter.txt", "r")
twt <- readLines(con, warn=FALSE)
close(con)

twt.size <- format(object.size(twt), units = "Mb")
twt.len <- length(twt)
twt.char <- sum(nchar(twt))

## blog
con <- file("en_US.blogs.txt", "r")
blg <- readLines(con, warn=FALSE)
close(con)

blg.size <- format(object.size(blg), units = "Mb")
blg.len <- length(blg)
blg.char <- sum(nchar(blg))

## news
con <- file("en_US.news.txt", "r")
nws <- readLines(con, warn=FALSE)
close(con)

nws.size <- format(object.size(nws), units = "Mb")
nws.len <- length(nws)
nws.char <-sum(nchar(nws))

## load files, obtain basic statistics and take sample x% of each file
set.seed(1)

twt.sample <- sample(twt, twt.len*factor, replace = F); rm(twt)
blg.sample <- sample(blg, blg.len*factor, replace = F); rm(blg)
nws.sample <- sample(nws, nws.len*factor, replace = F); rm(nws)

## creating a data corpus
data <- paste(nws.sample, blg.sample, twt.sample)
dataCorp <- VCorpus(VectorSource(data))

## function to cleanse text including removal of stopwords
cleanCorp_sw <- function(x){
        tmp <- tm_map(x, removeNumbers)
        tmp <- tm_map(tmp, removePunctuation)                   
        tmp <- tm_map(tmp, removeWords, stopwords())
        tmp <- tm_map(tmp, stripWhitespace)
#         tmp <- tm_map(tmp, stemDocument, language = "en")
        tmp <- tm_map(tmp, content_transformer(tolower))
        tmp <- tm_map(tmp, content_transformer(function(x) iconv(x, "latin1", "ASCII", sub="")))
        return(tmp)
}

## cleanse the data corpus
dataClean_sw <- cleanCorp_sw(dataCorp)

## Sets the default number of threads to use
## http://stackoverflow.com/questions/19024873/why-does-r-hang-when-using-ngramtokenizer
options(mc.cores=1) 

## ngram function
## http://weka.sourceforge.net/doc.dev/weka/core/tokenizers/NGramTokenize.html 
ngram <- function(x, ng) {
        dl <- " \\r\\n\\t.,;:\"()?!" 
        df <- data.frame(body=unlist(sapply(x, `[`, "content")), stringsAsFactors=F)
        tmp <- NGramTokenizer(df, Weka_control(min = ng, max = ng, delimiters = dl))
}

## create ngrams
uni_sw <- ngram(dataClean_sw, 1)      # unigram
bi_sw <- ngram(dataClean_sw, 2)       # bigram
tri_sw <- ngram(dataClean_sw, 3)      # trigram
quad_sw <- ngram(dataClean_sw, 4)     # quadgram

## frequency distribution function
freq <- function(x){
        options (digits = 2)
        freq <- sort(table(x), decreasing = TRUE)
        tbl <- cbind(freq)        
        return(tbl)
}

## calculate frequencies
uni_frq <- freq(uni_sw)
bi_frq <- freq(bi_sw)
tri_frq <- freq(tri_sw)
quad_frq <- freq(quad_sw)

## function to create data frame
frame <- function(x){
        y <- data.frame(words = row.names(x), x, row.names = NULL)
        y$words <- factor(y$words, levels = y$words[order(-y$freq)])
        return(y)
}

## create data table
uni <- frame(uni_frq)
bi <- frame(bi_frq)
tri <- frame(tri_frq)
quad <- frame(quad_frq)

# write to txt
saveRDS(uni, "ng_uni_1.rData")
saveRDS(bi, "ng_bi_1.rData")
saveRDS(tri, "ng_tri_1.rData")
saveRDS(quad, "ng_quad_1.rData")
