#!/bin/bash
# usage: bash scripts/import_to_qiime.sh RUN SRC_DIR [stage]
set -euo pipefail
RUN=$1; SRC=$2; STAGE=${3:-direct}


#CONDA_SH=${CONDA_SH:?set CONDA_SH to the path of your conda.sh}
CONDA_SH=${CONDA_SH:-/hpcfs/users/a1640999/tools/miniconda3/etc/profile.d/conda.sh}
source "$CONDA_SH"
conda activate rachis-qiime2-2026.10


PROJECT=${PROJECT:-$(cd "$(dirname "$0")/.." && pwd)}
cd "$PROJECT"
mkdir -p tmp_data "data/$RUN" "vis/$RUN"
export TMPDIR=$PWD/tmp_data

INPUT=$SRC
if [ "$STAGE" = "stage" ]; then
	INPUT=raw_files/$RUN
	mkdir -p "$INPUT"
	trap 'rm -rf "$INPUT"' EXIT          # remove the copy even if the job fails
	rsync -a --info=stats1 "$SRC"/ "$INPUT"/
fi

qiime tools import \
	--type 'SampleData[PairedEndSequencesWithQuality]' \
	--input-path "$INPUT" \
	--input-format CasavaOneEightSingleLanePerSampleDirFmt \
	--output-path data/$RUN/demux_paired_end.qza

qiime demux summarize \
	--i-data data/$RUN/demux_paired_end.qza \
       	--o-visualization vis/$RUN/demux_paired_end.qzv
