#!/usr/bin/env bash
# run this script as: "sudo bash update_R.sh"

# Following adds CRAN to sources that ubuntu uses so it can get latest version of R
# sudo su -c "echo 'deb http://cran.wustl.edu/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"

export DEBIAN_FRONTEND=noninteractive

## Remove R and R packages so bioconductor doesn't balk
sudo apt-get  -q -y remove r-base r-base-dev r-base-core
sudo apt-get  -q -y autoremove            
rm -rf /home/bitnami/R/x86_64-pc-linux-gnu-library/3.2 /usr/local/lib/R/site-library /usr/lib/R/site-library /usr/lib/R/library

## update and upgrade
apt-get -q update
apt-get -q -y --force-yes upgrade
apt-get -q -y --force-yes dist-upgrade

## R and R packages
apt-get -q -y --force-yes install r-base r-base-dev r-base-core
apt-get -q -y --force-yes install libxml2-dev
echo 'source("http://bioconductor.org/biocLite.R")' > install.R
echo 'biocLite()' >> install.R
echo 'biocLite("annotate")' >> install.R
echo 'biocLite("DESeq2")' >> install.R
echo 'biocLite("optparse")' >> install.R
echo 'biocLite("RColorBrewer")' >> install.R
echo 'biocLite("gplots")' >> install.R
echo "install.packages(c('rzmq','repr','IRkernel','IRdisplay'), repos = c('http://irkernel.github.io/', getOption('repos')), type = 'source')"  >> install.R
echo 'IRkernel::installspec()' >> install.R

Rscript install.R
rm install.R


