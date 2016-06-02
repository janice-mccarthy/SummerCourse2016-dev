# Simulate noisy HM

library(pheatmap)
library(genefilter)

simulate.noise.heatmap=function(n,m,alpha)
  {
    # Simulate Expression Matrix
    EXPRS=matrix(rnorm(2*n*m),m,2*n)
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



simulate.noise.PC=function(n,m,alpha)
  {
    # Simulate Expression Matrix
    EXPRS=matrix(rnorm(2*n*m),m,2*n)
    grp=factor(rep(0:1,c(n,n)))
    # Get the two sample t-statistics
    pvals=rowttests(EXPRS, grp)$p.value
    topgenes=which(pvals<alpha)
    EXPRS=EXPRS[topgenes,]
    annodat=data.frame(Condition=ifelse(grp==0,"N","Y"),row.names=colnames(EXPRS))
    PC=cmdscale(dist(t(EXPRS)))
    plot(PC,xlab="PC1",ylab="PC2",col=ifelse(grp==0,"yellow","blue"),pch=19)
    return(length(topgenes))
}
set.seed(765)
aa=simulate.noise.PC(20,20000,0.005)
aa=simulate.noise.PC(20,40000,0.0025)
aa=simulate.noise.PC(3,20000,0.005)
