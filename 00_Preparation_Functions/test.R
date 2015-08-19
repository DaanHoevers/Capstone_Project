file_path <- "C:/Users/dhoevers/Documents/03. Knowledge/01. Data Science/09.Capstone/Capstone_Project/00_Preparation_Functions/"

x <- paste0(file_path, "quiz.txt")

quiz <- read.table(x, sep="\t", header = TRUE, stringsAsFactors = FALSE)

a <- quiz$phrase
b <- sapply(a, cleanData)
c <- sapply(b, FUN = word_pred)
d <- c == quiz$answer

test_result <- data.table(quiz, result = c)



ng_bi_w <- ng_bi_w[freq != 1, ]
ng_tri_w <- ng_tri_w[freq != 1, ]
ng_quad_w <- ng_quad_w[freq != 1, ]

saveRDS(ng_uni_w, paste0(file_path, "ng_uni_w.RData"))
saveRDS(ng_bi_w, paste0(file_path, "ng_bi_w.RData"))
saveRDS(ng_tri_w, paste0(file_path, "ng_tri_w.RData"))
saveRDS(ng_quad_w, paste0(file_path, "ng_quad_w.RData"))