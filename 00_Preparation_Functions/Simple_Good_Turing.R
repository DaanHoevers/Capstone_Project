## D. Hoevers
## Use the Simple Good Turing method to create probablities

library(data.table)

## 1) create log values
## assuming input frame with 2 columns: ng and freq
SGT_func <- function(x){
        # change to data.table and adjust column names
        x <- data.table(x)
        setnames(x, c("ng", "freq"))
        
        ## create r, n (integers 0 to N)
        ## r: word frequencies
        ## n: number of distinct words occuring with each word frequency
        SGT <- x[,length(ng), by = freq]
        setnames(SGT, c("r", "n"))
        setorder(SGT, r)     
      
        ## check the sum of frequencies
        sum(x[,freq]) == sum(SGT[,r]*SGT[,n]) ## must be TRUE
        
        ## N: sum of the products of r and n
        N <- sum(SGT$r * SGT$n)
        
        ## P0: estimate of the total probability of all unseen words
        P0 <- SGT$n[1]/N
        
        ## Z1
        i1 <- 0
        
        ## i: immediately previous
        i <- c(i1, (SGT[-nrow(SGT),r]))
        
        ## kN
        kN <- 2*nrow(SGT)-i[length(i)]
        if (kN <= i[length(i)]){
                kN <- SGT[nrow(SGT),r]
        }
        
        ## k: immediately following 
        k <- c(SGT[-1,r], kN)
        
        ## check on k > i
        sum(k > i) == length(k)
        
        ## Z 
        Z <- 2*SGT[,n]/(k-i)
        
        ## create log of r and Z
        logr <- log(SGT[,r])
        logZ <- log(Z)
        
        ## line of best fit
        fit <- lm(logZ ~ logr)
        
        plot(logr, logZ)
        abline(fit)
        
        ## return coefficients S(r) = a + b logr
        a <- fit$coefficients[1]
        b <- fit$coefficients[2]
        
        ## data table
        SGT <- data.table(SGT, i = i, k = k, Z = Z, logr = logr, logZ = logZ)
        
        ## calculate r star
        row <- nrow(SGT)
        r_str <- vector("numeric", row)
        useY = FALSE
        
        for (i in 1:(row)){
                
                r1 <-SGT$r[i]+1
                nr1 <- SGT$n[i+1]
                nr <- SGT$n[i]
                Sr1 <- SGT$logr[i]+1
                Sr <- SGT$logr[i]   
                
                ## (3) x is the empirical Turing estimate for r
                x <- r1 * nr1 / nr
                
                ## (4) y is the loglinear smoothing
                y <- r1 * exp(a + b * Sr1) / exp(a + b * Sr)
                
                ## (5) t is the width of the 95% (or whatever) confidence interval of the 
                ## empirical Turing estimate 
                t <- 1.96 * sqrt(r1^2 * nr1 / nr^2 * (1 + nr1 / nr))
                
                ## if abs difference between x and y > t, return x, otherwise y
                if (useY == TRUE){
                        r_str[i] <- y
                } else if (abs(x-y) > t){
                        r_str[i] <- x
                } else if (abs(x-y) <= t){
                        useY = TRUE
                        r_str[i] <- y
                }
        }
        
        ## data table
        SGT <- data.table(SGT, r_str = r_str)
        
        ## N: sum of the products of r and n
        N <- sum(SGT$r * SGT$n)
        
        ## P0: estimate of the total probability of all unseen words
        P0 <- SGT$n[1]/N
        
        ## total of the products n and r star
        Nacc <- sum(SGT$n * SGT$r_str)
        
        ## calculate SGT estimate for the population freq of a word 
        ## whose freq in the sample is r
        p <- (1-P0)* SGT$r_str/ Nacc
        
        ## data table
        SGT <- data.table(SGT, p = p)
        
        return(SGT)
}

P_zero <- function(x){
        SGT <- x
        ## N: sum of the products of r and n
        N <- sum(SGT$r * SGT$n)
        
        ## P0: estimate of the total probability of all unseen words
        P0 <- SGT$n[1]/N
        
        ## check
        sum(SGT$r * SGT$n) + P0 == 1
        
        ## return P0
        return(P0)
}


