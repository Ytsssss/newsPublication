<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="dao.CommDAO"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <base href="<%=basePath%>">
    
    <title>后台管理系统</title>
    
	<meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    
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
  
  <body class="">
    
    

	<jsp:include page="/admin/top.jsp"></jsp:include>
    
    <jsp:include page="/admin/left.jsp"></jsp:include>
    

    
    <div class="content">
        
        <div class="header">


            <h1 class="page-title">Home</h1>
        </div>
        
                <ul class="breadcrumb">
            <li><a href="admin/index.jsp">Home</a> <span class="divider">/</span></li>
            <li class="active">Dashboard</li>
        </ul>
<div class="copyrights">Collect from <a href="http://www.cssmoban.com/"  title="网站模板">网站模板</a></div>
        <div class="container-fluid">
            <div class="row-fluid">
                    
<%CommDAO dao = new CommDAO();  
	ArrayList list1 = (ArrayList)dao.select("select * from news where shstatus='通过'");
	ArrayList list2 = (ArrayList)dao.select("select * from member where delstatus='0' ");
%>
<div class="row-fluid">
    <div class="block">
        <a href="#page-stats" class="block-heading" data-toggle="collapse">HOME</a>
        <div id="page-stats" class="block-body collapse in">

            <div class="stat-widget-container">
                
                    	<div class="stat-widget">
		                    <div class="stat-button">
		                        <p class="title"><%=list1.size() %></p>
		                        <p class="detail">新闻数量</p>
		                    </div>
		                </div>
		                
		                <div class="stat-widget">
		                    <div class="stat-button">
		                        <p class="title"><%=list2.size() %></p>
		                        <p class="detail">会员数量</p>
		                    </div>
		                </div>
		

            </div>
        </div>
    </div>
</div>



<div class="row-fluid">
    <div class="block span6">
        <a href="#tablewidget" class="block-heading" data-toggle="collapse">各栏目新闻数量统计</a>
        <div id="tablewidget" class="block-body collapse in">
        <%String sql = "SELECT  * from ppinfo where delstatus='0' ";
        ArrayList<HashMap> list4 = (ArrayList<HashMap>)dao.select(sql);
        %>
            <table class="table">
              <thead>
                <tr>
                  <th>栏目</th>
                  <th>新闻数量</th>
                </tr>
              </thead>
              <tbody>
              <%for(HashMap map2:list4){
            	  ArrayList<HashMap> aalist = (ArrayList<HashMap>)dao.select("select * from news where type="+map2.get("id")+"");
            	  %>
                <tr>
                  <td><%=map2.get("ppname") %></td>
                  <td><%=aalist.size() %></td>
                </tr>
               <%} %>
              </tbody>
            </table>
        </div>
    </div>
    
</div>


                    
                  <!--    <footer>
                        <hr>
                        <p class="pull-right">Collect from <a href="http://www.cssmoban.com/" title="网页模板" target="_blank">网页模板</a></p>

                        <p>&copy; 2012 <a href="#" target="_blank">Portnine</a></p>
                    </footer>
                    -->
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
