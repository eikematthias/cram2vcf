process MERGE_GVCFS {
   //publishDir "${params.outdir}/MergedCallset/GLNEXUS_DEEPVARIANT", mode: 'copy'
   scratch params.scratch
   label 'glnexus'
   cache 'lenient'
   input:
      path(gvcfs)
	   path(bed)
   output:
   //path('v_plink.txt'), emit: version
      tuple val('1'), path(merged_vcf), path(merged_tbi), emit: vcf 
   script:
	   merged_vcf = "deepvariant.joint_merged_" + task.index + ".vcf.gz"
      merged_tbi = "deepvariant.joint_merged_" + task.index + ".vcf.gz.tbi"
   """
      /usr/local/bin/glnexus_cli \
		   --config ${params.glnexus_config} \
		   --bed $bed \
		   $gvcfs | bcftools view - | bgzip -c > $merged_vcf
		   tabix $merged_vcf


   """	

}

process MERGE_ALL {
   publishDir "${params.outdir}/MergedCallset/GLNEXUS_DEEPVARIANT", mode: 'copy'
   scratch params.scratch
   label 'glnexus'

   input:
      tuple val(x), path(merged_vcf),path(merged_tbi)
   output:
   //path('v_plink.txt'), emit: version
      tuple path(allmerged_vcf), path(allmerged_tbi), emit: vcf
   script:
      allmerged_vcf = "deepvariant.joint_all_merged." + params.run_name + ".vcf.gz"
      allmerged_tbi = allmerged_vcf + ".tbi"
   """
      bcftools merge ${merged_vcf.join(' ')} | bgzip -c > $allmerged_vcf
		tabix $allmerged_vcf
   """	

}