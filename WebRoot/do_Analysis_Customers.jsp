<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%
ArrayList<Integer> p_list=new ArrayList<Integer>();//product ID, 10
ArrayList<Integer> u_list=new ArrayList<Integer>();//customer ID,20
ArrayList<String> p_name_list=new ArrayList<String>();//product ID, 10
ArrayList<String> u_name_list=new ArrayList<String>();//customer ID,20
HashMap<Integer, Integer> product_ID_amount	=	new HashMap<Integer, Integer>();
HashMap<Integer, Integer> customer_ID_amount=	new HashMap<Integer, Integer>();
%>
<%
	String  state=null, category=null, age=null;
	try { 
			state     =	request.getParameter("state"); 
			category  =	request.getParameter("category"); 
			System.out.println(category);
			age       =	request.getParameter("age"); 			
	}
	catch(Exception e) 
	{ 
       state=null; category=null; age=null;
	}
	String  pos_row_str=null, pos_col_str=null;
	int pos_row=0, pos_col=0;
	try { 
			pos_row_str     =	request.getParameter("pos_row"); 
			pos_row=Integer.parseInt(pos_row_str);		
			pos_col_str     =	request.getParameter("pos_col"); 
			pos_col=Integer.parseInt(pos_col_str);		
	}
	catch(Exception e) 
	{ 
       pos_row_str=null; pos_row=0;
       pos_col_str=null; pos_col=0;

	}
%>
<%
Connection	conn=null;
Statement 	stmt;
ResultSet 	rs=null;
String  	SQL_1=null,SQL_2=null,SQL_ut=null, SQL_pt=null, SQL_row=null, SQL_col=null;
String 		SQL_user = null, SQL_product = null, SQL_cell = null;
String  	SQL_amount_row=null,SQL_amount_col=null,SQL_amount_cell=null;
int 		p_id=0,u_id=0;
String		p_name=null,u_name=null;
int 		p_amount_price=0,u_amount_price=0;

int show_num_row=20, show_num_col=10;
	
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://127.0.0.1:5432/postgres";
	String user="postgres";
	String password="wizard";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
//	stmt2 =conn.createStatement();
	
	System.out.println("Start customer query...");
	long start=System.currentTimeMillis();
			
	if(("All").equals(state) && ("0").equals(category))//0,0
	{
		SQL_user = "select u.uid, u.uname, u.total from pre_users u order by u.total desc limit 20;";
		SQL_product = "select p.pid, p.pname, p.total from pre_products p order by p.total desc limit 10;";
		SQL_cell = "select u.uid, p.pid, s.total from ((select * from  pre_users order by pre_users.total desc limit 20)u full outer join (select * from pre_products order by pre_products.total desc limit 10)p on 1=1) left outer join products_users s on p.pid = s.pid and u.uid = s.uid group by u.uid, p.pid, u.total, p.total, s.total order by u.total desc, p.total desc;";
	}
	
	if(("All").equals(state) && !("0").equals(category))//0,1
	{
		SQL_user = "select u.uid, u.uname, u.total from categories_users u where u.cname = '"+ category +"' order by u.total desc limit 20;";
		SQL_product = "select p.pid, p.pname, p.total from pre_products p where p.cname = '"+ category +"' order by p.total desc limit 10;";
		SQL_cell = "select u.uid, p.pid, s.total as total from ((select * from  categories_users where categories_users.cname = '"+ category +"' order by categories_users.total desc limit 20)u full outer join (select * from pre_products where pre_products.cname = '"+ category +"' order by pre_products.total desc limit 10)p on 1=1) left outer join products_users s on p.pid = s.pid and u.uid = s.uid group by u.uid, p.pid, u.total, p.total, s.total order by u.total desc, p.total desc;";
	}

	if(!("All").equals(state) && ("0").equals(category))//1,0
	{
		SQL_user = "select u.uid, u.uname, u.total from pre_users u where u.state = '"+ state +"' order by u.total desc limit 20;";
		SQL_product = "select p.pid, p.pname, p.total from products_states p where p.state = '"+ state +"' order by p.total desc limit 10;";
		SQL_cell = "select u.uid, p.pid, s.total from ((select * from  pre_users where pre_users.state = '"+ state +"' order by pre_users.total desc limit 20) u full outer join (select * from products_states where products_states.state = '"+ state +"' order by products_states.total desc limit 10)p on 1=1) left outer join products_users s on p.pid = s.pid and u.uid = s.uid group by u.uid, p.pid, u.total, p.total, s.total order by u.total desc, p.total desc;";
	}

	if(!("All").equals(state) && !("0").equals(category))//1,1
	{
		SQL_user = "select u.uid, u.uname, u.total from categories_users u where u.cname = '"+ category +"' and u.state = '"+ state +"' order by u.total desc limit 20;";
		SQL_product = "select p.pid, p.pname, p.total from products_states p, categories c where p.cid = c.id and p.state = '"+ state +"' and c.name = '"+ category +"' order by p.total desc limit 10;";
		SQL_cell = "select u.uid, p.pid, s.total as total from ((select * from  categories_users c where c.cname = '"+ category +"' and c.state = '"+ state +"' order by c.total desc limit 20)u full outer join (select * from products_states pr, categories c where pr.cid = c.id and c.name = '"+ category +"' and pr.state = '"+ state +"' order by pr.total desc limit 10)p on 1=1) left outer join products_users s on p.pid = s.pid and u.uid = s.uid group by u.uid, p.pid, u.total, p.total, s.total order by u.total desc, p.total desc;";


/* 		SQL_1="select id,name from users where state='"+state+"' order by name asc offset "+pos_row+" limit "+show_num_row;
		SQL_2="select id,name from products where cid="+category+" order by name asc offset "+pos_col+" limit "+show_num_col;
		SQL_ut="insert into u_t (id, name) "+SQL_1;
		SQL_pt="insert into p_t (id, name) "+SQL_2;
		SQL_row="select count(*) from users where state='"+state+"' ";
		SQL_col="select count(*) from products where cid="+category+"";
		SQL_amount_row="select s.uid, sum(s.quantity*s.price) from  u_t u, sales s, products p  where s.pid=p.id and p.cid="+category+" and s.uid=u.id group by s.uid;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from p_t p, sales s, users u where s.pid=p.id  and s.uid=u.id and u.state='"+state+"'  group by s.pid;";
  */
	}

	//user 

	rs=stmt.executeQuery(SQL_user);
	while(rs.next())
	{
		u_id=rs.getInt(1);
		u_name=rs.getString(2);
		u_amount_price=rs.getInt(3);

		u_list.add(u_id);
		u_name_list.add(u_name);
		customer_ID_amount.put(u_id, u_amount_price);
	}

	//product
	rs=stmt.executeQuery(SQL_product);
	while(rs.next())
	{
		p_id=rs.getInt(1);   
		p_name=rs.getString(2);
		p_amount_price=rs.getInt(3);

		p_list.add(p_id);
	    p_name_list.add(p_name);
		product_ID_amount.put(p_id,p_amount_price);
		
	}
	System.out.println("row header");

%>	
<%	

   
    int i=0,j=0;
	HashMap<String, String> pos_idPair=new HashMap<String, String>();
	HashMap<String, Integer> idPair_amount=new HashMap<String, Integer>();	
	int amount=0;
	
%>
	<table align="center" width="100%" border="1">
		<tr align="center">
			<td width="12%"><table align="center" width="100%" border="0"><tr align="center"><td><strong><font size="+2" color="#FF00FF">CUSTOMER</font></strong></td></tr></table></td>
			<td width="88%">
				<table align="center" width="100%" border="1">
					<tr align="center">
<%	
	int amount_show=0;
	for(i=0;i<p_list.size();i++)
	{
		p_id			=   p_list.get(i);
		p_name			=	p_name_list.get(i);
		if(product_ID_amount.get(p_id)!=null)
		{
			amount_show=(Integer)product_ID_amount.get(p_id);
			if(amount_show!=0)
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td>");
			}
			else
			{
				out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
			}	
		}
		else
		{
			out.print("<td width='10%'><strong>"+p_name+"<br>(<font color='#ff0000'>$0</font>)</strong></td>");
		}
	}
%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
<table align="center" width="100%" border="1">
<tr><td width="12%">
	<table align="center" width="100%" border="1">
	<%	
		for(i=0;i<u_list.size();i++)
		{
			u_id			=	u_list.get(i);
			u_name			=	u_name_list.get(i);
			if(customer_ID_amount.get(u_id)!=null)
			{
				amount_show=(Integer)customer_ID_amount.get(u_id);
				if(amount_show!=0)
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#0000ff'>$"+amount_show+"</font>)</strong></td></tr>");
				}
				else
				{
					out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
				}	
			}
			else
			{
				out.println("<tr align=\"center\"><td width=\"10%\"><strong>"+u_name+"(<font color='#ff0000'>$0</font>)</strong></td></tr>");
			}
			for(j=0;j<p_list.size();j++)
			{
				p_id	=   p_list.get(j);
				pos_idPair.put(i+"_"+j, u_id+"_"+p_id);
				idPair_amount.put(u_id+"_"+p_id,0);
			}
		}
		System.out.println("column header");
	%>
	</table>
</td>
<td width="88%">	
	<%	
/* 		SQL_amount_cell="select s.uid, s.pid, sum(s.quantity*s.price) from u_t u,p_t p, sales s where s.uid=u.id and s.pid=p.id group by s.uid, s.pid;";
		 rs=stmt.executeQuery(SQL_amount_cell);  */
		 conn.setAutoCommit(false);
		 rs=stmt.executeQuery(SQL_cell);
		 System.out.println("execute cell 11");
		 while(rs.next())
		 {
			 u_id=rs.getInt(1);
			 p_id=rs.getInt(2);
			 amount=rs.getInt(3);
			 idPair_amount.put(u_id+"_"+p_id, amount);
		 }
		System.out.println("execute cell");
	%>	 
	<table align="center" width="100%" border="1">
	<%	
		long end=System.currentTimeMillis();
	    System.out.println("Finish, running time:"+(end-start)+"ms");
		String idPair="";
		for(i=0;i<u_list.size();i++)
		{
			out.println("<tr  align='center'>");
			for(j=0;j<p_list.size();j++)
			{
				idPair=(String)pos_idPair.get(i+"_"+j);
				amount=(Integer)idPair_amount.get(idPair);
				if(amount==0)
				{
					out.println("<td width=\"10%\"><font color='#ff0000'>0</font></td>");
				}
				else
				{
					out.println("<td width=\"10%\"><font color='#0000ff'><b>"+amount+"</b></font></td>");
				}
			}
			out.println("</tr>");
		}
	%>
	</table>
	
</td>
</tr>
</table>	

<%
	conn.commit();
	conn.setAutoCommit(true);
	conn.close();
}
catch(Exception e)
{
  out.println("Fail! Please connect your database first.");
}
%>	

</body>
</html>