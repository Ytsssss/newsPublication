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
  HashMap membersession = (HashMap)session.getAttribute("member");
  HashMap member = dao.select("select * from member where id="+membersession.get("id")).get(0);%>
	
	<div id="page-content" class="single-page">
		<div class="container">
			<div class="row">
				<div class="col-lg-12">
					<ul class="breadcrumb">
						<li><a href="index.jsp">Home</a></li>
						<li><a href="login.jsp">个人资料</a></li>
					</ul>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="heading"><h2>好友请求</h2></div>
					<%String userId = membersession.get("id").toString();
					List<HashMap> friendMap = dao.select("select m.uname as name,m.id as id,f.create_time as time from friend f left join member m on f.user_id=m.id where f.friend_id="+userId+" and f.status=1");
					if (friendMap.isEmpty() || friendMap == null){%>
					<p>暂无好友请求</p>
					<%}else {%>
					<table class="table table-striped" width="100%">
						<thead>
							<tr>
								<th>请求人</th>
								<th>请求时间</th>
								<th>操作</th>
							</tr>
						</thead>
						<tbody>
						<%for (HashMap friend : friendMap){%>
						<tr>
							<td>
								<%=friend.get("name")%>
							</td>
							<td>
								<%=friend.get("time")%>
							</td>
							<td>
								<button type="button" class="btn btn-success" onclick="agree(<%=friend.get("id")%>,<%=userId%>,this)">同意</button>
								<button type="button" class="btn btn-danger" onclick="disAgree(<%=friend.get("id")%>,<%=userId%>,this)">拒绝</button>
							</td>
						</tr>
						<%}%>
						</tbody>
					</table>
					<%}%>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<div class="heading"><h2>个人资料</h2></div>
					<form name="form2" id="ff2" method="post" action="/newspubsys/newspubsys?ac=memberinfo&id=<%=member.get("id") %>">
						<%String suc = (String)request.getAttribute("suc");
						if(suc!=null){%>
						    <div class="alert alert-info">
						        <button type="button" class="close" data-dismiss="alert">×</button>
						        	<%=suc %>
					    	</div>
						<%}%>
						<div class="form-group">
							<input type="text" value="<%=member.get("uname") %>" readonly="readonly" class="form-control" placeholder="用户名 :" name=username id="username" onblur="validatorloginName()" required>
						</div>
						<div class="form-group">
							<input type="password" class="form-control" placeholder="密码 :" name="upass" id="upass" required>
						</div>
						<div class="alert alert-info" id="pwderroinfo" style="display: none">
				        	<button type="button" class="close" data-dismiss="alert">×</button>
			    		</div>
						<div class="form-group">
							<input type="password" class="form-control" placeholder="再次输入密码 :" name="upass1" id="upass1" onblur="validatorpwd()" required>
						</div>
						<div class="form-group">
							<input type="text" value="<%=member.get("tname") %>" class="form-control" placeholder="姓名或厂商名称:" name="tname" id="tname" required>
						</div>
						<div class="form-group">
							<input name="sex" id="sex" type="radio" <%if(member.get("sex").equals("男")){out.print("checked==checked");} %> value="男"> 男 
							<input name="sex" id="sex" type="radio" <%if(member.get("sex").equals("女")){out.print("checked==selected");} %> value="女"> 女
						</div>
						<div class="form-group">
							<input type="text" value="<%=member.get("email") %>" class="form-control" placeholder="电子邮箱 :" name="email" id="email" required>
						</div>
						
						<div class="form-group">
							<input type="text" value="<%=member.get("qq") %>" class="form-control" placeholder="qq :" name="qq" id="qq" required>
						</div>
						<div class="form-group">
							<input type="text" value="<%=member.get("tel") %>" class="form-control" placeholder="电话 :" name="tel" id="tel" required>
						</div>
						<button type="submit" class="btn btn-1">Update</button>
					</form>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="foot.jsp"></jsp:include>
<script type="text/javascript">
function validatorpwd(){
	if(document.getElementById("upass").value!=document.getElementById("upass1").value){
		$("#pwderroinfo").show(); 
		$("#pwderroinfo").html("两次密码不一致");
		return false;
	}else{
		$("#pwderroinfo").hide(); 
	}
}
function agree(userId, friendId,obj) {
    $.ajax({
        type: "POST",
        url: "/newspubsys?ac=confirmFriend", //servlet的名字
        data: "userId="+userId+"&"+"friendId="+friendId,
        success: function(data){
            if(data=="true"){
                alert("已添加对方为好友");
                window.location.href="grinfo.jsp";
            }else if (data=="false"){
                alert("请登录后再添加好友");
            }
        }
    });

}
function disAgree(userId, friendId,obj) {
    $.ajax({
        type: "POST",
        url: "/newspubsys?ac=refuseFriend", //servlet的名字
        data: "userId="+userId+"&"+"friendId="+friendId,
        success: function(data){
            if(data=="true"){
                alert("已拒绝添加对方为好友");
                window.location.href="grinfo.jsp";
            }else if (data=="false"){
                alert("请登录后再添加好友");
            }
        }
    });

}
</script>
</body>
</html>
