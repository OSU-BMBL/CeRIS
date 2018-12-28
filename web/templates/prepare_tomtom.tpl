{{extends file="base.tpl"}}
{{block name="extra_js"}}

{{/block}}
{{block name="extra_style"}}

{{/block}}
{{block name="main"}}



<script>
$(document).ready(function () {
/*
      $('#motiftable').DataTable({
    	"order": [[ 2, "asc" ]]
      });
      $('.dataTables_length').addClass('bs-select');*/
	  var flag = [];
	  make_clust_main('data/{{$jobid}}/json/{{$filename}}','#container-id-1');
	  
});
</script>



  <div >
      <h1 class='wait_message'>Running TOMTOM, please wait ...</h1>
  </div>



{{/block}}