library(data.table)
library(tidyverse)
args = commandArgs(trailingOnly=TRUE)
bimfile <- args[1]
#bimfile <- fread("/run/user/1000/gvfs/sftp:host=medcluster.medfdm.uni-kiel.de/work_beegfs/sukmb465/projects/exome/Regeneron_PSC_CON/exome_PSC_CON/output/regeneron_PSC_CON_exome/SNPQCII/regeneron_PSC_CON_exome_QCed.bim")
colnames(bimfile) <- c("chr", "rsid", "zero", "pos", "a0", "a1")
bimfile$chr <- as.character(bimfile$chr)
perbase <- args[2]
#perbase <- fread("/run/user/1000/gvfs/sftp:host=medcluster.medfdm.uni-kiel.de/work_beegfs/sukmb465/projects/exome/mosdepth_lookup/checkquality/exome_snpqc_testarea/work/44/7ea95cb593647ca300e0ec85bef3b4/PSC00196.per-base.bed.gz")
colnames(perbase) <- c("chr", "start", "end", "cov")

merged <- bimfile[perbase, .(chr, rsid, pos, start, end, cov),
                  on = .(chr == chr, pos <= end, pos >= start)][!is.na(rsid),]

merged_withcov <- merged[cov >= 5,rsid]

