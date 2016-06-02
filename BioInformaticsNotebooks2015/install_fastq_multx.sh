## ea-utils (fastq-mcf)
# apt-get -q -y  install libgsl0-dev
cd /tmp
wget "https://drive.google.com/uc?export=download&id=0B7KhouP0YeRAc2xackxzRnFrUEU" -O ea-utils.1.1.2-806.tar.gz
tar -xvf ea-utils.1.1.2-806.tar.gz
cd ea-utils.1.1.2-806
make
cp -a fastq-multx /usr/local/bin/
cd /tmp
rm -rf ea-utils.1.1.2-806 ea-utils.1.1.2-806.tar.gz
