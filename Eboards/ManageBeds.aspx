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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageBeds.aspx.cs" Inherits="EBoards.ManageBeds" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-title" content="Inpatients" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="apple-touch-icon" href="img/inPatientsIcon.png" />
    <link rel="shortcut icon" type="image/x-icon" href="img/inPatientsIcon.png" />

    <title>Inpatients</title>

    <link href="Content/bootstrap.css" rel="stylesheet" />



    <link href="css/font-awesome.css" rel="stylesheet" />
    <link href="Content/pickadate/themes/classic.css" rel="stylesheet" />
    <link href="css/spinner.css" rel="stylesheet" />
    <link href="css/ima.css" rel="stylesheet" />
    <link href="Content/pickadate/themes/classic.date.css" rel="stylesheet" />
    <link href="Content/pickadate/themes/classic.time.css" rel="stylesheet" />


    <style>
        .picker__header select {
            min-height: 40px;
        }

        .nav-item.tabbedButton {
            display: inline-block;
            text-align: center;
            text-decoration: none;
            -moz-border-radius-topleft: 8px;
            -moz-border-radius-topright: 8px;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
            border: 1px solid #ffcc00;
        }

        .linkActive {
            -moz-border-radius-topleft: 7px;
            -moz-border-radius-topright: 7px;
            border-top-left-radius: 7px;
            border-top-right-radius: 7px;
            background-color: #ffcc00;
            color: black !important;
            border: 1px solid #ffcc00;
        }

        .navbar {
            margin-bottom: 0px;
            padding-bottom: 0px;
        }

        .navbar-toggler {
            margin-bottom: 5px;
        }
    </style>


    <%--    <link href="Content/easyautocomplete/easy-autocomplete.css" rel="stylesheet" />
    <link href="Content/easyautocomplete/easy-autocomplete.themes.css" rel="stylesheet" />--%>

    <script src="Scripts/jquery-3.0.0.js"></script>
    <script src="Scripts/popper_bootstrap4.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/knockout-3.4.2.js"></script>

    <script src="Scripts/moment-with-locales.js"></script>
    <%--    <script src="libs/tempusdominus-bootstrap-4.min.js"></script>--%>

    <%--<script src="Scripts/jquery.tablesorter.js"></script>--%>

    <script src="Content/pickadate/legacy.js"></script>
    <script src="Content/pickadate/picker.js"></script>
    <script src="Content/pickadate/picker.date.js"></script>
    <script src="Content/pickadate/picker.time.js"></script>

    <%--<script src="Content/easyautocomplete/jquery.easy-autocomplete.js"></script>--%>


    <script src="Content/summernote/summernote-bs4.js"></script>
    <link href="Content/summernote/summernote-bs4.css" rel="stylesheet" />


    <script src="globalsettings.js?v=1.0000010"></script>

    <script type="text/javascript">


        var synapseUserName = "";

        var questionModalOpen = false;

        //var listId = "08662d00-39f3-46bb-84fa-847da301df7b";

        var LocatorBoardID = "";
        //$('#lblLocatorBoardID').val(LocatorBoardID);

        var globalURL = GlobalServiceURL;

        var listId = "";

        //var vm = new viewModel();

        function LoadBoard() {

            synapseUserName = $('#lblUserFullName').text();



            //LoadBoardWithoutVM();

            //ko.applyBindings(vm);
            //vm.getColumnsAndQuestions();

            //setInterval(function () {
            //    reloadPageIfNotEditing();
            //}, 60000);
        }


    </script>
</head>
<body>



    <form id="form1" runat="server" style="height: 100%; background-color: #fff;">

        <asp:HiddenField ID="hdn_currentpatients_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_waitingarea_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_tcis_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_recentpatients_locatorboard_id" runat="server" />



        <%--   <div class="container-fluid">
            <div class="row bg-info text-white">
                <div class="col-md-8">
                    <button class="btn btn-info btn-sm">
                        <asp:Label ID="lblNavIMAPage" runat="server"></asp:Label>
                    </button>
                </div>
                <div class="col-md-4" style="padding-top: 4px;">
                    <a href="Default.aspx" class="btn btn-info btn-sm float-right">Home</a>
                </div>
            </div>
        </div>--%>

        <div class="container-fluid">




            <div class="navbar sticky-top navbar-expand-lg navbar-light" style="background-color: #fff;">
                <%--<a class="navbar-brand" href="#">iBoards</a>--%>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNavDropdown">


                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item tabbedButton">
                            <asp:LinkButton ID="lbtnNavCurrentPatients" runat="server" CssClass="nav-link" OnClick="lbtnNavCurrentPatients_Click">
                                <asp:Label runat="server" ID="lblNavCurrentPatients" Text="Current Patients"></asp:Label>
                                &nbsp;
                            <asp:Label runat="server" ID="lblNavCurrentPatientsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                &nbsp;&nbsp
                            </asp:LinkButton>
                        </li>
                        <li class="nav-item tabbedButton">
                            <asp:LinkButton ID="lbtnNavTCIs" runat="server" CssClass="nav-link" OnClick="lbtnNavTCIs_Click">
                                <asp:Label runat="server" ID="lblNavTCIs" Text="Patients to come in"></asp:Label>
                                &nbsp;
                            <asp:Label runat="server" ID="lblNavTCIsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                &nbsp;&nbsp
                            </asp:LinkButton>
                        </li>
                        <li class="nav-item tabbedButton">
                            <asp:LinkButton ID="lbtnNavWaitingArea" runat="server" CssClass="nav-link" OnClick="lbtnNavWaitingArea_Click">
                                <asp:Label runat="server" ID="lblNavWaitingArea" Text="Waiting for a bed"></asp:Label>
                                &nbsp;
                            <asp:Label runat="server" ID="lblNavWaitingAreaCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                &nbsp;&nbsp
                            </asp:LinkButton>
                        </li>
                        <li class="nav-item tabbedButton">
                            <asp:LinkButton ID="lbtnNavRecentPatients" runat="server" CssClass="nav-link" OnClick="lbtnNavRecentPatients_Click">
                                <asp:Label runat="server" ID="lblNavRecentPatients" Text="Recent"></asp:Label>
                                &nbsp;
                            <asp:Label runat="server" ID="lblNavRecentPatientsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                &nbsp;&nbsp
                            </asp:LinkButton>
                        </li>

                    </ul>



                </div>
            </div>
      
            
        
        </div>

        <div class="container-fluid">



            <div class="row" style="height: 5px; background-color: #ffcc00;">
                &nbsp;
            </div>

            <div class="row" style="border-top: 1px solid gray; padding-top: 3px;">

                <div class="col-md-4">
                    <div class="h5" style="margin-top: 4px;">
                        Bed Availability
                    </div>
                </div>

                <div class="col-md-4">

                    <div class="dropdown">
                        <div class="btn-group">
                            <button class="btn btn-light btn-sm dropdown-toggle" type="button" id="ddmUser" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fa fa-user"></i>
                                <asp:Label ID="lblUserFullName" runat="server"></asp:Label>
                            </button>
                            <div class="dropdown-menu" aria-labelledby="ddmUser">
                                <a class="dropdown-item" href="LogOut.aspx">Sign Out</a>
                            </div>
                        </div>
                        &nbsp;
                            <div class="btn-group">
                                <button class="btn btn-light btn-sm dropdown-toggle" type="button" id="ddmSettings" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <i class="fa fa-gear"></i>
                                </button>
                                <div class="dropdown-menu" aria-labelledby="ddmSettings">
                                    <asp:LinkButton ID="lbtnNavWardInfo" runat="server" CssClass="dropdown-item" OnClick="lbtnNavWardInfo_Click">
                                        <asp:Label runat="server" ID="lblNavWardInfo" Text="Ward Information"></asp:Label>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="lbtnNavManageBeds" runat="server" CssClass="dropdown-item" OnClick="lbtnNavManageBeds_Click">
                                        <asp:Label runat="server" ID="lblNavManageBeds" Text="Bed Availability"></asp:Label>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        <%-- &nbsp;

                        <a href="Default.aspx" class="btn btn-light btn-sm "><i class="fa fa-home"></i>&nbsp;</a>--%>
                    </div>

                </div>

                <div class="col-md-4">
                    <span class="pull-right">Select Ward: 
                        <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectedWard_SelectedIndexChanged" ID="ddlSelectedWard" CssClass="form-control-sm"></asp:DropDownList>
                    </span>
                </div>

            </div>


            <br />

            <div class="row">
                <div class="col-12">



                    <div>
                        <asp:GridView ID="gvBeds" runat="server" CssClass="table table-hover"
                            DataKeyNames="wardbaybed_id" AutoGenerateColumns="false" GridLines="None" >                            
                            <Columns>
                                <asp:TemplateField HeaderText="wardbaybed_id" Visible="false">   
                                    <ItemTemplate>
                                        <asp:Label ID="lblID" runat="server" Text='<%# Eval("wardbaybed_id") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" Visible="false">   
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("bedstatus") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Ward">
                                    <ItemTemplate>
                                        <asp:Label ID="lblwarddisplay" runat="server" Text='<%# Eval("warddisplay") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Bay">
                                    <ItemTemplate>
                                        <asp:Label ID="lblbaydisplay" runat="server" Text='<%# Eval("baydisplay") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Bed">
                                    <ItemTemplate>
                                        <asp:Label ID="lblbedbaydisplay" runat="server" Text='<%# Eval("bedbaydisplay") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sort">
                                    <ItemTemplate>
                                        <asp:Label ID="lblbedsortstringgv" runat="server" Text='<%# Eval("bedsortstring") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <asp:Label ID="lblStatusText" runat="server" Text='<%# Eval("statusdescription") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Notes">
                                    <ItemTemplate>
                                        <asp:Label ID="lblNotes" runat="server" Text='<%# Eval("notes") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Edit">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lnkBtnEdit" runat="server" Text="Edit" CssClass="btn btn-info" OnClick="Display"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div>
                        <div class="modal fade" id="myModal" role="dialog">
                            <div class="modal-dialog">
                                <!-- Modal content-->
                                <div class="modal-content">
                                    <div class="modal-header">


                                         <h4 class="modal-title float-left">
                                            <asp:Label ID="lblBedName" runat="server" Text="Ward Name"></asp:Label>
                                        </h4>

                                        <button type="button" class="close float-right" data-dismiss="modal">
                                            &times;</button>
                                       
                                    </div>
                                    <div class="modal-body">
                                        <div class="col-lg-12 col-sm-12 col-md-12 col-xs-12">
                                            <asp:Panel ID="pnlOccupied" CssClass="alert alert-danger" runat="server">
                                                <strong>This bed is occupied - unable to update status.</strong>
                                                <br />
                                                Please move the patient out of the bed if you wish to update the status
                                            </asp:Panel>
                                            <div class="form-group">
                                                <asp:Label ID="lblwardbaybed_id" runat="server" Visible="false"></asp:Label>
                                                 <asp:Label ID="lblStatus" runat="server" Text="Status: "></asp:Label>
                                                <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </div> 
                                            <div class="form-group">
                                                <asp:Label ID="lblNotes" runat="server" Visible="false"></asp:Label>
                                                
                                                <asp:textbox TextMode="MultiLine" Rows="5" ID="txtNotes" runat="server" CssClass="form-control"></asp:textbox>
                                            </div> 
                                            <div class="form-group hidden">
                                                <asp:Label ID="lbllblbedsortstring" runat="server" Text="Sort String"></asp:Label>
                                                <asp:TextBox ID="txtlblbedsortstring" runat="server" TabIndex="3" MaxLength="75" CssClass="form-control"></asp:TextBox>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <asp:LinkButton ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn btn-info"></asp:LinkButton>
                                        <asp:LinkButton ID="btnClose" runat="server" Text="Close" OnClick="btnClose_Click" CssClass="btn btn-info"></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                            <script type='text/javascript'>
                                function openModal() {
                                    $('[id*=myModal]').modal('show');
                                }

                                function closeModal() {
                                    $('[id*=myModal]').modal('hide');
                                }
                            </script>
                        </div>
                    </div>






                </div>
            </div>





            <div>

                <div hidden="">
                    IP Address :
                <asp:Label ID="lblIPAddress" runat="server"></asp:Label><br />
                    Locator Board ID :
                <asp:Label ID="lblLocatorBoardID" runat="server"></asp:Label><br />
                    Location Field :
                <asp:Label ID="lblLocationField" runat="server"></asp:Label><br />
                    Location Value :
                <asp:Label ID="lblLocationValue" runat="server"></asp:Label><br />
                    Default Sort Statement :
                <asp:Label ID="lblDefaultSortStatement" runat="server"></asp:Label><br />
                </div>
                <asp:Panel ID="pnlHasData" runat="server">

                    <div hidden="hidden">
                        <asp:HiddenField ID="hdnlocatorboardID" runat="server" />
                        <asp:HiddenField ID="hdnWard" runat="server" />
                        <asp:HiddenField ID="hdnBed" runat="server" />
                    </div>



                    <hr />



                </asp:Panel>



            </div>




        </div>

    </form>

</body>
</html>

