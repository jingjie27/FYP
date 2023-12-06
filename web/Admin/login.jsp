<%@page import="com.aurora.Utility.WebMisc"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Collection"%>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<%@taglib prefix="modal" uri="http://aurora-rms.asia/tags/modal" %>

<!DOCTYPE html>
<%
    System.out.println("Login Session =" + session.getId());

%>
<html>
    <head>
        <!-- Basic Page Info -->
        <meta charset="utf-8">
        <title>AURORA BOS</title>
        <!-- Site favicon -->
        <link rel="apple-touch-icon" sizes="180x180" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/apple-touch-icon.png">
        <link rel="icon" type="image/png" sizes="32x32" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/favicon-32x32.png">
        <link rel="icon" type="image/png" sizes="16x16" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/favicon-16x16.png">

        <!-- Mobile Specific Metas -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js" type="text/javascript"></script> 
        <!-- CSS -->
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/styles/core.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/styles/icon-font.min.css">
        <link rel="stylesheet" type="text/css" href="<%= WebMisc.getContextPath(request) %>/Admin/vendors/styles/style.css">

        <!-- Global site tag (gtag.js) - Google Analytics -->
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-119386393-1"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag()
            {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());

            gtag('config', 'UA-119386393-1');
        </script>
    </head>
    <body class="login-page">
        <div class="login-header box-shadow">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <div class="brand-logo">
                    <a href="login.html">
                        <img src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/aurora-logo-2.png" alt="">
                    </a>
                </div>
                <div class="brand-logo">
                    <a>
                        <img src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/client_logo.png" style="height: 70px; width: 70px;" alt="">
                    </a>
                </div>
                <!-- <div class="brand-logo">
                    <img src="vendors/images/client_logo.png" sizes="50x50" alt="">
                </div> -->
                <!-- <div class="align-items-center">
                        <ul>
                                <li><img src="vendors/images/client_logo.png" style="height: 70px; width: 70px;" alt=""></li>
                        </ul>
                </div> -->
            </div>
        </div>
        <div class="login-wrap d-flex align-items-center flex-wrap justify-content-center">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-md-6 col-lg-7">
                        <img src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/images/login-page-img.png" alt="">
                    </div>
                    <div class="col-md-6 col-lg-5">
                        <div class="login-box bg-white box-shadow border-radius-10">
                            <div class="login-title">
                                <h2 class="text-center text-primary">AURORA Admin Portal</h2>
                            </div>
                            <form id="FORM" action="<%= WebMisc.getContextPath(request) %>/ProcessRoute" method="POST">
                                <!-- <div class="select-role">
                                        <div class="btn-group btn-group-toggle" data-toggle="buttons">
                                                <label class="btn active">
                                                        <input type="radio" name="options" id="admin">
                                                        <div class="icon"><img src="vendors/images/briefcase.svg" class="svg" alt=""></div>
                                                        <span>I'm</span>
                                                        Manager
                                                </label>
                                                <label class="btn">
                                                        <input type="radio" name="options" id="user">
                                                        <div class="icon"><img src="vendors/images/person.svg" class="svg" alt=""></div>
                                                        <span>I'm</span>
                                                        Employee
                                                </label>
                                        </div>
                                </div> -->
                                <div class="input-group custom">
                                    <input type="text" class="form-control form-control-lg" placeholder="Username" id="userId" name="userId">
                                    <div class="input-group-append custom">
                                        <span class="input-group-text"><i class="icon-copy dw dw-user1"></i></span>
                                    </div>
                                </div>
                                <div class="input-group custom">
                                    <input type="password" class="form-control form-control-lg" placeholder="**********" id="password" name="password">
                                    <div class="input-group-append custom">
                                        <span class="input-group-text"><i class="dw dw-padlock1"></i></span>
                                    </div>
                                </div>
                                <div class="row pb-30">
                                    <div class="col-6">
                                        <!-- <div class="custom-control custom-checkbox">
                                                <input type="checkbox" class="custom-control-input" id="customCheck1">
                                                <label class="custom-control-label" for="customCheck1">Remember</label>
                                        </div> -->
                                    </div>
                                    <div class="col-6">
                                        <div class="forgot-password"><a href="forgot-password.html">Forgot Password</a></div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="input-group mb-0">
                                            <!--
                                                    use code for form submit
                                                    <input class="btn btn-primary btn-lg btn-block" type="submit" value="Sign In">
                                            -->
                                            <a id="submitButton" class="btn btn-primary btn-lg btn-block"  style="color: '#FFF'" href="javascript:login()">Sign In</a>
                                        </div>
                                        <!-- <div class="font-16 weight-600 pt-10 pb-10 text-center" data-color="#707373">OR</div> -->
                                        <!-- <div class="input-group mb-0">
                                                <a class="btn btn-outline-primary btn-lg btn-block" href="register.html">Register To Create Account</a>
                                        </div> -->
                                    </div>
                                </div>
                                <input name="CTRL_ID" type="hidden" value="ADMIN_LOGIN"/>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <modal:loader
                    clazz="modal fade"
                    aria_labelledby="loaderModal"
                    message="Please wait for a moment..."
                    path="<%= WebMisc.getCoreIP() %>"
            />
            <div class="modal fade" id="alert-modal" tabindex="-1" role="dialog" aria-labelledby="alertModal" aria-hidden="true">
                    <div class="modal-dialog modal-sm modal-dialog-centered">
                        <div class="modal-content bg-danger text-white">
                            <div class="modal-body text-center">
                                <h3 class="text-white mb-15"><i class="fa fa-exclamation-triangle"></i> Alert</h3>
                                <p id="errorMessage"></p>
                               
                                <button type="button" class="btn btn-light" data-dismiss="modal">Ok</button>
                            </div>
                        </div>
                    </div>
            </div>                    
                 
        </div>
        <!-- js -->
        <script src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/scripts/core.js"></script>
        <script src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/scripts/script.min.js"></script>
        <script src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/scripts/process.js"></script>
        <script src="<%= WebMisc.getContextPath(request) %>/Admin/vendors/scripts/layout-settings.js"></script>
        <script src="<%= WebMisc.getContextPath(request) %>/Admin/scripts/core_scripts.js"></script>
        <script>
//        function login()
//        {
//            console.log("LOGIN");
//            document.getElementById("FORM").target = "_top";
//            document.getElementById("FORM").submit();
//        }
        
        function login()
        {
            $("#loader-modal").modal("show")
            request.post({
                baseUrl: '<%= WebMisc.getIPAddr() %>',
                url : '/API/Web/login',
                headers : {
                    "X-Auth-User" : document.getElementById("userId").value
                },
                data : {
                    'entity' : {
                        'userId' : document.getElementById("userId").value,
                        'password' : document.getElementById('password').value
                    }
                }
            }).then((response) => {
                console.log(response)
                
                if(response['status'] === 'ok')
                {
                    let entityJson = {};
                    let SID = response.data.userId + new Date().getTime();
                    
                    entityJson["entity"] = response.data;
                    session.set("<%= WebMisc.TOKEN_NAME %>", response.data.token);
                    session.set("SID",SID)
                    request.post({
                        baseUrl :"<%= WebMisc.getIPAddr()%>",
                        url : '/API/common/session/login',
                        data : entityJson,
                        headers : {
                            "X-Access-ID" : SID,
                            "X-Auth-User" : response.data.userId
                        }
                    }).then((sessionResp) => {
                        setTimeout(function () { $("#loader-modal").modal("hide"); } , 1000);
                        
                        if(sessionResp["status"] === "ok")
                        {
                            window.close();
                            window.open('<%= WebMisc.getCoreIP() %>/Admin/index.jsp','',"top=0,left=0,width="  +
                            (window.screen.availWidth ) + ",height=" +
                            (window.screen.availHeight - 50) +
                            ",status=1,toolbar=0,menubar=0,location=0,resizable=1");
                            window.opener='Self'; 
                            window.open('','_parent',''); 
                            console.log(sessionResp)
                        }
                    })
                    
//                    let entityJson = {};
//                    entityJson["entity"] = response.data;
//                    
//                    document.cookie = "XAUTHTOKEN=testing;Path=/;"
//                    cookie.set("<%= WebMisc.TOKEN_NAME %>", response.data.token);
//                    cookie.setJson("LOGIN_INFO", entityJson);
////                    window.location.href = "<%= WebMisc.getContextPath(request) %>/Admin/redirect.jsp";
                }
                else if(response['status'] === 'error')
                {
                    console.log(response['message'])
                    document.getElementById("errorMessage").innerHTML = response['message'];
                    $("#alert-modal").modal("show");
                }
                    
            })
        }



        </script>
    </body>
</html>