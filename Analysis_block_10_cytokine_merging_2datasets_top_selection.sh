#!/bin/bash

# -----------------------------------------------------
# argument parcing
# -----------------------------------------------------

while [[ ${1} ]]; do
  case "${1}" in
    --RCODE)
    RCODE=${2}
    shift
    ;;
    --RWD_MAIN)
    RWD_MAIN=${2}
    shift
    ;;
    --METADATA)
    METADATA=${2}
    shift
    ;;
    --new_data_dir)
    new_data_dir=${2}
    shift
    ;;
    --cytokines_merging_v3)
    cytokines_merging_v3=${2}
    shift
    ;;
    --data_name1)
    data_name1=${2}
    shift
    ;;
    --data_name2)
    data_name2=${2}
    shift
    ;;
    --data_dir1)
    data_dir1=${2}
    shift
    ;;
    --data_dir2)
    data_dir2=${2}
    shift
    ;;
    --file_metadata1)
    file_metadata1=${2}
    shift
    ;;
    --file_metadata2)
    file_metadata2=${2}
    shift
    ;;
    --prefix_data1)
    prefix_data1=${2}
    shift
    ;;
    --prefix_data2)
    prefix_data2=${2}
    shift
    ;;
    --prefix_panel)
    prefix_panel=${2}
    shift
    ;;
    --prefix_pca)
    prefix_pca=${2}
    shift
    ;;
    --prefix_merging1)
    prefix_merging1=${2}
    shift
    ;;
    --prefix_merging2)
    prefix_merging2=${2}
    shift
    ;;
    --prefix_data_merging)
    prefix_data_merging=${2}
    shift
    ;;
    --prefix_clsubset)
    prefix_clsubset=${2}
    shift
    ;;
    --prefix_cytokines_cutoffs)
    prefix_cytokines_cutoffs=${2}
    shift
    ;;
    --prefix_clust)
    prefix_clust=${2}
    shift
    ;;
    --top_combinations)
    top_combinations=${2}
    shift
    ;;


    *)
    echo "Unknown parameter: ${1}" >&2
  esac

  if ! shift; then
    echo 'Missing parameter argument.' >&2
  fi
done

# -----------------------------------------------------
# function
# -----------------------------------------------------

RWD=$RWD_MAIN/${new_data_dir}
ROUT=$RWD/Rout
mkdir -p $ROUT

if ${cytokines_merging_v3}
then
  echo "$RWD"
fi

if ${cytokines_merging_v3}; then

  outdir="10_cytokines_merged_top_combinations/"

  ### Assign cluster to the top frequent combinations of cytokines, the rest is droped

  echo ">>> 06_cytokines_bimatrix_top_selection_merged"

  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' clust_prefix='${prefix_data_merging}${prefix_clust}' clust_outdir='${outdir}01_clustering' path_data=c('${RWD_MAIN}/${data_dir1}/060_cytokines_bimatrix/01_clustering/${prefix_data1}${prefix_panel}${prefix_pca}${prefix_merging1}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_bimatrix.txt','${RWD_MAIN}/${data_dir2}/060_cytokines_bimatrix/01_clustering/${prefix_data2}${prefix_panel}${prefix_pca}${prefix_merging2}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_bimatrix.txt') path_clustering_observables=c('${RWD_MAIN}/${data_dir1}/060_cytokines_bimatrix/01_clustering/${prefix_data1}${prefix_panel}${prefix_pca}${prefix_merging1}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_clustering_observables.xls','${RWD_MAIN}/${data_dir2}/060_cytokines_bimatrix/01_clustering/${prefix_data2}${prefix_panel}${prefix_pca}${prefix_merging2}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_clustering_observables.xls') data_name=c('${data_name1}','${data_name2}') top_combinations=${top_combinations}" $RCODE/06_cytokines_bimatrix_top_selection_merged.R $ROUT/06_cytokines_bimatrix_top_selection_merged.Rout
  tail $ROUT/06_cytokines_bimatrix_top_selection_merged.Rout


  ### Heatmap for data23

  echo ">>> 02_heatmaps"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' heatmap_prefix='${prefix_data_merging}${prefix_clust}${data_name1}_' heatmap_outdir='${outdir}01_clustering' path_data='${RWD_MAIN}/${data_dir1}/060_cytokines_bimatrix/01_clustering/${prefix_data1}${prefix_panel}${prefix_pca}${prefix_merging1}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_bimatrix.txt' path_metadata='${METADATA}/${file_metadata1}'   path_clustering_observables='${RWD_MAIN}/${data_dir1}/060_cytokines_bimatrix/01_clustering/${prefix_data1}${prefix_panel}${prefix_pca}${prefix_merging1}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_clustering_observables.xls' path_clustering='$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_clustering.xls'  path_clustering_labels='$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_clustering_labels.xls' path_marker_selection='$RWD/10_cytokines_merged/${prefix_data_merging}${prefix_clust}${data_name1}_marker_selection.txt' aggregate_fun='mean' pheatmap_palette='RdYlBu' pheatmap_palette_rev=TRUE pheatmap_scale=FALSE linkage='average'" $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout

  ### Heatmap for data29

  echo ">>> 02_heatmaps"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' heatmap_prefix='${prefix_data_merging}${prefix_clust}${data_name2}_' heatmap_outdir='${outdir}01_clustering' path_data='${RWD_MAIN}/${data_dir2}/060_cytokines_bimatrix/01_clustering/${prefix_data2}${prefix_panel}${prefix_pca}${prefix_merging2}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_bimatrix.txt' path_metadata='${METADATA}/${file_metadata2}'   path_clustering_observables='${RWD_MAIN}/${data_dir2}/060_cytokines_bimatrix/01_clustering/${prefix_data2}${prefix_panel}${prefix_pca}${prefix_merging2}${prefix_clsubset}${prefix_cytokines_cutoffs}raw2_clustering_observables.xls' path_clustering='$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_clustering.xls'  path_clustering_labels='$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_clustering_labels.xls' path_marker_selection='$RWD/${outdir}${prefix_data_merging}${prefix_clust}${data_name2}_marker_selection.txt' aggregate_fun='mean' pheatmap_palette='RdYlBu' pheatmap_palette_rev=TRUE pheatmap_scale=FALSE linkage='average'" $RCODE/02_heatmaps.R $ROUT/02_heatmaps.Rout
  tail $ROUT/02_heatmaps.Rout


  ### Analysis of cluster frequencies - 3 responses

  echo ">>> 08_frequencies_merged"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' freq_prefix='${prefix_data_merging}${prefix_clust}' freq_outdir='${outdir}03_frequencies_auto' path_metadata=c('${METADATA}/${file_metadata1}','${METADATA}/${file_metadata2}')  path_counts=c('$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_counts.xls','$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_counts.xls') data_name=c('${data_name1}','${data_name2}') path_fun_models='$RCODE/00_models.R' path_fun_formulas='$RCODE/00_formulas_2datasets_3responses.R' pdf_hight=8" $RCODE/08_frequencies_merged.R $ROUT/08_frequencies_merged.Rout
  tail $ROUT/08_frequencies_merged.Rout

  ### Analysis of cluster frequencies - 2 responses

  echo ">>> 08_frequencies_merged"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' freq_prefix='${prefix_data_merging}${prefix_clust}' freq_outdir='${outdir}03_frequencies_auto_2responses' path_metadata=c('${METADATA}/${file_metadata1}','${METADATA}/${file_metadata2}')  path_counts=c('$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_counts.xls','$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_counts.xls') data_name=c('${data_name1}','${data_name2}') path_fun_models='$RCODE/00_models.R' path_fun_formulas='$RCODE/00_formulas_2datasets_2responses.R' pdf_hight=8" $RCODE/08_frequencies_merged.R $ROUT/08_frequencies_merged.Rout
  tail $ROUT/08_frequencies_merged.Rout


  ### min_freq=0.01

  ### Analysis of cluster frequencies - remove clusters with very low number of cells and re-adjust the p-values - 3 responses

  echo ">>> 08_frequencies_merged_low_freq_out"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' freq_prefix='${prefix_data_merging}${prefix_clust}out001_' freq_outdir='${outdir}03_frequencies_auto' path_metadata=c('${METADATA}/${file_metadata1}','${METADATA}/${file_metadata2}')  path_counts=c('$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_counts.xls','$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_counts.xls') data_name=c('${data_name1}','${data_name2}') path_pvs='${outdir}03_frequencies_auto/${prefix_data_merging}${prefix_clust}frequencies_pvs_glmer_binomial_interglht.xls' model2fit='glmer_binomial_interglht' min_freq=0.01 pdf_hight=8" $RCODE/08_frequencies_merged_low_freq_out.R $ROUT/08_frequencies_merged_low_freq_out.Rout
  tail $ROUT/08_frequencies_merged_low_freq_out.Rout


  ### Analysis of cluster frequencies - remove clusters with very low number of cells and re-adjust the p-values - 2 responses

  echo ">>> 08_frequencies_merged_low_freq_out"
  R CMD BATCH --no-save --no-restore "--args rwd='$RWD' freq_prefix='${prefix_data_merging}${prefix_clust}out001_' freq_outdir='${outdir}03_frequencies_auto_2responses' path_metadata=c('${METADATA}/${file_metadata1}','${METADATA}/${file_metadata2}')  path_counts=c('$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name1}_counts.xls','$RWD/${outdir}01_clustering/${prefix_data_merging}${prefix_clust}${data_name2}_counts.xls') data_name=c('${data_name1}','${data_name2}') path_pvs='${outdir}03_frequencies_auto_2responses/${prefix_data_merging}${prefix_clust}frequencies_pvs_glmer_binomial_interglht.xls' model2fit='glmer_binomial_interglht' min_freq=0.01 pdf_hight=8" $RCODE/08_frequencies_merged_low_freq_out.R $ROUT/08_frequencies_merged_low_freq_out.Rout
  tail $ROUT/08_frequencies_merged_low_freq_out.Rout


fi














#