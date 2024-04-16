#method for merging two haplotyped SNPs from assembliles of a diploid plant into a single vcf

#Note that SYRI calls SNPs when the ALT position is an N, which can be removed with something like:

#rm SNPs with N in the Alt column
  
  awk -F '\t' 'BEGIN {OFS = FS } {if($5 !="N") print $0}'
