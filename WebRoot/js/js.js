function $(ID)
{
	return document.getElementById(ID);
}
function change()
{

	$("currentFlag_row").value=0;
	$("currentFlag_col").value=0;
	$("search_key_1").disabled = false;
	$("search_key_2").disabled = false;
	$("search_key_3").disabled = false;
   $("results").style.display="none";	//dis the results
   
}
function doNext20()
{
	var flag=Number($("currentFlag_row").value);
	$("currentFlag_row").value=flag+20;
	$("search_key_1").disabled = true;
	$("search_key_2").disabled = true;
	$("search_key_3").disabled = true;
	doSearch();
}
function doNext10()
{
	var flag=Number($("currentFlag_col").value);
	$("currentFlag_col").value=flag+10;
	$("search_key_1").disabled = true;
	$("search_key_2").disabled = true;
	$("search_key_3").disabled = true;
	doSearch();
}
function doSearch()
{
	$("results").innerHTML="";
	$("results").innerHTML="Caculating...<br><img src='images/bar.gif'/>";	
	 $("results").style.display="";//show results
	var type=$("search_key").value;
	var url="";
	 var pos_row=$("currentFlag_row").value;
	 var pos_col=$("currentFlag_col").value;
	 var state=$("search_key_1").value;
	 var category=$("search_key_2").value;
	 var age=$("search_key_3").value;
	if(type==1)//customer
	{
		
          url = "do_Analysis_Customers.jsp?pos_row="+pos_row+"&&pos_col="+pos_col+"&&state="+state+"&&category="+category+"&&age="+age;
	}
	else//state
	{
		   url = "do_Analysis_States.jsp?pos_row="+pos_row+"&&pos_col="+pos_col+"&&state="+state+"&&category="+category+"&&age="+age;
	}
	var req = getAjax();
	req.open("GET", url, true);
	req.onreadystatechange = function()
	{
		if(req.readyState==4)
		{
			var re = req.responseText;//获取返回的内容
			
			$("results").innerHTML=re;
		}
	};
	req.send(null);	
}


function getAjax()
{
	var oHttpReq = null;
	if(window.XMLHttpRequest)   
	{   //Mozilla 
		oHttpReq   =   new   XMLHttpRequest(); 
		if(oHttpReq.overrideMimeType)
	   { 
		   oHttpReq.overrideMimeType( 'text/xml '); 
	   } 
	}
	else if(window.ActiveXObject)
	{   //   IE 
	   try
	   { 
		   oHttpReq   =   new   ActiveXObject( "Msxml2.XMLHTTP "); 
	   }
	   catch(e)
	   { 
		   try
		   { 
			  oHttpReq   =   new   ActiveXObject( "Microsoft.XMLHTTP "); 
		   }
		   catch(e){} 
		}
	}
	return oHttpReq;
}
