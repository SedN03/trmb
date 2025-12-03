#Make the Bowtie2 index
bowtie2-build $GDIR/$GENOME $GDIR/GCA_030408175.1_UTM_Trep_v1.0_genomic.fna

#Run Alignment
bowtie2 -p 8 -x $GDIR/$GENOME -1 /work/sedric/Projects/microbes/seq/trim/$FILE$S1 -2 /work/sedric/Projects/microbes/seq/trim/$FILE$S2 --un-conc-gz $PROJDIR/exogenous/$FILE'_MICROBES' > $FILE'_HOST'.sam; samtools view -hbS -f 4 $FILE'_HOST'.sam > $PROJDIR/endogenous/$FILE'_ENDO.bam'; rm $FILE'_HOST'.sam; mv $PROJDIR/exogenous/$FILE'_MICROBES.1' $PROJDIR/exogenous/$FILE'_MICROBES_1.fq'; mv $PROJDIR/exogenous/$FILE'_MICROBES.2' $PROJDIR/exogenous/$FILE'_MICROBES_2.fq'

#Build Kraken2DB
kraken2-build --download-taxonomy -db KrakenDB
kraken2-build --download-library bacteria --db KrakenDB
kraken2-build --download-library archaea --db KrakenDB
kraken2-build --download-library viral --db KrakenDB
kraken2-build --download-library fungi --db KrakenDB
kraken2-build --build --db KrakenDB

#Run Seq against Database
kraken2 --db $GDIR --paired --classified-out $CLASSDIR/$FILE'_class'#.fq --unclassified-out $UNCDIR/$FILE'_unc'#.fq$PROJDIR/$FILE'_1.fq' $PROJDIR/$FILE'_2.fq'
