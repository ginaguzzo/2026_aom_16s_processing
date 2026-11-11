#!/bin/bash
# usage: bash scripts/dada2.sh RUN TRUNC_F TRUNC_R THREADS [OUT_DIR_NAME]
set -euo pipefail
RUN=$1; TRUNC_F=$2; TRUNC_R=$3; THREADS=${4:-8}; OUT=${5:-$RUN}


#CONDA_SH=${CONDA_SH:?set CONDA_SH to the path of your conda.sh}
CONDA_SH=${CONDA_SH:-/hpcfs/users/a1640999/tools/miniconda3/etc/profile.d/conda.sh}
source "$CONDA_SH"
conda activate rachis-qiime2-2026.10

PROJECT=${PROJECT:-$(cd "$(dirname "$0")/.." && pwd)}
cd "$PROJECT"
mkdir -p tmp_data "data/$OUT" "vis/$OUT"
export TMPDIR=$PWD/tmp_data


## Run dada2
qiime dada2 denoise-paired \
	--i-demultiplexed-seqs data/$RUN/demux_paired_end.qza \
	--p-trim-left-f 0 --p-trim-left-r 0 \
	--p-trunc-len-f $TRUNC_F --p-trunc-len-r $TRUNC_R \
	--p-n-threads $THREADS --verbose \
	--o-representative-sequences data/$OUT/rep_seqs_dada2.qza \
	--o-table data/$OUT/table_dada2.qza \
	--o-denoising-stats data/$OUT/dada2_stats_denoise.qza \
	--o-base-transition-stats data/$OUT/dada2_stats_transition.qza


## Visualise dada2 results
qiime metadata tabulate \
	--m-input-file data/$OUT/dada2_stats_denoise.qza \
	--o-visualization vis/$OUT/dada2_stats_denoise.qzv

qiime feature-table tabulate-seqs \
	--i-data data/$OUT/rep_seqs_dada2.qza \
	--o-visualization vis/$OUT/rep_seqs_dada2.qzv

qiime metadata tabulate \
	--m-input-file data/$OUT/dada2_stats_transition.qza \
	--o-visualization vis/$OUT/dada2_stats_transition.qzv

qiime feature-table summarize \
	--i-table data/$OUT/table_dada2.qza \
	--m-metadata-file metadata/metadata_combined_seq_runs_1-5.tsv \
	--o-feature-frequencies data/$OUT/feature_table_dada2_feature_freq.qza \
	--o-sample-frequencies data/$OUT/feature_table_dada2_sample_freq.qza \
	--o-summary vis/$OUT/feature_table_dada2.qzv
