process DEEPVARIANT {

   scratch params.scratch

   label 'deepvariant'

   input:
   //tuple val(meta),path(cram),path(index), path(reference)
    tuple val(meta), path(cram), path(index)//, val(reference_name), path(reference_fasta), path(reference_index)
    each path(bed)
    //tuple path(reference_fasta), path(reference_index), 
      tuple path(fasta_fai), path(fasta_gz), path(fasta_gzfai), path(fasta_gzi)

   output:
   //path('v_mosdepth.txt'), emit: version
         path(dv_gvcf), emit: gvcf
         tuple val(meta),path(dv_vcf), emit: vcf
         val(sample_name), emit: sample_name
   script:
      sampleid = meta.id

      dv_gvcf = sampleid + "_" + meta.sample_id + "-deepvariant.g.vcf.gz"
      dv_vcf = sampleid + "_" + meta.sample_id + "-deepvariant.vcf.gz"
      sample_name = "${sampleid}"
      
   """
      /opt/deepvariant/bin/run_deepvariant \
                --model_type=WES \
                --ref=${fasta_gz} \
                --reads $cram \
                --regions=$bed \
                --output_vcf=$dv_vcf \
                --output_gvcf=$dv_gvcf \
                --num_shards=${task.cpus}

   """	

}
/*cram_trim = file(r1).getBaseName() + "_trimmed.fastq.gz"
   r2_trim = file(r2).getBaseName() + "_trimmed.fastq.gz"
   json = file(r1).getBaseName() + ".fastp.json"
   html = file(r2).getBaseName() + ".fastp.html"
*/

//                --regions=$bed \

/*
      cat <<-END_VERSIONS > v_mosdepth.txt
      "${task.process}":
            mosdepth \$( mosdepth --version | sed -e "s/mosdepth //g" )
      END_VERSIONS
*/