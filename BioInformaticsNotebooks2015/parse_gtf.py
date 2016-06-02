#!/usr/bin/env python

import HTSeq
import argparse
import csv
import sys

# Following allows "| head" without throwing an IOError
# From <http://newbebweb.blogspot.com/2012/02/python-head-ioerror-errno-32-broken.html>
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

##================================================================================
##================================================================================

def main():
    parser = argparse.ArgumentParser(description="XXXXX")
    parser.add_argument("GFF", type=file, help="GTF/GFF File to parse")
    parser.add_argument("-o", "--out",metavar="FILENAME",type=argparse.FileType('w'),default=sys.stdout)
    parser.add_argument("-i", "--idattr", metavar="ID ATTRIBUTE", default="gene_id",
                        help="the %(metavar)s to extract from each GFF entry default:(%(default)s).")
    parser.add_argument("-t", "--type", metavar="FEATURE TYPE", action='append', default=[],
                        help="Limit GFF features to %(metavar)s.")
    parser.add_argument("-v", "--value", metavar="ATTRIBUTE", action='append', default=[],
                        help="the %(metavar)s to include in second, etc column of output file.")
    parser.add_argument("-d", "--dialect", default="excel", 
                        help="CSV format to use for output default:(%(default)s).")
    
    args = parser.parse_args()

    gtf_file = HTSeq.GFF_Reader( args.GFF,end_included=True )
    writer = csv.writer(args.out, dialect=args.dialect)

    gene_id_dict = {}
    # if args.type:
    #     raise StandardError, "blah"
    for feature in gtf_file:
        if args.type and feature.type not in args.type:
            continue
        if feature.attr[args.idattr] not in gene_id_dict:
            values = [feature.attr.get(attribute,"") for attribute in args.value]
            gene_id_dict[feature.attr[args.idattr]] = values
            writer.writerow([feature.attr[args.idattr]] + values)


def old():
    gene_id_dict = {}
    for feature in gtf_file:
        gene_id_dict.setdefault(feature.attr[args.idattr],[]).append(feature)
    print len(gene_id_dict)
    for id in gene_id_dict:
        print id
        for feat in gene_id_dict[id]:
            print "\t", feature
    print ",".join(['"{0}"'.format(id) for id in gene_id_dict])



if __name__ == "__main__":
    main()
