function show_peak_table(item){
		match_id = $(item).attr("id").match(/\d+/gm)
		regulon_id = $(item).attr("id").substring(8);
		table_id = "table-"+regulon_id
		species = document.getElementById("species").innerHTML
		match_species =  species.match(/[^Species: ].+/gm)[0]
		jobid = location.search.match(/\d+/gm)
		table_content_id = "table-content-"+regulon_id
		table_jquery_id="#"+table_content_id
		if ( ! $.fn.DataTable.isDataTable(table_jquery_id) ) {
		$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_peak'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_peak'
				}
				],
				"ajax": "prepare_peak.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"order": [[ 3, "desc" ]],
				columnDefs: [
				{
					targets: 0,
					render: function (data, type, row, meta)
					{
						if (type === 'display')
						{
							data = '<a  href="http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=' +row[6]+ '" target="_blank">'+data +'</a>';
						}
						return data;
					}
				},{
                "targets": [6],
                "visible": false
				},{
                "targets": [7],
                render: function (data, type, row, meta)
					{	
						var dat=new Array
						if (type === 'display')
						{
							res=data.split(" ")
							for(i=0;i < res.length;i++) {
								dat[i] = '<a  href="https://www.ensembl.org/id/' +res[i]+ '" target="_blank">'+res[i] +'</a>';
							}
						}
						return dat;
					}
				}
				],
		
		});
		}
		document.getElementById(table_id).innerHTML=""
	}
	
	
	function show_tad_table(item){
		match_id = $(item).attr("id").match(/\d+/gm)
		regulon_id = $(item).attr("id").substring(7);
		table_id = "tad-table-"+regulon_id
		species = document.getElementById("species").innerHTML
		match_species =  species.match(/[^Species: ].+/gm)[0]
		jobid = location.search.match(/\d+/gm)
		table_content_id = "tad-table-content-"+regulon_id
		table_jquery_id="#"+table_content_id
		if ( ! $.fn.DataTable.isDataTable(table_jquery_id) ){
			if(match_species=='Human'){
			$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				}
				],
				"ajax": "prepare_tad.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"aLengthMenu": [[5, 10, -1], [5, 10, "All"]],
			"iDisplayLength": 5,
		});
			} else if (match_species == 'Mouse'){
			$(table_jquery_id).DataTable( {
				dom: 'lBfrtip',
				buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_TAD_covered_genes'
				}
				],
				"ajax": "prepare_tad.php?jobid="+jobid+"&regulon_id="+regulon_id+"&species="+match_species+"&table="+table_content_id,
				"searching": false,
				"bInfo" : false,
				"aLengthMenu": [[ -1], [ "All"]],
				"iDisplayLength": -1,
		});
			}
		}
		document.getElementById(table_id).innerHTML=""
	}
	function show_similar_table(item) {
	match_id = $(item).attr("id").match(/\d+/gm)
	regulon_id = $(item).attr("id").substring(11)
	table_id = "similar-table-" + regulon_id
	species = document.getElementById("species").innerHTML
	match_species = species.match(/[^Species: ].+/gm)[0]
	jobid = location.search.match(/\d+/gm)
	table_content_id = "similar-table-content-" + regulon_id
	table_jquery_id = "#" + table_content_id
	if (!$.fn.DataTable.isDataTable(table_jquery_id)) {
	$(table_jquery_id).DataTable({
		dom: 'lBfrtip',
		buttons: [
				{
				extend:'copy',
				title: jobid+'_'+regulon_id+'_similar_regulon'
				},
				{
				extend:'csv',
				title: jobid+'_'+regulon_id+'_similar_regulon'
				}
				],
		"ajax": "prepare_similar_regulon.php?jobid=" + jobid + "&regulon_id=" + regulon_id + "&species=" + match_species + "&table=" + table_content_id,
		"searching": false,
		"paging": false,
		"bInfo" : false,
		"aLengthMenu": [
			[10, -1],
			[10, "All"]
		],
		"iDisplayLength": 10,
		
	});
	}
	document.getElementById(table_id).innerHTML = ""
	}
	
	function show_regulon_table(item) {
	match_id = $(item).attr("id").match(/\d+/gm)
	regulon_id = $(item).attr("id").substring(11)
	ct_id= regulon_id.substring(
    regulon_id.lastIndexOf("CT") + 2, 
    regulon_id.lastIndexOf("S")
	);
	table_id = "regulon-table-" + regulon_id
	species = document.getElementById("species").innerHTML
	match_species = species.match(/[^Species: ].+/gm)[0]
	jobid = location.search.match(/\d+/gm)
	table_content_id = "regulon-table-content-" + regulon_id
	table_jquery_id = "#" + table_content_id
	$.ajax({
		url: "prepare_regulon_tsne.php?jobid=" + jobid + "&id=" + regulon_id,
		type: 'POST',
		data: {'id': regulon_id},
		dataType: 'json',
		success: function(response) {
		document.getElementById(table_id).innerHTML = '<div class="col-sm-6"><p>CT'+ct_id+' t-SNE plot</p><img src="./data/'+jobid+'/regulon_id/overview_' + regulon_id + '.png" /></div><div class="col-sm-6"><p>Regulon '+ regulon_id +' t-SNE plot</p><img src="./data/'+jobid+'/regulon_id/' + regulon_id + '.png" /></div>'
		},
	})
	document.getElementById(table_id).innerHTML = ""
	}
	
	function get_gene_list(item){
	match_id = $(item).attr("id").match(/\d+/gm);
	if($(item).attr("id").includes("CT")) {
		file_path = 'data/'+ {{$jobid}} +'/'+{{$jobid}} + '_CT_'+match_id[0]+'_bic.regulon_gene_name.txt';
	} else {
		file_path = 'data/'+ {{$jobid}} +'/'+{{$jobid}} + '_module_'+match_id[0]+'_bic.regulon_gene_name.txt';
	}
	
	
	$.get(file_path,function(txt){
        var lines = txt.split("\n");
		gene_idx = match_id[1] - 1;
		lines[gene_idx].split("\t").shift().replace(/\t /g, '\n');
		//
		gene_list = lines[gene_idx].split("\t");
		gene_list.shift();
		
		var enrichr_info = {list: gene_list.join("\n"), description: 'Gene list send to '+$(item).attr("id") , popup: true};
	
		//console.log(enrichr_info);
          // defined globally - will improve
          send_to_Enrichr(enrichr_info);
    }); 
	
	}

	function send_to_Enrichr(options) { // http://amp.pharm.mssm.edu/Enrichr/#help
    var defaultOptions = {
    description: "",
    popup: false
	};

  if (typeof options.description == 'undefined')
    options.description = defaultOptions.description;
  if (typeof options.popup == 'undefined')
    options.popup = defaultOptions.popup;
  if (typeof options.list == 'undefined')
    alert('No genes defined.');

  var form = document.createElement('form');
  form.setAttribute('method', 'post');
  form.setAttribute('action', 'https://amp.pharm.mssm.edu/Enrichr/enrich');
  if (options.popup)
    form.setAttribute('target', '_blank');
  form.setAttribute('enctype', 'multipart/form-data');

  var listField = document.createElement('input');
  listField.setAttribute('type', 'hidden');
  listField.setAttribute('name', 'list');
  listField.setAttribute('value', options.list);
  form.appendChild(listField);

  var descField = document.createElement('input');
  descField.setAttribute('type', 'hidden');
  descField.setAttribute('name', 'description');
  descField.setAttribute('value', options.description);
  form.appendChild(descField);

  document.body.appendChild(form);
  form.submit();
  document.body.removeChild(form);
}