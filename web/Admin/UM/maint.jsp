<%-- 
    Document   : createForUser
    Created on : Nov 16, 2023, 1:21:17 PM
    Author     : wong jing jie
--%>



<%@page import="java.util.Locale"%>
<%@page import="com.aurora.Utility.HParam"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.aurora.Utility.WebMisc"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="search" uri="http://aurora-rms.asia/tags/search" %>
<%@taglib prefix="modal" uri="http://aurora-rms.asia/tags/modal" %>

<head>
    <!-- Basic Page Info -->
    <title>DeskApp - Bootstrap Admin Dashboard HTML Template</title>

    <!-- Site favicon -->
    <link rel="apple-touch-icon" sizes="180x180" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-16x16.png">

    <!-- Mobile Specific Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <script
        src="https://code.jquery.com/jquery-3.6.3.js"
        integrity="sha256-nQLuAZGRRcILA+6dMBOvcRh5Pe310sBpanc6+QBmyVM="
    crossorigin="anonymous"></script>
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/core.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/icon-font.min.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/css/responsive.bootstrap4.min.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/style.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/bootstrap-touchspin/jquery.bootstrap-touchspin.css">
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/switchery/switchery.min.css">
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
<%!
    private static final String SESSION_NAME = "groupResult";
    private static final String PAGE_TITLE = "Group Maintenance";
    private static final String SEARCH_URL = "API/Web/group/search";
    private static final String RESP_FIELD = "groups";
%>
<%

    String data = "";

    if (session.getAttribute("groupResult") != null) {
        data = (String) session.getAttribute("groupResult");
    }

    String SID = request.getParameter("SID");

%>
<body >

    <div class="col-md-12 col-sm-12 mb-30">

        <div class="row ml-1"> 
            <h5 class="h4 text-blue">New User</h5>

        </div>

        <div class="row justify-content-end align-items-end mr-10">
            <button type="button" class="btn btn-primary align-items-end mr-2" id="backBtn" >
                Back 
            </button>
            <div >
                <button id="saveBtn" type="submit" class="btn btn-success align-items-end" >
                    Create
                </button>
            </div>
        </div>
        <div class="pd-20 card-box">
            <div class="tab">
                <ul class="nav nav-tabs customtab" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-toggle="tab" href="#home2" role="tab" aria-selected="true">Details</a>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="home2" role="tabpanel">
                        <div class="pd-20">
                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>User ID</label>
                                        <input id="userID" type="text" class="form-control" required>
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input id="password" type="password" class="form-control" required>
                                        <div class="alert alert-danger" id="passwordAlert" style="display: none;"></div>
                                    </div>
                                </div>      
                            </div>

                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>First Name</label>
                                        <input id="firstName" type="text" class="form-control" required>
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Last Name</label>
                                        <input id="lastName" type="text" class="form-control" required>
                                    </div>
                                </div>      
                            </div>

                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Email</label>
                                        <input id="email" type="text" class="form-control" required>
                                        <div class="alert alert-danger" id="emailAlert" style="display: none;"></div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Allow Void</label>
                                        <select class="form-control" id="authorization" name="allowVoid" required>
                                            <option value="Y">Yes</option>
                                            <option value="N">No</option>
                                        </select>
                                    </div>
                                </div>      
                            </div>

                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Title</label>
                                        <input id="title" type="text" class="form-control" required>
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Authorization</label>
                                        <select class="form-control" id="authorization" name="authorization" required>
                                            <option value="A">Super Admin</option>
                                            <option value="M">Management</option>
                                            <option value="S">Staff</option>
                                        </select>
                                    </div>
                                </div>      
                            </div>

                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Date Create</label>
                                        <input id="dateCreate" type="text" class="form-control date-picker activate" disabled="">
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Create By</label>
                                        <input id="createBy" type="text" class="form-control" disabled="">
                                    </div>
                                </div>      
                            </div>

                            <div class="row">
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <div class="form-group">
                                            <label>User Status</label>
                                            <select class="form-control" id="userActive" name="userActive" required>
                                                <option value="Y">Active</option>
                                                <option value="N">Non-Active</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Contact Number</label>
                                        <input id="contactNumber" type="text" class="form-control" >
                                    </div>
                                    <div class="alert alert-danger" id="contactNumberAlert" style="display: none;"></div>
                                </div>      
                            </div>

                            <div class="row">

                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>User Pin</label>
                                        <input id="userPin" type="text" class="form-control" >
                                    </div>
                                    <div class="alert alert-danger" id="userPinAlert" style="display: none;"></div>
                                </div>      
                            </div>

                        </div>

                    </div>
                </div>
            </div>
        </div>


        <modal:loader
            clazz="modal fade"
            aria_labelledby="loaderModal"
            message="Please wait for a moment..."
        path="<%= WebMisc.getCoreIP()%>"
            />
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/core.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/script.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/process.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/layout-settings.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/core_scripts.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/jquery.dataTables.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/dataTables.bootstrap4.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/dataTables.responsive.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/datatables/js/responsive.bootstrap4.min.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/datatable-setting.js"></script>
        <!-- Switchery -->
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/switchery/switchery.min.js"></script>
        <!-- TouchSpin -->
        <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/bootstrap-touchspin/jquery.bootstrap-touchspin.js"></script>
        <script src="<%= WebMisc.getCoreIP()%>/Admin/vendors/scripts/advanced-components.js"></script>


        <script>
        $(document).ready(function ()
        {
            $('#userPin').on('input', function () {
                var userPin = $(this).val();

                // Check if the input contains only 6 numeric digits
                if (/^\d{6}$/.test(userPin)) {
                    // Valid input, hide the alert
                    $('#userPinAlert').hide();
                } else {
                    // Invalid input, show alert
                    $('#userPinAlert').show().text('User Pin must be 6 numeric digits');
                }

                // Restrict input after 6 digits
                if (userPin.length > 6) {
                    $(this).val(userPin.slice(0, 6));
                }
            });
            $('#createBy').val(session.get("UID"));
            $(".activate").val(today());
            $('#dateCreate').text(today());
            $("#contactNumber").on("input", function () {
                // Get the input value
                var inputValue = $(this).val();
                // Remove any non-numeric characters
                var numericValue = inputValue.replace(/\D/g, '');

                // Validate the length and ensure it's numeric
                if (numericValue.length > 0 && (!/^\d+$/.test(numericValue) || numericValue.length < 10 || numericValue.length > 11 || !/^0/.test(numericValue))) {
                    // Display an error message
                    $("#contactNumberAlert").text("Contact number must start with 0 and be a numeric value between 10 and 11 digits.");
                    $("#contactNumberAlert").show();
                } else {
                    // Clear the error message
                    $("#contactNumberAlert").text("");
                    $("#contactNumberAlert").hide();
                }
            });

            // Additional validation when the input loses focus
            $("#contactNumber").on("blur", function () {
                var numericValue = $(this).val().replace(/\D/g, '');
                if (numericValue.length < 10 || numericValue.length > 11 || !/^0/.test(numericValue)) {
                    // Clear input and display an error message
                    $(this).val("");
                    $("#contactNumberAlert").text("Contact number must start with 0 and be a numeric value between 10 and 11 digits.");
                    $("#contactNumberAlert").show();
                }
            });
            console.log($("#contactNumber"));
            $("#email").on("blur", function () {
                // Get the input value
                var emailValue = $(this).val();
                // Validate email format
                if (!isValidEmail(emailValue)) {
                    // Display an error message
                    $("#emailAlert").text("Email must have a valid format (e.g., example@example.com).");
                    $("#emailAlert").show();
                } else {
                    // Check if the email contains at least one character
                    if (emailValue.length === 0) {
                        // Display an error message
                        $("#emailAlert").text("Email must have at least one character.");
                        $("#emailAlert").show();
                    } else {
                        // Clear the error message
                        $("#emailAlert").text("");
                        $("#emailAlert").hide();
                    }
                }
            });
            // Function to validate email format
            function isValidEmail(email) {
                // Regular expression for validating an Email
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }

            $("#password").on("blur", function () {
                // Get the input value
                var passwordValue = $(this).val();
                // Validate password format
                if (!isValidPassword(passwordValue)) {
                    // Display an error message
                    $("#passwordAlert").text("Password must be 8 to 16 characters long, with at least one lowercase letter, one uppercase letter, and one symbol.");
                    $("#passwordAlert").show();
                    // Clear the input
                    $(this).val("");
                } else {
                    // Check if the password contains at least one character
                    if (passwordValue.length === 0) {
                        // Display an error message
                        $("#passwordAlert").text("Password must have at least one character.");
                        $("#passwordAlert").show();
                    } else {
                        // Clear the error message
                        $("#passwordAlert").text("");
                        $("#passwordAlert").hide();
                    }
                }
            });
            // Function to validate password format
            function isValidPassword(password) {
                // Regular expressions for password validation
                var lengthRegex = /^.{8,16}$/;
                var lowercaseRegex = /[a-z]/;
                var uppercaseRegex = /[A-Z]/;
                var symbolRegex = /[!@#$%^&*(),.?":{}|<>]/;
                // Check all conditions
                return lengthRegex.test(password) &&
                        lowercaseRegex.test(password) &&
                        uppercaseRegex.test(password) &&
                        symbolRegex.test(password);
            }



            function today()
            {
                var d = new Date();
                var curr_date = d.getDate();
                var curr_month = d.getMonth() + 1;
                var curr_year = d.getFullYear();
                var str_date = "", str_month = "";
                if (curr_month < 10)
                    str_month = '0' + curr_month;
                else
                    str_month = curr_month + "";
                if (curr_date < 10)
                    str_date = '0' + curr_date;
                else
                    str_date = curr_date + "";
                return curr_year + "-" + str_month + "-" + str_date;
            }

            function hasErrors() {
                // Check for errors and display an alert message
                if ($("#emailAlert").is(":visible") || $("#passwordAlert").is(":visible") || $("#contactNumberAlert").is(":visible")) {
                    alert('Please fix the errors before saving.');
                    return true;
                } else {
                    // Clear any previous error messages
                    $("#emailAlert, #passwordAlert, #contactNumberAlert").hide();
                    return false;
                }
            }

            $('#backBtn').click(function ()
            {
                console.log("Triggered Back Button");
                window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/UM/search.jsp';
//                history.back();
            });
            $('#saveBtn').click(function ()
            {
                if (hasErrors()) {
                    // Do not perform save operation if there are errors
                    return;
                }
                console.log("'Test Create Button");
                $("#loader-modal").modal("show");
                var data = {
                    "entity":
                            [
                                {
                                    "groupId": $("#groupId").val(),
                                    "groupName": $("#groupName").val(),
                                    "groupActiveCd": $("#groupActiveCd").val(),
                                    "userId": session.get("USR_ID", "")
                                }
                            ]

                };
                console.log("Data From Create Group Master Maintenance.");
                console.log(data);
                request.post({
                    baseUrl: '<%= WebMisc.getMasterIP()%>',
                    url: '/API/Web/grp/create',
                    data: data,
                    authUrl: "<%= WebMisc.getCoreIP()%>",
                    accessID: session.get("SID", ""),
                    authToken: true
                }).then((response) => {
                    $("#loader-modal").modal("hide");
                    console.log("After Hide Model");
                    if (response.data.token !== null)
                    {
                        console.log(response.data.token);
                        session.set("X-AUTH-TOKEN", response.data.token);
                        window.location.href = '<%= WebMisc.getMasterIP()%>/Admin/MT/GRP/search.jsp?mode=success';
                    } else
                    {
                        console.log("Response is NULL!");
                        var messages = response.message;
                        swal(
                                {
                                    type: 'error',
                                    title: 'Unexpected Error!',
                                    text: response.message
                                }
                        );
                    }
                });
            });
        }
        );
        </script>
</body>


