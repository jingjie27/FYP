<%-- 
    Document   : loadLogin
    Created on : May 1, 2022, 9:22:12 PM
    Author     : henry
--%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.aurora.Utility.HParam"%>
<%@page import="com.aurora.API.Bean.Web.LoginResult"%>
<%@page import="java.util.List"%>
<%@page import="com.aurora.Model.Util.HttpResponseStatus"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.aurora.Utility.WebMisc"%>
<link rel="icon" type="image/png" sizes="32x32" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/favicon-16x16.png">

<title>Redirecting... Do Not Refresh</title>
<% 
    String entityString = "";
    for(Cookie cookie : request.getCookies())
    {
        
        System.out.println(cookie.getName());
        
        if(StringUtils.equals(cookie.getName(), "LOGIN_INFO"))
            entityString = cookie.getValue().replaceAll("%44", ",").replaceAll("'", "\"").replaceAll("%32", " ");
       
       
    }
    LoginResult result = (LoginResult) WebMisc.entity(entityString, LoginResult.class);
    HParam loginInfo = new HParam();
    
    System.out.println("Entity = " + entityString);
    System.out.println("Result = " + result.getUserId());
    
    loginInfo.put("USR_ID", result.getUserId());
    loginInfo.put("FIRST_NAME", StringUtils.defaultIfEmpty(result.getFirstName(), ""));
    loginInfo.put("LAST_NAME", StringUtils.defaultIfEmpty(result.getLastName(), ""));
    loginInfo.put("USR_EMAIL", StringUtils.defaultIfEmpty(result.getUserEmail(),""));
    loginInfo.put("ALLOW_VOID", StringUtils.defaultIfEmpty(result.getAllowVoid(),""));
    loginInfo.put("AUTH_LVL", StringUtils.defaultIfEmpty(result.getAuthorization(),""));

    
    session.setAttribute("LOGIN_USER", loginInfo);
    
    System.out.println("REDIRECT = "+ request.getSession().getId());
    WebMisc.setMenuNavigation(request, entityString);
//    WebMisc.setToken(request, response, result.getToken());
//    WebMisc.clearResponse(request);

%>


<script>

window.open('<%= WebMisc.getContextPath(request) %>/Admin/index.jsp','',"top=0,left=0,width="  +
(window.screen.availWidth ) + ",height=" +
(window.screen.availHeight - 50) +
",status=1,toolbar=0,menubar=0,location=0,resizable=1");
window.opener='Self'; 
window.open('','_parent',''); 
window.close();

</script>
