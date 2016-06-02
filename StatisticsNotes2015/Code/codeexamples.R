

############################################################################################
                                        # simulate p-value for testing for a biased coin
### talk about sample() along with replace=TRUE or FALSE
sim.coin.pval=function(k,pH,p0=0.5)
    {
        x=sample(c("H","T"),k,replace=TRUE,prob=c(pH,1-pH))
        pval=binom.test(sum(x=='H'), n=k, p = p0)$p.value
        #pval=prop.test(sum(x=='H'),k,p=0.5)$p.value
        return(pval)
    }

############################################################################################
### Model Formulation

# Rails example
library(nlme)
library(lattice)
data(Rail)
xyplot(travel~Rail,data=Rail,ylab="Zero-force travel time (nano-seconds)")

# Linear Model ignoring random effect
summary(lm(travel~1,data=Rail))
# Linear Model incorporating random effect
lme(travel~1,random=~1|Rail,data=Rail)


sim.ranef=function(nk,n,se,sb,verbose=FALSE)
    {
        # n exp units with nk replicates each
        N=n*nk
        e=rnorm(N,0,se)
        b=rep(rnorm(n,0,sb),each=nk)
        id=rep(1:n,each=nk)
        y=0+e+b
        dat=data.frame(id,b,e,y)
        mod0=summary(lm(y~1,data=dat))
        mod1=summary(lme(y~1,random=~1|id,data=dat))
        pval0=mod0$coef["(Intercept)","Pr(>|t|)"]
        pval1=mod1$tTable["(Intercept)","p-value"]
        if(verbose)
            {
                out=list(dat,mod0,mod1)
            }
        else
            {
                out=c(pval0,pval1)
            }
        out
    }

### Show them a data set, a plot along with lm and lme models
set.seed(210)
ex1=sim.ranef(3,6,0.25,0.5,verbose=TRUE)
ex1[[1]]
xyplot(y~id,data=ex1[[1]])
ex1[[2]]
ex1[[3]]

set.seed(210)
B=1000
res=replicate(B,sim.ranef(3,6,0.25,0.5,verbose=FALSE))
mean(res[1,]<0.05)
mean(res[2,]<0.05)
rm(B)

par(mfrow=c(1,3))
qqplot(qunif(ppoints(500)), res[1,],cex=0.1,xlab="Uniform Distribution",ylab="lm")
abline(0,1)
qqplot(qunif(ppoints(500)), res[2,],cex=0.1,xlab="Uniform Distribution",ylab="lme")
abline(0,1)
plot(res[1,],res[2,],pch=19,cex=0.5,xlab="lm",ylab="lme")
abline(0,1)

# Increase Sample size
B=1000
res=replicate(B,sim.ranef(3,50,0.25,0.5,verbose=FALSE))
mean(res[1,]<0.05)

mean(res[2,]<0.05)


par(mfrow=c(1,3))
qqplot(qunif(ppoints(500)), res[1,],cex=0.1,xlab="Uniform Distribution",ylab="lm")
abline(0,1)
qqplot(qunif(ppoints(500)), res[2,],cex=0.1,xlab="Uniform Distribution",ylab="lme")
abline(0,1)
plot(res[1,],res[2,],pch=19,cex=0.5,xlab="lm",ylab="lme")
abline(0,1)





# Clustering Effect on Two sample problem
sim.twosample.clustered=function(nk,n,se,sb,verbose=FALSE)
    {
        N=n*nk
        e0=rnorm(N,0,se)
        e1=rnorm(N,0,se)
        b0=rep(rnorm(n,0,sb),each=nk)
        b1=rep(rnorm(n,0,sb),each=nk)
        y0=e0+b0
        y1=e1+b1
        t.test(y0,y1)$p.value
    }

set.seed(2314)
B=1000
# Simulate with no clustering effect (sb=0)
pval0=replicate(B,sim.twosample.clustered(3,10,0.25,0))
# Simulate with no clustering effect (sb>0)
pval1=replicate(B,sim.twosample.clustered(3,10,0.25,0.5))
rm(B)

mean(pval0<0.05)
mean(pval1<0.05)
par(mfrow=c(1,2))
qqplot(qunif(ppoints(500)), pval0,cex=0.1,xlab="Uniform Distribution")
abline(0,1)
qqplot(qunif(ppoints(500)), pval1,cex=0.1,xlab="Uniform Distribution")
abline(0,1)





############################################################################################

### Multiple Testing
sim.coin.pval=function(k,pH)
    {
        x=sample(c("H","T"),k,replace=TRUE,prob=c(pH,1-pH))
        pval=binom.test(sum(x=='H'), n=k, p = 0.5)$p.value
        #pval=prop.test(sum(x=='H'),k,p=0.5)$p.value
        return(pval)
    }

set.seed(1223)
B=10000
# Single coin experiment
pval1=replicate(B,sim.coin.pval(1000,0.5))
mean(pval1<0.05)

# Two coin experiment
pval1=replicate(B,sim.coin.pval(1000,0.5))
mean(pval1<0.05)
pval2=replicate(B,sim.coin.pval(1000,0.5))
mean(pval2<0.05)

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
#p.adjust(cbind(pval1,pval2),method ="bonferroni")
                    

############################################################################################





### Unsupervised


# Simulate noisy HM

library(pheatmap)
library(genefilter)

simulate.noise.heatmap=function(n,m,alpha)
  {
    # Simulate Expression Matrix
    EXPRS=matrix(rnorm(2*n*m),m,2*n)
    rownames(EXPRS)=paste("G",1:m,sep="")
    colnames(EXPRS)=paste("id",1:(2*n),sep="")
    grp=factor(rep(0:1,c(n,n)))
    # Get the two sample t-statistics
    pvals=rowttests(EXPRS, grp)$p.value
    topgenes=which(pvals<alpha)
    EXPRS=EXPRS[topgenes,]
    annodat=data.frame(Condition=ifelse(grp==0,"N","Y"),row.names=colnames(EXPRS))
    pheatmap(EXPRS,
             border_color =NA,
             show_rownames = FALSE,
             show_colnames=FALSE,
             annotation_col=annodat,
             color=colorRampPalette(c("red3", "black", "green3"))(50),
             annotation_colors=list(Condition=c(Y="blue",N="yellow")))
    return(length(topgenes))
}

set.seed(765)
aa=simulate.noise.heatmap(20,20000,0.005)
aa=simulate.noise.heatmap(20,40000,0.0025)
aa=simulate.noise.heatmap(3,20000,0.005)
############################################################################################

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
