include { INPUT_CHECK } from '../modules/input_check'
include { DEEPVARIANT } from '../modules/deepvariant'
include { MERGE_GVCFS; MERGE_ALL } from '../modules/merge_gvcfs'
//include { SOFTWARE_VERSIONS } from '../modules/software_versions'
//include { MULTIQC } from './../modules/multiqc'

workflow MAIN {
/*
	take:
	samplesheet
*/	
	main:

		ch_bed = params.regions_bed
		//deepvariant_ref = Channel.fromFilePairs("${params.fasta_fa}"+'{.fa.gz.fai,.fa.gz}',size: -1, flat: true)//Channel.from( [ [file(params.fasta_fa),file(params.fasta_fai)] ] ).map { it -> tuple(it[0], it[1])  }//.map { [ file(params.fasta_fa),file(params.fasta_fai) ] }.view()//.from( [ file(params.fasta_fa),file(params.fasta_fai)] ).view()//.map { [file(params.fasta_fa), file(params.fasta_fai)] }.view()//
		deepvariant_ref = Channel.from( 
										[ 	
											file(params.fasta_fai),
											//file(params.fasta_gz),
											file(params.fasta_fa),
											file(params.fasta_gzfai),
											file(params.fasta_gzi) ] 
											)
		INPUT_CHECK()
        
		DEEPVARIANT(
           INPUT_CHECK.out.cram,//.combine(deepvariant_ref),
		   ch_bed,
		   deepvariant_ref.collect()
        )
		ch_buffered = DEEPVARIANT.out.gvcf.buffer(size: 50, remainder: true)//.view()
		
		MERGE_GVCFS( 
						ch_buffered,
						ch_bed 
						)
		
		MERGE_ALL( MERGE_GVCFS.out.vcf.groupTuple()) 
		//ch_versions = MOSDEPTH.out.version.first()
		//SOFTWARE_VERSIONS(
		//ch_versions.collect()
		//)		
		
/*	
        MULTIQC(
           FASTP.out.json.collect()
        )

	emit:
	qc = MULTIQC.out.report
*/	
}
