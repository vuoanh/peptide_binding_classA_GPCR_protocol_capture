#!/bin/bash

#Rosetta version
ROSETTA=/path/to/rosetta/main/source/bin/rosetta_scripts.linuxgccrelease

cd 6C1Q 
# asign prefix, names of residue, and parame files
resf_file=design.resf
xml_file=relax.xml
res1=A01
param2=3-cyclohexyl-L-alanine.params

# Run design with top 10 relaxed models
$ROSETTA -parser:protocol $xml_file \
    -out:pdb_gz \
    -out:prefix ${seed}_\
    -nstruct 10 \
    -out:file:scorefile ${seed}_scores.out \
    -s 6C1Q_refined.pdb \
    -native 6C1Q_refined.pdb \
    -ex1 \
    -ex2 \
    -parser:script_vars res_type=${res1},${res2} resf_file=${resf_file} \
    -extra_res_fa ${param} \
    -chemical:exclude_patches LowerDNA  UpperDNA SpecialRotamer VirtualBB ShoveBB VirtualDNAPhosphate VirtualNTerm CTermConnect sc_orbitals pro_hydroxylated_case1 pro_hydroxylated_case2 ser_phosphorylated thr_phosphorylated  tyr_phosphorylated tyr_sulfated lys_dimethylated lys_monomethylated  lys_trimethylated lys_acetylated glu_carboxylated cys_acetylated tyr_diiodinated C_methylamidated MethylatedProteinCterm Cterm_amidation
