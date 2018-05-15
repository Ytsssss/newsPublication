<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="dao.CommDAO"%>
<%@page import="util.Info"%>
<%@page import="util.PageManager"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="">
    <meta name="author" content="">
	
    <title><%=session.getAttribute("sitename") %></title>
	
    <!-- Bootstrap Core CSS -->
    <link rel="stylesheet" href="css/bootstrap.min.css"  type="text/css">
	
	<!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
	
	
	<!-- Custom Fonts -->
    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css"  type="text/css">
    <link rel="stylesheet" href="fonts/font-slider.css" type="text/css">
	
	<!-- jQuery and Modernizr-->
	<script src="js/jquery-2.1.1.js"></script>
	
	<!-- Core JavaScript Files -->  	 
    <script src="js/bootstrap.min.js"></script>
	
	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="js/html5shiv.js"></script>
        <script src="js/respond.min.js"></script>
    <![endif]-->
    <script charset="utf-8" src="/newspubsys/kindeditor/kindeditor.js"></script>
	<script charset="utf-8" src="/newspubsys/kindeditor/lang/zh-CN.js"></script>
	<script>
	        KindEditor.ready(function(K) {
	                window.editor = K.create('#editor_id');
	        });
	</script>
	<script>

KindEditor.ready(function(K) {

K.create('textarea[name="note"]', {

uploadJson : '/newspubsys/kindeditor/jsp/upload_json.jsp',

                fileManagerJson : '/newspubsys/kindeditor/jsp/file_manager_json.jsp',

                allowFileManager : true,

                allowImageUpload : true, 

autoHeightMode : true,

afterCreate : function() {this.loadPlugin('autoheight');},

afterBlur : function(){ this.sync(); }  //Kindeditor下获取文本框信息

});

});

</script>
</head>

<body>
	<jsp:include page="top.jsp"></jsp:include>
	<!--//////////////////////////////////////////////////-->
	<!--///////////////////HomePage///////////////////////-->
	<!--//////////////////////////////////////////////////-->
      <%CommDAO dao = new CommDAO();  
  HashMap membersession = (HashMap)session.getAttribute("member");
  HashMap member = dao.select("select * from member where id="+membersession.get("id")).get(0);%>
	
	<div id="page-content" class="single-page">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<ul class="breadcrumb">
						<li><a href="createproject.jsp">发布新闻</a></li>
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="heading"><h2>发布新闻</h2></div>
					<form name="form2" id="ff2" method="post" action="/newspubsys/newspubsys?ac=newsadd&mid=<%=member.get("id") %>" enctype="multipart/form-data">
						<div class="form-group">
							<input type="text" class="form-control" placeholder="标题 :" name="title" id="title" required>
						</div>
						<div class="form-group">
							图片：<input type="file" class="form-control" placeholder="图片 :" name="filename" id="filename" required>
						</div>
						<div class="form-group">
							栏目：
							<select id="type" name="type" class="input-xlarge" required>
									<option value="">请选择栏目</option>
								    <%ArrayList<HashMap> pplist = (ArrayList<HashMap>)dao.select("select * from ppinfo where delstatus='0' "); 
								    for(HashMap ppmap:pplist){%>
								    <option value="<%=ppmap.get("id") %>"><%=ppmap.get("ppname") %></option>
								    <%} %>
							</select>
						</div>
						<div class="form-group">
							内容：<textarea id="editor_id" id="note" name="note" style="width:1000px;height:400px;" ></textarea>
						</div>
						
						<button type="submit" class="btn btn-1">提交</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="foot.jsp"></jsp:include>
<script type="text/javascript">
	<%String suc = (String)request.getAttribute("suc");
	if(suc!=null){%>
		location.href="myprojects.jsp?info=<%=suc%>"
	<%}%>
</script>
</body>
</html>
