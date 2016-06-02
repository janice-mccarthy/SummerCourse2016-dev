cnts=read.table("http://bowtie-bio.sourceforge.net/recount/countTables/mortazavi_count_table.txt",header=TRUE)
cnts=rbind(cnts[1:10,],data.frame(gene="...",SRX001866="...",SRX001867="...",SRX001868="..."))
write.csv(cnts,file="../Figures/countexample.csv",quote=FALSE)

