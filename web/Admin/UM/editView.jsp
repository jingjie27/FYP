<%-- 
    Document   : UserManagement - editView
    Created on : 16 Nov 2023, 12:15:18 pm
    Author     : jingjie
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
    <title>User Management Edit View</title>

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

<%
    boolean isViewMode = StringUtils.equalsAnyIgnoreCase(request.getParameter("mode"), "view");
    String data = "";

    if (session.getAttribute("groupResult") != null) {
        data = (String) session.getAttribute("groupResult");
    }

%>
<body >

    <div class="col-md-12 col-sm-12 mb-30">
        <div class="row col-md-12 pt-10 pb-10 pl-20"> 
            <div style="flex : 2; display: flex;  align-items: center">
                <div>
                    <h5 class="h4 text-blue"><%= StringUtils.capitalize(request.getParameter("mode"))%> Group</h5>
                </div>
            </div>
            <div style="flex : 1;display: flex; justify-content: flex-end; align-items: flex-end">
                <button type="button" class="btn btn-primary align-items-end mr-2" id="backBtn" >
                    Back 
                </button>
                <% if (!StringUtils.equalsAnyIgnoreCase(request.getParameter("mode"), "view")) { %>
                <button type="submit" class="btn btn-success align-items-end" id="saveBtn" >
                    Save 
                </button>
                <% }%>
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
                                        <input id="userID" type="text" class="form-control" disabled="">
                                    </div>
                                </div>
                                <div class="col-md-6 col-sm-12">
                                    <div class="form-group">
                                        <label>Password</label>
                                        <input id="password" type="text" class="form-control" required>
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
                                        <select class="form-control" id="allowVoid" name="allowVoid" required>
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


        function populateData(userData) {
            $("#userID").val(userData.userID);
            $("#firstName").val(userData.firstName);
            $("#lastName").val(userData.lastName);
            $("#password").val(userData.userPsw);
            $("#email").val(userData.email);
            $("#contactNumber").val(userData.contactNumber);
            $("#title").val(userData.title);
            $("#createBy").val(userData.createBy);
            $("#dateCreate").val(userData.dateCreate);
            $("#userActive").val(userData.userStatus);
            $("#allowVoid").val(userData.allowVoid);
            $("#authorization").val(userData.authorization);

            console.log("Populated Data:");
            console.log(userData);
        }

        var data = session.get("userMngData", null);

        if (data !== null) {
            populateData(data);
        } else {
            console.error("Session data is null or in an unexpected format.");
        }


        $(document).ready(function ()
        {

            var data = session.get("userMngData", null);
            if (data !== null) {
                populateData(data);
            } else {
                console.error("Session data is null or in an unexpected format.");
            }



            $('#createBy').val(session.get("UID"));
            $(".activate").val(today());
            $('#dateCreate').text(today());
            $("#contactNumber").on("input", function () {
                // Get the input value
                var inputValue = $(this).val();

                // Remove any non-numeric characters
                var numericValue = inputValue.replace(/\D/g, '');

                // Format the numeric value with spaces after the first 3 digits
                var formattedValue = numericValue.replace(/(\d{3})(\d{1,8})?(\d{0,7})?/, function (match, p1, p2, p3) {
                    return [p1, p2 && ' ' + p2, p3].filter(Boolean).join('');
                });

                // Update the input value with the formatted value
                $(this).val(formattedValue);

                // Validate the length and ensure it's numeric
                if (numericValue.length > 0 && (!/^\d+$/.test(numericValue) || numericValue.length < 10 || numericValue.length > 11)) {
                    // Display an error message
                    $("#contactNumberAlert").text("Contact number must be a numeric value between 10 and 11 digits.");
                    $("#contactNumberAlert").show();
                } else {
                    // Clear the error message
                    $("#contactNumberAlert").text("");
                    $("#contactNumberAlert").hide();
                }


//                if ("<%= request.getParameter("mode") != null && request.getParameter("mode").equalsIgnoreCase("view")%>") {
//                    $("input, select").prop("disabled", true);
//                    $("#saveBtn").hide();
//                } else {
//                    console.log("<%= request.getParameter("mode")%>");
//                }

            });

            // Additional validation when the input loses focus
            $("#contactNumber").on("blur", function () {
                var numericValue = $(this).val().replace(/\D/g, '');

                if (numericValue.length > 11) {
                    // Clear input and display an error message
                    $(this).val("");
                    $("#contactNumberAlert").text("Contact number must be a numeric value between 10 and 11 digits.");
                    $("#contactNumberAlert").show();
                }
            });

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

            $('#backBtn').click(function ()
            {
                console.log("Triggered Back Button");
//                window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/UM/search.jsp';
                history.back();
            });

            $('#saveBtn').click(function ()
            {
                var sessionData = session.get("userMngData", null);

//     var newPassword = document.getElementById("password");
//        if (newPassword && newPassword.value) {
//          sessionData.userPsw = newPassword.value;
//        }

                console.log(password);
                $("#loader-modal").modal("show");
                var data = {
                    "entity": [
                        {
                            "userID": sessionData.userID,
                            "userPsw": $("#password").val(),
                            "userPin": sessionData.userPin,
                            "firstName": $("#firstName").val(),
                            "lastName": $("#lastName").val(),
                            "email": $("#email").val(),
                            "allowVoid": $("#allowVoid").val(),
                            "title": $("#title").val(),
                            "authorization": $("#authorization").val(),
                            "dateCreate": sessionData.dateCreate,
                            "createBy": sessionData.createBy,
                            "userStatus": $("#userActive").val(),
                            "contactNumber": $("#contactNumber").val(),
                            "lastVersion": sessionData.lastVersion
                        }
                    ]
                };

                console.log("Data From Create Group Master Maintenance.");
                console.log(data);
                request.post({
                    baseUrl: '<%= WebMisc.getCoreIP()%>',
                    url: '/API/Web/um/update',
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
                        history.back();
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
