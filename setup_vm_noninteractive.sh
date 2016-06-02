# run this script as: "sudo bash setup_vm_noninteractive.sh"

# Following adds CRAN to sources that ubuntu uses so it can get latest version of R
# sudo su -c "echo 'deb http://cran.wustl.edu/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list"

export DEBIAN_FRONTEND=noninteractive

## update and upgrade
apt-get -q update
apt-get -q -y upgrade

## screen, make, git
apt-get -q -y  install screen
apt-get -q -y  install make
apt-get -q -y  install git

## tophat, bowtie2, bwa, samtools
apt-get -q -y  install tophat
apt-get -q -y  install bwa
apt-get -q -y  install samtools

## R and R packages
apt-get -q -y  install r-base r-base-dev
apt-get -q -y  install libxml2-dev
echo 'source("http://bioconductor.org/biocLite.R")' > install.R
echo 'biocLite()' >> install.R
echo 'biocLite("annotate")' >> install.R
echo 'biocLite("DESeq2")' >> install.R
echo 'biocLite("optparse")' >> install.R
echo 'biocLite("RColorBrewer")' >> install.R
echo 'biocLite("gplots")' >> install.R
Rscript install.R
rm install.R

## htseq-count
apt-get -q -y  install build-essential python2.7-dev python-numpy python-matplotlib python-pip
pip install htseq
pip install pysam

## ea-utils (fastq-mcf)
apt-get -q -y  install libgsl0-dev
wget "https://drive.google.com/uc?export=download&id=0B7KhouP0YeRAc2xackxzRnFrUEU" -O ea-utils.1.1.2-806.tar.gz
tar -xvf ea-utils.1.1.2-806.tar.gz
cd ea-utils.1.1.2-806
make
cp -a fastq-mcf /usr/local/bin/
cd ~
rm -rf ea-utils.1.1.2-806 ea-utils.1.1.2-806.tar.gz

## fastqc
apt-get -q -y  install fastqc default-jre

## sra-toolkit
# apt-get -q -y  install sra-toolkit
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.4.3/sratoolkit.2.4.3-ubuntu64.tar.gz
tar -zxf sratoolkit.2.4.3-ubuntu64.tar.gz
cp sratoolkit.2.4.3-ubuntu64/bin/*  /usr/local/bin/
rm sratoolkit.2.4.3-ubuntu64.tar.gz
rm -r sratoolkit.2.4.3-ubuntu64
sudo --user bitnami vdb-config --restore-defaults
echo "test sra-toolkit with the following command:"
echo "fastq-dump -X 5 -Z SRR390728"
