### Supervised

# Simulate noisy data matrix (EXPRS)
set.seed(123)
n=20
m=1000
EXPRS=matrix(rnorm(2*n*m),2*n,m)
rownames(EXPRS)=paste("pt",1:(2*n),sep="")
colnames(EXPRS)=paste("g",1:m,sep="")
# The group labels are assigned arbitrarily
grp=rep(0:1,c(n,n))

#Pick the top 10 features based on the 
#two-sample $t$-test
library(genefilter)
stats=abs(rowttests(t(EXPRS), factor(grp))$statistic)
ii=order(-stats)
#Filter out all genes except the top 10
TOPEXPRS=EXPRS[, ii[1:10]]

# Fit 3-NN
library(class)
mod0=knn(train=TOPEXPRS,test=TOPEXPRS,cl=grp,k=3)
# Error Resubstituion
table(mod0,grp)
# Naive CV
mod1=knn.cv(TOPEXPRS,grp,k=3)
table(mod1,grp)
# Proper CV
top.features=function(EXP,resp,test,fsnum)
  {
    top.features.i=function(i,EXP,resp,test,fsnum)
      {
        stats=abs(mt.teststat(EXP[,-i],resp[-i],test=test))
        ii=order(-stats)[1:fsnum]
        rownames(EXP)[ii]
      }
    sapply(1:ncol(EXP),top.features.i,EXP=EXP,resp=resp,test=test,fsnum=fsnum)
  }


# This function evaluates the knn

knn.loocv=function(EXP,resp,test,k,fsnum,tabulate=FALSE,permute=FALSE)
  {
    if(permute)
      resp=sample(resp)
    topfeat=top.features(EXP,resp,test,fsnum)
    pids=rownames(EXP)
    EXP=t(EXP)
    colnames(EXP)=as.character(pids)
    knn.loocv.i=function(i,EXP,resp,k,topfeat)
      {
        ii=topfeat[,i]
        mod=knn(train=EXP[-i,ii],test=EXP[i,ii],cl=resp[-i],k=k)[1]
      }
    out=sapply(1:nrow(EXP),knn.loocv.i,EXP=EXP,resp=resp,k=k,topfeat=topfeat)
    if(tabulate)
      out=ftable(pred=out,obs=resp)
    return(out)
}

library(multtest)
knn.loocv(t(EXPRS),as.integer(grp),"t.equalvar",3,10,TRUE)
