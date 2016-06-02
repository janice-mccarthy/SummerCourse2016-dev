### Multiple Testing
### The purpose of this example is to illustrate the inflation
## of the type I error if decisions are made based on unadjusted
### p-values
sim.coin.pval=function(k,pH)
    {
        x=sample(c("H","T"),k,replace=TRUE,prob=c(pH,1-pH))
        pval=binom.test(sum(x=='H'), n=k, p = 0.5)$p.value
        return(pval)
    }

set.seed(1223)
B=10000
# Single coin experiment (is this a fair coin?)
pval1=replicate(B,sim.coin.pval(1000,0.5))
mean(pval1<0.05)

                                        # Two coin experiment
### Is coin 1 fair
pval1=replicate(B,sim.coin.pval(1000,0.5))
mean(pval1<0.05)
### Is coin 2 fair?
pval2=replicate(B,sim.coin.pval(1000,0.5))
mean(pval2<0.05)

### Are either coins fair
# FWER based on marginal testing
mean(pval1<0.05|pval2<0.05)
# FWER based on Adjusting 
mean(pval1<0.05/2|pval2<0.05/2)

# Bonf adjustment for Experiment 1
c(pval1[1],pval2[1])
p.adjust(c(pval1[1],pval2[1]),method ="bonferroni")
c(pval1[1],pval2[1])*2
pmin(c(pval1[1],pval2[1])*2,1)

                                        # Why does this not make any sense
### FWER adjustment is within experiment not across experiments
#p.adjust(cbind(pval1,pval2),method ="bonferroni")
                    

############################################################################################



## This example shows how to add Bonferroni P-values and
## Qvalues based on unadjusted P-values
library(ALL)
library(qvalue)
library(genefilter)

### Summarize the Data
ALL

### The goal is to identify probe sets differentially
### expressed between BCR/ABL positive and negative pts in ALL pts
### Subset the data set first
ALLDAT=ALL[,pData(ALL)[["mol.biol"]]%in%c("BCR/ABL","NEG")]

### Conduct the two-sample t-test
results=rowttests(ALLDAT,"mol.biol")

### Check the reults
### statistic: test stat for two-sa,pel t test
### dm: difference in mean expression
### p.value : p-value
head(results)

### Proportion of probe sets with unadjusted p-value <0.05
mean(results[["p.value"]]<0.05)
### Proportion of probe sets with unadjusted p-value <0.01
mean(results[["p.value"]]<0.01)


## Now add Bonferroni p-values to account for FWER and qvalues to account for
## FDR

results=data.frame(results,fwerp=p.adjust(results[["p.value"]],method="bonferroni"), qval=qvalue(results[["p.value"]])$qvalue)

mean(results[["fwerp"]]<0.05)
mean(results[["qval"]]<0.05)
