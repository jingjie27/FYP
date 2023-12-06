<%-- 
    Document   : setSession
    Created on : 14 Sep 2023, 9:44:51 pm
    Author     : henry
--%>

<%@page import="com.aurora.Utility.WebMisc"%>
<%@page contentType="text/html" pageEncoding="windows-1256"%>
<!DOCTYPE html>
<html>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1256">
        <title>Redirecting...</title>
    </head>
    <script>
        $(document).ready(function ()
        {
            var value = session.get("UID", "");
            if (typeof (value) === "undefined" || value === "")
                session.set("UID", '<%= request.getParameter("UID") %>');
            window.location.replace('<%=request.getParameter("redirect")%>' + "?SID=" + session.get('SID', '') +
                                "&UID=" + session.get("UID","") ;

        });
    </script>
    <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/core_scripts.js"></script>
    
</html>
