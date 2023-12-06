<%-- 
    Document   : INVENTORY DETAIL
    Created on : Nov 10, 2023, 4:16:00 PM
    Author     : Wong Jing Jie
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
    <title>AURORA Order Checklist Edit Search</title>

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

    <style>
        table.dataTable td.dt-control {
            text-align: center;
            cursor: pointer;
        }
        table.dataTable td.dt-control:before {
            display: inline-block;
            color: rgba(0, 0, 0, 0.5);
            content: "-";
        }
        table.dataTable tr.dt-hasChild td.dt-control:before {
            content: "-";
        }

        table.dataTable tr th.dt-control:before, table.dataTable tr th.dt-control:after {
            content: '';
        }

        table.dataTable tr th.dw-trash:before, table.dataTable tr th.dw-trash:after {
            content: '';
        }

        table.dataTable th.edit-button:before {
            content: '';
        }

        table.dataTable tr td.dw-trash, table.dataTable tr td.dw-edit2{
            padding: 0.3rem;
            cursor:pointer;
        }

        table.dataTable tr td.dw-trash:before {
            font-size: 25px;
            font-weight: bolder;
        }


        table.dataTable tr td.dw-trash:hover {
            color:red;
        }

        table.dataTable tr td.dw-edit2:before {
            font-size: 20px;
            color: rgba(79, 36, 122, 0.5);
            font-weight:bolder;
        }

        table.dataTable tr td.dw-edit2:hover:before{
            color: #4F247A;
        }

        #addItemBtn {
            color: #4F247A!important;
        }

        #addItemBtn:hover {
            color: white!important;
            background-color: #4F247A!important;
        }
    </style>
</head>
<%
    boolean isViewMode = StringUtils.equalsAnyIgnoreCase(request.getParameter("mode"), "view");
%>
<body >

    <div class="col-md-12 col-sm-12 mb-30">
        <div class="row col-md-12 pt-10 pb-10 pl-20"> 
            <div style="flex : 2; display: flex;  align-items: center">
                <div>
                    <h5 class="h4 text-blue">Inventory Stock Detail</h5>
                </div>
            </div>
            <div style="flex : 1;display: flex; justify-content: flex-end; align-items: flex-end">
                <button type="button" class="btn btn-primary align-items-end mr-2" id="backBtn" >
                    Back 
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
                            <form id="form">


                                <hr>
                                <div class="row mb-10">
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Store Code</label>
                                            <input type="text" class="form-control" id="storeCode" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Store Name</label>
                                            <input id="storeName" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Store Bin Location</label>
                                            <input id="storeBinLocation" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <div class="form-group">
                                            <label>Last Order Date</label>
                                            <input id="lastOrderDate" type="text" class="form-control date-picker" disabled/>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Store On Hand Quantity</label>
                                            <input id="storeOnHandQuantity" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Store On Order Quantity</label>
                                            <input id="storeOnOrderQuantity" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Stock Average Cost</label>
                                            <input id="stockAverageCost" type="text" class="form-control" disabled>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <span class="font-weight-bold">Auto Replenishment</span><br>
                                            <div id="autoReplenishment" class="badge badge-primary badge-pill" align="center"></div>
                                        </div>
                                    </div>
                                </div>

                                <input id="mode" type="hidden" value="<%= request.getParameter("mode")%>"/>
                            </form>


                            <div class="row mb-3">
                                <div class="col-4">
                                    <div class="h5 text-blue mb-10 font-weight-bold">Stock Movement</div>
                                </div>

                            </div>

                            <div class="pb-20">
                                <table class="data-table table hover" id="itemList" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th>Item Short SKU</th>
                                            <th>Type</th>
                                            <th>Reference No</th>
                                            <th>Quantity</th>
                                            <th>UOM</th>
                                            <th>Date Time</th>

                                        </tr>
                                    </thead>
                                </table>
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
    <%
        // Assuming data is a server-side variable
        String autoReplenishmentValue = (String) request.getAttribute("autoReplenishment");
    %>
    <!-- Touchspin and tooltip element -->
    <script>
//        $("#storeCode").val(data["storeCode"]);
//        $("#categoryCd").val(data["storeName"]);
//        $("#drinkMenu").val(data["storeBinLocation"]);
//        $("#sellPrcWovat").val(data["lastOrderDate"]);
//        $("#sellPrcWvat").val(data["stockOnHandQuantity"]);
//        $("#specialMenu").val(data["stockOnOrderQuantity"]);
//        $("#specialMenu").val(data["stockAverageCost"]);
//        $("#specialMenu").val(data["autoReplenishment"]);

        if ("<%= autoReplenishmentValue%>" === "Y") {
            $("#autoReplenishment").append("Yes");
        } else if ("<%= autoReplenishmentValue%>" === "N") {
            $("#autoReplenishment").append("No");
        } else {
            $("#autoReplenishment").append("Empty");
        }
        var hardcodedData = [
            {itemShorttSKU: 'ABC123', type: 'Type1', referenceNo: 'Ref123', quantity: 10, UOM: 'kg', dateTime: '2023-09-10', status: 'in'},
            {itemShorttSKU: 'DEF456', type: 'Type2', referenceNo: 'Ref456', quantity: 20, UOM: 'lbs', dateTime: '2023-09-11', status: 'out'}
            // Add more hardcoded data as needed
        ];

        $(document).ready(function () {

            $('#backBtn').click(function () {
                window.location.href = '<%= WebMisc.getCoreIP()%>/Admin/STK/inventory.jsp';
            });
            // Check if DataTable is already initialized
            if ($.fn.DataTable.isDataTable('#itemList')) {
                // If yes, destroy the existing DataTable
                $('#itemList').DataTable().destroy();
            }

            // Initialize DataTable with the specified configurations
            let table = $('#itemList').DataTable({
                data: hardcodedData,
                columns: [
                    {className: 'dt-control', orderable: true, data: null, defaultContent: ''},
                    {data: 'itemShorttSKU'},
                    {data: 'type'},
                    {data: 'referenceNo'},
                    {data: 'quantity'},
                    {data: 'UOM'},
                    {data: 'dateTime'}
                ],
                order: [[1, 'asc']],
                rowId: 'itemShorttSKU',
                stateSave: true,
                createdRow: function (row, data, dataIndex) {
                    // Check the status property and apply styles
                    let status = data.status;

                    if (status === 'in') {
                        $('td', row).eq(4).css('color', 'green'); // Quantity column
                    } else if (status === 'out') {
                        $('td', row).eq(4).css('color', 'red'); // Quantity column
                    }
                }
            });

            console.log(hardcodedData);
        });
    </script>

</body>

