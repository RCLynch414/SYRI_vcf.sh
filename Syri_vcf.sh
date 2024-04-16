rm mergeList.txt

cat $@ | while read sample; do

cd $sample.syri

cat "$sample"syri.vcf | grep '#' | sed 's/#CHROM.*/##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">/' > $sample.2.vcf

echo "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$sample">> $sample.2.vcf

cat "$sample"syri.vcf | grep -v '#' | awk -F '\t' 'BEGIN {OFS = FS } {if($4 !="N") print $0,"GT","0|1"}'  >> $sample.2.vcf

bgzip -f $sample.2.vcf
bcftools index $sample.2.vcf.gz

cd -

echo "$sample.syri/$sample.2.vcf.gz" >> mergeList.txt

done


#haplotype merger


cat $@ | while read sample; do

bcftools merge /data1/rlynch/ryan/"$sample"a.syri/"$sample"a.2.vcf.gz /data1/rlynch/ryan/"$sample"b.syri/"$sample"b.2.vcf.gz  | grep '#' | sed '/^#CHROM/d' > "$sample"_haploMerged.vcf 

echo "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t$sample" >> "$sample"_haploMerged.vcf

bcftools merge /data1/rlynch/ryan/"$sample"a.syri/"$sample"a.2.vcf.gz /data1/rlynch/ryan/"$sample"b.syri/"$sample"b.2.vcf.gz | grep -v "#" | awk -F '\t' 'BEGIN {OFS = FS } {if($10 =="0|1" && $11 =="0|1") {print $1,$2,$3,$4,$5,$6,$7,$8,$9,"1/1"} else {print $1,$2,$3,$4,$5,$6,$7,$8,$9,"0/1"}}'  >> "$sample"_haploMerged.vcf

bgzip -f "$sample"_haploMerged.vcf

bcftools index "$sample"_haploMerged.vcf.gz

done