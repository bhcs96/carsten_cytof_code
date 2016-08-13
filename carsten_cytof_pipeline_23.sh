#!/bin/bash
## Define paths to software and reference files

RWD_MAIN=/Users/gosia/Dropbox/UZH/carsten_cytof
RCODE=$RWD_MAIN
METADATA=$RWD_MAIN/CK_metadata
PANELS=$RWD_MAIN/CK_panels


## Define which analysis to re-run
pcascores=true
select_observables=true
flowsom=true
heatmaps=true
runtsne=true
plottsne=true
frequencies=true
cluster_merging=true
cluster_extracting=true
cytokines=false
fcs_saving=false
pd1=false

##############################################################################
# Analysis of CK_2016-06-23_01 data
# Use Analysis block 1
##############################################################################

DATA=23
PANEL=1
RWD=$RWD_MAIN/CK_2016-06-23_01
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_panel="panel1.xlsx"
file_metadata="metadata_23_01.xlsx"

pca_score_cutoff=3
rand_seed_consensus=123
nmetaclusts=20

prefix_data="23_"
prefix_panel="01_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# -------------------------------------------------------------
# Analysis block 1 - main 
# (change parameters above and copy-paste block below)


### PCA scores 
if ${pcascores}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel}' path_panel='${PANELS}/${file_panel}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
tail $ROUT/01_pcascores.Rout
fi

### Select observables for clustering
if ${select_observables}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
tail $ROUT/02_select_observables.Rout
fi

### FlowSOM clustering
if ${flowsom}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
tail $ROUT/02_flowsom.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Run tSNE
if ${runtsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
tail $ROUT/03_runtsne.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------


##########################################
# Analysis of CK_2016-06-23_01 mergingNEW
# Use Analysis block 2
##########################################

file_merging="cluster_mergingNEW.xlsx"
prefix_merging="mergingNEW_"

# -------------------------------------------------------------
# Analysis block 2 - cluster merging
# (change parameters above and copy-paste block below)


### Cluster merging
if ${cluster_merging}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_cluster_merging='${file_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
tail $ROUT/02_cluster_merging.Rout
fi


### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------

##########################################
# Analysis of CK_2016-06-23_01 mergingNEW2
# Use Analysis block 2
##########################################

file_merging="cluster_mergingNEW2.xlsx"
prefix_merging="mergingNEW2_"

# -------------------------------------------------------------
# Analysis block 2 - cluster merging
# (change parameters above and copy-paste block below)


### Cluster merging
if ${cluster_merging}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_cluster_merging='${file_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
tail $ROUT/02_cluster_merging.Rout
fi


### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------

##########################################
# CK_2016-06-23_01 - CD4 and CD8 cluster extracting from mergingNEW2
# Use Analysis block 3
##########################################

DATA=23
PANEL=1
RWD=$RWD_MAIN/CK_2016-06-23_01
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_metadata="metadata_23_01.xlsx"

prefix_data="23_"
prefix_panel="01_"
prefix_pca="pca1_"

prefix_merging="mergingNEW2_"

extract_cluster=('CD4' 'CD8')
extract_dir=('CK_2016-06-23_01_CD4_mergingNEW2' 'CK_2016-06-23_01_CD8_mergingNEW2')


# -------------------------------------------------------------
# Analysis block 3 - cluster extracting
# (change parameters above and copy-paste block below)

### Cluster extracting
if ${cluster_extracting}; then
for i in 0 1
do
  
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' extract_cluster='${extract_cluster[$i]}' extract_dir='${RWD_MAIN}/${extract_dir[$i]}/010_cleanfcs'" $RCODE/02_cluster_extracting.R $ROUT/02_cluster_extracting.Rout
  tail $ROUT/02_cluster_extracting.Rout

done
fi

# -------------------------------------------------------------



##########################################
# Analysis of CK_2016-06-23_01_CD4_mergingNEW2 using panel1CD4.xlsx
# and CK_2016-06-23_01_CD8_mergingNEW2 using panel1CD8.xlsx
# Use Analysis block 4
##########################################

DATA=23
PANEL=1

file_metadata="metadata_23_01.xlsx"

rand_seed_consensus=1234
nmetaclusts=20

prefix_data="23_"
prefix_pca="pca1_"
prefix_clust="cl20_"

data_dir=('CK_2016-06-23_01_CD4_mergingNEW2' 'CK_2016-06-23_01_CD8_mergingNEW2')
file_panel=('panel1CD4.xlsx' 'panel1CD8.xlsx')
prefix_panel=('01CD4_' '01CD8_')
pca_score_cutoff=(2 2)


# -------------------------------------------------------------
# Analysis block 4 - main for CD4 and CD8
# (change parameters above and copy-paste block below)

### PCA scores
if ${pcascores}; then
for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"

  ### PCA scores
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel[$i]}' path_panel='${PANELS}/${file_panel[$i]}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
  tail $ROUT/01_pcascores.Rout

done
fi


for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  ### Select observables for clustering
  if ${select_observables}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff[$i]} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
  tail $ROUT/02_select_observables.Rout
  fi

  ### FlowSOM clustering
  if ${flowsom}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
  tail $ROUT/02_flowsom.Rout
  fi

  ### Heatmaps
  if ${heatmaps}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel[$i]}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout
  fi

  ### Run tSNE
  if ${runtsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
  tail $ROUT/03_runtsne.Rout
  fi

  ### Plot tSNE
  if ${plottsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
  tail $ROUT/03_plottsne.Rout
  fi

  ### Get cluster frequencies
  if ${frequencies}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
  tail $ROUT/04_frequencies.Rout
  fi

  
done


# -------------------------------------------------------------


##########################################
# Analysis of CK_2016-06-23_01_CD4_mergingNEW2 using panel1CD4.xlsx of merging_CD4_2
# and CK_2016-06-23_01_CD8_mergingNEW2 using panel1CD8.xlsx of merging_CD8_2
# Use Analysis block 5
##########################################

file_merging=('cluster_merging_CD4_2.xlsx' 'cluster_merging_CD8_2.xlsx')
prefix_merging=('merging_CD4_2' 'merging_CD8_2')


# -------------------------------------------------------------
# Analysis block 5 - cluster merging for CD4 and CD8
# (change parameters above and copy-paste block below)

for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  ### Cluster merging
  if ${cluster_merging}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_cluster_merging='${file_merging[$i]}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
  tail $ROUT/02_cluster_merging.Rout
  fi

  ### Heatmaps
  if ${heatmaps}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_panel='${PANELS}/${file_panel[$i]}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout
  fi

  ### Plot tSNE
  if ${plottsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_rtsne_out='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
  tail $ROUT/03_plottsne.Rout
  fi

  ### Get cluster frequencies
  if ${frequencies}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
  tail $ROUT/04_frequencies.Rout
  fi

done


# -------------------------------------------------------------


##############################################################################
# Analysis of CK_2016-06-23_02 data
# Use Analysis block 1
##############################################################################

DATA=23
PANEL=2
RWD=$RWD_MAIN/CK_2016-06-23_02
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_panel="panel2.xlsx"
file_metadata="metadata_23_02.xlsx"

pca_score_cutoff=1
rand_seed_consensus=1234
nmetaclusts=20

prefix_data="23_"
prefix_panel="02_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# -------------------------------------------------------------
# Analysis block 1 - main 
# (change parameters above and copy-paste block below)


### PCA scores 
if ${pcascores}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel}' path_panel='${PANELS}/${file_panel}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
tail $ROUT/01_pcascores.Rout
fi

### Select observables for clustering
if ${select_observables}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
tail $ROUT/02_select_observables.Rout
fi

### FlowSOM clustering
if ${flowsom}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
tail $ROUT/02_flowsom.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Run tSNE
if ${runtsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
tail $ROUT/03_runtsne.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------

##########################################
# Analysis of CK_2016-06-23_02 merging2
# Use Analysis block 2
##########################################

file_merging="cluster_merging2.xlsx"
prefix_merging="merging2_"

# -------------------------------------------------------------
# Analysis block 2 - cluster merging
# (change parameters above and copy-paste block below)

### Cluster merging
if ${cluster_merging}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_cluster_merging='${file_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
tail $ROUT/02_cluster_merging.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------


##########################################
# CK_2016-06-23_02 - CD4 and CD8 cluster extracting from merging2
# Use Analysis block 3
##########################################

DATA=23
PANEL=2
RWD=$RWD_MAIN/CK_2016-06-23_02
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_metadata="metadata_23_02.xlsx"

prefix_data="23_"
prefix_panel="02_"
prefix_pca="pca1_"

prefix_merging="merging2_"

extract_cluster=('CD4' 'CD8')
extract_dir=('CK_2016-06-23_02_CD4_merging2' 'CK_2016-06-23_02_CD8_merging2')


# -------------------------------------------------------------
# Analysis block 3 - cluster extracting
# (change parameters above and copy-paste block below)

### Cluster extracting
if ${cluster_extracting}; then
for i in 0 1
do
  
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' extract_cluster='${extract_cluster[$i]}' extract_dir='${RWD_MAIN}/${extract_dir[$i]}/010_cleanfcs'" $RCODE/02_cluster_extracting.R $ROUT/02_cluster_extracting.Rout
  tail $ROUT/02_cluster_extracting.Rout

done
fi

# -------------------------------------------------------------


##########################################
# Analysis of CK_2016-06-23_02_CD4_merging2 using panel2CD4.xlsx
# and CK_2016-06-23_02_CD8_merging2 using panel2CD8.xlsx
# Use Analysis block 4
##########################################

DATA=23
PANEL=2

file_metadata="metadata_23_02.xlsx"

rand_seed_consensus=1234
nmetaclusts=20

prefix_data="23_"
prefix_pca="pca1_"
prefix_clust="cl20_"

data_dir=('CK_2016-06-23_02_CD4_merging2' 'CK_2016-06-23_02_CD8_merging2')
file_panel=('panel2CD4.xlsx' 'panel2CD8.xlsx')
prefix_panel=('02CD4_' '02CD8_')
pca_score_cutoff=(0.96 1)


# -------------------------------------------------------------
# Analysis block 4 - main for CD4 and CD8
# (change parameters above and copy-paste block below)

### PCA scores
if ${pcascores}; then
for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"

  ### PCA scores
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel[$i]}' path_panel='${PANELS}/${file_panel[$i]}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
  tail $ROUT/01_pcascores.Rout

done
fi


for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  ### Select observables for clustering
  if ${select_observables}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff[$i]} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
  tail $ROUT/02_select_observables.Rout
  fi

  ### FlowSOM clustering
  if ${flowsom}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
  tail $ROUT/02_flowsom.Rout
  fi

  ### Heatmaps
  if ${heatmaps}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel[$i]}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout
  fi

  ### Run tSNE
  if ${runtsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
  tail $ROUT/03_runtsne.Rout
  fi

  ### Plot tSNE
  if ${plottsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
  tail $ROUT/03_plottsne.Rout
  fi

  ### Get cluster frequencies
  if ${frequencies}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
  tail $ROUT/04_frequencies.Rout
  fi

done

# -------------------------------------------------------------

##########################################
# Analysis of CK_2016-06-23_02_CD4_merging2 using panel2CD4.xlsx for cluster_merging_CD4.xlsx
# and CK_2016-06-23_02_CD8_merging2 using panel2CD8.xlsx for cluster_merging_CD8_2.xlsx
# Use Analysis block 5
##########################################

file_merging=('cluster_merging_CD4.xlsx' 'cluster_merging_CD8_2.xlsx')
prefix_merging=('merging_CD4' 'merging_CD8_2')

# -------------------------------------------------------------
# Analysis block 5 - cluster merging for CD4 and CD8
# (change parameters above and copy-paste block below)

for i in 0 1
do
  
  RWD=$RWD_MAIN/${data_dir[$i]}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  ### Cluster merging
  if ${cluster_merging}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_cluster_merging='${file_merging[$i]}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
  tail $ROUT/02_cluster_merging.Rout
  fi

  ### Heatmaps
  if ${heatmaps}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_panel='${PANELS}/${file_panel[$i]}' path_clustering_observables='${prefix_data}${prefix_panel[$i]}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel[$i]}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout
  fi

  ### Plot tSNE
  if ${plottsne}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_rtsne_out='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel[$i]}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
  tail $ROUT/03_plottsne.Rout
  fi

  ### Get cluster frequencies
  if ${frequencies}; then
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}' path_clustering='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel[$i]}${prefix_pca}${prefix_merging[$i]}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
  tail $ROUT/04_frequencies.Rout
  fi

done


# -------------------------------------------------------------


clusters2analyse="c('CM','EM','TE')"
cluster_name="Tmem"

### Analysis of positive-negative (cytokine) markers
nmetaclusts=40

## Based on cluster_merging_CD4.xlsx
if ${cytokines}; then
for indx in 0
do

  RWD=$RWD_MAIN/${data}_${extr_dir[$indx]}_${merging}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  pca_prefix="pnl${extr_dir[$indx]}_pca1_" # 'pnlCD4_pca1_'
  merging_prefix="merging_${extr_dir[$indx]}" # 'merging_CD4'

  ## based on cytokines_CM_RAW.xlsx
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' cytokines_prefix='${pca_prefix}${merging_prefix}_cyt${cluster_name}_' path_panel='${PANELS}/panel_${extr_dir[$indx]}.xlsx' path_cytokines_cutoffs='${PANELS}/panel_${extr_dir[$indx]}_cytokines_CM_RAW.xlsx' path_clustering='${pca_prefix}${merging_prefix}_clustering.xls' path_clustering_labels='${pca_prefix}${merging_prefix}_clustering_labels.xls' clusters2analyse=${clusters2analyse} cutoff_colname='positive_cutoff_raw' data2analyse='raw' cytokines_suffix='_${nmetaclusts}cl_raw' nmetaclusts=${nmetaclusts}" $RCODE/06_cytokines.R $ROUT/06_cytokines.Rout
 tail $ROUT/06_cytokines.Rout
  

done
fi


nmetaclusts=20

## Based on cluster_merging_CD8_2.xlsx
if ${cytokines}; then
for indx in 1
do

  RWD=$RWD_MAIN/${data}_${extr_dir[$indx]}_${merging}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  pca_prefix="pnl${extr_dir[$indx]}_pca1_" # 'pnlCD8_pca1_'
  merging_prefix="merging_${extr_dir[$indx]}_2" # 'merging_CD8_2'
  
  ## based on cytokines_CM_RAW.xlsx
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' cytokines_prefix='${pca_prefix}${merging_prefix}_cyt${cluster_name}_' path_panel='${PANELS}/panel_${extr_dir[$indx]}.xlsx' path_cytokines_cutoffs='${PANELS}/panel_${extr_dir[$indx]}_cytokines_CM_RAW.xlsx' path_clustering='${pca_prefix}${merging_prefix}_clustering.xls' path_clustering_labels='${pca_prefix}${merging_prefix}_clustering_labels.xls' clusters2analyse=${clusters2analyse} cutoff_colname='positive_cutoff_raw' data2analyse='raw' cytokines_suffix='_${nmetaclusts}cl_raw' nmetaclusts=${nmetaclusts}" $RCODE/06_cytokines.R $ROUT/06_cytokines.Rout
 tail $ROUT/06_cytokines.Rout
  

done
fi



### Analysis of PD-1
nmetaclusts=20

## Based on cluster_merging_CD4.xlsx
if ${pd1}; then
for indx in 0
do

  RWD=$RWD_MAIN/${data}_${extr_dir[$indx]}_${merging}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  pca_prefix="pnl${extr_dir[$indx]}_pca1_" # 'pnlCD4_pca1_'
  merging_prefix="merging_${extr_dir[$indx]}" # 'merging_CD4'

  ## based on cytokines_CM_RAW.xlsx
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' pd1_prefix='${pca_prefix}${merging_prefix}_pd1${cluster_name}_' path_panel='${PANELS}/panel_${extr_dir[$indx]}.xlsx' path_cytokines_cutoffs='${PANELS}/panel_${extr_dir[$indx]}_cytokines_CM_RAW.xlsx' path_clustering='${pca_prefix}${merging_prefix}_clustering.xls' path_clustering_labels='${pca_prefix}${merging_prefix}_clustering_labels.xls' clusters2analyse=${clusters2analyse} cutoff_colname='positive_cutoff_raw' data2analyse='raw' cytokines_suffix='_${nmetaclusts}cl_raw' nmetaclusts=${nmetaclusts}" $RCODE/07_pd1.R $ROUT/07_pd1.Rout
 tail $ROUT/07_pd1.Rout
  

done
fi


## Based on cluster_merging_CD8_2.xlsx
if ${pd1}; then
for indx in 1
do

  RWD=$RWD_MAIN/${data}_${extr_dir[$indx]}_${merging}
  ROUT=$RWD/Rout
  mkdir -p $ROUT
  echo "$RWD"
  
  pca_prefix="pnl${extr_dir[$indx]}_pca1_" # 'pnlCD8_pca1_'
  merging_prefix="merging_${extr_dir[$indx]}_2" # 'merging_CD8_2'
  
  ## based on cytokines_CM_RAW.xlsx
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' pd1_prefix='${pca_prefix}${merging_prefix}_pd1${cluster_name}_' path_panel='${PANELS}/panel_${extr_dir[$indx]}.xlsx' path_cytokines_cutoffs='${PANELS}/panel_${extr_dir[$indx]}_cytokines_CM_RAW.xlsx' path_clustering='${pca_prefix}${merging_prefix}_clustering.xls' path_clustering_labels='${pca_prefix}${merging_prefix}_clustering_labels.xls' clusters2analyse=${clusters2analyse} cutoff_colname='positive_cutoff_raw' data2analyse='raw' cytokines_suffix='_${nmetaclusts}cl_raw' nmetaclusts=${nmetaclusts}" $RCODE/07_pd1.R $ROUT/07_pd1.Rout
 tail $ROUT/07_pd1.Rout
  

done
fi


##############################################################################
# Analysis of CK_2016-06-23_03 data
# Use Analysis block 1
##############################################################################

DATA=23
PANEL=3
RWD=$RWD_MAIN/CK_2016-06-23_03
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_panel="panel3.xlsx"
file_metadata="metadata_23_03.xlsx"

pca_score_cutoff=0.9
rand_seed_consensus=1234
nmetaclusts=20

prefix_data="23_"
prefix_panel="03_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# -------------------------------------------------------------
# Analysis block 1 - main 
# (change parameters above and copy-paste block below)


### PCA scores 
if ${pcascores}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel}' path_panel='${PANELS}/${file_panel}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
tail $ROUT/01_pcascores.Rout
fi

### Select observables for clustering
if ${select_observables}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
tail $ROUT/02_select_observables.Rout
fi

### FlowSOM clustering
if ${flowsom}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
tail $ROUT/02_flowsom.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Run tSNE
if ${runtsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
tail $ROUT/03_runtsne.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------


##########################################
# Analysis of CK_2016-06-23_03 merging2
# Use Analysis block 2
##########################################

file_merging="cluster_merging2.xlsx"
prefix_merging="merging2_"

# -------------------------------------------------------------
# Analysis block 2 - cluster merging
# (change parameters above and copy-paste block below)

### Cluster merging
if ${cluster_merging}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_cluster_merging='${file_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
tail $ROUT/02_cluster_merging.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------


##########################################
# Analysis of CK_2016-06-23_03 merging3
# USe Analysis block 2
##########################################

file_merging="cluster_merging3.xlsx"
prefix_merging="merging3_"

# -------------------------------------------------------------
# Analysis block 2 - cluster merging
# (change parameters above and copy-paste block below)

### Cluster merging
if ${cluster_merging}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' merging_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_cluster_merging='${file_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'" $RCODE/02_cluster_merging.R $ROUT/02_cluster_merging.Rout
tail $ROUT/02_cluster_merging.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_merging}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi

# -------------------------------------------------------------


##############################################################################
# Analysis of CK_2016-06-23_03all data using panel3_v2.xlsx
# Use Analysis block 1 
##############################################################################

DATA=23
PANEL=3
RWD=$RWD_MAIN/CK_2016-06-23_03all
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_panel="panel3_v2.xlsx"
file_metadata="metadata_23_03all.xlsx"

pca_score_cutoff=1
nmetaclusts=20
rand_seed_consensus=1234

prefix_data="${DATA}_"
prefix_panel="03v2_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# -------------------------------------------------------------
# Analysis block 1 
# (change parameters above and copy-paste block below)
# -------------------------------------------------------------

### PCA scores 
if ${pcascores}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel}' path_panel='${PANELS}/${file_panel}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
tail $ROUT/01_pcascores.Rout
fi

### Select observables for clustering
if ${select_observables}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
tail $ROUT/02_select_observables.Rout
fi

### FlowSOM clustering
if ${flowsom}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
tail $ROUT/02_flowsom.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Run tSNE
if ${runtsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
tail $ROUT/03_runtsne.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi


# -------------------------------------------------------------


##############################################################################
# Analysis of CK_2016-06-23_03all data using panel3_v3.xlsx
# Use Analysis block 1 
##############################################################################

DATA=23
PANEL=3
RWD=$RWD_MAIN/CK_2016-06-23_03all
ROUT=$RWD/Rout
mkdir -p $ROUT
echo "$RWD"

file_panel="panel3_v3.xlsx"
file_metadata="metadata_23_03all.xlsx"

pca_score_cutoff=1
nmetaclusts=20
rand_seed_consensus=1234

prefix_data="${DATA}_"
prefix_panel="03v3_"
prefix_pca="pca1_"
prefix_clust="cl20_"

# -------------------------------------------------------------
# Analysis block 1 
# (change parameters above and copy-paste block below)


### PCA scores 
if ${pcascores}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' pcas_prefix='${prefix_data}${prefix_panel}' path_panel='${PANELS}/${file_panel}'" $RCODE/01_pcascores.R $ROUT/01_pcascores.Rout
tail $ROUT/01_pcascores.Rout
fi

### Select observables for clustering
if ${select_observables}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' observ_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' pca_score_cutoff=${pca_score_cutoff} pca_skip_top=0" $RCODE/02_select_observables.R $ROUT/02_select_observables.Rout
tail $ROUT/02_select_observables.Rout
fi

### FlowSOM clustering
if ${flowsom}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' flowsom_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' nmetaclusts=${nmetaclusts} rand_seed_consensus=${rand_seed_consensus}" $RCODE/02_flowsom.R $ROUT/02_flowsom.Rout
tail $ROUT/02_flowsom.Rout
fi

### Heatmaps
if ${heatmaps}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' heatmap_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_panel='${PANELS}/${file_panel}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls'  path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls' path_pca_score='${prefix_data}${prefix_panel}princompscore_by_sample.xls' " $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
tail $ROUT/02_heatmaps.Rout
fi

### Run tSNE
if ${runtsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsne_prefix='${prefix_data}${prefix_panel}${prefix_pca}' path_clustering_observables='${prefix_data}${prefix_panel}${prefix_pca}clustering_observables.xls' tsne_pmin=1500" $RCODE/03_runtsne.R $ROUT/03_runtsne.Rout
tail $ROUT/03_runtsne.Rout
fi

### Plot tSNE
if ${plottsne}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' tsnep_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_rtsne_out='${prefix_data}${prefix_panel}${prefix_pca}rtsne_out.rda' path_rtsne_data='${prefix_data}${prefix_panel}${prefix_pca}rtsne_data.xls' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'  tsne_cmin=1000 pdf_width=15 pdf_height=10" $RCODE/03_plottsne.R $ROUT/03_plottsne.Rout
tail $ROUT/03_plottsne.Rout
fi

### Get cluster frequencies
if ${frequencies}; then
R CMD BATCH --no-save --no-restore "--args rwd='$RWD' path_metadata='${METADATA}/${file_metadata}' freq_prefix='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}' path_clustering='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering.xls' path_clustering_labels='${prefix_data}${prefix_panel}${prefix_pca}${prefix_clust}clustering_labels.xls'" $RCODE/04_frequencies.R $ROUT/04_frequencies.Rout
tail $ROUT/04_frequencies.Rout
fi


# -------------------------------------------------------------




















