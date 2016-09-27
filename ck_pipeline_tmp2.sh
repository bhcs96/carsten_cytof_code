#!/bin/bash

###############################################################################################################
## Define paths to software and reference files

RWD_MAIN=/Users/gosia/Dropbox/UZH/carsten_cytof
RCODE=/Users/gosia/Dropbox/UZH/carsten_cytof_code
METADATA=$RWD_MAIN/CK_metadata
PANELS=$RWD_MAIN/CK_panels


## Define which analysis to re-run
data_normalization=false
pcascores=false
select_observables=false
flowsom=false
heatmaps=false
runtsne=false
plottsne=false
plottsne_expr=false
frequencies=true
expression=false
cluster_merging=false
cluster_extracting=false
fcs_saving=false
cytokines=false
pd1=false


## global parameters
tsne_pmin=1500

###############################################################################################################
# Analysis of CK_2016-06-23_01 data
# Use Analysis block 1
###############################################################################################################

DATA=23
PANEL=1
data_dir="CK_2016-06-23_01"

file_panel="panel1.xlsx"
file_metadata="metadata_23_01.xlsx"

pca_score_cutoff=3
rand_seed_consensus=123
nmetaclusts=20

prefix_data="23_"
prefix_panel="01_"
prefix_pca="pca1_"
prefix_clust="cl20_"


file_merging="${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}cluster_merging6.xlsx"
prefix_merging="merging6_"

./Analysis_block_2_cluster_merging.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir} --cluster_merging ${cluster_merging} --heatmaps ${heatmaps} --plottsne ${plottsne} --frequencies ${frequencies} --expression ${expression} --METADATA ${METADATA} --PANELS ${PANELS} --file_metadata ${file_metadata} --file_panel ${file_panel} --prefix_data ${prefix_data} --prefix_panel ${prefix_panel} --prefix_pca ${prefix_pca} --prefix_clust ${prefix_clust} --prefix_merging ${prefix_merging} --file_merging ${file_merging}


# --------------------------------------------------
# Analysis of CK_2016-06-23_01_CD4_mergingNEW2 using panel1CD4.xlsx
# and CK_2016-06-23_01_CD8_mergingNEW2 using panel1CD8.xlsx
# Use Analysis block 1
# --------------------------------------------------

DATA=23
PANEL=1

file_metadata="metadata_23_01.xlsx"

rand_seed_consensus=1234
nmetaclusts=20

prefix_pca="pca1_"
prefix_clust="cl20_"

data_dir=('CK_2016-06-23_01_CD4_mergingNEW2' 'CK_2016-06-23_01_CD8_mergingNEW2')
prefix_data=('23CD4_' '23CD8_')
file_panel=('panel1CD4.xlsx' 'panel1CD8.xlsx')
prefix_panel=('01CD4_' '01CD8_')
pca_score_cutoff=(2 2)


# --------------------------------------------------
# Analysis of CK_2016-06-23_01_CD4_mergingNEW2 using panel1CD4.xlsx for cluster_merging
# and CK_2016-06-23_01_CD8_mergingNEW2 using panel1CD8.xlsx for cluster_merging
# Use Analysis block 2
# --------------------------------------------------

prefix_clust="cl20_"

file_merging=("${prefix_data[0]}${prefix_panel[0]}${prefix_pca}${prefix_clust}cluster_merging.xlsx" "${prefix_data[1]}${prefix_panel[1]}${prefix_pca}${prefix_clust}cluster_merging.xlsx")
prefix_merging=('merging_' 'merging_')

# rerun only for CD8

for i in 1
do
  ./Analysis_block_2_cluster_merging.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir[$i]} --cluster_merging ${cluster_merging} --heatmaps ${heatmaps} --plottsne ${plottsne} --frequencies ${frequencies} --expression ${expression} --METADATA ${METADATA} --PANELS ${PANELS} --file_metadata ${file_metadata} --file_panel ${file_panel[$i]} --prefix_data ${prefix_data[$i]} --prefix_panel ${prefix_panel[$i]} --prefix_pca ${prefix_pca} --prefix_clust ${prefix_clust} --prefix_merging ${prefix_merging[$i]} --file_merging ${file_merging[$i]}
done



file_merging=("${prefix_data[0]}${prefix_panel[0]}${prefix_pca}${prefix_clust}cluster_merging2.xlsx" "${prefix_data[1]}${prefix_panel[1]}${prefix_pca}${prefix_clust}cluster_merging2.xlsx")
prefix_merging=('merging2_' 'merging2_')

# run only for CD4 - merging2 exists only in CD4 by now

for i in 0
do
  ./Analysis_block_2_cluster_merging.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir[$i]} --cluster_merging ${cluster_merging} --heatmaps ${heatmaps} --plottsne ${plottsne} --frequencies ${frequencies} --expression ${expression} --METADATA ${METADATA} --PANELS ${PANELS} --file_metadata ${file_metadata} --file_panel ${file_panel[$i]} --prefix_data ${prefix_data[$i]} --prefix_panel ${prefix_panel[$i]} --prefix_pca ${prefix_pca} --prefix_clust ${prefix_clust} --prefix_merging ${prefix_merging[$i]} --file_merging ${file_merging[$i]}
done


# --------------------------------------------------
# Analysis of cytokines
# in CK_2016-06-23_02_CD4_merging2 and CK_2016-06-23_02_CD8_merging2
# Use Analysis block 4
# --------------------------------------------------

DATA=23
PANEL=2
file_metadata="metadata_23_02.xlsx"

prefix_pca="pca1_"
prefix_clust="cl20_"

data_dir=('CK_2016-06-23_02_CD4_merging2' 'CK_2016-06-23_02_CD8_merging2')
prefix_data=('23CD4_' '23CD8_')
file_panel=('panel2CD4.xlsx' 'panel2CD8.xlsx')
prefix_panel=('02CD4_' '02CD8_')

prefix_merging=('merging_' 'merging_')
clsubset=("c('CM','EM')" "c('CM','EM','TE')")
prefix_clsubset=('Tmem_' 'Tmem_')
file_cytokines_cutoffs=('panel2CD4_cytokines_CM.xlsx' 'panel2CD8_cytokines_CM.xlsx')
prefix_cytokines_cutoffs=('cytCM_' 'cytCM_')
nmetaclusts=(40 20)


file_merging_cyt=("${prefix_data[0]}${prefix_panel[0]}${prefix_pca}${prefix_merging[0]}${prefix_clsubset[0]}${prefix_cytokines_cutoffs[0]}raw2_cl${nmetaclusts[0]}_cytokine_merging2.xlsx" "${prefix_data[1]}${prefix_panel[1]}${prefix_pca}${prefix_merging[1]}${prefix_clsubset[1]}${prefix_cytokines_cutoffs[1]}raw2_cl${nmetaclusts[1]}_cytokine_merging2.xlsx")
prefix_merging_cyt=("cytmerging2_" "cytmerging2_")


for i in 0 1
do
  ./Analysis_block_4_cytokines.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir[$i]} --cytokines ${cytokines} --PANELS ${PANELS} --METADATA ${METADATA} --file_metadata ${file_metadata} --prefix_data ${prefix_data[$i]} --prefix_panel ${prefix_panel[$i]} --prefix_pca ${prefix_pca} --prefix_merging ${prefix_merging[$i]} --prefix_clsubset ${prefix_clsubset[$i]} --prefix_cytokines_cutoffs ${prefix_cytokines_cutoffs[$i]} --file_cytokines_cutoffs ${file_cytokines_cutoffs[$i]} --clsubset ${clsubset[$i]} --nmetaclusts ${nmetaclusts[$i]} --file_merging_cyt ${file_merging_cyt[$i]} --prefix_merging_cyt ${prefix_merging_cyt[$i]}
done


# --------------------------------------------------
# Analysis of PD1+ and PD1- cells
# in CK_2016-06-23_02_CD4_merging2 and CK_2016-06-23_02_CD8_merging2
# Use Analysis block 5
# --------------------------------------------------

### Analysis of cytokines for PD1+

prefix_merging=('merging_' 'merging_')
clsubset=("c('CM','EM')" "c('CM','EM','TE')")
prefix_clsubset=('Tmem_' 'Tmem_')
file_cytokines_cutoffs=('panel2CD4_cytokines_CM.xlsx' 'panel2CD8_cytokines_CM.xlsx')
prefix_cytokines_cutoffs=('cytCM_' 'cytCM_')
nmetaclusts=(20 20)

file_merging_pd1=("${prefix_data[0]}${prefix_panel[0]}${prefix_pca}${prefix_merging[0]}${prefix_clsubset[0]}${prefix_cytokines_cutoffs[0]}raw2_pd1positive_cl${nmetaclusts[0]}_pd1_merging.xlsx" "${prefix_data[1]}${prefix_panel[1]}${prefix_pca}${prefix_merging[1]}${prefix_clsubset[1]}${prefix_cytokines_cutoffs[1]}raw2_pd1positive_cl${nmetaclusts[1]}_pd1_merging.xlsx")
prefix_merging_pd1=("pd1merging_" "pd1merging_")


for i in 0 1
do
  ./Analysis_block_5_pd1.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir[$i]} --pd1 ${pd1} --PANELS ${PANELS} --METADATA ${METADATA} --file_metadata ${file_metadata} --prefix_data ${prefix_data[$i]} --prefix_panel ${prefix_panel[$i]} --prefix_pca ${prefix_pca} --prefix_merging ${prefix_merging[$i]} --prefix_clsubset ${prefix_clsubset[$i]} --prefix_cytokines_cutoffs ${prefix_cytokines_cutoffs[$i]} --file_cytokines_cutoffs ${file_cytokines_cutoffs[$i]} --clsubset ${clsubset[$i]} --nmetaclusts ${nmetaclusts[$i]} --file_merging_pd1 ${file_merging_pd1[$i]} --prefix_merging_pd1 ${prefix_merging_pd1[$i]}
done



###############################################################################################################
# Analysis of CK_2016-06-23_03 data
# Use Analysis block 1
###############################################################################################################

DATA=23
PANEL=3
data_dir="CK_2016-06-23_03"

file_panel="panel3.xlsx"
file_metadata="metadata_23_03.xlsx"

pca_score_cutoff=0.9
rand_seed_consensus=1234
nmetaclusts=20

prefix_data="23_"
prefix_panel="03_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# --------------------------------------------------
# Analysis of CK_2016-06-23_03 merging2
# Use Analysis block 2
# --------------------------------------------------

prefix_clust="cl20_"

file_merging="${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}cluster_merging4.xlsx"
prefix_merging="merging4_"

./Analysis_block_2_cluster_merging.sh --RCODE ${RCODE} --RWD_MAIN ${RWD_MAIN} --data_dir ${data_dir} --cluster_merging ${cluster_merging} --heatmaps ${heatmaps} --plottsne ${plottsne} --frequencies ${frequencies} --expression ${expression} --METADATA ${METADATA} --PANELS ${PANELS} --file_metadata ${file_metadata} --file_panel ${file_panel} --prefix_data ${prefix_data} --prefix_panel ${prefix_panel} --prefix_pca ${prefix_pca} --prefix_clust ${prefix_clust} --prefix_merging ${prefix_merging} --file_merging ${file_merging}







#