<%-- 
    Document   : UserManagementSearch
    Created on : 16 Nov 2023, 12:15:18 pm
    Author     : jingjie
--%>
<%@page import="com.aurora.Model.SearchObject"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@page import="com.aurora.Utility.WebMisc"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="search" uri="http://aurora-rms.asia/tags/search" %>
<%@taglib prefix="modal" uri="http://aurora-rms.asia/tags/modal" %>
<!DOCTYPE html>
<html>
    <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/jquery-min.js"></script>
    <head>

        <!-- Basic Page Info -->
        <title>AURORA User Management Search</title>

        <!-- Site favicon -->
        <link rel="apple-touch-icon" sizes="180x180" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-16x16.png">

        <!-- Mobile Specific Metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/core.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/icon-font.min.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/css/dataTables.bootstrap4.min.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/css/responsive.bootstrap4.min.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/style.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/autocomplete.css">

        <!-- Global site tag (gtag.js) - Google Analytics -->

    </head>

    <%!
        private static final String SESSION_NAME = "userMngResult"; // item result set into the web session
        private static final String PAGE_TITLE = "User Management"; // Header Name for search
        private static final String SEARCH_URL = "Aurora/API/Web/um/search"; // refer to API Documentation
        private static final String RESP_FIELD = "userMng"; // indicate where to find the data
%>
    <%
        String data = "";

        if (session.getAttribute(SESSION_NAME) != null) {
            data = (String) session.getAttribute(SESSION_NAME);
        }

        if (session.getAttribute("USR_ID") == null) {
            session.setAttribute("USR_ID", request.getParameter("UID"));
        }

        String SID = request.getParameter("SID");

        System.out.println("Core IP:" + WebMisc.getCoreIP());
    %>

    <body>
        <%-- 
            Search:Header 
        
                title = This is to indicate title name on the HTML Page
                searchUrl = This is to indicate the URL to the API
                sessionName = This is to indicate the sessionName where the response will be set
                token = This is to indicate whether or not token is used during search
                responseField = This is the field name of the API where the datatable should populate
                fields = This is a json that indicate the search fields to include

        --%>
        <search:header 
        title="<%= PAGE_TITLE%>"
        server='<%= WebMisc.getIPAddr("GENERAL")%>'
        searchUrl="<%= SEARCH_URL%>"
        sessionName="<%= SESSION_NAME%>"          
            token="true"
        accessID="<%= SID%>"        
        responseField="<%= RESP_FIELD%>"             
            fields="{\"objects\":[
            {
            \"label\" : \"User ID\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"userID\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"First Name\", 
            \"apiInputID\" : \"firstName\",
            \"type\" : \"autocomplete\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Last Name\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"lastName\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"User Email\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"email\"
            },
            {
            \"label\" : \"Title\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"title\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Authorization\", 
            \"apiInputID\" : \"authorization\",
            \"type\" : \"option\",
            \"options\" : [
            {
            \"display\" : \"Super Admin\",
            \"value\" : \"A\"
            },
            {
            \"display\" : \"Management\",
            \"value\" : \"M\"
            },
            {
            \"display\" : \"Staff\",
            \"value\" : \"S\"
            }]
            },
            {
            \"label\" : \"Created Date\", 
            \"type\" : \"date\",
            \"apiInputID\" : \"createdDate\"
            }
            ]}"
            />         
        <div class="row pb-20 mr-10 justify-content-end align-items-end">
            <button type="button" class="btn btn-success " onclick="javascript:maint('new')">
                <i class="icon-copy fa fa-plus" aria-hidden="true"></i>
                Add Record
            </button>
        </div>
        <div class="card-box mb-30">
            <div class="pb-20 pd-20">
                <search:datatable
                    header="{
                    \"header\" : [
                    {
                    \"label\" : \"User ID\",
                    \"clazz\" : \"table-plus\",
                    \"apiField\" : \"userID\"

                    },
                    {
                    \"label\" : \"First Name\",
                    \"apiField\" : \"firstName\"
                    },
                    {
                    \"label\" : \"Last Name\",
                    \"apiField\" : \"lastName\"
                    },
                    {
                    \"label\" : \"User Email\",
                    \"apiField\" : \"email\"
                    },
                    {
                    \"label\" : \"Title\",
                    \"apiField\" : \"title\"
                    },
                    {
                    \"label\" : \"Authorization\",
                    \"apiField\" : \"authorization\"
                    },
                    {
                    \"label\" : \"Create Date\",
                    \"apiField\" : \"createDate\"
                    },
                    {
                    \"label\" : \"Last Version\",
                    \"apiField\" : \"lastVersion\",
                    \"hidden\" : \"true\"

                    }


                    ]}"
                json="<%= data%>"
                    className="com.aurora.API.Bean.Web.UserMngSearchResult"
                    />
            </div>
        </div>

        <modal:loader
            clazz="modal fade"
            aria_labelledby="loaderModal"
            message="Please wait for a moment..."
        path="<%= WebMisc.getCoreIP()%>"
            />
        <script>
            $(document).ready(function () {
                if ('<%= request.getParameter("mode")%>' === 'success')
                    search();
            });
            function maint(mode, data)
            {
                console.log(mode);
                session.set("USR_ID", "<%= request.getParameter("UID")%>");
                session.set("SID", '<%= SID%>');
                if (mode === 'new')
                {
                    window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/UM/maint.jsp'
                } else if ('view' === mode || 'edit' === mode)
                {
                    $("#loader-modal").modal("show");

                    request.get({
                        baseUrl: '<%= (StringUtils.endsWith(WebMisc.getCoreIP(), "/") ? WebMisc.getCoreIP() : WebMisc.getCoreIP() + "/")%>',
                        authUrl: '<%= WebMisc.getCoreIP()%>',
                        accessID: '<%= SID%>',
                        url: 'API/Web/um/view', // API always using view as it grabs info only
                        data: {
                            groupId: data[0],
                            lastVersion: data[7]
                        },
                        authToken: true
                    }).then((response) => {
                        $("#loader-modal").modal("hide");
                        if (response.status === 'ok')
                        {
                            session.set("groupData", response.data);
                            window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/UM/editView.jsp?mode=' + mode
                        } else
                        {
                                                  console.error('<%= WebMisc.getCoreIP()%>/Admin/UM/editView.jsp?mode=' + mode);


                            swal(
                                    {
                                        type: 'error',
                                        title: 'Unexpected Error!',
                                        html: response.message
                                    }
                            );
                        }
                    });
                } else if ('delete' === mode)
                {
                    request.post({
                        baseUrl: '<%= (StringUtils.endsWith(WebMisc.getCoreIP(), "/") ? WebMisc.getCoreIP() : WebMisc.getCoreIP() + "/")%>',
                        authUrl: '<%= WebMisc.getCoreIP()%>',
                        accessID: '<%= SID%>',
                        url: 'API/Web/um/delete',
                        data: {
                            entity: [{
                                    userID: data[0],
                                    lastVersion: data[7]
                                }]
                        },
                        authToken: true
                    }).then((response) => {
                        $("#loader-modal").modal("hide");
                        if (response.status === 'ok')
                        {
                            swal(
                                    {
                                        type: 'success',
                                        title: 'Successfully Deactivated!',
                                        message: "The record has been deactivated!"
                                    }
                            )
                            search($('#pageNumber').val());
                        } else
                        {
                            swal(
                                    {
                                        type: 'error',
                                        title: 'Unexpected Error!',
                                        html: response.message
                                    }
                            )
                        }
                    });
                }

            }
        </script>

        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/core.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/script.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/process.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/layout-settings.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/core_scripts.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/autocomplete.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/jquery.dataTables.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/dataTables.bootstrap4.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/dataTables.responsive.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/responsive.bootstrap4.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/datatable-setting.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweetalert2.all.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweet-alert.init.js"></script>
    </body>
</html>
