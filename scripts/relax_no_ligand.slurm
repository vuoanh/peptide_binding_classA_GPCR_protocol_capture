#!/bin/bash
template=`readlink -f $1`
work_dir=`readlink -f $2`
prefix=$3
xml=scripts/relax_interface_analyze_no_ligand.xml
nstruct=10

cd $work_dir
/path/to/rosetta/main/source/bin/rosetta_scripts.linuxgccrelease \
    -parser:protocol $xml \
    -out:pdb_gz \
    -out:prefix ${prefix}_ \
    -nstruct $nstruct \
    -out:file:scorefile ${prefix}_scores.out \
    -s $template \
    -native $template \
    -relax:constrain_relax_to_start_coords \
    -relax:constrain_relax_to_native_coords 
