<%@ page import="com.hp.it.cdc.robin.srm.domain.User"%>
<script>
function hideModal(id){
	$('#'+id).modal('hide')
}

$(document).ready(function() {
	$("#user_lookup").addClass("span9");

	//go to page
   	$("#gotoPageId").focusout(function(e){
       	var gotoPage = $("#gotoPageId").val();
       	var gotoPageNum = new Number(gotoPage);
       	var maxPageNum = new Number("${pageCounts }");
       	if (gotoPageNum > 0 && gotoPageNum <= maxPageNum){
    		getPageRecords(gotoPage, "${pageCounts }", "cur")
           }else{
           	alert("Please input valid page number!");
           }
       })
});

var queryParams = "queryContent=${params.queryContent}";

function callQueryUsers(curNum, maxNum,params){
	$.ajax({
		url:'manageUsers',
		data: "pageId=" + curNum + "&subAction=query&" + params,
		cache: false,
		success: function(data,textStatus){
			$('#QUERY_USER_DIV').html(data);
			if (curNum == 1){
				$("#PAGE_PREV").attr('class','disabled');
			}
			if (curNum+'' == maxNum+''){
				$("#PAGE_NEXT").attr('class','disabled');
			}
			$("#PAGE_"+curNum).attr('class','active');
		}
	});
}

function getPageRecords(pageId, maxPage, type){
	var curNum = new Number(pageId);
	var maxNum = new Number(maxPage);
	if (type == 'Prev'){
		if (curNum > 1){
			curNum--;
		}else{
			return;
		}
	}else if (type == 'Next'){
		if (curNum < maxNum){
			curNum++;
		}else{
			return;
		}
	}
	var sortName = getSortName();
	callQueryUsers(curNum, maxNum, queryParams + "&sortParams=" + sortName);
}

function sortTable(sortParams, curNum, maxNum){
	$("#sortNameId").attr("value", sortParams);
	var orderParams = "desc";
	if ("${params.sortParams}"==sortParams){
		if ("${params.orderParams}"=='desc'){
			orderParams = "asc";
		}
	}
	callQueryUsers(curNum, maxNum, queryParams +"&sortParams="+sortParams+"&orderParams="+orderParams);
}

function getSortName(){
	return $("#sortNameId").val();
}

</script>
<div class="tab-content" id="QUERY_USER_DIV">
	<div class="tab-pane active" id="tab6">
		<g:if test="${flash.message}">
			<div class="alert alert-success" role="status">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				${flash.message}
			</div>
		</g:if>
		<g:if test="${flash.error}">
			<div class="alert alert-error" role="status">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				${flash.error}
			</div>
		</g:if>
		<!--Query Users Start-->
		<g:formRemote name="myForm" 
			url="[action:'manageUsers',params:[subAction:'query'],controller:'admin']"
			update="SRM-BODY-CONTENT">
			
			<div>
				<g:render contextPath="../query" template="formQueryUsers"/>
				<g:submitButton name="Find user"
								value="${message(code: 'button.label.finduser', default: 'Find user')}"
								class="btn btn-primary span2" style="vertical-align:top"/>
			</div>
		</g:formRemote>

		<!--Query Users End-->
		<g:if test="${flash.totalCount !=null && flash.totalCount!=''}">
		<div>
			${flash.totalCount}
			<g:message code="users.query.results" default="results found" />
		</div>
		
		<!--Results Found Start-->
		<div>
			<table class="table table-bordered table-striped">
				<thead>
					<tr>
						<th><a href="javascript:sortTable('userBusinessInfo3', ${currentPage },${pageCounts })" >${message(code: 'users.name.label', default: 'Name')}</a></th>
						<th><a href="javascript:sortTable('userBusinessInfo2', ${currentPage },${pageCounts })">${message(code: 'users.email.label', default: 'Email')}</a></th>
						<th><a href="javascript:sortTable('userBusinessInfo1', ${currentPage },${pageCounts })">${message(code: 'users.eid.label', default: 'EID')}</a></th>
						<th><a href="javascript:sortTable('status', ${currentPage },${pageCounts })">${message(code: 'users.status.label', default: 'Status')}</a></th>
						<th><a href="javascript:sortTable('role', ${currentPage },${pageCounts })">${message(code: 'users.role.label', default: 'Status')}</a></th>
					</tr>
				</thead>
				<tbody>
					<g:render template="resultUserTemplate"/>
				</tbody>
			</table>
		</div>
		</g:if>
		<!-- Results Found End -->
		<!-- Pagination -->
		<g:if test="${totalCounts > message(code:"user.page.each.count", default:'10').toInteger()}">
		<div class="pagination pagination-right">
		  <ul>
		  	<g:if test="${currentPage==1 }">
		  		<li id="PAGE_FIRST"><a href="javascript:getPageRecords(1, ${pageCounts}, 'Cur')">First</a></li>
			    <li id="PAGE_PREV" class="disabled"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
		  	</g:if>
		  	<g:else>
		  		<li id="PAGE_FIRST"><a href="javascript:getPageRecords(1, ${pageCounts}, 'Cur')">First</a></li>
		  		<li id="PAGE_PREV"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Prev')">Prev</a></li>
		  	</g:else>
		    <%--<g:each var="i" in="${ (0..<pageCounts) }">
		    	<g:if test="${currentPage==1 && i==0 }">
				    <li id="PAGE_${i+1}" class="active"><a href="javascript:getPageRecords(${i+1}, ${pageCounts}, 'Cur')">${i+1 }</a></li>
			  	</g:if>
			  	<g:else>
			    	<li id="PAGE_${i+1}"><a href="javascript:getPageRecords(${i+1}, ${pageCounts}, 'Cur')">${i+1 }</a></li>
			  	</g:else>
		    </g:each>--%>
		     <li><a>Page ${currentPage } of ${pageCounts}</a></li>
		    <g:if test="${currentPage==pageCounts }">
			    <li id="PAGE_NEXT" class="disabled"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
		  	</g:if>
		  	<g:else>
		  		<li id="PAGE_NEXT"><a href="javascript:getPageRecords(${currentPage }, ${pageCounts}, 'Next')">Next</a></li>
		  		<li id="PAGE_LAST"><a href="javascript:getPageRecords(${pageCounts}, ${pageCounts}, 'Cur')">Last</a></li>
		  	</g:else>
		  	<li class="pull-right"><i class="icon-hand-right"></i><input id="gotoPageId" class="input-small" name="gotoPage"/><font color="#0088cc"><g:message code="label.resource.page.title"/></font></li>
		  </ul>
		</div>
		</g:if>
	</div>
</div>

<!-- Modal render-->
<g:render template="formShowUserDetails"
	collection="${userList}" />