'''
Python 2.7
The clustergrammer python module can be installed using pip:
pip install clustergrammer

or by getting the code from the repo:
https://github.com/MaayanLab/clustergrammer-py
'''
import sys
from clustergrammer import Network
net = Network()
filename = sys.argv[1]
outname = sys.argv[2]
wd = sys.argv[3]
# load matrix tsv file
net.load_file(filename)
#net.load_file('/home/www/html/iris3/data/20181124190953/2018111413246_heatmap_matrix.txt')
# net.load_file('txt/ccle_example.txt')
# net.load_file('txt/rc_val_cats.txt')
# net.load_file('txt/number_labels.txt')
# net.load_file('txt/mnist.txt')
# net.load_file('txt/tuple_cats.txt')
# net.load_file('txt/example_tsv.txt')

# net.enrichrgram('KEA_2015')

# optional filtering and normalization
##########################################
# net.filter_sum('row', threshold=20)
# net.normalize(axis='col', norm_type='zscore', keep_orig=True)
# net.filter_N_top('row', 250, rank_type='sum')
# net.filter_threshold('row', threshold=3.0, num_occur=4)
# net.swap_nan_for_zero()
# net.set_cat_color('col', 1, 'Cell Type: 1', 'blue')

  # net.make_clust()
  # net.dendro_cats('row', 5)

#net.cluster(dist_type='cos',views=['N_row_sum', 'N_row_var'] , dendro=True,
#               sim_mat=True, filter_sim=0.1, calc_cat_pval=False, enrichrgram=
#               False, run_clustering=True)
#net.set_cat_color('col', 1, 'Cell Type: 1', '#9370DB')
#net.set_cat_color('col', 1, 'Cell Type: 2', 'blue')
#net.set_cat_color('col', 1, 'Cell Type: 3', 'orange')
#net.set_cat_color('col', 1, 'Cell Type: 4', 'aqua')
#net.set_cat_color('col', 1, 'Cell Type: 5', 'lime')
#net.set_cat_color('col', 1, 'Cell Type: 6', 'purple')
#net.set_cat_color('col', 1, 'Cell Type: 7', 'red')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: One', inst_color='red')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Two', inst_color='blue')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Three', inst_color='orange')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Four', inst_color='aqua')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Five', inst_color='purple')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Six', inst_color='lime')
#net.set_cat_color(axis='col', cat_index=1, cat_name='CellType: Seven', inst_color='yellow')

net.cluster(dist_type='cos', enrichrgram=
               True, run_clustering=False)
# write jsons for front-end visualizations
out = wd + 'json/' + outname + '.json'
net.write_json_to_file('viz', out, 'indent')
#net.write_json_to_file('sim_row', 'json/mult_view_sim_row.json', 'no-indent')
#net.write_json_to_file('sim_col', 'json/mult_view_sim_col.json', 'no-indent')
