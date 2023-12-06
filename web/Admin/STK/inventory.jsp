<%-- 
    Document   : StockInventoryReport
    Created on : 10 Nov 2023, 12:15:18 pm
    Author     : chinwei
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
        <title>AURORA Order Checklist Search</title>

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
        private static final String SESSION_NAME = "odChcklstResult"; // item result set into the web session
        private static final String PAGE_TITLE = "Stock Inventory Report"; // Header Name for search
        private static final String SEARCH_URL = "API/Web/odrchklst/searchReleasePochklst"; // refer to API Documentation
        private static final String RESP_FIELD = "odrchklsts"; // indicate where to find the data
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
        server='<%= WebMisc.getIPAddr("BUYING")%>'
        searchUrl="<%= SEARCH_URL%>"
        sessionName="<%= SESSION_NAME%>"          
            token="true"
        accessID="<%= SID%>"        
        responseField="<%= RESP_FIELD%>"             
            fields="{\"objects\":[
            {
            \"label\" : \"Store\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"store\",
            \"queryFieldID\" : \"queryStore\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Short SKU\", 
            \"type\" : \"autocomplete\",
            \"apiInputID\" : \"item\",
            \"queryFieldID\" : \"queryItem\",
            \"codeField\" : \"true\"
            },
            {
            \"label\" : \"Last Order Date\", 
            \"type\" : \"date\",
            \"apiInputID\" : \"ltorDate\"
            }
            ]}"
            />         
        <div class="row pb-20 mr-10 justify-content-end align-items-end">
            <button type="button" class="btn btn-success" onclick="javascript:maint('new')">
                <i class="icon-copy fa fa-plus" aria-hidden="true"></i>
                Add Record
            </button>
        </div>

        <div class="card-box mb-30">
            <div class="pb-20 pd-20">
                <table class="data-table table hover nowrap" id="datatable" style="width: 100%;">
                    <thead>
                        <tr>
                            <th>Short SKU</th>
                            <th>Store</th>
                            <th>Store Name</th>
                            <th>Store On Order</th>
                            <th>Store On hand</th>
                            <th>Total Cost</th>
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

            if ($.fn.dataTable.isDataTable('#datatable')) {
            console.log("destroy");
                    $('#datatable').DataTable().destroy();
            }

            let table = $('#datatable').DataTable({
            data: dataArray, // chg back to dataArray when search work
                    columns: [
                    {data:
                            function (data, type, row, meta) {
                            return data.shortSku;
                            }
                    },
                    {data:
                            function (data, type, row, meta) {
                            return data.store;
                            }
                    },
                    {data:
                            function (data, type, row, meta) {
                            return data.storeName;
                            }
                    },
                    {data:
                            function (data, type, row, meta) {
                            return data.storeOnOrder;
                            }
                    },
                    {data:
                            function (data, type, row, meta) {
                            return data.storeOnHand;
                            }
                    },
                    {data:
                            function (data, type, row, meta) {
                            return "RM " + data.totalCost;
                            }
                    },
                    {
                    className: 'detail-btn',
                            orderable: false,
                            data:
                            function (data, type, row, meta) {
                            return ' <button type="button" class="btn btn-primary" id="releaseBtn" ><i class="icon-copy fa fa-check-circle mr-2" aria-hidden="true"></i>Detail</button>';
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
                    rowId: 'chklstNo',
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
                    table.on('click', "td.detail-btn", function () {
                    var data = table.row($(this).parents('tr')).data();
                            swal({
                            type: 'warning',
                                    title: 'Are you sure?',
                                    text: 'You are about to release PO for checklist: ' + data.chklstNo + ' to Store: ' + data.store + '-' + data.storeName,
                                    showCancelButton: true
                            }).then(function (result) {
                    if (result.value) {
                    console.log("release PO");
                            //sweet alert
                            swal({
                            type: 'success',
                                    title: 'Success!',
                                    text: 'PO has been released successfully!'
                            });
                            //releasePO(data.chklstNo, data.lastVersion);
 window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/STK/inventoryDetail.jsp';
                    }
                    });
                    });
            }
            var dataArray = [{ "shortSku": "00001",
                    "store": "0001",
                    "storeName": "Hello",
                    "storeOnOrder": "50Flower",
                    "storeOnHand": "10Flower",
                    "totalCost": "5000" }];
                    var ab = {};
                    populateTable(dataArray, ab);
        </script>

    </body>
</html>

