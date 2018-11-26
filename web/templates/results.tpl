{{extends file="base.tpl"}}

{{block name="extra_js"}}
<script type="text/javascript">
  var $J = jQuery.noConflict()
  $J(document).ready(function() {
    $J("table.data").dataTable({
      "bStateSave" : true, "bJQueryUI": true, "sPaginationType": "full_numbers", "iDisplayLength": 15,
      "aLengthMenu": [[15, 30, 50, -1], [15, 30, 50, "All"]]
    });
  });
</script>
{{/block}}

{{block name="extra_style"}}
.dataTables_wrapper { min-height: 0; }
div#content { min-height: 400px; }
{{/block}}

{{block name="main"}}


	

<table border="0" width="100%" bordercolor="000000">
<form action="{{$URL}}" method="POST" enctype="multipart/form-data" class="corner shadow" style="padding: 5px 30px; margin: 5px 0px;">
  <tr>
<br>
    <td align="middle">
<br>
<div class = "frame" align="left" style="width:640px;height:150px;font-size:20px">
	
        {{if {{$download_flag}} == "1"}}
		<a href={{$download_url1}}> GoolamM111c100k3o200f_log.txt</a><br>
	<a href={{$download_url2}}> Goolam111_S_k.csv</a><br>
	<p>{{$theData}}</p>
  {{else}}
  {{block name="meta"}}
  <strong>You have successfully submitted a job. The page will be automatically refreshed every 10 seconds</strong> 
  
  <p>{{$theData}}</p>
  {{/block}}
  {{/if}}
	</div>

    </td>
  </tr>
</form>
</table>
{{/block}}