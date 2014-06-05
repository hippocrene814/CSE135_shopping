<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<%@include file="welcome.jsp" %>
<%
if(session.getAttribute("name")!=null)
{

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
</head>

<body>

<div style="width:20%; position:absolute; top:50px; left:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
	<table width="100%">
		<tr><td><a href="products_browsing.jsp" target="_self">Show Produts</a></td></tr>
		<tr><td><a href="buyShoppingCart.jsp" target="_self">Buy Shopping Cart</a></td></tr>
	</table>	
</div>
<div style="width:79%; position:absolute; top:50px; right:0px; height:90%; border-bottom:1px; border-bottom-style:solid;border-left:1px; border-left-style:solid;border-right:1px; border-right-style:solid;border-top:1px; border-top-style:solid;">
<p><table align="center" width="80%" style="border-bottom-width:2px; border-top-width:2px; border-bottom-style:solid; border-top-style:solid">
	<tr><td align="left"><font size="+3">
	<%
	String uName=(String)session.getAttribute("name");
	int userID  = (Integer)session.getAttribute("userID");
	String role = (String)session.getAttribute("role");
	String ustate = (String)session.getAttribute("ustate");
	String card=null;
	long start, end;
	int card_num=0;
	try {card=request.getParameter("card"); }catch(Exception e){card=null;}
	try
	{
		 card_num    = Integer.parseInt(card);
		 if(card_num>0)
		 {
	
				Connection conn=null;
				Statement stmt=null;
				Statement stmt2=null;
				ResultSet 	rs=null;
				try
				{
					
					String SQL_copy="INSERT INTO sales (uid, pid, quantity, price) select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";
					String  SQL="delete from carts where uid="+userID+";";

					String SQL_find="select c.uid, c.pid, c.quantity, c.price from carts c where c.uid="+userID+";";

					String SQL_update_pu=null;
					String SQL_update_ps=null;
					String SQL_update_cu=null;
					String SQL_update_cs=null;

					String SQL_update_p=null;
					String SQL_update_u=null;
					String SQL_update_s=null;


					
					try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
					String url="jdbc:postgresql://127.0.0.1:5432/postgres";
					String user="postgres";
					String password="wizard";
					conn =DriverManager.getConnection(url, user, password);
					stmt =conn.createStatement();
					stmt2 = conn.createStatement();
					try{
						
							System.out.println("Start customer query...");
							start=System.currentTimeMillis();
							
							conn.setAutoCommit(false);
							/**record log,i.e., sales table**/
							stmt.execute(SQL_copy);

							int sum = 0;
							int tmp = 0;
							int p_id;
							int p_qty, p_price;
							rs=stmt.executeQuery(SQL_find);
							while(rs.next())
							{
								p_id=rs.getInt(2);
								p_qty=rs.getInt(3);
								p_price=rs.getInt(4);
								tmp = p_qty * p_price;
								sum = sum + tmp;
								SQL_update_pu="update products_users set total = total + "+tmp+" where pid = "+p_id+" and uid ="+userID+";";
								stmt2.executeUpdate(SQL_update_pu);
								SQL_update_ps="update products_states set total = total + "+tmp+" where pid = "+p_id+" and state = '"+ustate+"';";
								stmt2.executeUpdate(SQL_update_ps);
								SQL_update_cu="update categories_users set total = total + "+tmp+" where cname = (select name from categories where id = (select cid from products where id = "+p_id+"))";
								stmt2.executeUpdate(SQL_update_cu);
								SQL_update_cs="update categories_states set total = total + "+tmp+" where state = '"+ustate+"' and cname = (select name from categories where id = (select cid from products where id = "+p_id+"))";
								stmt2.executeUpdate(SQL_update_cs);
								SQL_update_p="update pre_products set total = total + "+tmp+" where pid = "+p_id+";";
								stmt2.executeUpdate(SQL_update_p);
							}

							SQL_update_u="update pre_users set total = total + "+sum+" where uid ="+userID+";";
							stmt.executeUpdate(SQL_update_u);
							SQL_update_s="update pre_states set total = total + "+sum+" where state = '"+ustate+"';";
							stmt.executeUpdate(SQL_update_s);

							end=System.currentTimeMillis();
	    					System.out.println("Finish, running time:"+(end-start)+"ms");

							stmt.execute(SQL);
							conn.commit();
							
							conn.setAutoCommit(true);
							out.println("Dear customer '"+uName+"', Thanks for your purchasing.<br> Your card '"+card+"' has been successfully proved. <br>We will ship the products soon.");
							out.println("<br><font size=\"+2\" color=\"#990033\"> <a href=\"products_browsing.jsp\" target=\"_self\">Continue purchasing</a></font>");
					}
					catch(Exception e)
					{
						out.println("1");
						System.out.print(e);
						out.println("Fail! Please try again <a href=\"purchase.jsp\" target=\"_self\">Purchase page</a>.<br><br>");
						
					}
					conn.close();
				}
				catch(Exception e)
				{
						out.println("<font color='#ff0000'>Error.<br><a href=\"purchase.jsp\" target=\"_self\"><i>Go Back to Purchase Page.</i></a></font><br>");
						
				}
			}
			else
			{
				out.println("2");
				out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
			}
		}
	catch(Exception e) 
	{ 
		out.println("3");
		out.println("Fail! Please input valid credit card numnber.  <br> Please <a href=\"purchase.jsp\" target=\"_self\">buy it</a> again.");
	}
%>
	
	</font><br>
</td></tr>
</table>
</div>
</body>
</html>
<%}%>