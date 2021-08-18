#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --time=10:00:00
#SBATCH --array=1-100

seed=$SLURM_ARRAY_TASK_ID
#Rosetta version
ROSETTA=/Path/To/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease

cd 5VBL
# asign prefix, names of residue, and parame files
resf_file=design.resf
xml_file=relax.xml
res1=R01
param1=./L-homo-arginine.params
res2=P01
param2=./L-Octahydroindole-2-carboxylic-acid.params
res3=L01
param3=/home/vuot2/bin/ncaa_lib/external_database/leucine_dev/L-norleucine.params
res4=023
param4=./4-Chloro-L-phenylalanin.params
res5=A01
param5=~/bin/ncaa_lib/external_database/alanine_dev/3-cyclohexyl-L-alanine.params

# Run design with top 10 relaxed models
$ROSETTA -parser:protocol $xml_file \
    -out:pdb_gz \
    -out:prefix ${seed}_ \
    -nstruct 1 \
    -out:file:scorefile ${seed}_scores.out \
    -s 5VBL_refined.pdb \
    -native 5VBL_refined.pdb \
    -ex1 \
    -ex2 \
    -parser:script_vars res_type=${res1},${res2},${res3},${res4},${res5} resf_file=${resf_file} \
    -extra_res_fa ${param1} ${param2} ${param3} ${param5} ${param4} \
