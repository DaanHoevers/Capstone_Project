library(shinyapps)

deployApp(appName = "Capstone_Final_Project_Next_Word_App")

showLogs("Capstone_Final_Project_Next_Word_App")


###

# load most common word
com_wrd <- readRDS(paste0(file_path, "Most_Common_wrd.RData"))

# load SGT n grams
SGT_uni <- data.table(readRDS(paste0(file_path, "SGT_uni.RData")))
SGT_bi <- data.table(readRDS(paste0(file_path, "SGT_bi.RData")))
SGT_tri <- data.table(readRDS(paste0(file_path, "SGT_tri.RData")))
SGT_quad <- data.table(readRDS(paste0(file_path, "SGT_quad.RData")))

# load word frequencies
ng_uni_w <- data.table(readRDS(paste0(file_path, "ng_uni_w.RData")))
ng_tri_w <- data.table(readRDS(paste0(file_path, "ng_tri_w.RData")))
ng_bi_w <- data.table(readRDS(paste0(file_path,"ng_bi_w.RData")))
ng_quad_w <- data.table(readRDS(paste0(file_path, "ng_quad_w.RData")))


13: com_wrd <- readRDS("data/Most_Common_wrd.RData")    ["data/Most_Common_wrd.RData" -> "data/Most_Common_wrd.rData"]
Filepaths are case-sensitive on ShinyApps.io.
