#!/usr/bin/env python

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.SeqIO import FastaIO
import argparse
import sys

def main():
    parser = argparse.ArgumentParser(description="Reverse-complement sequences in input file.")
    parser.add_argument("FASTA_FILE", type=file,
                        help="Multi-FASTA file containing the sequences to reverse-complement")
    parser.add_argument("-o", "--output",type=argparse.FileType('w'),
                        default=sys.stdout,metavar="OUTFILE",
                        help="Save to %(metavar)s (default: STDOUT)")
    parser.add_argument("-b", "--both",action="store_true",default="False",
                        help="Output the original sequence along with the reverse complemented sequence")
    args = parser.parse_args()

    recomp(args.FASTA_FILE,args.output,args.both)
    
def recomp(input, output, both=False):
    fasta_out = FastaIO.FastaWriter(output, wrap=None)
    fasta_out.write_header()
    for seq_record in SeqIO.parse(input, "fasta"):
        rc_rec = seq_record.reverse_complement(id = seq_record.id + "_RC", description="")
        if both==True:
            fasta_out.write_record(seq_record)
        fasta_out.write_record(rc_rec)
    fasta_out.write_footer()

if __name__ == "__main__":
    main()
