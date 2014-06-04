<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" import="database.*"   import="java.util.*" errorPage="" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>CSE135</title>
<script type="text/javascript" src="js/js.js" language="javascript"></script>
</head>

<body>
<%@include file="welcome.jsp" %>
<%
//if(session.getAttribute("name")!=null)
//{
//	int userID  = (Integer)session.getAttribute("userID");
//	String role = (String)session.getAttribute("role");


Connection conn=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs=null,rs_2=null,rs_3=null;
String SQL=null;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	String url="jdbc:postgresql://127.0.0.1:5432/postgres";
	String user="postgres";
	String password="wizard";
	conn =DriverManager.getConnection(url, user, password);
	stmt =conn.createStatement();
	
%>	

<input type="hidden" id="currentFlag_row" value="0">
<input type="hidden" id="currentFlag_col" value="0">
<div style="position:absolute; top:35px; left:0px; width:100%; height:70px; background-color:#66CCFF">
<table align="left" width="200px" border="1">
	<tr>
		<td>
			<select name="search_key" id="search_key" onChange="change()">
				<option value="1" selected="selected">Customers</option>
				<option value="2">States</option>
			</select>
		</td>
		<td>
			<table  align="center" width="100%" border="1">
				<tr>
					<td>State</td>
					<td>Category</td>
<!-- 					<td>Age</td> -->
				</tr>
				<tr>
					<td>
						<select name="search_key_1" id="search_key_1">
							<option value="All" selected="selected">All States</option>
							<option value="Alabama">Alabama</option> 
							<option value="Alaska">Alaska</option>
							<option value="Arizona">Arizona</option>
							<option value="Arkansas">Arkansas</option>
							<option value="California">California</option>
							<option value="Colorado">Colorado</option>
							<option value="Connecticut">Connecticut</option>
							<option value="Delaware">Delaware</option>
							<option value="Florida">Florida</option>
							<option value="Georgia">Georgia</option>
							<option value="Hawaii">Hawaii</option>
							<option value="Idaho">Idaho</option>
							<option value="Illinois">Illinois</option>
							<option value="Indiana">Indiana</option>
							<option value="Iowa">Iowa</option>
							<option value="Kansas">Kansas</option>
							<option value="Kentucky">Kentucky</option>
							<option value="Louisiana">Louisiana</option>
							<option value="Maine">Maine</option>
							<option value="Maryland">Maryland</option>
							<option value="Massachusetts">Massachusetts</option>
							<option value="Michigan">Michigan</option>
							<option value="Minnesota">Minnesota</option>
							<option value="Mississippi">Mississippi</option>
							<option value="Missouri">Missouri</option>
							<option value="Montana">Montana</option>
							<option value="Nebraska">Nebraska</option>
							<option value="Nevada">Nevada</option>
							<option value="New Hampshire">New Hampshire</option>
							<option value="New Jersey">New Jersey</option>
							<option value="New Mexico">New Mexico</option>
							<option value="New York">New York</option>
							<option value="North Carolina">North Carolina</option>
							<option value="North Dakota">North Dakota</option>
							<option value="Ohio">Ohio</option>
							<option value="Oklahoma">Oklahoma</option>
							<option value="Oregon">Oregon</option>
							<option value="Pennsylvania">Pennsylvania</option>
							<option value="Rhode Island">Rhode Island</option>
							<option value="South Carolina">South Carolina</option>
							<option value="South Dakota">South Dakota</option>
							<option value="Tennessee">Tennessee</option>
							<option value="Texas">Texas</option>
							<option value="Utah">Utah</option>
							<option value="Vermont">Vermont</option>
							<option value="Virginia">Virginia</option>
							<option value="Washington">Washington</option>
							<option value="West Virginia">West Virginia</option>
							<option value="Wisconsin">Wisconsin</option>
							<option value="Wyoming">Wyoming</option>
						</select>
					</td>
					<td>
						<select name="search_key_2" id="search_key_2">
							<option value="0" selected="selected">All Categories</option>
<%
							/**SQL_1 for (state, amount)**/
								String SQL_1="SELECT * FROM categories";
								rs=stmt.executeQuery(SQL_1);
								int c_id=0;
								String c_name=null;
								while(rs.next())
								{
									c_id=rs.getInt(1);
									c_name=rs.getString(2);
									out.println("<option value=\""+c_name+"\">"+c_name+"</option>");
								}
%>
						</select>
					</td>
					<input type="hidden" name="search_Key_3" id="search_key_3" value="0">
<!--  					<td>
						<select name="search_key_3" id="search_key_3">
							<option value="0" selected="selected">All Ages</option>
							<option value="12_18">12-18</option>
							<option value="18_45">18-45</option>
							<option value="45_65">45-65</option>
							<option value="65_100">65-</option>
						</select>
					</td>  -->
				</tr>
			</table>
		</td>
		<td>
			<input type="button" value="Run Query" onClick="doSearch()">
		</td>
	</tr>
</table>
<div>
<div id="results" style="position:absolute; top:75px; left:0px; width:100%;">
</div>
<%	
}
catch(Exception e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}	
//}	
%>

</body>
</html>