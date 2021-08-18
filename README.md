
for i in `awk '{print $2}' classA.lst`; do tail -n+3 ${i}/${i}_*_scores.out| grep SCORE:| awk '{print $6, $NF".pdb.gz"}' |sort -g |head | awk '{print $2}' > ${i}/${i}_top10.lst; done
