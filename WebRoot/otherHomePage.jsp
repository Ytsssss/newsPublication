<%--
  Created by IntelliJ IDEA.
  User: 99517
  Date: 2018/5/17
  Time: 19:20
  To change this template use File | Settings | File Templates.
--%>
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
    <link rel="stylesheet" href="/newspubsys/admin/lib/font-awesome/css/font-awesome.css">
</head>
<% String userId = request.getParameter("userId");
    HashMap membersession = (HashMap)session.getAttribute("member");%>
<body>
<jsp:include page="top.jsp"></jsp:include>
<!--//////////////////////////////////////////////////-->
<!--///////////////////HomePage///////////////////////-->
<!--//////////////////////////////////////////////////-->

<div id="page-content" class="single-page">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <ul class="breadcrumb">
                    <li><a href="otherHomePage.jsp?userId=<%=userId%>">他的发布</a></li>
                    <%if (membersession == null){%>
                    <button style="margin-left: 800px;" class="btn btn-default" type="button" id="addbtn"
                            onclick="addFriend(<%=membersession==null?"0":membersession.get("id")%>,<%=userId%>,this)">添加好友</button>
                    <%}else {
                    String id = membersession.get("id").toString();
                    List friendMap = dao.select("select * from friend where user_id="+id+" and friend_id="+userId+" and status=0");
                    List requstMap = dao.select("select * from friend where user_id="+id+" and friend_id="+userId+" and status=1");
                    if (!requstMap.isEmpty() && requstMap!=null){%>
                    <span style="margin-left: 800px;">已发送好友请求</span>
                    <%}else if (!friendMap.isEmpty()&&friendMap!=null){%>
                    <span style="margin-left: 800px;">已添加对方为好友</span>
                    <%}else {%>
                    <button style="margin-left: 800px;" class="btn btn-default" type="button" id="addbtn"
                            onclick="addFriend(<%=membersession==null?"0":membersession.get("id")%>,<%=userId%>,this)">添加好友</button>
                    <%}%>
                    <%}%>
                </ul>
            </div>
        </div>
        <%
            String sql = "select * from news where mid='"+userId+"' order by id desc";
            String url ="/newspubsys/otherHomePage.jsp?1=1";
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
                    <div class="info">
                        <%=promap.get("savetime") %>
                    </div>

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
<script type="text/javascript">
    function addFriend(userId, friendId, obj) {
        $.ajax({
            type: "POST",
            url: "/newspubsys?ac=addFriend", //servlet的名字
            data: "userId="+userId+"&"+"friendId="+friendId,
            success: function(data){
                if(data=="true"){
                    $("#addbtn").html("已发送好友请求");
                    obj.className="btn btn-default disabled";
                    alert("已发送好友请求");
                }else if (data=="false"){
                    alert("请登录后再请求添加好友");
                }
            }
        });
    }
</script>
</body>
</html>
