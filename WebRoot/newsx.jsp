
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
</head>

<body>
	<jsp:include page="top.jsp"></jsp:include>
	<!--//////////////////////////////////////////////////-->
	<!--///////////////////HomePage///////////////////////-->
	<!--//////////////////////////////////////////////////-->
      <%CommDAO dao = new CommDAO();
      String id = request.getParameter("id");
      HashMap map = dao.select("select * from news where id="+id).get(0);
      HashMap membermap = dao.select("select * from member where id="+map.get("mid")).get(0);
      HashMap membersession = (HashMap)session.getAttribute("member");%>
	
	<div id="page-content" class="single-page">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<ul class="breadcrumb">
						<li>新闻详情</li>
						<li><a href="newsx.jsp?id=<%=id %>"><%=map.get("title") %></a></li>
					</ul>
				</div>
			</div>
			<div class="info">	
				<h2><%=map.get("title") %></h2>
				发布人：<%=membermap.get("tname")%>&nbsp;&nbsp;&nbsp;<%=map.get("savetime") %>
				&nbsp;&nbsp;&nbsp;<button type="button" class="btn btn-success" onclick="follow()">关注</button><br/>
				<img alt="" src="upfile/<%=map.get("filename") %>" width="700" height="400"><br/>
				<%=map.get("note") %>
			</div>
			
				
<div class="product-desc">
						<ul class="nav nav-tabs">
							<li class="active"><a href="javascript:void(0)" onclick="selectTag('tagContent0',this)">评论</a></li>
						</ul>
						<div class="tab-content" id="tags">
							<div id="tagContent0" class="tab-pane fade in active">
							<form name="form2" id="ff2" method="post" action="/newspubsys/newspubsys?ac=pl&newsid=<%=id %>">
								<table class="bordered" width="100%">  
									<thead>  
										<tr>  
										<th>评论内容</th>  
										<th>评论人</th>
										<th>评论时间</th>  
										<th></th>
										</tr>  
									</thead>
									<%String sql = "select  * from pl where newsid='"+id+"' order by savetime desc "; 
	                                String url ="/newspubsys/newsx.jsp?1=1&id="+id;
	                                String did = request.getParameter("did");
	                                if(did!=null){
	                                	dao.commOper("delete from pl where id="+did);
	                                }
	                                PageManager pageManager = PageManager.getPage(url,10, request);
								    pageManager.doList(sql);
								    PageManager bean= (PageManager)request.getAttribute("page");
								    ArrayList<HashMap> pjlist=(ArrayList)bean.getCollection();
								    for(HashMap pjmap :pjlist)
								    {
								    HashMap mmm = dao.select("select * from member where id="+pjmap.get("mid")).get(0);
								    %>
									<tr>  
										<td><%=pjmap.get("content") %></td>  
										<td><%=mmm.get("tname") %></td>
										<td><%=pjmap.get("savetime") %></td>
										<td>
										<%if(membersession!=null&&membersession.get("id").equals(map.get("mid"))){%>
											<a href="newsx.jsp?id=<%=id %>&did=<%=pjmap.get("id") %>">删除</a>
										<%} %>
										</td>
									</tr>  
									<%} %>
									<tr>
										<td colspan="9">${page.info }</td>
									</tr>
									<%
									HashMap member = (HashMap)session.getAttribute("member");
									if(member!=null){ %>
									<tr>
										<td colspan="3">
											评论：<input type="text" class="form-control" placeholder="评论" name="content" id="content" required>
											<button type="submit" class="btn btn-1">提交</button>
										</td>
									</tr>
									<%} %>
								</table>
								</form>
							</div>
						</div>
					</div>

		</div>
	</div>	
	
	<jsp:include page="foot.jsp"></jsp:include>

	<script type="text/javascript">
        function follow(){
            var userId = membersession.get("id");
            var followId = membermap.get("id");
            $.ajax({
                type: "POST",
                url: "/newspubsys/newspubsys?ac=follow", //servlet的名字
                data: "userId="+userId+"&"+"followId="+followId,
                success: function(data){
                    if(data=="true"){
                        alert("关注成功");
                    }else if (data=="false"){
                       	alert("请登录后再关注");
                    }
                }
            });
        }
	</script>
</body>
</html>