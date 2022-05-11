#!/bin/bash

. $1

# Generate exon annotation file
START1=$(date +%s)
# perl Algorithm_generating_annotation_exon.pl $geneAnnotation
END1=$(date +%s)
DIFF1=$(( $END1 - $START1))
echo "It took $DIFF1 seconds to generate exon annotation file!"

# Process exon annotation files and generate feature start and gene mapping files
START2=$(date +%s)
# perl Algorithm_preprocessing_exon_annotation_RR.pl "$geneAnnotation".exon
END2=$(date +%s)
DIFF2=$(( $END2 - $START2))
echo "It took $DIFF2 seconds to generate feature start and gene mapping files!"

#Classify variants by regions (CDS, Upstream, Downstream, Intron, UTRs...)
START3=$(date +%s)
# perl Algorithm_mapping_variants_reporting_class_intronLocation_updown.pl ChrAll_knownGene.txt.exons VCF_input_file_in_tab_delimited_format.txt
# OR
# perl Algorithm_mapping_variants_reporting_class_intronLocation_updown.pl ChrAll_knownGene.txt.exons VCF_input_file_in_tab_delimited_format.txt IntronExon_boundary_in_bp
perl Algorithm_mapping_variants_reporting_class_intronLocation_updown.pl "$geneAnnotation".exons $vcfFile $intronBoundary
END3=$(date +%s)
DIFF3=$(( $END3 - $START3))
echo "It took $DIFF3 seconds to classify variants by regions!"


#Predict amino acid change type
START4=$(date +%s)
# perl Algorithm_predicting_full_AA_change_samtools_updown.pl VCF_input_file_in_tab_delimited_format.txt.append kgXref.txt hg19_CDSIntronWithSign.txt.out ChrAll_knownGene.txt > VCF_input_file_in_tab_delimited_format.txt.out.txt
perl Algorithm_predicting_full_AA_change_samtools_updown.pl "$vcfFile".append $conversionFile $sequenceFile $geneAnnotation >"$vcfFile".out.txt
END4=$(date +%s)
DIFF4=$(( $END4 - $START4))
echo "It took $DIFF4 seconds for predicting amino acid change type!"

#Prioritize mutation effects
START5=$(date +%s)
# perl Algorithm_prioritizing_mutation_headerTop_updown.pl VCF_input_file_in_tab_delimited_format.txt.append.out.txt
perl Algorithm_prioritizing_mutation_headerTop_updown.pl "$vcfFile".append.out.txt
END5=$(date +%s)
DIFF5=$(( $END4 - $START4))
echo "It took $DIFF5 seconds for prioritizing mutation effects!"
