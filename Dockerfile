# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Derived from:
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/r-notebook/Dockerfile
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/datascience-notebook/Dockerfile
# wget https://raw.githubusercontent.com/jupyter/docker-stacks/master/scipy-notebook/Dockerfile
# See https://github.com/jupyter/docker-stacks

FROM jupyter/r-notebook

# This file is derived from a file created by Josh Granek for a Duke workshop on microbiome analysis.
# It is modified for a Duke summer course in High-Throughput Sequencing and Analysis
# MAINTAINER Josh Granek <josh@duke.edu> 

MAINTAINER Janice M. McCarthy <janice.mccarthy@duke.edu>

USER root

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Install Less
##~~~~~~~~~~~~
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    less \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

##---------------------------------------------------------------------------
# Install Python 2 and Bash Kernel
##--------------------------------
USER jovyan

# Install Python 2 packages
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 \
    'ipython=4.1*' \
    'ipywidgets=4.1*' \
    'matplotlib=1.5*' \
    && conda clean -tipsy

# Install Bash Kernel
RUN pip install --user --no-cache-dir bash_kernel && \
    python -m bash_kernel.install

USER root

# Install Python 2 kernel spec globally to avoid permission problems when NB_UID
# switching at runtime.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install
##---------------------------------------------------------------------------

##===========================================================================
# Install R kernel

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan

# R packages
RUN conda config --add channels r && \
    conda install --quiet --yes \
    'r-base=3.2*' \
    'r-irkernel=0.5*' \
    'r-plyr=1.8*' \
    'r-devtools=1.9*' \
    'r-dplyr=0.4*' \
    'r-ggplot2=1.0*' \
    'r-tidyr=0.3*' \
    'r-shiny=0.12*' \
    'r-rmarkdown=0.8*' \
    'r-forecast=5.8*' \
    'r-stringr=0.6*' \
    'r-rsqlite=1.0*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.1*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-randomforest=4.6*' && conda clean -tipsy

USER root
## screen, make, git
#RUN apt-get -q -y  install screen
RUN apt-get -q -y  install make
RUN apt-get -q -y  install git

## tophat, bowtie2, bwa, samtools
FROM quagbrain/tophat-bowtie2-samtools
#RUN apt-get -q -y  install tophat
#RUN apt-get -q -y  install bwa
#RUN apt-get -q -y  install samtools

## R and R packages
RUN apt-get -q -y  install libxml2-dev

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.revolutionanalytics.com/'; options(repos = r)" > ~/.Rprofile

#RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(suppressUpdates = FALSE);biocLite('annotate', suppressUpdates = FALSE);biocLite('DESeq2', suppressUpdates = FALSE);biocLite('optparse', suppressUpdates = FALSE);biocLite('RColorBrewer', suppressUpdates = FALSE);"biocLite('gplots', suppressUpdates = FALSE)"
RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(suppressUpdates = FALSE)"


## htseq-count
RUN apt-get -q -y  install build-essential python2.7-dev python-numpy python-matplotlib python-pip
RUN pip install htseq
RUN pip install pysam

## ea-utils (fastq-mcf)
RUN apt-get -q -y  install libgsl0-dev
RUN wget "https://drive.google.com/uc?export=download&id=0B7KhouP0YeRAc2xackxzRnFrUEU" -O ea-utils.1.1.2-806.tar.gz
RUN tar -xvf ea-utils.1.1.2-806.tar.gz
RUN cd ea-utils.1.1.2-806
RUN make
RUN cp -a fastq-mcf /usr/local/bin/
RUN cd ~
RUN rm -rf ea-utils.1.1.2-806 ea-utils.1.1.2-806.tar.gz

## fastqc
RUN apt-get -q -y  install fastqc default-jre

## sra-toolkit
# apt-get -q -y  install sra-toolkit
RUN wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.4.3/sratoolkit.2.4.3-ubuntu64.tar.gz
RUN tar -zxf sratoolkit.2.4.3-ubuntu64.tar.gz
RUN cp sratoolkit.2.4.3-ubuntu64/bin/*  /usr/local/bin/
RUN rm sratoolkit.2.4.3-ubuntu64.tar.gz
RUN rm -r sratoolkit.2.4.3-ubuntu64
RUN sudo --user bitnami vdb-config --restore-defaults
RUN echo "test sra-toolkit with the following command:"
RUN echo "fastq-dump -X 5 -Z SRR390728"

USER jovyan
