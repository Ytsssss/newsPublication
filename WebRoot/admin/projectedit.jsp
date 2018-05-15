<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="util.Info"%>
<%@page import="util.PageManager"%>
<%@page import="dao.CommDAO"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
	<meta charset="utf-8">
    <title>后台管理系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <base href="<%=basePath%>">
    <meta name="description" content="Admin panel developed with the Bootstrap from Twitter.">
    <meta name="author" content="travis">
    
	<link rel="stylesheet" type="text/css" href="/newspubsys/admin/lib/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/newspubsys/admin/stylesheets/theme.css">
    <link rel="stylesheet" href="/newspubsys/admin/lib/font-awesome/css/font-awesome.css">

    <script src="/newspubsys/admin/lib/jquery-1.7.2.min.js" type="text/javascript"></script>

    <!-- Demo page code -->

    <style type="text/css">
        #line-chart {
            height:300px;
            width:800px;
            margin: 0px auto;
            margin-top: 1em;
        }
        .brand { font-family: georgia, serif; }
        .brand .first {
            color: #ccc;
            font-style: italic;
        }
        .brand .second {
            color: #fff;
            font-weight: bold;
        }
    </style>

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="../assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="../assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="../assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="../assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="../assets/ico/apple-touch-icon-57-precomposed.png">

  </head>
    <%CommDAO dao = new CommDAO(); 
  String id = request.getParameter("id");
  HashMap map = dao.select("select * from projects where id="+id).get(0);
  %>
  <body class="">
	<jsp:include page="/admin/top.jsp"></jsp:include>
    
    <jsp:include page="/admin/left.jsp"></jsp:include>
    
    
       <div class="content">
        
        <div class="header">
            
            <h1 class="page-title">项目编辑</h1>
        </div>
        
                <ul class="breadcrumb">
            <li><a href="admin/index.jsp">Home</a> <span class="divider">/</span></li>
            <li class="active">项目编辑</li>
        </ul>

        <div class="container-fluid">
            <div class="row-fluid">
						<div class="alert alert-info" id="erroinfo" style="display: none">
				        	<button type="button" class="close" data-dismiss="alert">×</button>
			    		</div>
<div class="well">
    <div id="myTabContent" class="tab-content">
      <div class="tab-pane active in" id="home">
		    <form id="form" action="/newspubsys/newspubsys?ac=adminprojectedit&id=<%=id %>" method="post" enctype="multipart/form-data">
		        <label>标题</label>
		        <input type="text" class="input-xlarge span12" placeholder="标题 :" name="title" id="title" value="<%=map.get("title")%>" required>
		        <label>图片</label>
		        <input type="file" class="form-control" placeholder="图片 :" name="filename" id="filename">
		        <label>厂商介绍</label>
		        <textarea class="input-xlarge span12" placeholder="厂商介绍 :" name="suggest" id="suggest"  cols="100" rows="3" required><%=map.get("suggest")%></textarea>
		        <label>测试范围 </label>
		        <textarea class="input-xlarge span12" placeholder="测试范围 :" name="testfw" id="testfw" cols="100" rows="3" required><%=map.get("testfw")%></textarea>
		        <label>超出范围</label>
		        <textarea class="input-xlarge span12" placeholder="超出范围 :" name="ccfw" id="ccfw" cols="100" rows="3" required><%=map.get("ccfw")%></textarea>
		        <label>活动说明</label>
		        <textarea class="input-xlarge span12" placeholder="活动说明 :" name="fdnote" id="fdnote" cols="100" rows="3" required><%=map.get("fdnote")%></textarea>
		        <label>漏洞奖励和定义</label>
		        <textarea class="input-xlarge span12" placeholder="漏洞奖励和定义 :" name="jlnote" id="jlnote" cols="100" rows="3" required><%=map.get("jlnote")%></textarea>
		        <label>注意事项</label>
		        <textarea class="input-xlarge span12" placeholder="注意事项:" name="zynote" id="zynote" cols="100" rows="3" required><%=map.get("zynote")%></textarea>
		        <label>奖励金额</label>
		        <input type="number" class="input-xlarge span12" placeholder="奖励金额 :" name="jlmoney" id="jlmoney" value="<%=map.get("jlmoney")%>" required>
		        <button class="btn btn-primary"><i class="icon-save"></i> Save</button>
		    </form>
      </div>
  </div>

</div>

<div class="modal small hide fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
    <h3 id="myModalLabel">Delete Confirmation</h3>
  </div>
  <div class="modal-body">
    
    <p class="error-text"><i class="icon-warning-sign modal-icon"></i>Are you sure you want to delete the user?</p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>
    <button class="btn btn-danger" data-dismiss="modal">Delete</button>
  </div>
</div>
            </div>
        </div>
    </div>

    <script src="/newspubsys/admin/lib/bootstrap/js/bootstrap.js"></script>
    <script type="text/javascript">
        $("[rel=tooltip]").tooltip();
        $(function() {
            $('.demo-cancel-click').click(function(){return false;});
        });
    </script>
  </body>
</html>
