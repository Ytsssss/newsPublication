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
	 <%CommDAO dao = new CommDAO();  %>
	<%HashMap sitemap = dao.select("select * from siteinfo where id=1").get(0); 
	session.setAttribute("sitename",sitemap.get("sitenamefont"));%>
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
</head>

<body>
	<jsp:include page="top.jsp"></jsp:include>
	<!--//////////////////////////////////////////////////-->
	<!--///////////////////HomePage///////////////////////-->
	<!--//////////////////////////////////////////////////-->
	<%String key2 = request.getParameter("key2")==null?"":request.getParameter("key2"); 
	
		if(key2.equals("")){
			key2="1";
		}
	
	HashMap mmmm = dao.select("select * from ppinfo where id="+key2).get(0);
	%>
	<div id="page-content" class="single-page">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<ul class="breadcrumb">
						<li><a href="search.jsp?key2=<%=key2 %>"><%=mmmm.get("ppname") %></a></li>
					</ul>
				</div>
			</div>
			<div class="alert alert-info" id="tsinfo" style="display: none;">
				<button type="button" class="close" data-dismiss="alert">×</button>	
			</div>
						<%
			String sql = "select n.id as id,n.filename as filename,n.title as title, n.savetime as savetime, m.uname as uname from news n left join member m on n.mid=m.id where n.shstatus='通过'";
			String url = "/newspubsys/search.jsp?1=1";
			String key1 = request.getParameter("key1")==null?"":request.getParameter("key1");
			
			String f = request.getParameter("f");
			if(f==null)
			 {
				key1 = Info.getUTFStr(key1);
			 }
			 if(!key1.equals(""))
			 {
				 sql+=" and (title like'%"+key1+"%' "+" or uname like'%"+key1+"%' ";
				 url+="&key1="+key1;
			 }
			 if(!key2.equals(""))
			 {
				 sql+=" and (type ='"+key2+"')";
			 	url+="&key2="+key2;
			 }
			 sql += " order by id desc";
			 System.out.println(sql);
			PageManager pageManager = PageManager.getPage(url,10, request);
		    pageManager.doList(sql);
		    PageManager bean= (PageManager)request.getAttribute("page");
		    ArrayList<HashMap> prolist=(ArrayList)bean.getCollection();
				for(HashMap promap:prolist){ 
			%>
				<div class="product well">
					<div class="col-md-3">
						<div class="image">
							<a href="newsx.jsp?id=<%=promap.get("id") %>"><img src="upfile/<%=promap.get("filename") %>" border="0" width="300" height="150"/></a>
						</div>
					</div>
					<div class="col-md-9">
						<div class="caption">
							<div class="name"><h3><a href="newsx.jsp?id=<%=promap.get("id") %>"><%=promap.get("title") %></a></h3></div>
						</div>
						<div class="info">
							<%=promap.get("uname") %>
						</div>
						<div class="info">	
							<%=promap.get("savetime") %>
						</div>
					</div>
				</div>	
			<%} %>
<div class="row">
${page.info }
</div>


		</div>
	</div>	
	
	<jsp:include page="foot.jsp"></jsp:include>

</body>
</html>
