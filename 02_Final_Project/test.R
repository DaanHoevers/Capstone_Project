quiz <- read.table("quiz.txt", sep="\t", header = TRUE, stringsAsFactors = FALSE)

a <- quiz$phrase
b <- sapply(a, cleanData)
c <- sapply(b, FUN = word_pred)
d <- c == quiz$answer

test_result <- data.table(quiz, result = c)