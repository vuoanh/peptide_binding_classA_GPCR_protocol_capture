#!/bin/bash

##############
# OANH VU 
# 06 05 2020
##############

THREAD_NUM=10

# Check the number of the parameters
if [ "$#" -ne 4 ]
then
    echo "Wrong number of arguements. Usage: $0 <model_list of pdb.gz files> <prefix of output name> <2 chain names in alphabetical order>"
    echo "This script calculates average per-residue-ddg for residues in the protein-protein interface. The model will use ref2015 as the scoring fxns" 
    echo "the first model in the model list will be used for the output pdb file"
    exit 1
else
    # Read in variables
    model_list=$1
    prefix=$2
    target_chain=$3
    ligand_chain=$4
    ROSETTA=/path/to/rosetta/main/source/bin/residue_energy_breakdown.linuxgccrelease

    echo Computing per_residue ddg
    $ROSETTA -l $model_list -out:file:silent ${prefix}_ddg_score.out 
    echo extracting the average ddg values for each cluster 
    model_num=`cat $model_list | wc -l`
    model_num_cutoff=$((model_num / 5)) 
    #Choose the residues that have interaction to at least 20% of the selected model
    grep -v onebody ${prefix}_ddg_score.out | grep "[0-9]${target_chain} "| grep "[0-9]${ligand_chain} "| awk '{print $4,$7}'|sort -g | uniq -c| awk -v n=$model_num_cutoff '$1 > n {print $2, $3}' > ${prefix}_ddg_interface.res.lst

    # extract all ddg values
    #grep "[0-9]${target_chain} " ddg_out.sc| grep "[0-9]$ligand_chain " | grep -v oneboy| awk '{print $4, $5, $7, $8, $(NF-1), $2}' > interaction.ddg.sc
    grep "[0-9]${target_chain} " ${prefix}_ddg_score.out| grep "[0-9]$ligand_chain " | grep -v onebody| awk '{print $4, $7, $(NF-1), $NF}' |sed "s/${target_chain} / /g"|sed "s/${ligand_chain} / /g" > ${prefix}_${ligand_chain}_${target_chain}_interaction.ddg.sc
    #grep -v onebody ddg_score.out| grep '  '| awk '{print $4, $(NF-1)}' > cluster_${cluster}.res.ddg.sc
    # take average of ddg on each residues of the ligand and the target
    for res in `awk '{print $1}' ${prefix}_ddg_interface.res.lst|sort|uniq`; do echo $res `grep "^${res} " ${prefix}_${ligand_chain}_${target_chain}_interaction.ddg.sc | awk '{print $3}' | scripts/ave_columns`; done | sed "s/${target_chain} / /g" > ${prefix}_chain${target_chain}.ave.res.ddg.sc
    for res in `awk '{print $2}' ${prefix}_ddg_interface.res.lst|sort|uniq`; do echo $res `grep " ${res} " ${prefix}_${ligand_chain}_${target_chain}_interaction.ddg.sc | awk '{print $3}' | scripts/ave_columns`; done | sed "s/${ligand_chain} / /g" > ${prefix}_chain${ligand_chain}.ave.res.ddg.sc
	model=`head -1 $model_list`
	echo best model is ${model}
	zgrep ATOM $model | awk -v n=$target_chain '$5==n' > ${model}_${target_chain}.pdb
	zgrep ATOM $model | awk -v n=$ligand_chain '$5==n' > ${model}_${ligand_chain}.pdb
	#gunzip ${model}.gz
	echo "output model with b-factor values set to per residue ddg for ${prefix} is ${prefix}.ddg.pdb" 
	scripts/set_residue_b_factor.scr ${prefix}_chain${target_chain}.ave.res.ddg.sc ${model}_${target_chain}.pdb > ${prefix}_chain${target_chain}.ddg.pdb
	scripts/set_residue_b_factor.scr ${prefix}_chain${ligand_chain}.ave.res.ddg.sc ${model}_${ligand_chain}.pdb > ${prefix}_chain${ligand_chain}.ddg.pdb
	#gzip ${model}
fi
