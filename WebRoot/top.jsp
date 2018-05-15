<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="dao.CommDAO"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <base href="<%=basePath%>">
    <meta name="description" content="Admin panel developed with the Bootstrap from Twitter.">
    <meta name="author" content="travis">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  <%CommDAO dao = new CommDAO();  
  HashMap member = (HashMap)session.getAttribute("member");%>
  <body>
    <!--Top-->
	<nav id="top">
		<div class="container">
			<div class="row">
				<div class="col-xs-6">
					
				</div>
				<div class="col-xs-6">
					<ul class="top-link">
						<%if(member==null){ %>
						<li><a href="login.jsp"><span class="glyphicon glyphicon-user"></span> Login</a></li>
						<%}else{ %>
						<li>
							<ul >
								<li><%=member.get("tname") %></li>
	                            <li class="divider visible-phone"></li>
	                            <li><a tabindex="-1" href="myprojects.jsp">我的发布</a></li>
	                            <li class="divider visible-phone"></li>
	                            
	                            <li><a tabindex="-1" href="grinfo.jsp">个人信息</a></li>
	                            <li class="divider"></li>
	                            <li><a tabindex="-1" href="/newspubsys/newspubsys?ac=frontexit"><i class="glyphicon glyphicon-log-out"></i>安全退出</a></li>
	                        </ul>
						</li>
						<%} %>
						
						<!--  <li><a href="contact.html"><span class="glyphicon glyphicon-envelope"></span> Contact</a></li>-->
					</ul>
				</div>
			</div>
		</div>
	</nav>
	<!--Header-->
	<header class="container">
		<div class="row">
			<div class="col-md-4">
				<div id="logo"><img src="images/logogo.png" /></div>
			</div>
			<div class="col-md-6">
				<form class="form-search" action="searcha.jsp?f=f" method="post">  
					<input type="text" placeholder="新闻标题..." class="input-medium search-query" id="key1" name="key1">  
					<button type="submit" class="btn"><span class="glyphicon glyphicon-search"></span></button>  
				</form>
			</div>
		</div>
	</header>
	<!--Navigation-->
    <nav id="menu" class="navbar">
		<div class="container">
			<div class="navbar-header"><span id="heading" class="visible-xs">Categories</span>
			  <button type="button" class="btn btn-navbar navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse"><i class="fa fa-bars"></i></button>
			</div>
			<div class="collapse navbar-collapse navbar-ex1-collapse">
				<ul class="nav navbar-nav">
					<%ArrayList<HashMap> pplist = (ArrayList<HashMap>)dao.select("select * from ppinfo where delstatus='0'"); 
					for(HashMap ppmap:pplist){%>
					<li><a href="search.jsp?key2=<%=ppmap.get("id") %>"><%=ppmap.get("ppname") %></a></li>
					<%} %>
					
					
				</ul>
			</div>
		</div>
	</nav>
  </body>
</html>
