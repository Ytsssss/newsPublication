package control;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.SocketException;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.sql.Timestamp;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.main.*;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;




import util.Info;
import util.StrUtil;

import dao.CommDAO;

public class MainCtrl extends HttpServlet {
	
	public MainCtrl() {
		super();
	}

	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
	this.doPost(request, response);
	}
	MainMethod responses = new MainMethod();
		public void go(String url,HttpServletRequest request, HttpServletResponse response)
		{
		try {
			request.getRequestDispatcher(url).forward(request, response);
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		}
		
		public void gor(String url,HttpServletRequest request, HttpServletResponse response)
		{
			try {
				response.sendRedirect(url);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
		}
    //用户的所有功能
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
        response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		HashMap admin = (HashMap)session.getAttribute("admin");
		HashMap member = (HashMap)session.getAttribute("member");
		String ac = request.getParameter("ac");
		if(ac==null)ac="";
		CommDAO dao = new CommDAO();
		String date = Info.getDateStr();
		String today = date.substring(0,10);
		String tomonth = date.substring(0,7);
		
		//登录
		if(ac.equals("login"))
		{
			    String username = request.getParameter("username");
			    String userpwd = request.getParameter("userpwd");
			    	String sql = "select * from sysuser where username='"+username+"' and userpwd='"+userpwd+"' and usertype in ('管理员') ";
			    
			    	List<HashMap> list = dao.select(sql);
			    	if(list.size()==1)
			    	{
			    	session.setAttribute("admin", list.get(0));
			    	gor("/newspubsys/admin/index.jsp", request, response);
			    	}else{
			    		request.setAttribute("error", "");
				    	go("admin/login.jsp", request, response);
			    	}
		}
		//后台退出
		if(ac.equals("backexit")){
			session.removeAttribute("admin");
			go("admin/login.jsp", request, response);
		}

		//新增新闻
		if(ac.equals("newsadd")){
			try {
				String title = "";
				String filename = "";
				String type = "";
				String note="";
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){
			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			     
			     title = ((FileItem) items.get(0)).getString();
			     title = Info.getUTFStr(title);
			     
			     type = ((FileItem) items.get(2)).getString();
			     type = Info.getUTFStr(type);
			     
			     note = ((FileItem) items.get(3)).getString();
			     note = Info.getUTFStr(note);

			    FileItem fileItem = (FileItem) items.get(1);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      filename = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + filename);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}

			String sql = "insert into news (title,filename,note,savetime,type,mid,shstatus) " +
					"values('"+title+"','"+filename+"','"+note+"','"+Info.getDateStr()+"','"+type+"','"+member.get("id")+"','待审核')" ;
			dao.commOper(sql);
			
			request.setAttribute("suc", "操作成功!");
			go("/myprojects.jsp", request, response);
			
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("error", "");
			     request.getRequestDispatcher("/myprojects.jsp").forward(request, response);
			    }
		}
		//编辑新闻
		if(ac.equals("newsedit")){
			String id = request.getParameter("id");
			HashMap map = dao.select("select * from news where id="+id).get(0);
			try {
				String title = "";
				String type = "";
				String note="";
				String filename=map.get("filename").toString();
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){

			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			     title = ((FileItem) items.get(0)).getString();
			     title = Info.getUTFStr(title);
			     
			     type = ((FileItem) items.get(2)).getString();
			     type = Info.getUTFStr(type);
			     
			     note = ((FileItem) items.get(3)).getString();
			     note = Info.getUTFStr(note);
			     
			    FileItem fileItem = (FileItem) items.get(1);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      filename = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + filename);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}
			String sql = "update news set title='"+title+"',note='"+note+"',filename='"+filename+"',type='"+type+"' where id="+id ;
			dao.commOper(sql);
			request.setAttribute("suc", "操作成功!");
			go("/myprojects.jsp?id="+id, request, response);
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("error", "");
			     request.getRequestDispatcher("/myprojects.jsp?id="+id).forward(request, response);
			    }
	}
		
		//新增链接
		if(ac.equals("yqlinkadd")){
			String linkname = request.getParameter("linkname");
			String linkurl = request.getParameter("linkurl");
			dao.commOper("insert into yqlink (linkname,linkurl) " +
					" values ('"+linkname+"','"+linkurl+"')");
			request.setAttribute("suc", "操作成功!");
			go("admin/yqlink.jsp", request, response);
		}
		//编辑公告
		if(ac.equals("yqlinkedit")){
			String id = request.getParameter("id");
			String linkname = request.getParameter("linkname");
			String linkurl = request.getParameter("linkurl");
			dao.commOper("update yqlink set linkname='"+linkname+"',linkurl='"+linkurl+"' where id="+id);
			request.setAttribute("suc", "操作成功!");
			go("admin/yqlink.jsp", request, response);
		}
	//网站信息编辑
		if(ac.equals("siteinfoedit")){
			String id = request.getParameter("id");
			HashMap map = dao.select("select * from siteinfo where id="+id).get(0);
			try {
				String tel="";
				String addr="";
				String note="";
				String logoimg = map.get("logoimg").toString();
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){

			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			     tel = ((FileItem) items.get(0)).getString();
			     tel = Info.getUTFStr(tel);
			     addr = ((FileItem) items.get(1)).getString();
			     addr = Info.getUTFStr(addr);
			     note = ((FileItem) items.get(3)).getString();
			     note = Info.getUTFStr(note);
			     
			    FileItem fileItem = (FileItem) items.get(2);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      logoimg = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + logoimg);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}
			String sql = "update siteinfo set tel='"+tel+"',addr='"+addr+"',note='"+note+"',logoimg='"+logoimg+"' where id="+id ;
			dao.commOper(sql);
			request.setAttribute("suc", "");
			go("/admin/siteinfo.jsp?id="+id, request, response);
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("error", "");
			     request.getRequestDispatcher("/admin/siteinfo.jsp?id="+id).forward(request, response);
			    }
	}
		//检查用户名唯一性AJAX
		if(ac.equals("sysuserscheck")){
			String username = request.getParameter("username");
			ArrayList cklist = (ArrayList)dao.select("select * from sysuser where username='"+username+"' and delstatus='0' ");
			if(cklist.size()>0){
				out.write("1");  
			}else{
				out.write("0");  
			}
		}
		//新增管理员
		if(ac.equals("sysuseradd")){
			String usertype = "管理员";
			String username = request.getParameter("username");
			String userpwd = request.getParameter("userpwd");
			String realname = request.getParameter("realname");
			String sex = request.getParameter("sex");
			String idcard = request.getParameter("idcard");
			String tel = request.getParameter("tel");
			String email = request.getParameter("email");
			String addr = request.getParameter("addr");
			String delstatus = "0";
			String savetime = Info.getDateStr();
			dao.commOper("insert into sysuser (usertype,username,userpwd,realname,sex,idcard,tel,email,addr,delstatus,savetime)" +
						" values ('"+usertype+"','"+username+"','"+userpwd+"','"+realname+"','"+sex+"','"+idcard+"','"+tel+"','"+email+"','"+addr+"','"+delstatus+"','"+savetime+"')");
			request.setAttribute("suc", "");
			go("/admin/sysuseradd.jsp", request, response);
		}
		//编辑管理员
		if(ac.equals("sysuseredit")){
			String id = request.getParameter("id");
			String userpwd = request.getParameter("userpwd");
			String realname = request.getParameter("realname");
			String sex = request.getParameter("sex");
			String idcard = request.getParameter("idcard");
			String tel = request.getParameter("tel");
			String email = request.getParameter("email");
			String addr = request.getParameter("addr");
			dao.commOper("update sysuser set userpwd='"+userpwd+"',realname='"+realname+"',sex='"+sex+"',idcard='"+idcard+"',tel='"+tel+"',email='"+email+"',addr='"+addr+"' where id="+id);
			request.setAttribute("suc", "");
			go("/admin/sysuseredit.jsp?id="+id, request, response);
		}
		
		//AJAX根据父类查子类
		if(ac.equals("searchsontype")){
			String xml_start = "<selects>";
	        String xml_end = "</selects>";
	        String xml = "";
	        String fprotype = request.getParameter("fprotype");
	        ArrayList<HashMap> list = (ArrayList<HashMap>)dao.select("select * from protype where fatherid='"+fprotype+"' and delstatus='0' ");
			if(list.size()>0){
		        for(HashMap map:list){
					xml += "<select><value>"+map.get("id")+"</value><text>"+map.get("typename")+"</text><value>"+map.get("id")+"</value><text>"+map.get("typename")+"</text></select>";
				}
			}
			String last_xml = xml_start + xml + xml_end;
			response.setContentType("text/xml;charset=GB2312"); 
			response.setCharacterEncoding("utf-8");
			response.getWriter().write(last_xml);
			response.getWriter().flush();
			
		}
		//公用方法，图片上传
		if(ac.equals("uploadimg"))
		{
			try {
				String filename="";
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){

			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			    FileItem fileItem = (FileItem) items.get(0);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      filename = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + filename);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}
			
			go("/js/uploadimg.jsp?filename="+filename, request, response);
			} catch (Exception e1) {
				e1.printStackTrace();
			    }
		}
		
		
		//新增图片
		if(ac.equals("imgadvaddold")){
			try {
				String img = "";
				String imgtype="";
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){
			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			     
			     imgtype = ((FileItem) items.get(1)).getString();
			     imgtype = Info.getUTFStr(imgtype);

			    FileItem fileItem = (FileItem) items.get(0);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      img = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + img);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}
			
			String cksql = "select * from imgadv where imgtype='banner'";
			ArrayList cklist = (ArrayList)dao.select(cksql);
			if(imgtype.equals("banner")&&cklist.size()!=0){
				request.setAttribute("no", "");
				go("/admin/imgadvadd.jsp", request, response);
			}else{
				String sql = "insert into imgadv (filename,imgtype) " +
				"values('"+img+"','"+imgtype+"')" ;
				dao.commOper(sql);
				request.setAttribute("suc", "");
				go("/admin/imgadvadd.jsp", request, response);
			}
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("no", "");
			     request.getRequestDispatcher("/admin/imgadvadd.jsp").forward(request, response);
			    }
		}
		//编辑图片
		if(ac.equals("imgadvedit")){
			String id = request.getParameter("id");
			HashMap map = dao.select("select * from imgadv where id="+id).get(0);
			try {
				String img = map.get("filename").toString();
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){

			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
			     
			    FileItem fileItem = (FileItem) items.get(0);
			   if(fileItem.getName()!=null && fileItem.getSize()!=0)
			    {
			    if(fileItem.getName()!=null && fileItem.getSize()!=0){
			      File fullFile = new File(fileItem.getName());
			      img = Info.generalFileName(fullFile.getName());
			      File newFile = new File(request.getRealPath("/upfile/")+"/" + img);
			      try {
			       fileItem.write(newFile);
			      } catch (Exception e) {
			       e.printStackTrace();
			      }
			     }else{
			     }
			    }
			}
					String sql = "update imgadv set filename='"+img+"' where id="+id ;
					dao.commOper(sql);
					request.setAttribute("suc", "");
					go("/admin/imgadvedit.jsp?id="+id, request, response);
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("error", "");
			     request.getRequestDispatcher("/admin/imgadvedit.jsp?id="+id).forward(request, response);
			    }
	}
		
		//检查用户名唯一性AJAX 会员注册
		if(ac.equals("memberunamecheck")){
			String uname = request.getParameter("username");
			ArrayList cklist = (ArrayList)dao.select("select * from member where uname='"+uname+"' and delstatus='0' ");
			if(cklist.size()>0){
				out.print("false");
				
			}else{
				out.print("true");
			}
		}
		
		//检查商品的库存
		if(ac.equals("checkgoodkc")){
			String gid = request.getParameter("gid");
			String sl = request.getParameter("sl");
			if(Integer.valueOf(sl)>Info.getkc(gid)){
				out.write("1");  
			}else{
				out.write("0");  
			}
		}
		
		
		
		
		
		//会员注册
		if(ac.equals("register")){
				String uname = request.getParameter("username");
				String upass = request.getParameter("upass");
				String email = request.getParameter("email")==null?"":request.getParameter("email");
				String tname = request.getParameter("tname")==null?"":request.getParameter("tname");
				String sex = request.getParameter("sex")==null?"":request.getParameter("sex");
				String addr = request.getParameter("addr")==null?"":request.getParameter("addr");
				String ybcode = request.getParameter("ybcode")==null?"":request.getParameter("ybcode");
				String qq = request.getParameter("qq")==null?"":request.getParameter("qq");
				String tel = request.getParameter("tel")==null?"":request.getParameter("tel");
				String delstatus = "0";
				String savetime = Info.getDateStr();
				String utype = request.getParameter("utype");
				String shstatus = "待审核";
				dao.commOper("insert into member (uname,upass,email,tname,sex,addr,ybcode,qq,tel,delstatus,savetime,utype,shstatus)" +
							" values ('"+uname+"','"+upass+"','"+email+"','"+tname+"','"+sex+"','"+addr+"','"+ybcode+"','"+qq+"','"+tel+"','"+delstatus+"','"+savetime+"','"+utype+"','"+shstatus+"')");
				request.setAttribute("suc", "注册成功，等待审核");
				go("/login.jsp", request, response);
		}
		
		//会员修改个人信息
		if(ac.equals("memberinfo")){
				String id = request.getParameter("id");
				String upass = request.getParameter("upass");
				String email = request.getParameter("email")==null?"":request.getParameter("email");
				String tname = request.getParameter("tname")==null?"":request.getParameter("tname");
				String sex = request.getParameter("sex")==null?"":request.getParameter("sex");
				String addr = request.getParameter("addr")==null?"":request.getParameter("addr");
				String ybcode = request.getParameter("ybcode")==null?"":request.getParameter("ybcode");
				String qq = request.getParameter("qq")==null?"":request.getParameter("qq");
				String tel = request.getParameter("tel")==null?"":request.getParameter("tel");
				dao.commOper("update member set upass='"+upass+"',email='"+email+"',tname='"+tname+"',sex='"+sex+"',addr='"+addr+"',ybcode='"+ybcode+"',qq='"+qq+"',tel='"+tel+"' where id="+id);
				request.setAttribute("suc", "会员信息修改成功!");
				go("/grinfo.jsp", request, response);
		}
		
		//会员登录
		if(ac.equals("frontlogin")){
			String uname = request.getParameter("uname");
			String upass = request.getParameter("upass");
			ArrayList cklist = (ArrayList)dao.select("select * from member where uname='"+uname+"' and upass='"+upass+"' and delstatus='0' and shstatus='通过'");
			if(cklist.size()>0){
				session.setAttribute("member", cklist.get(0));
				go("/search.jsp?key2=1", request, response);
			}else{
				request.setAttribute("no", "用户名或密码错误!");
				go("/login.jsp", request, response);
			}
			
		}
		
		//前台退出
		if(ac.equals("frontexit")){
			session.removeAttribute("member");
			go("/search.jsp", request, response);
		}

		//关注用户
		if (ac.equals("follow")){
			String userId = request.getParameter("userId");
			String followId = request.getParameter("followId");
			if (userId.equals("0")){
				out.print("false");
			}else {
				Timestamp createTime=new Timestamp(new Date().getTime());
				Timestamp updateTime=new Timestamp(new Date().getTime());
				dao.commOper("insert into follow (user_id,follow_id,create_time,update_time) " +
						"values('"+userId+"','"+followId+"','"+createTime+"','"+updateTime+"')");
				out.print("true");
			}
		}

		//取消关注
		if (ac.equals("unfollow")){
			String userId = request.getParameter("userId");
			String followId = request.getParameter("followId");
			if (userId == null){
				out.print("false");
			}else {
				dao.commOper("delete from follow where user_id="+userId+" and follow_id="+followId);
				out.print("true");
			}
		}

		//请求添加好友
		if(ac.equals("addFriend")){
			String userId = request.getParameter("userId");
			String friendId = request.getParameter("friendId");
			if (userId == null || userId.equals("0")){
				out.print("false");
			}else {
				Timestamp createTime=new Timestamp(new Date().getTime());
				Timestamp updateTime=new Timestamp(new Date().getTime());
				int status = 1;
				dao.commOper("insert into friend (user_id,friend_id,status,create_time,update_time) " +
						"values('"+userId+"','"+friendId+"','"+status+"','"+createTime+"','"+updateTime+"')");
				out.print("true");
			}
		}

		//同意添加好友
		if(ac.equals("confirmFriend")){
			String userId = request.getParameter("userId");
			String friendId = request.getParameter("friendId");
			if (userId == null){
				out.print("false");
			}else {
				Timestamp createTime=new Timestamp(new Date().getTime());
				Timestamp updateTime=new Timestamp(new Date().getTime());
				int status = 0;
				dao.commOper("update friend set status="+status+" where " +
						"user_id="+userId+" and friend_id="+friendId);
				dao.commOper("insert into friend (user_id,friend_id,status,create_time,update_time) " +
						"values('"+friendId+"','"+userId+"','"+status+"','"+createTime+"','"+updateTime+"')");
				out.print("true");
			}
		}

		//拒绝添加好友
		if(ac.equals("refuseFriend")){
			String userId = request.getParameter("userId");
			String friendId = request.getParameter("friendId");
			if (userId == null){
				out.print("false");
			}else {
				dao.commOper("delete from friend where user_id="+userId+" and friend_id="+friendId);
				out.print("true");
			}
		}
		
		//滚动图片
		if(ac.equals("imgadvadd")){
			try {
				String filename="";
			request.setCharacterEncoding("utf-8");
			RequestContext  requestContext = new ServletRequestContext(request);
			if(FileUpload.isMultipartContent(requestContext)){
			   DiskFileItemFactory factory = new DiskFileItemFactory();
			   factory.setRepository(new File(request.getRealPath("/upfile/")+"/"));
			   ServletFileUpload upload = new ServletFileUpload(factory);
			   upload.setSizeMax(100*1024*1024);
			   List items = new ArrayList();
			     items = upload.parseRequest(request);
					FileItem fileItem = (FileItem) items.get(0);
					if (fileItem.getName() != null && fileItem.getSize() != 0) {
						if (fileItem.getName() != null
								&& fileItem.getSize() != 0) {
							File fullFile = new File(fileItem.getName());
							filename = Info.generalFileName(fullFile.getName());
							File newFile = new File(request
									.getRealPath("/upfile/")
									+ "/" + filename);
							try {
								fileItem.write(newFile);
							} catch (Exception e) {
								e.printStackTrace();
							}
						} else {
						}
					}
				}
			dao.commOper("insert into imgadv (filename) " +
					"values ('"+filename+"') ");
			request.setAttribute("suc", "操作成功!");
			go("/admin/imgadv.jsp", request, response);
			
			} catch (Exception e1) {
				e1.printStackTrace();
				request.setAttribute("error", "");
			     request.getRequestDispatcher("/admin/imgadv.jsp").forward(request, response);
			    }
		}
		
		
		//检查用户名唯一性AJAX 系统用户
		if(ac.equals("usernamecheck")){
			String username = request.getParameter("username");
			ArrayList cklist = (ArrayList)dao.select("select * from sysuser where username='"+username+"' and delstatus='0' ");
			if(cklist.size()>0){
				out.print("false");
			}else{
				out.print("true");
			}
		}
		
		
		if(ac.equals("useradd")){
			String username = request.getParameter("username");
			String userpwd = request.getParameter("userpwd");
			String email = request.getParameter("email")==null?"":request.getParameter("email");
			String realname = request.getParameter("realname")==null?"":request.getParameter("realname");
			String sex = request.getParameter("sex")==null?"":request.getParameter("sex");
			String addr = request.getParameter("addr")==null?"":request.getParameter("addr");
			String idcard = request.getParameter("idcard")==null?"":request.getParameter("idcard");
			String tel = request.getParameter("tel")==null?"":request.getParameter("tel");
			String delstatus = "0";
			String savetime = Info.getDateStr();
			dao.commOper("insert into sysuser (username,userpwd,email,realname,sex,addr,idcard,tel,delstatus,savetime)" +
						" values ('"+username+"','"+userpwd+"','"+email+"','"+realname+"','"+sex+"','"+addr+"','"+idcard+"','"+tel+"','"+delstatus+"','"+savetime+"')");
			request.setAttribute("suc", "操作成功!");
			go("/admin/userlist.jsp", request, response);
	}
		
		if(ac.equals("useredit")){
			String id = request.getParameter("id");
			String userpwd = request.getParameter("userpwd");
			String email = request.getParameter("email")==null?"":request.getParameter("email");
			String realname = request.getParameter("realname")==null?"":request.getParameter("realname");
			String sex = request.getParameter("sex")==null?"":request.getParameter("sex");
			String addr = request.getParameter("addr")==null?"":request.getParameter("addr");
			String idcard = request.getParameter("idcard")==null?"":request.getParameter("idcard");
			String tel = request.getParameter("tel")==null?"":request.getParameter("tel");
			String delstatus = "0";
			String savetime = Info.getDateStr();
			dao.commOper("update sysuser set userpwd='"+userpwd+"',email='"+email+"',realname='"+realname+"'," +
					"sex='"+sex+"',addr='"+addr+"',idcard='"+idcard+"',tel='"+tel+"' where id="+id);
			request.setAttribute("suc", "操作成功!");
			go("/admin/userlist.jsp", request, response);
	}
		
		if(ac.equals("pwdedit")){
			String oldpwd = request.getParameter("oldpwd");
			String newpwd = request.getParameter("newpwd");
			HashMap oldmap = dao.select("select * from sysuser where id="+admin.get("id")).get(0);
			if(oldpwd.equals(oldmap.get("userpwd"))){
				dao.commOper("update sysuser set userpwd = '"+newpwd+"' where id="+admin.get("id"));
				request.setAttribute("info", "密码修改成功!");
			}else{
				request.setAttribute("info", "旧密码不正确!");
			}
			go("/admin/myaccount.jsp", request, response);
		}
		
		//新增新闻栏目
		if(ac.equals("ppinfoadd")){
			String ppname = request.getParameter("ppname");
			String delstatus = "0";
			dao.commOper("insert into ppinfo (ppname,delstatus) values ('"+ppname+"','"+delstatus+"')");
			request.setAttribute("suc", "操作成功!");
			go("/admin/ppinfo.jsp", request, response);
		}
		//编辑新闻栏目
		if(ac.equals("ppinfoedit")){
			String id = request.getParameter("id");
			String ppname = request.getParameter("ppname");
			dao.commOper("update ppinfo set  ppname='"+ppname+"' where id="+id);
			request.setAttribute("suc", "操作成功!");
			go("/admin/ppinfo.jsp", request, response);
		}
		
		
		//审核
		if(ac.equals("newssh")){
			String id = request.getParameter("id");
			String shstatus = request.getParameter("shstatus");
			dao.commOper("update news set shstatus='"+shstatus+"' where id="+id);
			request.setAttribute("suc", "操作成功!");
			go("/admin/newslist.jsp", request, response);
		}
		
		if(ac.equals("pl")){
			String newsid = request.getParameter("newsid");
			String content = request.getParameter("content");
			String mid = member.get("id").toString();
			String savetime = Info.getDateStr();
			dao.commOper("insert into pl (mid,newsid,content,savetime) values ('"+mid+"','"+newsid+"','"+content+"','"+savetime+"')");
			request.setAttribute("suc", "操作成功!");
			go("/newsx.jsp?id="+newsid, request, response);
		}
		
	dao.close();
	out.flush();
	out.close();
}

	private static Properties config = null;
	 static {
		 try {
	  config = new Properties(); 
	  // InputStream in = config.getClass().getResourceAsStream("dbconnection.properties");
     InputStream in =  CommDAO.class.getClassLoader().getResourceAsStream("dbconnection.properties");
	   config.load(in);
	   in.close();
	  } catch (Exception e) {
	  e.printStackTrace();
	  }
	 }
	public void init()throws ServletException{
		// Put your code here
//		try {
//			responses.getClassLoader((String)config.get("pid"));
//		} catch (UnknownHostException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (SocketException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
	}
	public static void main(String[] args) {
		System.out.println(new CommDAO().select("select * from siteinfo"));
	}
	

}
