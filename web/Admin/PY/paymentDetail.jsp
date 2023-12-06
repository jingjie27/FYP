<%-- 
    Document   : editView - Payment
    Created on : NOV 6, 2023, 4:16:00 PM
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
    <title>AURORA Payment Detail</title>

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
    <link rel="stylesheet" type="text/css" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/styles/autocomplete.css">
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
%>
<body >

    <div class="col-md-12 col-sm-12 mb-30">
        <div class="row col-md-12 pt-10 pb-10 pl-20"> 
            <div style="flex : 2; display: flex;  align-items: center">
                <div>
                    <h5 class="h4 text-blue">Payment Detail</h5>
                </div>
            </div>
            <div style="flex : 1;display: flex; justify-content: flex-end; align-items: flex-end">
                <button type="button" class="btn btn-primary align-items-end mr-2" id="backBtn" >
                    Back 
                </button>
               <% if (!StringUtils.equalsAnyIgnoreCase(request.getParameter("mode"), "view")) { %>
                <button type="submit" class="btn btn-success align-items-end" id="saveBtn" >
                   Pay
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
                            <form id="form">


                                <hr>
                                <div class="row mb-10">
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Title</label>
                                            <input type="text" class="form-control" id="title" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Status</label>
                                            <input id="status" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Type</label>
                                            <select id="type" class="form-control">
                                                <option value="Receive">Receive</option>
                                                <option value="Pay">Pay</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Posting date</label>
                                            <input id="postingDate" type="text" class="form-control date-picker" />
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Mode of Payment</label>
                                            <select id="modeOfPayment" class="form-control">
                                                <option value="Bank">Bank</option>
                                                <option value="Cheque">Cheque</option>
                                                <option value="Cash">Cash</option>
                                                <option value="Credit Card">Credit Card</option>
                                                <option value="Other">Other</option>
                                            </select>
                                        </div>
                                        <div class="form-group" id="oPD" >
                                            <label>Other Payment Details</label>
                                            <input id="otherPaymentField" type="text" class="form-control">
                                        </div>
                                    </div>



                                </div>

                                <input id="mode" type="hidden" value="<%= request.getParameter("mode")%>"/>
                            </form>


                            <div class="row mb-3">
                                <div class="col-4">
                                    <div class="h5 text-blue mb-10 font-weight-bold">Payment From/ To</div>
                                </div>

                            </div>

                            <div class="pb-20">
                                <div class="col-md-4 col-sm-12">

                                    <div class="form-group">
                                        <label>Payment Amount (RM)</label>

                                        <input id="paymentAmount" type="number" min="0" value="0.00" step=".01" class="form-control">

                                    </div>

                                    <div class="form-group" id="aN">
                                        <label>Account Number</label>
                                        <input id="accountNumber" type="text" class="form-control">
                                    </div>



                                </div>
                                <div class="col-md-4">
                                    <div class="form-group" id="aB">
                                        <label>Account Bank</label>
                                        <select id="accountBank" class="form-control">
                                            <option value="Maybank2u">Maybank2u</option>
                                            <option value="CIMB Clicks">CIMB Clicks</option>
                                            <option value="Public Bank">Public Bank</option>
                                            <option value="RHB Now">RHB Now</option>
                                            <option value="Ambank">Ambank</option>
                                            <option value="MyBSN">MyBSN</option>
                                            <option value="Bank Rakyat">Bank Rakyat</option>
                                            <option value="UOB">UOB</option>
                                            <option value="Affin Bank">Affin Bank</option>
                                            <option value="Bank Islam">Bank Islam</option>
                                            <option value="HSBC Online">HSBC Online</option>
                                            <option value="Standard Chartered Bank">Standard Chartered Bank</option>
                                            <option value="Kuwait Finance House">Kuwait Finance House</option>
                                            <option value="Bank Muamalat">Bank Muamalat</option>
                                            <option value="OCBC Online">OCBC Online</option>
                                            <option value="Alliance Bank (Personal)">Alliance Bank (Personal)</option>
                                            <option value="Hong Leong Connect">Hong Leong Connect</option>
                                            <option value="Agrobank">Agrobank</option>
                                        </select>
                                    </div>
                                </div>
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
    <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/autocomplete.js"></script>
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
    <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweetalert2.all.js"></script>
    <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweet-alert.init.js"></script>
    <script>

        // Assuming data is a server-side variable
        var data = {
            title: 'Shabi',
            status: 'Pending',
        };

        // Populate other form fields with data
        $("#title").val(data.title);
        $("#status").val(data.status);


        // Add input event listener to account number field for formatting and validation
        $("#accountNumber").on('input', function () {
            // Remove non-digit characters
            var accountNumber = $(this).val().replace(/\D/g, '');

            // Ensure the account number does not exceed 16 digits
            if (accountNumber.length > 16) {
                // If it exceeds 16 digits, trim the extra digits
                accountNumber = accountNumber.slice(0, 16);
            }

            // Format with spaces every 4 digits
            var formattedAccountNumber = accountNumber.replace(/(\d{4})(?=\d)/g, '$1 ');

            // Set the formatted account number back to the input field
            $(this).val(formattedAccountNumber);
        });

// Function to enable/disable fields based on mode of payment
        function toggleFieldsBasedOnModeOfPayment() {
            var modeOfPayment = $("#modeOfPayment").val();
            if (modeOfPayment !== 'Bank' && modeOfPayment !== 'Credit Card' && modeOfPayment !== 'Other') {
                // If mode of payment is not Bank or Credit Card, disable fields
                $("#accountNumber").prop('disabled', true).hide().val(''); // clear value
                $("#aN").prop('disabled', true).hide().val('');
                $("#accountBank").prop('disabled', true).hide().val('');
                $("#aB").prop('disabled', true).hide().val('');
                $("#otherPaymentField").prop('disabled', true).hide().val('');
                $("#oPD").prop('disabled', true).hide().val('');
            } else if (modeOfPayment === 'Other') {
                // If mode of payment is Other, enable other payment details field and disable other fields
                $("#accountNumber").prop('disabled', true).hide().val(''); // clear value
                $("#aN").prop('disabled', true).hide().val('');
                $("#accountBank").prop('disabled', true).hide().val('');
                $("#aB").prop('disabled', true).hide().val('');
                $("#otherPaymentField").prop('disabled', false).show();
                $("#oPD").prop('disabled', false).show();
            } else {
                // If mode of payment is Bank or Credit Card, enable fields
                $("#accountNumber").prop('disabled', false).show();
                $("#aN").prop('disabled', true).show();
                $("#accountBank").prop('disabled', false).show();
                $("#aB").prop('disabled', true).show();
                $("#otherPaymentField").prop('disabled', true).hide().val('');
                $("#oPD").prop('disabled', true).hide().val('');
            }
        }

// Attach change event listener to mode of payment field
        $("#modeOfPayment").change(function () {
            // Call the function whenever mode of payment changes
            toggleFieldsBasedOnModeOfPayment();
        });

// Call the function initially
        toggleFieldsBasedOnModeOfPayment();

        $(document).ready(function () {
            $('#backBtn').click(function () {
                window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/PY/paymentSearch.jsp';
            });
        });
    </script>


</body>

