<%--BEGIN LICENSE BLOCK--%> 
<%--Interneuron Terminus

Copyright(C) 2025  Interneuron Limited

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.If not, see<http://www.gnu.org/licenses/>. --%>
<%--END LICENSE BLOCK--%> 
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DynamicLocatorBoard.aspx.cs" Inherits="EBoards.DynamicLocatorBoard" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Locator Board</title>
    <link href="css/custom.css?v=1.0000010" rel="stylesheet" />
    <link href="Content/bootstrap33.min.css" rel="stylesheet" />
    <link href="css/font-awesome.css?v=1.0000010" rel="stylesheet" />

    <link href="css/ima.css" rel="stylesheet" />

    <script src="Scripts/jquery-1.12.4.js"></script>
    <script src="js/JQuery.XDomainRequests.js"></script>
    <script src="globalsettings.js?v=1.0000010"></script>


    <%--<script src="qustionservice.js"></script>--%>




    <script type="text/javascript">

        var globalURL = GlobalServiceURL;

        function BuildTable() {
            var LocatorBoardID = $('#lblLocatorBoardID').text();
            var list_id = $('#lblListID').text();
            var tablecssstyle = $('#lbltablecssstyle').text();
            var tableheadercssstyle = $('#lbltableheadercssstyle').text();
            var defaultrowcssstyle = $('#lbldefaultrowcssstyle').text();
            var cols = $('#lblCols').text();
            cols = JSON.parse(cols);
            var rows = $('#lblRows').text();
            rows = JSON.parse(rows);

            var html = "<table id='tblList' ";
            html += "class='" + tablecssstyle + "' >";
            html += "<thead class='" + tableheadercssstyle + "'><tr>";


            //console.log("cols.length: " + cols.length);

            for (var i = 0; i < cols.length; i++) {
                var obj = cols[i];
                html += "<th class='h4'>" + obj.displayname + "</th>";
            }
            html += "</tr></thead>";

            html += "<tbody>";

            for (var i = 0; i < rows.length; i++) {

                var rowcssfield = "";


                var row = rows[i];
                $.each(row, function (index, element) {

                    var j = 0;
                    var colCSS = element;
                    colCSS = JSON.parse(colCSS);


                    if (index == "col_0") {
                        rowcssfield = colCSS.rowcssfield
                        //console.log("rowcssfield:" + rowcssfield)
                    }
                });


                html += "<tr class='" + rowcssfield + "'>";


                $.each(row, function (index, element) {
                    var col = element;
                    col = JSON.parse(col);

                    //var rowcssfield = "";
                    //if (i == 0) {
                    //    rowcssfield = col.rowcssfield
                    //}
                    //console.log("rowcssfield:" + rowcssfield)

                    $.each(col, function (index, element) {
                        var bednumbercolour = "";

                        if (index == "attributevalue") {
                            html += "<td class='" + col.defaultcssclassname + "'>";
                            if (element != null) {
                                if (element.indexOf("same name") >= 0) {
                                    html += "<span class='syn-text-danger' style='min-width: 75px;'>"
                                    html += element;
                                    html += "</span>" // same name
                                }
                                else if (element.indexOf("_end_bednumbercolour") >= 0) {
                                    var startElement = element.replace('_end_bednumbercolour', '</div>');
                                    var newElement = "";
                                    if (element.indexOf("start_bednumbercolour_amber_") >= 0) {
                                        newElement = startElement.replace('start_bednumbercolour_amber_', '<div style="background-color: #FFFF00; min-width: 75px;">');
                                    }
                                    if (element.indexOf("start_bednumbercolour_green_")  >= 0) {
                                        newElement = startElement.replace('start_bednumbercolour_green_', '<div style="background-color: #108f4D; min-width: 75px;">');
                                    }
                                    if (element.indexOf("start_bednumbercolour_red_") >= 0) {
                                        newElement = startElement.replace('start_bednumbercolour_red_', '<div style="background-color: #D21313; min-width: 75px;">');
                                    }
                                    // var endElement = startElement.replace('_end_bednumbercolour', '</div>').replace(startElement,'');
                                    html += newElement;

                                }
                                else if (element.indexOf("tcidisplaylist_") >= 0) {
                                    var startElement = element.replace('tcidisplaylist_', '');
                                    var newElement = replaceAll(startElement, '_newline', '<br />');
                                    html += newElement;
                                }

                                else {
                                    html += element;
                                }

                            }
                            html += "</td>";
                        }
                    });

                });
                html += "<tr>";
            }

            html += "</tr></tbody>";

            html += "</table>";
            $('#tableSection').html(html);



        }



        function LoadBoard() {




            BuildTable();
        }

        $(document).ready(function () {
            setInterval(function () {
                window.location.reload();
            }, 60000);
        })

        function replaceAll(str, find, replace) {
            return str.replace(new RegExp(find, 'g'), replace);
        }


    </script>
</head>
<body>



    <form id="form1" runat="server" style="height: 100%; background-color: #fff;">





        <div class="container-fluid">

            <div>

                <div hidden="hidden">
                    IP Address :
                <asp:Label ID="lblIPAddress" runat="server"></asp:Label><br />
                    Locator Board ID :
                <asp:Label ID="lblLocatorBoardID" runat="server"></asp:Label><br />
                    Location Field :
                <asp:Label ID="lblLocationField" runat="server"></asp:Label><br />
                    Location Value :
                <asp:Label ID="lblLocationValue" runat="server"></asp:Label><br />
                    ListID Value :
                <asp:Label ID="lblListID" runat="server"></asp:Label><br />
                    Default Sort Statement :
                <asp:Label ID="lblDefaultSortStatement" runat="server"></asp:Label><br />
                    tablecssstyle :
                <asp:Label ID="lbltablecssstyle" runat="server"></asp:Label><br />
                    tableheadercssstyle :
                <asp:Label ID="lbltableheadercssstyle" runat="server"></asp:Label><br />
                    defaultrowcssstyle :
                <asp:Label ID="lbldefaultrowcssstyle" runat="server"></asp:Label><br />
                    Cols Value :
                <asp:Label ID="lblCols" runat="server"></asp:Label><br />
                    Rows Value :
                <asp:Label ID="lblRows" runat="server"></asp:Label><br />


                </div>


                <asp:Panel ID="pnlHasData" runat="server">

                    <div hidden="hidden">
                        <asp:HiddenField ID="hdnlocatorboardID" runat="server" />
                        <asp:HiddenField ID="hdnWard" runat="server" />
                        <asp:HiddenField ID="hdnBed" runat="server" />
                    </div>
                    <div class="hidden">
                        <asp:Literal ID="ltrlTopLeft" runat="server" Visible="false"></asp:Literal>
                    </div>



                    <div class="row">
                        <div class="col-md-6">
                            <asp:Literal ID="ltrlHeading" runat="server"></asp:Literal>
                        </div>

                        <div class="col-md-6 hidden">
                            <asp:Literal ID="ltrlTopRight" runat="server"></asp:Literal>
                        </div>

                        <div class="col-md-3 h4">
                            <br />
                            <table class="table table-condensed table-bordered">
                              
                                <tr>
                                    <td>
                                        <asp:Label ID="lblNumberOfBedsOccupied" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>Beds Occupied
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblNumberOfBedsAvailable" runat="server" Text="0" Visible="false"></asp:Label>
                                    </td>
                                    <td>Available
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblNumberOfClosedBeds" runat="server" Text="0" Visible="false"></asp:Label>
                                    </td>
                                    <td>Out of Use
                                    </td>
                                </tr>                                
                            </table>
                        </div>
                        <div class="col-md-3 h4">
                            <br />
                            <table class="table table-condensed table-bordered">
                                 <tr>
                                    <td>
                                        <asp:Label ID="lblTCISIn24Hours" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>TCIs 24 Hours
                                    </td>
                                </tr>
                                 <tr>
                                    <td>
                                        <asp:Label ID="lblTCISIn24HoursWithBeds" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>TCIs-allocated beds
                                    </td>
                                </tr>
                                 <tr>
                                    <td>
                                        <asp:Label ID="lblPatientsWaiting" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>Patients Waiting
                                    </td>
                                </tr>
                                 <tr>
                                    <td>
                                        <asp:Label ID="lblPatientsWaitingAllocatedBeds" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>Waiting-allocated beds 
                                    </td>
                                </tr>
                                
                                
                                
                               
                            </table>
                        </div>
                    </div>

                    <div id="tableSection" style="margin-top: 2px;">
                    </div>

                    <hr />




                </asp:Panel>

                <asp:Panel ID="pnlNoData" runat="server">


                    <div class="row" style="margin-top: 100px;">
                        <div class="col-md-12">
                            <div class="alert alert-danger" style="text-align: center; margin: 40px;">


                                <div class="row" style="background-color: rgb(114, 28, 36); color: white; font-size: 3em;">
                                    <div class="col-md-12" style="height: 100%;">
                                        <h1>Locator Board</h1>
                                    </div>
                                </div>
                                <br />
                                <br />
                                <h3>Device not configured</h3>

                                <h4>Please use the Locator Board Device Manager in Studio to configure the settings for this device.
                                </h4>
                                <br />
                                <br />

                                <h4>The IP Address of this device is:
                                </h4>
                                <br />
                                <br />
                                <div class="row" style="background-color: rgb(114, 28, 36); color: white; font-size: 3em;">
                                    <div class="col-md-12" style="height: 100%;">

                                        <asp:Label ID="lblHiddenIPAddress" runat="server"></asp:Label>
                                    </div>


                                </div>


                            </div>
                        </div>
                    </div>


                </asp:Panel>

            </div>


            <%-- <div id="divLoading" data-bind="visible: IsLoading" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); transform: -webkit-translate(-50%, -50%); transform: -moz-translate(-50%, -50%); transform: -ms-translate(-50%, -50%); z-index: 9999;">

                <img src="img/5.gif" />

            </div>--%>
        </div>

    </form>

</body>
</html>
