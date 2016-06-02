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


