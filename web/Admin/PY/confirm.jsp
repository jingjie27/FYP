<%-- 
    Document   : PaymentConfirm
    Created on : 14 Nov 2023
    Author     : Chinwei
--%>

<%@page import="com.aurora.Model.SearchObject"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.aurora.Utility.WebMisc"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="search" uri="http://aurora-rms.asia/tags/search" %>
<%@taglib prefix="modal" uri="http://aurora-rms.asia/tags/modal" %>
<%--<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>--%>
<head>
    <!-- Basic Page Info -->
    <title>AURORA Confirm Payment</title>

    <!-- Site favicon -->
    <link rel="apple-touch-icon" sizes="180x180" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="<%= WebMisc.getCoreIP()%>/Admin/vendors/images/favicon-16x16.png">

    <!-- Mobile Specific Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <script src="<%= WebMisc.getCoreIP()%>/Admin/scripts/jquery-min.js"></script>
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
    private static final String SESSION_NAME = "paymentResult";
    private static final String PAGE_TITLE = "Payment Maintenance";
    private static final String SEARCH_URL = "API/Web/payment/search";
    private static final String RESP_FIELD = "payment";
%>
<%
    String data = "";
//    String tenantId = WebMisc.getTenantIdByUser(request.getParameter("UID"));
    if (session.getAttribute("paymentResult") != null) {
        data = (String) session.getAttribute("recvResult");
    }

    if (session.getAttribute("USR_ID") == null) {
        session.setAttribute("USR_ID", request.getParameter("UID"));
    }

    String SID = request.getParameter("SID");

%>
<body >
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
        server='<%= WebMisc.getIPAddr("BUYING")%>'
        searchUrl="<%= SEARCH_URL%>"
        sessionName="<%= SESSION_NAME%>"          
            token="true"
        accessID="<%= SID%>"        
        responseField="<%= RESP_FIELD%>"             
            fields="{\"objects\":[
            {
            \"label\" : \"Title\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"title\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Status\", 
            \"apiInputID\" : \"status\",
            \"type\" : \"option\",
            \"options\" : [
            {
            \"display\" : \"Pending\",
            \"value\" : \"P\"
            },
            {
            \"display\" : \"Paid\",
            \"value\" : \"A\"
            }]
            },
            {
            \"label\" : \"Type\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"type\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Posting Date\", 
            \"type\" : \"date\",
            \"apiInputID\" : \"posDate\"
            },
            {
            \"label\" : \"Mode Of Payment\", 
            \"apiInputID\" : \"moPayment\",
            \"type\" : \"option\",
            \"options\" : [
            {
            \"display\" : \"Cash Cheque\",
            \"value\" : \"C\"
            },
            {
            \"display\" : \"Credit Card\",
            \"value\" : \"R\"
            }]
            }
            ]}"
            />          
    <div class="card-box mb-30">
        <div class="pb-20 pd-20">
            <table class="data-table table hover nowrap" id="datatable" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Status</th>
                        <th>Type</th>
                        <th>Posting Date</th>
                        <th>Mode Of Payment</th>
                        <th>Action</th>
                        <th></th>
                    </tr>
                </thead>
            </table>
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
    <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweetalert2.all.js"></script>
    <script src="<%= WebMisc.getCoreIP()%>/Admin/src/plugins/sweetalert2/sweet-alert.init.js"></script>

    <script>
        $(document).ready(function () {
            if ('<%= request.getParameter("mode")%>' === 'success')
                search();
        });
    </script>

    <script>
        function populateTable(dataArray, pageInfo) {

            console.log(dataArray);
            if ($.fn.dataTable.isDataTable('#datatable')) {

                $('#datatable').DataTable().destroy();
            }

            let table = $('#datatable').DataTable({
                data: dataArray,
                columns: [
                    {data:
                                function (data, type, row, meta) {
                                    return data.title;
                                }
                    },
                    {data:
                                function (data, type, row, meta) {
                                    return data.status;
                                }
                    },
                    {data:
                                function (data, type, row, meta) {
                                    return data.type;
                                }
                    },
                    {data:
                                function (data, type, row, meta) {
                                    return data.posDate;
                                }
                    },
                    {data:
                                function (data, type, row, meta) {
                                    return data.moPayment;
                                }
                    },
                    {
                        className: 'confirm-btn',
                        orderable: false,
                        data:
                                function (data, type, row, meta) {
                                    return ' <button type="button" class="btn btn-primary" id="confirmBtn" ><i class="icon-copy fa fa-check-circle mr-2" aria-hidden="true"></i>Confirm Payment</button>';
                                }
                    },
                    {
                        visible: false,
                        orderable: false,
                        data: "lastVersion",
                        defaultContent: ''
                    }
                ],
                order: [[1, 'asc']],
                rowId: 'title',
                stateSave: true,
                paging: false,
                destroy: true,
                info: false
            });

            let initialRow = (pageInfo.currentPage * pageInfo.pageSize) - (pageInfo.pageSize - 1);
            let lastRow = Math.min((pageInfo.currentPage * pageInfo.pageSize), pageInfo.totalRows);
            var tableFooter = '<div class="row"><div class="col-sm-12 col-md-5"><div class="dataTables_info" id="datatable_info" role="status" aria-live="polite">Showing ' + initialRow + ' to ' + lastRow + ' of ' + pageInfo.totalRows + ' entries </div> </div> <div class="col-sm-12 col-md-7"><div class="dataTables_paginate paging_simple_numbers" id="datatable_paginate"><ul class="pagination"><li class="paginate_button page-item previous" id="datatable_previous"><a href="#" aria-controls="datatable" data-dt-idx="0" tabindex="0" class="page-link">Previous</a></li>';
            tableFooter += '<li class="paginate_button page-item next" id="datatable_next"><a href="#" aria-controls="datatable" data-dt-idx="3" tabindex="0" class="page-link">Next</a></li></ul></div></div></div>';
            $('#datatable_wrapper').append(tableFooter);
            if (pageInfo.currentPage === 1)
                $('.previous').addClass('d-none');
            if (pageInfo.currentPage === pageInfo.totalPages)
                $('.next').addClass('d-none');

            $('.next').on('click', function () {
                search((pageInfo.currentPage + 1))
            });
            $('.previous').on('click', function () {
                search((pageInfo.currentPage - 1))
            });


            table.on('click', "td.confirm-btn", function () {
                var data = table.row($(this).parents('tr')).data();
                swal({
                    type: 'warning',
                    title: 'Are you sure?',
                    text: 'You are about to payment?',
                    showCancelButton: true
                }).then(function (result) {
                    if (result.value) {
                        console.log("confirm Payment");
                        //sweet alert
                        swal({
                            type: 'success',
                            title: 'Success!',
                            text: 'Payment already Done!'
                        });
                        //confirmRC(data.recvNo, data.lastVersion);
                    }
                });

            });
        }
        var dataArray = [{"title": "IceCream",
                    "status": "A",
                    "type": "dessert",
                    "posDate": "11November2023",
                    "moPayment": "R"}];
                    var ab = {};
                    populateTable(dataArray, ab);
    </script>

</body>
</html>
