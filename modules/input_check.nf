//
// Check input samplesheet and get read channels
//

workflow INPUT_CHECK {
    take:
    //samplesheet // file: /path/to/samplesheet.csv

    main:
    //samplesheet
    Channel
        .from(file(params.input))
        .splitCsv ( header:true, sep:',' )
        .map { create_cram_channel(it) }
        .set { cram }

    emit:
    cram                                     // channel: [ val(meta), [ reads ] ]
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def create_cram_channel(LinkedHashMap row) {
    def meta = [:]
    //meta.patient_id   = row.patient_id
    meta.id = row.id
    //meta.library_id   = row.library_id
    //meta.readgroup_id = row.rgID

    def array = []
    if (!file(row.cram).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> Cram file does not exist!\n${row.cram}"
    }
        if (!file(row.index).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> Cram file does not exist!\n${row.index}"
    }
    /*
    if (!file(row.R2).exists()) {
         exit 1, "ERROR: Please check input samplesheet -> Read 2 FastQ file does not exist!\n${row.R2}"
    }
    */
    array = [ meta, file(row.cram), file(row.index) ]//, file(row.reference)
    return array
}
