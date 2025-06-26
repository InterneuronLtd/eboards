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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IMA.aspx.cs" Inherits="EBoards.IMA" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <meta charset="utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-title" content="Inpatients" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <%--<meta name="viewport" content="width=device-width, initial-scale=1.0"/>--%>
    <link rel="apple-touch-icon" href="img/inPatientsIcon.png" />
    <link rel="shortcut icon" type="image/x-icon" href="img/inPatientsIcon.png" />

    <title>Inpatients</title>
    <link href="css/custom.css" rel="stylesheet" />
    <link href="css/font-awesome.css?v=1.0000010" rel="stylesheet" />
    <link href="Content/bootstrap.css?v=1.0000010" rel="stylesheet" />





    <link href="Content/pickadate/themes/classic.css?v=1.0000010" rel="stylesheet" />
    <link href="css/spinner.css?v=1.0000010" rel="stylesheet" />
    <link href="css/ima.css?v=1.0000010" rel="stylesheet" />
    <link href="Content/pickadate/themes/classic.date.css?v=1.0000010" rel="stylesheet" />
    <link href="Content/pickadate/themes/classic.time.css?v=1.0000010" rel="stylesheet" />

    <%--<link href="css/custom.css?v=1.0000010" rel="stylesheet" />--%>

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


        /*sticky-top { margin-bottom: 0px; }
        navbar-expand-lg { margin-bottom: 0px; }*/

        .alert {
            margin-bottom: 1px;
            height: 30px;
            line-height: 30px;
            padding: 0px 15px;
        }
    </style>


    <%--    <link href="Content/easyautocomplete/easy-autocomplete.css" rel="stylesheet" />
    <link href="Content/easyautocomplete/easy-autocomplete.themes.css" rel="stylesheet" />--%>

    <script src="Scripts/jquery-3.0.0.js?v=1.0000010"></script>
    <script src="Scripts/popper_bootstrap4.js?v=1.0000010"></script>
    <script src="Scripts/bootstrap.js?v=1.0000010"></script>
    <script src="Scripts/knockout-3.4.2.js?v=1.0000010"></script>

    <script src="Scripts/moment-with-locales.js?v=1.0000010"></script>
    <%--    <script src="libs/tempusdominus-bootstrap-4.min.js"></script>--%>

    <%--<script src="Scripts/jquery.tablesorter.js"></script>--%>

    <script src="Content/pickadate/legacy.js?v=1.0000010"></script>
    <script src="Content/pickadate/picker.js?v=1.0000010"></script>
    <script src="Content/pickadate/picker.date.js?v=1.0000010"></script>
    <script src="Content/pickadate/picker.time.js?v=1.0000010"></script>

    <%--<script src="Content/easyautocomplete/jquery.easy-autocomplete.js"></script>--%>


    <script src="GlobalSettings.js?v=1.0000010"></script>
    <script src="IMAListViewModel.js?v=1.0000010"></script>

    <script src="QustionService.js?v=1.0000010"></script>
    <script src="Scripts/oidc/oidc-client.js?v=1.0000010"></script>
    <script src="Scripts/oidc/OidcPageHelper.js?v=1.0000010"></script>


    <script src="Scripts/stickyheader.js"></script>

    <script type="text/javascript">


        var synapseUserName = "";

        var questionModalOpen = false;

        //var listId = "08662d00-39f3-46bb-84fa-847da301df7b";

        var LocatorBoardID = "";
        //$('#lblLocatorBoardID').val(LocatorBoardID);

        var globalURL = GlobalServiceURL;

        var listId = "";

        var frozenMinutes = 0;

        var vm = new viewModel();

        function LoadBoard() {

            frozenMinutes = 0;

            $('#divHandoverEnabled').hide();
            $('#divHandoverDisabled').show();

            $('#chkHandoverMode').click(function () {
                $('#divHandoverEnabled').toggle();
                $('#divHandoverDisabled').toggle();
                var msg = "(0 minutes)";
                $('#refreshMinutes').text(msg);
            })
            synapseUserName = $('#lblUserFullName').text();

            SetActiveTab();

            LoadBoardWithoutVM();

            ko.applyBindings(vm);
            vm.getColumnsAndQuestions();


            setTimeout(function () {
                $('#tblList').stickyheader();
            }, 1000);


            var resized = false;

            setInterval(function () {
                if (!resized) {
                    resizeMe();
                    resized = true;
                }
            }, 1000);


            setInterval(function () {
                reloadPageIfNotEditing();
            }, 60000);
        }

        function resizeMe() {
            setTimeout(function () {
                $('#tblList').stickyheader();
            }, 1000);
        }

        function SetActiveTab() {
            var currentPage = $('#lblCurrentPage').text();

            console.log("Current Page: " + currentPage);

            $("#lbtnNavCurrentPatients").removeClass("linkActive");
            $("#lbtnNavWaitingArea").removeClass("linkActive");
            $("#lbtnNavTCIs").removeClass("linkActive");
            $("#lbtnNavRecentPatients").removeClass("linkActive");

            switch (currentPage) {
                case "Delivery":
                    $("#lbtnNavCurrentPatients").addClass("linkActive");
                    break;
                case "Triage":
                    $("#lbtnNavTCIs").addClass("linkActive");
                    break;
                case "Ward Waiting Area":
                    $("#lbtnNavWaitingArea").addClass("linkActive");
                    break;
                case "Recent Patients":
                    $("#lbtnNavRecentPatients").addClass("linkActive");
                    break;
                default:

            }
        }

        function GetBedBoardDetails() {
            //console.log("LocatorBoardID:" + LocatorBoardID);

            return $.getJSON(globalURL + "List/GetListByLocatorBoardID/" + LocatorBoardID, function (data) {
                //console.log(data);
            });

        }



        function GetWards() {
            return $.getJSON(globalURL + "GetList?synapsenamespace=meta&synapseentityname=ward&orderby=warddisplay", function (data) {
            });
        }


        function GetWardsWithWaitingArea() {
            var defaultsortstatementString = " ORDER BY wardcode ";


            var filterList = [];
            //var filter = new Object();
            //filter.filterClause = "wardcode = @wardcode";
            //filterList.push(filter);
            //Add Parameters
            //var paramList = [];
            //var param = new Object();
            //param.paramName = "wardcode";
            //param.paramValue = $('#lblLocationValue').text();
            //param.paramValue = vm.selectedWard(); // $('#ddlSelectedWard').val();


            //param.paramValue = $('#ddlUpdateReturnWard').val();

            ////console.log('Selected Ward: ' + vm.selectedWard());

            //paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            //console.log('Params:' + JSON.stringify(paramList));


            var service = "GetBaseViewListByPost/eboards_wardswithwaitingarea";


            return PostData(service, "", postData);
        }

        function GetReturnBeds() {
            var defaultsortstatementString = " ORDER BY bedsortstring ";


            var filterList = [];
            var filter = new Object();
            filter.filterClause = "wardcode = @wardcode";
            filterList.push(filter);
            //Add Parameters
            var paramList = [];
            var param = new Object();
            param.paramName = "wardcode";
            //param.paramValue = $('#lblLocationValue').text();
            //param.paramValue = vm.selectedWard(); // $('#ddlSelectedWard').val();


            param.paramValue = $('#ddlUpdateReturnWard').val();

            //console.log('Selected Ward: ' + vm.selectedWard());

            paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            //console.log('Params:' + JSON.stringify(paramList));


            var service = "GetBaseViewListByPost/eboards_bedstatus";


            return PostData(service, "", postData);
        }

        function GetAllocatedBeds() {
            var defaultsortstatementString = " ORDER BY bedsortstring ";


            var filterList = [];
            var filter = new Object();
            filter.filterClause = "wardcode = @wardcode";
            filterList.push(filter);
            //Add Parameters
            var paramList = [];
            var param = new Object();
            param.paramName = "wardcode";
            //param.paramValue = $('#lblLocationValue').text();
            //param.paramValue = vm.selectedWard(); // $('#ddlSelectedWard').val();

            var allocatedWard = vm.allocatedwardcode();
            console.log('Allocated Ward: ' + allocatedWard);

            param.paramValue = allocatedWard;



            paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            //console.log('Params:' + JSON.stringify(paramList));


            var service = "GetBaseViewListByPost/eboards_allbeds";


            return PostData(service, "", postData);
        }

        function GetBeds() {
            var defaultsortstatementString = " ORDER BY bedsortstring ";


            var filterList = [];
            var filter = new Object();
            filter.filterClause = "wardcode = @wardcode";
            filterList.push(filter);
            //Add Parameters
            var paramList = [];
            var param = new Object();
            param.paramName = "wardcode";
            //param.paramValue = $('#lblLocationValue').text();
            //param.paramValue = vm.selectedWard(); // $('#ddlSelectedWard').val();

            console.log("Ward Code Selected:" + vm.wardcode());
            console.log("Bed Code Selected:" + vm.bedcode());
            param.paramValue = vm.wardcode(); //$('#ddlSelectedWard').val();

            //console.log('Selected Ward: ' + vm.selectedWard());

            paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            //console.log('Params:' + JSON.stringify(paramList));


            var service = "GetBaseViewListByPost/eboards_bedstatus";


            return PostData(service, "", postData);
        }


        function GeCoreEncounterDetails(encounterID) {
            return $.getJSON(globalURL + "GetObject?synapsenamespace=core&synapseentityname=encounter&id=" + encounterID, function (data) {
            });
        }

        function GetEBoardEncounterDetails(encounterID) {
            return $.getJSON(globalURL + "GetObjectWithInsert?synapsenamespace=local&synapseentityname=eboards_encounter&synapseattributename=encounter_id&attributevalue=" + encounterID + "&keyvalue=" + encounterID + "&returnsystemattributes=1", function (data) {
            });
        }


        function GetWard(wardcode) {
            return $.getJSON(globalURL + "GetListByAttribute?synapsenamespace=meta&synapseentityname=ward&synapseattributename=wardcode&attributevalue=" + wardcode, function (data) {
            });
        }

        function GetBed(bedcode) {
            return $.getJSON(globalURL + "GetListByAttribute?synapsenamespace=meta&synapseentityname=wardbaybed&synapseattributename=wardbaybed_id&attributevalue=" + bedcode, function (data) {
            });
        }

        function GetListDetails() {

            return $.getJSON(globalURL + "List/GetListDetails/" + listId, function (data) {
                //console.log(data);
            });

        }

        function GetColumns() {

            return $.getJSON(globalURL + "List/GetListColumns/" + listId, function (data) {
                //console.log(data);
            });

        }

        function GetListData() {

            //console.log("IP Address: " + $('#lblIPAddress').text());
            //console.log("Locator Board ID: " + $('#lblLocatorBoardID').text());
            //console.log("Location Field: " + $('#lblLocationField').text());
            //console.log("Location Value: " + $('#lblLocationValue').text());
            var defaultsortstatementString = $('#lblDefaultSortStatement').text();

            if (!defaultsortstatementString) {
                defaultsortstatementString = " " + "ORDER BY firstname ASC ";
            }
            //console.log("Default Sort Statement: " + defaultsortstatementString);

            var filterList = [];
            var filter = new Object();
            filter.filterClause = $('#lblLocationField').text() + " = @locationid";
            filterList.push(filter);
            //Add Parameters
            var paramList = [];
            var param = new Object();
            param.paramName = "locationid";
            //param.paramValue = $('#lblLocationValue').text();
            //param.paramValue = vm.selectedWard(); // $('#ddlSelectedWard').val();


            param.paramValue = $('#ddlSelectedWard').val();

            //console.log('Selected Ward: ' + vm.selectedWard());

            paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            //console.log('Params:' + JSON.stringify(paramList));


            var service = "List/GetListDataByPost/" + listId;


            return PostData(service, "", postData);

            //return $.getJSON(globalURL + "List/GetListData/" + listId, function (data) {

            //});

        }

        function PostData(service, params, data) {

            var serviceURL = GlobalServiceURL;
            //console.log(params); console.log(data);
            //Get Request Information          
            var uri = serviceURL + service + params;

            return jQuery.ajax({
                data: data,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: encodeURI(uri),
                type: 'POST',
                success: function (result) {
                    // Do something with the result
                }
            });
        }

        function GenerateFilterData(filterList, paramList, selectStatement, ordergroupbyStatement) {

            var filterobject = new Object();
            filterobject.filters = filterList;

            var paramobject = new Object();
            paramobject.filterparams = paramList;

            var selectobject = new Object();
            selectobject.selectstatement = selectStatement;

            var ordergroupbyobject = new Object();
            ordergroupbyobject.ordergroupbystatement = ordergroupbyStatement;

            var jdata = [];
            jdata.push(filterobject);
            jdata.push(paramobject);
            jdata.push(selectobject);
            jdata.push(ordergroupbyobject);
            var json = JSON.stringify(jdata);
            //console.log(json);
            return json;
        }



        function reloadPageIfNotEditing() {


            if ($('#chkHandoverMode').is(':checked')) {


                frozenMinutes++;

                var txt = "minutes";
                if (frozenMinutes == 1) {
                    txt = "minute"
                }
                var msg = "(" + frozenMinutes + " " + txt + ")";
                $('#refreshMinutes').text(msg);

            }

            if (!questionModalOpen && !$('#chkHandoverMode').is(':checked')) {
                window.location.reload();
            }
        }


        function checkUpdateReturnStatus() {
            //console.log("ddlUpdateReturn:" + $('#ddlUpdateReturn').val());
            $('#divUpdateReturnBed').hide();

            if ($('#ddlUpdateReturn').val() === 'Not Returning') {
                $('#divUpdateReturnInfo').hide();
                $('#divUpdateReturnFields').hide();
            }
            else {
                $('#divUpdateReturnInfo').show();
                $('#divUpdateReturnFields').show();
            }


            var selectedWard = $('#ddlUpdateReturnWard').find(":selected").text();
            if (selectedWard != "Please select ...") {
                if ($('#ddlUpdateReturn').val() === 'Returning to Bed on Ward') {

                    $.when(
                        vm.geteboardEncounter()
                    ).done(
                        function (

                        ) {

                            //console.log('Got encounter');

                            $.when(
                                GetReturnBeds()
                            ).done(
                                function (
                                    Beds
                                ) {

                                    // vm.Beds(Beds);
                                    //data-bind="options: Beds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id'"


                                    var $dropdown = $("#ddlUpdateReturnBed");
                                    $dropdown.empty()
                                    var pleaseSelect = "<option />";
                                    $dropdown.append($(pleaseSelect).val(null).text("Please select ..."));
                                    $.each(Beds, function () {
                                        if (this.wardbaybed_id == vm.returnbedcode()) {
                                            var opt = "<option selected/>";
                                            if (this.enabled == false) {
                                                opt = "<option selected disabled/>";
                                            };
                                        }
                                        else {
                                            opt = "<option />";
                                            if (this.enabled == false) {
                                                opt = "<option disabled/>";
                                            };
                                        }

                                        $dropdown.append($(opt).val(this.wardbaybed_id).text(this.bedbaystatusdisplay));


                                    });





                                });

                        });

                    $('#divUpdateReturnBed').show();
                }
            }
        }


        function checkAllocationData() {
            /*
                 *  Allocation Checks
                 *  ------------------

                                AdmittedWard	AdmittedBed	    AllocatedWard	AllocatedBed	   Effect on Allocation
                    Scenario 1	    A	           nil	            A	            1	            Do Nothing
                    Scenario 2	    A	           nil	            A	           nil	            Clear Allocation 
                    Scenario 3	    A	            1	            A	            1	            Clear Allocation
                    Scenario 4	    A	            1	            A	           nil	            Clear Allocation
                    Scenario 5	    A	            1	            A	            2	            Do Nothing
                    Scenario 6	    A	           nil	            B	           nil	            Do Nothing
                */

            //console.log("checkAllocationData() called!");


            if (vm.wardcode() == vm.allocatedwardcode()) {
                console.log("Allocation check - wards are the same");
                //Admitted  Bed is nil
                if (!vm.bedcode() || vm.bedcode == "") {
                    console.log("Admitted Bed is nil");
                    //Allocated Bed is nil
                    if (!vm.allocatedbedcode() || vm.allocatedbedcode == "") {
                        //Clear Allocation - Scenario 2
                        console.log("Clear Allocation - Scenario 2");
                        vm.allocatedwardcode(null);
                        vm.allocatedbedcode(null);
                        vm.allocateddate(null);
                        vm.allocatedtime(null);
                    }
                    //Allocated Bed is not null
                    else if (vm.allocatedbedcode.length > 0) {
                        //Do nothing - Scenario 1
                        console.log("Do nothing - Scenario 1");
                    }
                    else {
                        //Do nothing - Scenario 1
                        console.log("Do nothing - Scenario 1");
                    }
                }
                else
                //Admitted Bed is not nil
                {
                    console.log("Admitted Bed is NOT nil");
                    //Allocated Bed is nil
                    if (!vm.allocatedbedcode() || vm.allocatedbedcode == "") {
                        //Clear Allocation - Scenario 4
                        console.log("Clear Allocation - Scenario 4");
                        vm.allocatedwardcode(null);
                        vm.allocatedbedcode(null);
                        vm.allocateddate(null);
                        vm.allocatedtime(null);
                    }
                    //Admitted Bed equals Allocated Bed
                    else if (vm.bedcode() == vm.allocatedbedcode()) {
                        //Clear Allocation - Scenario 3
                        console.log("Clear Allocation - Scenario 3");
                        vm.allocatedwardcode(null);
                        vm.allocatedbedcode(null);
                        vm.allocateddate(null);
                        vm.allocatedtime(null);
                    }
                    else {
                        //Do nothing - Scenario 5
                        console.log("Do nothing - Scenario 5");
                    }
                }

            }
            else {
                console.log("Allocation check - wards are NOT the same");
                // Do nothing - Scenario 6
                console.log("Do nothing - Scenario 6");
            }
        }

        function LoadBoardWithoutVM() {
            LocatorBoardID = $('#lblLocatorBoardID').text(); //getParameterByName('id'); //"aba2feb8-e00c-4aef-8c4f-cde7689543e7";
            //console.log("IP Address: " + $('#lblIPAddress').text());
            //console.log("Locator Board ID: " + $('#lblLocatorBoardID').text());
            //console.log("Location Field: " + $('#lblLocationField').text());
            //console.log("Location Value: " + $('#lblLocationValue').text());

            //$("#datetimepicker4").datetimepicker({
            //    format: 'L'
            //});

            $('#divLocationData').hide();
            $('#divReturnInformation').hide();
            $('#divQuestionData').show();

            $('#detail-modal').on('hidden.bs.modal', function (e) {
                //vm.getColumnsAndQuestions();
                $('#divLocationData').hide();
                $('#divReturnInformation').hide();
                $('#divQuestionData').show();
                questionModalOpen = false;
                vm.getListOnly();
            });

            $('#detail-modal').on('shown.bs.modal', function () {
                hideAllModalDivs();
            });

            $('#btnLocationDone').click(function (event) {
                $('#divLocationData').hide();
                $('#divReturnInformation').hide();
                $('#divQuestionData').show();
                event.preventDefault();
            });

            $('#chkIsReturning').click(function (event) {
                console.log($("#chkIsReturning").is(":checked"));
                if ($("#chkIsReturning").is(":checked")) {
                    $('#divReturnInformation').show();
                }
                else {
                    $('#divReturnInformation').hide();
                }
            });

            $('[data-toggle="popover"]').popover();



            $("#calMoveBedDate").pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: false,
                selectMonths: false
            });

            $('#calEDD').pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: true,
                selectMonths: true
            });

            $('#calReturnWardDate').pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: true,
                selectMonths: true
            });

            $('#calReturnWardTime').pickatime({
                format: 'HH:i'
            });

            //---
            $('#calAllocateDate').pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: true,
                selectMonths: true
            });

            $('#calAllocateTime').pickatime({
                format: 'HH:i'
            });
            //--

            $('#calClearBedDate').pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: true,
                selectMonths: true
            });

            $('#calMoveWardDate').pickadate({
                format: "yyyy-mm-dd",
                formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
                hiddenName: true,
                selectYears: true,
                selectMonths: true
            });

            $('#calMoveWardTime').pickatime({
                format: 'HH:i'
            });


            //Return to Huddle
            $('#btnReturnToHuddle').click(function (event) {
                vm.geteboardEncounter();
                hideAllModalDivs();
                $('#divQuestionData').show();
            });

            //Move Ward
            $('#btnMoveWard').click(function (event) {
                vm.geteboardEncounter();

                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divChangeWard').show();

                $("#ddlWard").val($("#ddlWard option:first").val());

                $('#divMoveWardError').hide();
                $('#divMoveWardDateError').hide();

                event.preventDefault();
            });

            $('#btnSaveWardMove').click(function (event) {
                event.preventDefault();



                $('#divMoveWardError').hide();
                $('#divMoveWardDateError').hide();

                $('#pMoveWardError').text("");
                var selectedWard = $('#ddlWard').find(":selected").text();
                if (selectedWard === "Please select ...") {
                    $('#divMoveWardError').show();
                    $('#pMoveWardError').text("Please select a ward");
                    event.preventDefault();
                    return;
                }



                var dt = new Date(Date.parse($("#calMoveWardDate").val()));
                dt.setMinutes(dt.getMinutes() + dt.getTimezoneOffset());

                if (isNaN(dt)) {
                    $('#divMoveWardDateError').show();
                    event.preventDefault();
                    return;
                }

                var min = 0;
                if (vm.moveMin() == "0" || vm.moveMin() == "00") {
                    min = 0;
                } else {
                    min = parseInt(
                        vm.moveMin()
                    ) || -1;
                }

                var hour = 0;
                if (vm.moveHour() == "0" || vm.moveHour() == "00") {
                    hour = 0;
                } else {
                    hour = parseInt(
                        vm.moveHour()
                    ) || -1;
                }

                if (min < 0 || min > 59) {
                    $('#divMoveWardDateError').show();
                    event.preventDefault();
                    return;
                }

                if (hour < 0 || hour > 23) {
                    $('#divMoveWardDateError').show();
                    event.preventDefault();
                    return;
                }

                var now = new Date();
                var today = new Date(now.getUTCFullYear(), now.getMonth(), now.getDate());

                if (Date.parse(dt) > Date.parse(today)) {
                    alert("Move Date cannot be in the future");
                    $('#divMoveWardDateError').show();
                    event.preventDefault();
                    return;
                }

                if (Date.parse(dt) == Date.parse(today)) {
                    if (hour > now.getHours()) {
                        alert("Move Date cannot be in the future");
                        $('#divMoveWardDateError').show();
                        event.preventDefault();
                        return;
                    }
                    else if (hour == now.getHours()) {
                        if (min > now.getMinutes()) {
                            alert("Move Date cannot be in the future");
                            $('#divMoveWardDateError').show();
                            event.preventDefault();
                            return;
                        }

                    }
                }


                var minDtAllowed = today.setDate(today.getDate() - 3);
                if (dt < minDtAllowed) {
                    alert("Move Date has to be in the last 3 days");
                    $('#divMoveWardDateError').show();
                    event.preventDefault();
                    return;
                }

                var moveDateTime = $("#calMoveWardDate").val();

                var moveHour = hour;
                if (moveHour < 10) {
                    moveHour = '0' + moveHour;
                }

                var moveMin = min;
                if (moveMin < 10) {
                    moveMin = '0' + moveMin;
                }

                if (!moveDateTime == "") {
                    moveDateTime += "T" + moveHour + ":" + moveMin + ":00.000Z";
                }
                else {
                    moveDateTime = null;
                }


                //console.log("moveDateTime:" + moveDateTime);

                vm.bedtransferdatetime(moveDateTime);




                selectedWard = $('#ddlWard').find(":selected").val();

                vm.wardcode(selectedWard);


                if (vm.wardcode() == vm.originalwardcode()) {
                    alert('Ward has not changed - save cancelled');
                    return;
                }

                //Clear the admitted bed
                vm.bedcode(null);

                checkAllocationData();

                SaveEBoardEncounter(true);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAdmitMenu').show();



            });




            //Allocate to Ward
            $('#btnAllocateWard').click(function (event) {
                vm.geteboardEncounter();

                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divChangeAllocatedWard').show();

                $("#ddlAllocatedWard").val($("#ddlWard option:first").val());

                $('#divAllocatedWardError').hide();

                event.preventDefault();
            });

            $('#btnSaveAllocatedWardMove').click(function (event) {
                event.preventDefault();
                $('#divAllocatedWardError').hide();
                $('#pAllocatedWardError').text("");
                var selectedWard = $('#ddlAllocatedWard').find(":selected").text();
                if (selectedWard === "Please select ...") {
                    $('#divAllocatedWardError').show();
                    $('#pAllocatedWardError').text("Please select a ward");
                    event.preventDefault();
                    return;
                }

                selectedWard = $('#ddlAllocatedWard').find(":selected").val();

                vm.allocatedwardcode(selectedWard);
                vm.allocatedbedcode(null);

                SaveEBoardEncounter(false);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAllocateMenu').show();

            });

            //Send to hospital Waiting Area
            $('#btnSendToHospitalWaitingArea').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divSendToHospitalWaitingArea').show();
                event.preventDefault();
            });

            $('#btnSaveMoveToHospitalWaitingArea').click(function (event) {
                //////$('#divQuestionData').show();
                //////hideAllModalDivs();
                //////vm.bedcode(null);
                //////vm.wardcode(null);
                //////SaveEBoardEncounter(true);
                //////event.preventDefault();
            });

            //Send to Ward Waiting Area
            $('#btnSendToWardWaitingArea').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divSendToWardWaitingArea').show();
                event.preventDefault();

            });

            $('#btnSaveMoveToWardWaitingArea').click(function (event) {
                $('#divQuestionData').show();
                vm.bedcode(null);
                SaveEBoardEncounter(true);
                hideAllModalDivs();
                event.preventDefault();
            });


            //Allocate Bed
            $('#btnAllocateBed').click(function (event) {

                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divChangeAllocatedBed').show();
                $('#divMoveAllocatedBedError').hide();
                $('#divNotOkayToMoveAllocatedBed').hide();

                if (!vm.allocatedwardcode() || vm.allocatedwardcode == "") {
                    $('#divNotOkayToMoveAllocatedBed').show();
                    $('#divOkayToMoveAllocatedBed').hide();
                    $('#btnSaveAllocatedBedMove').hide();
                    return;
                }

                event.preventDefault();

                vm.Beds([]);

                $.when(
                    vm.geteboardEncounter()
                ).done(
                    function (

                    ) {

                        //console.log('Got encounter');

                        $.when(
                            GetAllocatedBeds()
                        ).done(
                            function (
                                Beds
                            ) {

                                // vm.Beds(Beds);
                                //data-bind="options: Beds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id'"
                                console.log("Allocated Beds: " + JSON.stringify(Beds));

                                var $dropdown = $("#ddlAllocatedBed");
                                $dropdown.find('option')
                                    .remove()
                                    .end();
                                var pleaseSelect = "<option />";
                                $dropdown.append($(pleaseSelect).val(null).text("Please select ..."));
                                $.each(Beds, function () {
                                    if (this.wardbaybed_id == vm.allocatedwardcode()) {
                                        var opt = "<option selected/>";
                                        //if (this.enabled == false) {
                                        //    opt = "<option selected disabled/>";
                                        //};
                                    }
                                    else {
                                        opt = "<option />";
                                        //if (this.enabled == false) {
                                        //    opt = "<option disabled/>";
                                        //};
                                    }

                                    $dropdown.append($(opt).val(this.wardbaybed_id).text(this.bedbaydisplay));
                                });




                                if (!vm.allocatedwardcode()) {
                                    $('#divNotOkayToMoveAllocatedBed').show();
                                    $('#divOkayToMoveAllocatedBed').hide();
                                    $('#btnSaveAllocatedBedMove').hide();


                                }
                                else {
                                    $('#divNotOkayToMoveAllocatedBed').hide();
                                    $('#divOkayToMoveAllocatedBed').show();
                                    $('#btnSaveAllocatedBedMove').show();
                                }

                            });

                    });
            });

            $('#btnSaveAllocatedBedMove').click(function (event) {
                event.preventDefault();
                $('#divMoveAllocatedBedError').hide();
                var selectedBed = $('#ddlAllocatedBed').find(":selected").text();

                if (selectedBed === "Please select ...") {
                    $('#divMoveBedError').show();
                    event.preventDefault();
                    return;
                }

                selectedBed = $('#ddlAllocatedBed').find(":selected").val();
                vm.allocatedbedcode(selectedBed);
                //vm.hasbeeninbed(true);
                SaveEBoardEncounter(false);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAllocateMenu').show();


            });


            //Save Bed
            $('#btnMoveBed').click(function (event) {

                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divChangeBed').show();
                $('#divMoveBedError').hide();
                $('#divMoveBedDateError').hide();
                $('#divNotOkayToMoveBed').hide();

                event.preventDefault();

                vm.Beds([]);

                $.when(
                    vm.geteboardEncounter()
                ).done(
                    function (

                    ) {

                        //console.log('Got encounter');

                        $.when(
                            GetBeds()
                        ).done(
                            function (
                                Beds
                            ) {

                                // vm.Beds(Beds);
                                //data-bind="options: Beds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id'"


                                var $dropdown = $("#ddlBed");
                                $dropdown.find('option')
                                    .remove()
                                    .end();
                                var pleaseSelect = "<option />";
                                $dropdown.append($(pleaseSelect).val(null).text("Please select ..."));
                                $.each(Beds, function () {
                                    if (this.wardbaybed_id == vm.bedcode()) {
                                        var opt = "<option selected/>";
                                        if (this.enabled == false) {
                                            opt = "<option selected disabled/>";
                                        };
                                    }
                                    else {
                                        opt = "<option />";
                                        if (this.enabled == false) {
                                            opt = "<option disabled/>";
                                        };
                                    }

                                    $dropdown.append($(opt).val(this.wardbaybed_id).text(this.bedbaystatusdisplay));
                                });




                                if (!vm.wardcode()) {
                                    $('#divNotOkayToMoveBed').show();
                                    $('#divOkayToMoveBed').hide();
                                    $('#btnSaveBedMove').hide();


                                }
                                else {
                                    $('#divNotOkayToMoveBed').hide();
                                    $('#divOkayToMoveBed').show();
                                    $('#btnSaveBedMove').show();
                                }

                            });

                    });
            });

            $('#btnSaveBedMove').click(function (event) {
                event.preventDefault();
                $('#divMoveBedError').hide();
                $('#divMoveBedDateError').hide();
                var selectedBed = $('#ddlBed').find(":selected").text();

                if (selectedBed === "Please select ...") {
                    $('#divMoveBedError').show();
                    event.preventDefault();
                    return;
                }


                //var dt = Date.parse($("#calMoveBedDate").val());
                var dt = new Date(Date.parse($("#calMoveBedDate").val()));

                dt.setMinutes(dt.getMinutes() + dt.getTimezoneOffset());

                if (isNaN(dt)) {
                    $('#divMoveBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var min = 0;
                if (vm.moveMin() == "0" || vm.moveMin() == "00") {
                    min = 0;
                } else {
                    min = parseInt(
                        vm.moveMin()
                    ) || -1;
                }

                var hour = 0;
                if (vm.moveHour() == "0" || vm.moveHour() == "00") {
                    hour = 0;
                } else {
                    hour = parseInt(
                        vm.moveHour()
                    ) || -1;
                }

                console.log("min:" + min);

                if (min < 0 || min > 59) {
                    $('#divMoveBedDateError').show();
                    event.preventDefault();
                    return;
                }

                if (hour < 0 || hour > 23) {
                    $('#divMoveBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var now = new Date();
                var today = new Date(now.getUTCFullYear(), now.getMonth(), now.getDate());

                if (Date.parse(dt) > Date.parse(today)) {
                    alert("Move Date cannot be in the future");
                    $('#divMoveBedDateError').show();
                    event.preventDefault();
                    return;
                }

                if (Date.parse(dt) == Date.parse(today)) {
                    if (hour > now.getHours()) {
                        alert("Move Date cannot be in the future");
                        $('#divMoveBedDateError').show();
                        event.preventDefault();
                        return;
                    }
                    else if (hour == now.getHours()) {
                        if (min > now.getMinutes()) {
                            alert("Move Date cannot be in the future");
                            $('#divMoveBedDateError').show();
                            event.preventDefault();
                            return;
                        }

                    }
                }


                var minDtAllowed = today.setDate(today.getDate() - 3);
                if (dt < minDtAllowed) {
                    alert("Move Date has to be in the last 3 days");
                    $('#divMoveBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var moveDateTime = $("#calMoveBedDate").val();

                var moveHour = hour;
                if (moveHour < 10) {
                    moveHour = '0' + moveHour;
                }

                var moveMin = min;
                if (moveMin < 10) {
                    moveMin = '0' + moveMin;
                }

                if (!moveDateTime == "") {
                    moveDateTime += "T" + moveHour + ":" + moveMin + ":00.000Z";
                }
                else {
                    moveDateTime = null;
                }

                vm.bedtransferdatetime(moveDateTime);

                selectedBed = $('#ddlBed').find(":selected").val();
                vm.bedcode(selectedBed);
                vm.hasbeeninbed(true);


                if (vm.bedcode() == vm.originalbedcode()) {
                    alert("Bed has not changed - save cancelled");
                    return;
                }


                checkAllocationData();



                SaveEBoardEncounter(true);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAdmitMenu').show();


            });

            //Clear Bed
            $('#btnClearBed').click(function (event) {
                $('#divClearBedDateError').hide();
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divClearBed').show();
                if (!vm.wardcode()) {
                    $('#divNotOkayToClearBed').show();
                    $('#divOkayToClearBed').hide();
                    $('#btnSaveClearBed').hide();
                }
                else if (!vm.bedcode()) {
                    $('#divNotOkayToClearBed').show();
                    $('#divOkayToClearBed').hide();
                    $('#btnSaveClearBed').hide();
                }
                else {
                    $('#divNotOkayToClearBed').hide();
                    $('#divOkayToClearBed').show();
                    $('#btnSaveClearBed').show();
                }
                event.preventDefault();
            });

            $('#btnSaveClearBed').click(function (event) {

                event.preventDefault();

                $('#divClearBedDateError').hide();



                var dt = new Date(Date.parse($("#calClearBedDate").val()));
                dt.setMinutes(dt.getMinutes() + dt.getTimezoneOffset());

                //var dt = Date.parse($("#calClearBedDate").val());
                console.log(dt);

                //dt.setMinutes(dt.getMinutes() + dt.getTimezoneOffset());

                if (isNaN(dt)) {
                    $('#divClearBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var min = 0;
                if (vm.moveMin() == "0" || vm.moveMin() == "00") {
                    min = 0;
                } else {
                    min = parseInt(
                        vm.moveMin()
                    ) || -1;
                }

                var hour = 0;
                if (vm.moveHour() == "0" || vm.moveHour() == "00") {
                    hour = 0;
                } else {
                    hour = parseInt(
                        vm.moveHour()
                    ) || -1;
                }

                if (min < 0 || min > 59) {
                    $('#divClearBedDateError').show();
                    event.preventDefault();
                    return;
                }

                if (hour < 0 || hour > 23) {
                    $('#divClearBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var now = new Date();
                var today = new Date(now.getUTCFullYear(), now.getMonth(), now.getDate());

                if (Date.parse(dt) > Date.parse(today)) {
                    alert("Move Date cannot be in the future");
                    $('#divClearBedDateError').show();
                    event.preventDefault();
                    return;
                }

                if (Date.parse(dt) == Date.parse(today)) {
                    if (hour > now.getHours()) {
                        alert("Move Date cannot be in the future");
                        $('#divClearBedDateError').show();
                        event.preventDefault();
                        return;
                    }
                    else if (hour == now.getHours()) {
                        if (min > now.getMinutes()) {
                            alert("Move Date cannot be in the future");
                            $('#divClearBedDateError').show();
                            event.preventDefault();
                            return;
                        }

                    }
                }


                var minDtAllowed = today.setDate(today.getDate() - 3);
                if (dt < minDtAllowed) {
                    alert("Move Date has to be in the last 3 days");
                    $('#divClearBedDateError').show();
                    event.preventDefault();
                    return;
                }

                var moveDateTime = $("#calClearBedDate").val();

                var moveHour = hour;
                if (moveHour < 10) {
                    moveHour = '0' + moveHour;
                }

                var moveMin = min;
                if (moveMin < 10) {
                    moveMin = '0' + moveMin;
                }

                if (!moveDateTime == "") {
                    moveDateTime += "T" + moveHour + ":" + moveMin + ":00.000Z";
                }
                else {
                    moveDateTime = null;
                }

                //console.log("moveHour:" + moveHour + ", moveMin" + moveMin);

                vm.bedtransferdatetime(moveDateTime);

                vm.bedcode(null);

                console.log("Clear Bed function called");
                checkAllocationData();

                SaveEBoardEncounter(true);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAdmitMenu').show();

                event.preventDefault();
            });

            //Clear Allocate Bed
            $('#btnClearAllocatedBed').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divClearAllocatedBed').show();
                if (!vm.allocatedwardcode()) {
                    $('#divNotOkayToClearAllocatedBed').show();
                    $('#divOkayToClearAllocatedBed').hide();
                    $('#btnSaveClearAllocatedBed').hide();
                }
                else if (!vm.allocatedbedcode()) {
                    $('#divNotOkayToClearAllocatedBed').show();
                    $('#divOkayToClearAllocatedBed').hide();
                    $('#btnSaveClearAllocatedBed').hide();
                }
                else {
                    $('#divNotOkayToClearAllocatedBed').hide();
                    $('#divOkayToClearAllocatedBed').show();
                    $('#btnSaveClearAllocatedBed').show();
                }
                event.preventDefault();
            });

            $('#btnSaveClearAllocatedBed').click(function (event) {
                vm.allocatedbedcode(null);
                SaveEBoardEncounter(false);
                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });



            //Clear All Allocation Data
            $('#btnClearAllocatedAll').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divClearAllocatedAll').show();
                event.preventDefault();
            });

            $('#btnSaveClearAllocatedAll').click(function (event) {
                vm.allocatedwardcode(null);
                vm.allocatedbedcode(null);
                vm.allocateddate(null);
                vm.allocatedtime(null);
                SaveEBoardEncounter(false);
                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });


            //Update EDD
            $('#btnUpdateEDD').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divUpdateEDD').show();
                event.preventDefault();
            });

            $('#btnSaveUpdateEDD').click(function (event) {
                var selectedEDD = $("#calEDD").val();
                if (!selectedEDD == "") {
                    selectedEDD += "T00:00:00.000Z";
                }
                else {
                    selectedEDD = null;
                }

                vm.edd(selectedEDD);

                vm.bedtransferdatetime(null);

                SaveEBoardEncounter(true);

                $('#divQuestionData').show();
                hideAllModalDivs();
                event.preventDefault();
            });


            //Allocate Date Time
            $('#btnAllocateDateTime').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateDateTime').show();
                event.preventDefault();
            });

            $('#btnSaveAllocateDateTime').click(function (event) {

                event.preventDefault();

                var allocatedDate = $("#calAllocateDate").val();
                if (!allocatedDate == "") {
                    allocatedDate += "T00:00:00.000Z";
                }
                else {
                    allocatedDate = null;
                }


                var allocatedTime = $("#calAllocateTime").val();
                if (!allocatedTime == "") {
                    //Do nothing
                }
                else {
                    allocatedTime = null;
                }

                vm.allocateddate(allocatedDate);
                vm.allocatedtime(allocatedTime);

                SaveEBoardEncounter(false);

                hideAllModalDivs();
                $('#divQuestionData').hide();
                $('#divAllocateMenu').show();

            });

            //Update Return Information
            $('#btnUpdateReturn').click(function (event) {


                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divUpdateReturnInformation').show();
                $('#divUpdateReturnInfo').hide();
                $('#divUpdateReturnFields').hide();
                $('#divUpdateReturnError').hide();
                //$('#divUpdateReturnBed').hide();
                $('#pUpdateReturnError').val("");


                vm.ReturnBeds([]);

                //$.when(
                //    vm.geteboardEncounter()
                //).done(
                //    function (

                //    ) {

                //        //console.log('Got encounter');

                //        $.when(
                //            GetReturnBeds()
                //        ).done(
                //            function (
                //                Beds
                //            ) {

                //                // vm.Beds(Beds);
                //                //data-bind="options: Beds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id'"


                //                var $dropdown = $("#ddlUpdateReturnBed");
                //                var pleaseSelect = "<option />";
                //                $dropdown.append($(pleaseSelect).val(null).text("Please select ..."));
                //                $.each(Beds, function () {
                //                    if (this.wardbaybed_id == vm.returnbedcode()) {
                //                        var opt = "<option selected/>";
                //                        if (this.enabled == false) {
                //                            opt = "<option selected disabled/>";
                //                        };


                //                    }
                //                    else {
                //                        opt = "<option />";
                //                        if (this.enabled == false) {
                //                            opt = "<option disabled/>";
                //                        };
                //                    }

                //                    $dropdown.append($(opt).val(this.wardbaybed_id).text(this.bedbaystatusdisplay));


                //                });





                //            });

                //    });






                checkUpdateReturnStatus();

                event.preventDefault();
            });

            $('#ddlUpdateReturn').change(function (event) {
                checkUpdateReturnStatus();
            });

            $('#ddlUpdateReturnWard').change(function (event) {

                checkUpdateReturnStatus();
                //if (vm.originalreturnwardcode() != $('#ddlUpdateReturnWard').val()) {
                //    console.log('Not the same ward');
                $("#ddlUpdateReturnBed").val($("#ddlUpdateReturnBed option:first").val());
                //}
                //else {
                //    log('The same ward');
                //}
            });

            $('#btnSaveUpdateReturn').click(function (event) {

                event.preventDefault();
                $('#divUpdateReturnError').hide();
                $('#pUpdateReturnError').text("");

                $('#divUpdateReturnError').hide();

                var selectedWard = $('#ddlUpdateReturnWard').find(":selected").text();
                var selectedBed = $('#ddlUpdateReturnBed').find(":selected").text();

                if ($("#ddlUpdateReturn").val() == "Returning to Ward") {
                    if (selectedWard === "Please select ...") {
                        $('#divUpdateReturnError').show();
                        $('#pUpdateReturnError').text("Please select a ward");
                        event.preventDefault();
                        return;
                    }
                }

                if ($("#ddlUpdateReturn").val() == "Returning to Bed on Ward") {
                    if (selectedWard === "Please select ...") {
                        $('#divUpdateReturnError').show();
                        $('#pUpdateReturnError').text("Please select a ward");
                        event.preventDefault();
                        return;
                    }
                    if (selectedBed === "Please select ...") {
                        $('#divUpdateReturnError').show();
                        $('#pUpdateReturnError').text("Please select a bed");
                        event.preventDefault();
                        return;
                    }
                }

                var MoveWardReturn = $('#ddlUpdateReturn').find(":selected").val();

                var selectedReturnDate = $("#calReturnWardDate").val();
                if (!selectedReturnDate == "") {
                    selectedReturnDate += "T00:00:00.000Z";
                }
                else {
                    selectedReturnDate = null;
                }


                var selectedReturnTime = $("#calReturnWardTime").val();
                if (!selectedReturnTime == "") {
                    //Do nothing
                }
                else {
                    selectedReturnTime = null;
                }

                selectedWard = $('#ddlUpdateReturnWard').find(":selected").val();
                selectedBed = $('#ddlUpdateReturnBed').find(":selected").val();

                vm.returncode(MoveWardReturn);
                switch (MoveWardReturn) {
                    case "Not Returning":
                        vm.returnwardcode(null);
                        vm.returnbedcode(null);
                        vm.returndate(null);
                        vm.returntime(null);
                        break;
                    case "Returning to Ward":
                        vm.returnwardcode(selectedWard);
                        vm.returnbedcode(null);
                        vm.returndate(selectedReturnDate);
                        vm.returntime(selectedReturnTime);
                        break;
                    case "Returning to Bed on Ward":
                        vm.returnwardcode(selectedWard);
                        vm.returnbedcode(selectedBed);
                        vm.returndate(selectedReturnDate);
                        vm.returntime(selectedReturnTime);
                        break;
                    default:
                        console.log("Something else");
                        break;
                }




                SaveEBoardEncounter(false);

                $('#divQuestionData').show();
                hideAllModalDivs();
            });

            //Demographics Alias
            $('#btnUpdateDemographics').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divUpdateDemographics').show();
                event.preventDefault();
            });

            $('#btnSaveUpdateDemographics').click(function (event) {
                event.preventDefault();
                vm.aliasfirstname($('#txtAliasFirstName').val());
                vm.aliaslastname($('#txtAliasLastName').val());
                vm.likestobeknownas($('#txtAliasLikesToBeKnownAs').val());

                $.when(
                    SaveEBoardEncounter(false)
                ).done(
                    function (

                    ) {

                        $.when(
                            GetListPersonBanner('list/GetListPersonBanner/' + listID + '/' + vm.encounter_id())
                        ).done(
                            function (
                                banner
                            ) {
                                $('#patientBanner').html(banner.patientbanner);
                                $('#divQuestionData').show();
                                hideAllModalDivs();
                            });

                    });

            });


            $('#btnClearAlias').click(function (event) {
                event.preventDefault();

                var result = confirm("Are you sure that you want to clear the alias?");
                if (result) {
                    $('#txtAliasFirstName').val("");
                    $('#txtAliasLastName').val("");
                    vm.aliasfirstname(null);
                    vm.aliaslastname(null);
                    $.when(
                        SaveEBoardEncounter(false)
                    ).done(
                        function (

                        ) {

                            $.when(
                                GetListPersonBanner('list/GetListPersonBanner/' + listID + '/' + vm.encounter_id())
                            ).done(
                                function (
                                    banner
                                ) {
                                    $('#patientBanner').html(banner.patientbanner);
                                });

                        });

                }

            });


            //Admit
            $('#btnAdmit').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAdmitMenu').show();
                event.preventDefault();
            });

            //Admit
            $('#btnAllocate').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });



            //Actual Cancel Buttons
            $('#btnCancelWardMove').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAdmitMenu').show();
                event.preventDefault();
            });

            $('#btnCancelBedMove').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAdmitMenu').show();
                event.preventDefault();
            });

            $('#btnCancelClearBed').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAdmitMenu').show();
                event.preventDefault();
            });


            $('#btnCancelAllocatedWardMove').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });

            $('#btnCancelAllocatedBedMove').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });

            $('#btnCancelClearAllocatedBed').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });

            $('#btnCancelAllocateDateTime').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });

            $('#btnCancelClearAllocatedAll').click(function (event) {
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divAllocateMenu').show();
                event.preventDefault();
            });

            //Cancel Buttond
            $('.btncancel').click(function (event) {
                $('#divQuestionData').show();
                hideAllModalDivs();
                event.preventDefault();
            });

        }

        function SaveEBoardEncounter(sendWriteBack) {
            var data = new Object();

            if (!sendWriteBack) {

                moveDateTime = '';

                var dt = new Date();
                var month = dt.getMonth() + 1;
                if (parseInt(month) < 10) {
                    month = "0" + month;
                }

                var day = dt.getDay();
                if (parseInt(day) < 10) {
                    day = "0" + day;
                }

                var hours = dt.getHours();
                if (parseInt(hours) < 10) {
                    hours = "0" + hours;
                }


                var minutes = dt.getMinutes();
                if (parseInt(minutes) < 10) {
                    minutes = "0" + minutes;
                }

                var moveDt = dt.getFullYear() + '-' + month + '-' + day;
                vm.moveDate(moveDt);
                vm.moveHour(hours);
                vm.moveMin(minutes);

                var moveDateTime = moveDt;
                if (!moveDateTime == "") {
                    moveDateTime += "T" + hours + ":" + minutes + ":00.000Z";
                }
                else {
                    moveDateTime = null;
                }

                vm.bedtransferdatetime(moveDateTime);
            }

            data.eboards_encounter_id = vm.eboards_encounter_id();
            data.encounter_id = vm.encounter_id();
            data.wardcode = vm.wardcode();
            data.bedcode = vm.bedcode();
            data.edd = vm.edd();
            data.returnwardcode = vm.returnwardcode();
            data.returnbedcode = vm.returnbedcode();
            data.returndate = vm.returndate();
            data.returntime = vm.returntime();
            data.aliasfirstname = vm.aliasfirstname();
            data.aliaslastname = vm.aliaslastname();
            data.likestobeknownas = vm.likestobeknownas();
            data.returncode = vm.returncode();

            data.hasbeeninbed = vm.hasbeeninbed();

            data.allocatedwardcode = vm.allocatedwardcode();
            data.allocatedbedcode = vm.allocatedbedcode();
            data.allocateddate = vm.allocateddate();
            data.allocatedtime = vm.allocatedtime();

            data._createdby = synapseUserName;

            data.bedtransferdatetime = vm.bedtransferdatetime();

            var json = JSON.stringify(data);

            var serviceURL = GlobalServiceURL;
            var params = "";
            var service = 'PostObject?synapsenamespace=local&synapseentityname=eboards_encounter';
            var uri = serviceURL + service + params;

            var jqxhr = jQuery.ajax({
                data: json,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: encodeURI(uri),
                type: 'POST'
            }, function () {

            })
                .done(function (result) {

                    if (sendWriteBack) {
                        //Write back to PAS
                        console.log("send Writeback");
                    }

                    if (sendWriteBack) {
                        sendWriteBackMessage(vm.eboards_encounter_id());
                    }

                    vm.geteboardEncounter();

                    return 1;
                })
                .fail(function (jqxhr2, textStatus, error) {
                    var err = textStatus + ", " + error;
                    console.log("Request Failed: " + err);
                    return 0;
                })
                .always(function () {
                    console.log("complete");
                });
        }


        function sendWriteBackMessage(encounter_id) {
            return $.getJSON(globalURL + "/Interop/GenerateInpatientTransferMessage/" + encounter_id, function (data) {
                //console.log(data);
            });
        }

        //Load Return Information from VM
        function LoadReturnInfoFromVM() {

        }

        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }

        function GetListQuestionData(service) {

            //var service = service;
            var uri = globalURL + service;

            return jQuery.ajax({
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: encodeURI(uri),
                headers: {
                    "Accept": "application/json; charset=utf-8",
                    "Content-Type": "application/json; charset=utf-8"
                },
                crossDomain: true,
                type: 'GET',
                success: function (result) {
                    // Do something with the result
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });

        }

        function GetListPersonBanner(service) {

            //var service = service;
            var uri = globalURL + service;

            return jQuery.ajax({
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                url: encodeURI(uri),
                headers: {
                    "Accept": "application/json; charset=utf-8",
                    "Content-Type": "application/json; charset=utf-8"
                },
                crossDomain: true,
                type: 'GET',
                success: function (result) {
                    // Do something with the result                   
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });

        }

        function PostListQuestionData(service, data) {
            //console.log("Posted Data: " + data);
            //var service = service;
            var uri = globalURL + service;

            return jQuery.ajax({
                data: data,
                dataType: "json",
                headers: {
                    "Accept": "application/json; charset=utf-8",
                    "Content-Type": "application/json; charset=utf-8",
                },
                crossDomain: true,
                contentType: "application/json; charset=utf-8",
                url: encodeURI(uri),
                type: 'POST',
                success: function (result) {
                    // Do something with the result
                    //LoadBoard();
                    //var vm = new viewModel();
                    //vm.loadQuestions();

                    //var vm = new viewModel();            


                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    // alert(errorThrown);
                }
            });

        }

        var substringMatcher = function (strings) {
            return function findMatches(q, cb) {
                var matches, substringRegex;

                // an array that will be populated with substring matches
                matches = [];

                // regex used to determine if a string contains the substring `q`
                substrRegex = new RegExp(q, 'i');

                // iterate through the pool of strings and for any string that
                // contains the substring `q`, add it to the `matches` array
                $.each(strings, function (i, string) {
                    if (substrRegex.test(string)) {
                        matches.push(string);
                    }
                });

                cb(matches);
            };
        };

        function getAllQuestions(id) {


            if (!id) {
                return;
            }


            //console.log("id passed:" + id);

            vm.IsModalLoading(false);


            $("#detail-modal").modal("show");

            listID = listId;
            contextField = '';
            contextValue = id;

            $('#patientBanner').html("");
            $('#formContainer').html("");


            $.when(
                GetListPersonBanner('list/GetListPersonBanner/' + listID + '/' + id)
            ).done(
                function (
                    banner
                ) {

                    //console.log(banner.patientbanner);
                    $('#patientBanner').html(banner.patientbanner);

                    $('#formContainer').html("");

                    $.when(
                        //GetListPersonBanner('list/GetListPersonBanner/' + listID + '/' + id),
                        GetListQuestionData('list/GetListQuestions/' + listID + '/' + id)
                    ).done(
                        function (
                            //banner,
                            data
                        ) {
                            //console.log(banner);


                            var dt = new Date();
                            var month = dt.getMonth() + 1;
                            if (parseInt(month) < 10) {
                                month = "0" + month;
                            }
                            //console.log("month:" + month);

                            var day = dt.getDate();
                            if (parseInt(day) < 10) {
                                day = "0" + day;
                            }
                            //console.log("day:" + day);
                            var hours = dt.getHours();
                            if (parseInt(hours) < 10) {
                                hours = "0" + hours;
                            }


                            var minutes = dt.getMinutes();
                            if (parseInt(minutes) < 10) {
                                minutes = "0" + minutes;
                            }

                            var moveDt = dt.getFullYear() + '-' + month + '-' + day;
                            vm.moveDate(moveDt);
                            //console.log("vm.moveDate():" + vm.moveDate());
                            vm.moveHour(hours);
                            vm.moveMin(minutes);

                            var moveDateTime = moveDt;
                            if (!moveDateTime == "") {
                                moveDateTime += "T" + hours + ":" + minutes + ":00.000Z";
                            }
                            else {
                                moveDateTime = null;
                            }

                            vm.bedtransferdatetime(moveDateTime);






                            $.each(data, function (i, question) {

                                var questiontype_id = question.questiontype_id;

                                switch (questiontype_id) {
                                    case "bbc7acbc-b968-4dad-b9d2-ee22ce943a35":  //"Text Box (Limit 255)"                1
                                        generateTextBox(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id);
                                        //console.log(question.displayvalue);
                                        break;
                                    case "feb547a3-3b84-40c7-8007-547c9fe267e9":  //"Text Area (No limit)"                2
                                        generateTextArea(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id);
                                        break;
                                    case "3aa99ab6-9df6-4c3a-a966-6cc51ce1a3bf":  //"HTML Tag (Label, Custom HTML)"       3
                                        generateHTMLDiv(question.listquestion_id, question.htmlsnippet);
                                        break;
                                    case "fc1f2643-b491-4889-8d1a-910619b65722":  //"Drop Down List"                      4
                                        generateSelect(question.listquestion_id, question.labeltext, question.questionoptions, question.displayvalue, question.question_id);
                                        break;
                                    case "ca1f1b24-b490-4e57-8921-9f680819e47c":  //"Radio Button List"                                
                                        generateRadioList(question.listquestion_id, question.questionoptions, question.displayvalue, question.question_id);
                                        break;
                                    case "71490eff-a54b-455a-86b1-a4d5ab676f32": //"Radio Button Image List"                                
                                        generateRadioImage(question.listquestion_id, question.questionoptions, question.displayvalue, question.question_id);
                                        break;
                                    case "3d236e17-e40e-472d-95a5-5e45c5e02faf":  //"Check Box List"                      5
                                        generateCheckBoxList(question.listquestion_id, question.labeltext, question.questionoptions);
                                        break;
                                    case "6c166d07-53d0-4cd3-80f4-801cadcc88eb":  //"Calendar Control"                    6
                                        generateCalendar(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id);
                                        break;
                                    case "83d4fd68-ac33-4996-bd2a-8b6338526520":  //"Time Picker"                         7
                                        generateTimePicker(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id);
                                        break;
                                    case "4f31c02d-fa36-4033-8977-8f25bef33d52":  //"Auto-complete Selection List"        8
                                        //generateAutoComplete(id, labelText, url, defaultValue, questionID) 
                                        generateAutoComplete(question.listquestion_id, question.labeltext, question.questionoptions, question.displayvalue, question.question_id);
                                        break;
                                    case "164c31d5-d32e-4c97-91d6-a0d01822b9b6":  //"Single Checkbox (Binary)"        9                                
                                        generateCheckBox(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id, question.htmlsnippet, question.htmlsnippetalt);
                                        //generateCheckBoxList(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id, question.htmlsnippet, question.htmlsnippetalt);
                                        break;
                                    case "221ca4a0-3a39-42ff-a0f4-885ffde0f0bd": //"Checkbox Image (Binary)"
                                        generateCheckBoxImage(question.listquestion_id, question.labeltext, question.displayvalue, question.question_id, question.htmlsnippet, question.htmlsnippetalt);
                                        break;
                                    default:
                                        console.log("Missing qt:" + questiontype_id);
                                        break;
                                }

                                vm.IsModalLoading(false);
                                //var func = "'" + question.listquestion_id + "'"; //, '" + selectedItem.Questionname + "');";


                            });



                        });
                });



        }

        function hideAllModalDivs() {
            $('#divChangeWard').hide();
            $('#divSendToHospitalWaitingArea').hide();
            $('#divSendToWardWaitingArea').hide();
            $('#divChangeBed').hide();
            $('#divClearBed').hide();
            $('#divUpdateReturnInformation').hide();
            $('#divUpdateEDD').hide();
            $('#divUpdateDemographics').hide();
            $('#divChangeAllocatedWard').hide();
            $('#divChangeAllocatedBed').hide();
            $('#divClearAllocatedBed').hide();
            $('#divAllocateDateTime').hide();

            $('#divAdmitMenu').hide();
            $('#divAllocateMenu').hide();
            $('#divClearAllocatedAll').hide();


        }

    </script>
</head>
<body>



    <form id="form1" runat="server" style="height: 100%; background-color: #fff;">

        <asp:HiddenField ID="hdn_currentpatients_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_waitingarea_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_tcis_locatorboard_id" runat="server" />
        <asp:HiddenField ID="hdn_recentpatients_locatorboard_id" runat="server" />

        <div class="modal" tabindex="-1" role="dialog" id="detail-modal">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">



                    <div class="modal-header">


                        <div class="container bg-dark" id="divModalView" data-bind="visible: !IsModalLoading()">

                            <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
                                <span style="color: #fff" aria-hidden="true">&times;</span>
                            </button>

                            <%--<br />
                            <div class="row" style="margin-top: 7px;">
                                <div class="col-md-12">
                                    <div class="bg-primary text-white" style="padding: 3px; font-size: 1.3em;">
                                        <span><strong><span data-bind="text: vm.admittedWardDisplay()"></span></strong>&nbsp; <span data-bind="text: vm.admittedBedDisplay()"></span>
                                        </span>
                                    </div>
                                </div>
                            </div>--%>

                            <div class="row">
                                <div class="col-md-12">
                                    <div id="patientBanner" style="padding: 3px;"></div>
                                </div>
                            </div>



                           <%-- <div class="row">
                                <div class="col-md-12">
                                    <div class="bg-secondary text-white" style="padding: 3px;">
                                        <span>Allocated to move to : <strong><span data-bind="text: vm.allocatedWardDisplay()"></span></strong>&nbsp; <span data-bind="text: vm.allocatedBedDisplay()"></span>
                                        </span>
                                        <br />
                                        <span data-bind="text: vm.formattedAllocateDateAndTime()"></span>
                                    </div>
                                </div>
                            </div>--%>


                            <%--<div id="" class="row" style="margin-top: 7px; margin-bottom: 7px;">
                                <div class="col-md-12">
                                    <button class="btn btn-info" id="btnReturnToHuddle" type="button">Update Status</button>
                                    &nbsp;
                                        <button class="btn btn-primary" id="btnAdmit" data-bind="visible: vm.patientclasscode() == 'I'">Move</button>
                                    &nbsp;
                                        <button class="btn btn-secondary" id="btnAllocate">Allocate</button>
                                    &nbsp;
                                        <button class="btn btn-danger" id="btnUpdateEDD" type="button">Update EDD</button>
                                    &nbsp;                                        
                                        <button class="btn btn-success" id="btnUpdateDemographics" type="button">Update Alias</button>
                                </div>
                            </div>--%>

                        </div>


                    </div>

                    <div class="modal-body" style="min-height: 600px; max-height: 600px; overflow-y: auto;">






                        <div id="divAdmitMenu">
                            <div class="card">

                                <%--                                <div class="card-header bg-primary text-white">
                                   &nbsp;
                                </div>--%>

                                <div class="card-body">
                                    <button class="btn btn-primary btn-sm" id="btnMoveWard" type="button">Move Ward</button>
                                    <button class="btn btn-primary btn-sm" id="btnMoveBed" type="button">Move Bed</button>
                                    <button class="btn btn-primary btn-sm" id="btnClearBed" type="button">Clear Admitted Bed</button>
                                </div>
                            </div>
                        </div>

                        <div id="divAllocateMenu">
                            <div class="card">

                                <%-- <div class="card-header bg-secondary text-white">
                                    &nbsp;
                                </div>--%>

                                <div class="card-body">

                                    <button class="btn btn-secondary btn-sm" id="btnAllocateWard" type="button">Allocate Ward</button>
                                    <button class="btn btn-secondary btn-sm" id="btnAllocateBed" type="button">Allocate Bed</button>
                                    <button class="btn btn-secondary btn-sm" id="btnAllocateDateTime" type="button">Allocate Date Time</button>
                                    <button class="btn btn-secondary btn-sm" id="btnClearAllocatedBed" type="button">Clear Allocated Bed</button>
                                    <button class="btn btn-secondary btn-sm" id="btnClearAllocatedAll" type="button">Clear All Allocation Data</button>
                                </div>
                            </div>
                        </div>

                        <div id="divChangeWard">

                            <div class="card">

                                <div class="card-header bg-primary text-white">
                                    Move Ward
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">


                                        <div class="form-group" id="fgddlWard">
                                            <label for="ddlWard" class="control-label col-xs-4">Select Ward</label>
                                            <div class="col-xs-8">
                                                <select id="ddlWard" name="ddlWard" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: selectedWard, optionsCaption: 'Please select ...'">
                                                </select>
                                            </div>
                                        </div>


                                        <div class="container bg-dark text-white">
                                            Actual Move Time
                                                <div class="row">
                                                    <div class="col-md-6">
                                                    </div>
                                                    <div class="col-md-6">
                                                    </div>
                                                </div>
                                            <div class="row" style="padding-bottom: 7px;">
                                                <div class="col-md-12">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <input type="text" data-bind="value: moveDate" class="form-control picker__input" id="calMoveWardDate" name="calMoveWardDate" />
                                                            </td>
                                                            <td>
                                                                <input type="number" id="txtMoveWardTimeHours" data-bind="value: moveHour" class="form-control" min="0" max="23" style="max-width: 70px;" />
                                                            </td>
                                                            <td>:</td>
                                                            <td>
                                                                <input type="number" id="txtMoveWardTimeMinutes" data-bind="value: moveMin" class="form-control" min="0" max="59" style="max-width: 70px;" />
                                                            </td>
                                                        </tr>

                                                    </table>

                                                    <div id="divMoveWardDateError" class="alert alert-danger" style="margin-top: 7px;">
                                                        <h5>
                                                            <i class="fa fa-exclamation-triangle"></i>&nbsp;Invalid Date and Time 
                                                        </h5>
                                                        <p>Please select or enter a valid date time</p>
                                                    </div>



                                                </div>

                                            </div>
                                        </div>


                                        <br />



                                        <%-- <div class="alert alert-info">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                            </h5>
                                            <p>Moving a patient to another ward will make this patient drop off the current ward list and move to the current list of the newly selected ward</p>
                                            <p>Admittted Bed Information will be cleared</p>
                                        </div>--%>

                                        <div id="divMoveWardError" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                            </h5>
                                            <p id="pMoveWardError"></p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelWardMove" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveWardMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move Patient to Ward</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>




                        </div>

                        <div id="divSendToHospitalWaitingArea">

                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Move to Hospital Waiting Area
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">

                                        <div class="form-group">
                                            <label for="ddlCurrentHospitalWaitingAreaWard" class="control-label col-xs-4">Current Ward</label>
                                            <div class="col-xs-8">
                                                <select id="ddlCurrentHospitalWaitingAreaWard" name="ddlCurrentHospitalWaitingAreaWard" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: vm.wardcode(), optionsCaption: 'No ward selected', disable: true">
                                                </select>
                                            </div>
                                        </div>

                                        <div class="alert alert-info">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                            </h5>
                                            <p>Moving the patient to the Hospital Waiting Area will make this patient drop off the current ward list and move to the current list of the newly selected ward</p>
                                            <p>The patient will still be available under the Recent Patient's list</p>
                                        </div>


                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelMoveToHospitalWaitingArea" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveMoveToHospitalWaitingArea" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move to Hospital Waiting Area</button>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div>



                        </div>

                        <div id="divSendToWardWaitingArea">

                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Move to Ward Waiting Area
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">

                                        <div class="form-group">
                                            <label for="ddlCurrentClearWard" class="control-label col-xs-4">Current Ward</label>
                                            <div class="col-xs-8">
                                                <select id="ddlCurrentClearWard" name="ddlCurrentClearWard" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: vm.wardcode(), optionsCaption: 'No ward selected', disable: true">
                                                </select>
                                            </div>
                                        </div>

                                        <div class="alert alert-info">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                            </h5>
                                            <p>Moving the patient to the Ward Waiting Area will make this patient drop off the current ward list and move to the ward waiting area for the current area</p>
                                            <p>The patient will still be available under the Recent Patient's list</p>
                                        </div>


                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelMoveToWardWaitingArea" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveMoveToWardWaitingArea" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move to Ward Waiting Area</button>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div>

                        </div>

                        <div id="divChangeBed">

                            <div class="card">

                                <div class="card-header bg-primary text-white">
                                    Move Bed
                                </div>



                                <div class="card-body">

                                    <div id="divOkayToMoveBed">

                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="ddlBed" class="control-label col-xs-4">Select Bed</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlBed" name="ddlBed" class="select form-control">
                                                    </select>

                                                </div>
                                            </div>

                                            <div class="container bg-dark text-white">
                                                Actual Move Time
                                                <div class="row">
                                                    <div class="col-md-6">
                                                    </div>
                                                    <div class="col-md-6">
                                                    </div>
                                                </div>
                                                <div class="row" style="padding-bottom: 7px;">
                                                    <div class="col-md-12">
                                                        <table>
                                                            <tr>
                                                                <td>
                                                                    <input type="text" data-bind="value: moveDate" class="form-control picker__input" id="calMoveBedDate" name="calMoveBedDate" />
                                                                </td>
                                                                <td>
                                                                    <input type="number" id="txtMoveTimeHours" data-bind="value: moveHour" class="form-control" min="0" max="23" style="max-width: 70px;" />
                                                                </td>
                                                                <td>:</td>
                                                                <td>
                                                                    <input type="number" id="txtMoveTimeMinutes" data-bind="value: moveMin" class="form-control" min="0" max="59" style="max-width: 70px;" />
                                                                </td>
                                                            </tr>

                                                        </table>

                                                        <div id="divMoveBedDateError" class="alert alert-danger" style="margin-top: 7px;">
                                                            <h5>
                                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Invalid Date and Time 
                                                            </h5>
                                                            <p>Please select or enter a valid date and time</p>
                                                        </div>



                                                    </div>

                                                </div>
                                            </div>


                                            <br />

                                        </div>

                                        <div id="divMoveBedError" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                            </h5>
                                            <p>Please select a bed to admit the patient to</p>
                                        </div>
                                    </div>

                                    <div id="divNotOkayToMoveBed" class="alert alert-danger">
                                        <h5>
                                            <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to admit to bed 
                                        </h5>
                                        <p>This patient is not currently admitted to a ward</p>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <button id="btnCancelBedMove" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                        </div>
                                        <div class="col-md-6">
                                            <button id="btnSaveBedMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move Patient to Bed</button>
                                        </div>
                                    </div>



                                </div>
                            </div>

                        </div>

                        <div id="divClearBed">
                            <div class="card">

                                <div class="card-header bg-primary text-white">
                                    Clear Admitted Bed
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">


                                        <div id="divOkayToClearBed">
                                            <%--   <div class="alert alert-info">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                                </h5>
                                                <p>Clearing the admitted bed will make this patient drop off the current ward list and move to the ward waiting area for the current area</p>
                                            </div>--%>
                                        </div>

                                        <div class="container bg-dark text-white">
                                            Actual Clear Bed Time
                                                <div class="row">
                                                    <div class="col-md-6">
                                                    </div>
                                                    <div class="col-md-6">
                                                    </div>
                                                </div>
                                            <div class="row" style="padding-bottom: 7px;">
                                                <div class="col-md-12">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <input type="text" data-bind="value: moveDate" class="form-control picker__input" id="calClearBedDate" name="calClearBedDate" />
                                                            </td>
                                                            <td>
                                                                <input type="number" id="txtClearTimeHours" data-bind="value: moveHour" class="form-control" min="0" max="23" style="max-width: 70px;" />
                                                            </td>
                                                            <td>:</td>
                                                            <td>
                                                                <input type="number" id="txtClearTimeMinutes" data-bind="value: moveMin" class="form-control" min="0" max="59" style="max-width: 70px;" />
                                                            </td>
                                                        </tr>

                                                    </table>

                                                    <div id="divClearBedDateError" class="alert alert-danger" style="margin-top: 7px;">
                                                        <h5>
                                                            <i class="fa fa-exclamation-triangle"></i>&nbsp;Invalid Date and Time 
                                                        </h5>
                                                        <p>Please select or enter a valid date and time</p>
                                                    </div>




                                                </div>

                                            </div>
                                        </div>

                                        <br />

                                        <div id="divNotOkayToClearBed" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to clear admitted bed 
                                            </h5>
                                            <p>This patient is not currently admitted to a ward and a bed</p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelClearBed" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveClearBed" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Clear Admitted Bed</button>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>


                        <div id="divChangeAllocatedWard">

                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Allocate to Ward
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">


                                        <div class="form-group" id="fgddlAllocatedWard">
                                            <label for="ddlAllocatedWard" class="control-label col-xs-4">Select Ward</label>
                                            <div class="col-xs-8">
                                                <select id="ddlAllocatedWard" name="ddlAllocatedWard" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', optionsCaption: 'Please select ...'">
                                                </select>
                                            </div>
                                        </div>




                                        <%--  <div class="alert alert-info">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                            </h5>
                                            <p>Moving a patient to another ward could potentiall move a patient off the current list</p>
                                            <p>Allocated Bed Information will be cleared</p>
                                        </div>--%>

                                        <div id="divAllocatedWardError" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                            </h5>
                                            <p id="pAllocatedWardError"></p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelAllocatedWardMove" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveAllocatedWardMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Allocate Patient to Ward</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>




                        </div>


                        <div id="divChangeAllocatedBed">

                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Allocate Bed
                                </div>



                                <div class="card-body">

                                    <div id="divOkayToMoveAllocatedBed">

                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="ddlAllocatedBed" class="control-label col-xs-4">Select Bed</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlAllocatedBed" name="ddlAllocatedBed" class="select form-control">
                                                    </select>

                                                </div>
                                            </div>
                                        </div>

                                        <div id="divMoveAllocatedBedError" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                            </h5>
                                            <p>Please select a bed to allocate the patient to</p>
                                        </div>
                                    </div>

                                    <div id="divNotOkayToMoveAllocatedBed" class="alert alert-danger">
                                        <h5>
                                            <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to allocate to bed 
                                        </h5>
                                        <p>This patient is not currently allocated to a ward</p>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <button id="btnCancelAllocatedBedMove" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                        </div>
                                        <div class="col-md-6">
                                            <button id="btnSaveAllocatedBedMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Allocate Patient to Bed</button>
                                        </div>
                                    </div>



                                </div>
                            </div>

                        </div>


                        <div id="divClearAllocatedBed">
                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Clear Allocated Bed
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">


                                        <div id="divOkayToClearAllocatedBed">
                                            <%--<div class="alert alert-info">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note this will clear the allocated bed
                                                </h5>
                                            </div>--%>
                                        </div>

                                        <div id="divNotOkayToClearAllocatedBed" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to clear allocated bed 
                                            </h5>
                                            <p>This patient is not currently allocated to a ward and bed</p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelClearAllocatedBed" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveClearAllocatedBed" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Clear Allocated Bed</button>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>



                        <div id="divClearAllocatedAll">
                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Clear All Allocation Data
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">


                                        <div id="divOkayToClearAllocatedAll">
                                            <%--<div class="alert alert-info">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note this will clear the allocated information, including Allocated Ward, Allocated Bed and Allocated Date / Time
                                                </h5>
                                            </div>--%>
                                        </div>


                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelClearAllocatedAll" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveClearAllocatedAll" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Clear All Allocation Information</button>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>


                        <div id="divAllocateDateTime">
                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Allocation Date and Time
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">

                                        <div class="form-group" id="fgAllocateDateTime">
                                            <label class="control-label col-xs-4">Allocation Date \ Time</label>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <small>Date</small>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <input type="text" data-bind="value: vm.formattedAllocateDateTime()" class="form-control picker__input" id="calAllocateDate" name="calAllocateDate" />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <small>Time</small>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <input type="text" data-bind="value: vm.allocatedtime()" class="form-control picker__input" id="calAllocateTime" name="calAllocateTime" />
                                                </div>
                                            </div>
                                        </div>

                                    </div>


                                    <div class="row">
                                        <div class="col-md-6">
                                            <button id="btnCancelAllocateDateTime" class="btn btn-light"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                        </div>
                                        <div class="col-md-6">
                                            <button id="btnSaveAllocateDateTime" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Update Allocation Date Time</button>
                                        </div>
                                    </div>

                                </div>

                            </div>
                        </div>



                        <div id="divUpdateReturnInformation">
                            <div class="card">

                                <div class="card-header bg-secondary text-white">
                                    Allocation Information
                                </div>

                                <div class="card-body">
                                    <div class="form-horizontal">




                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="ddlUpdateReturn" class="control-label col-xs-4">Allocation Detail</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlUpdateReturn" name="ddlUpdateReturn" class="select form-control" data-bind="value: vm.returncode()">
                                                        <option value="Not Returning">Not Allocated</option>
                                                        <option value="Returning to Ward">Allocated to Ward Only (No bed specified)</option>
                                                        <option value="Returning to Bed on Ward">Allocated to Ward and Bed</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div id="divUpdateReturnInfo" class="alert alert-success">
                                            <i class="fa fa-bed"></i>&nbsp;
                                                <label id="lblUpdateReturn">Patient is allocated</label>
                                        </div>

                                        <div id="divUpdateReturnFields">

                                            <div class="form-group">
                                                <label for="ddlUpdateReturnWard" class="control-label col-xs-4">Select Ward</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlUpdateReturnWard" name="ddlWard" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: vm.returnwardcode(), optionsCaption: 'Please select ...'">
                                                    </select>

                                                </div>
                                            </div>

                                            <div class="form-group" id="divUpdateReturnBed">
                                                <label for="ddlUpdateReturnBed" class="control-label col-xs-4">Select Bed</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlUpdateReturnBed" name="ddlUpdateReturnBed" class="select form-control">
                                                    </select>
                                                </div>
                                            </div>



                                            <div class="form-group" id="divUpdateReturnDates">
                                                <label class="control-label col-xs-4">Allocation Date \ Time</label>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <small>Date</small>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <%--<h1 data-bind="text: vm.formattedReturnDate()"></h1>--%>
                                                        <input type="text" data-bind="value: vm.formattedReturnDate()" class="form-control picker__input" id="calReturnWardDate" name="calReturnWardDate" />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <small>Time</small>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <input type="text" data-bind="value: vm.returntime()" class="form-control picker__input" id="calReturnWardTime" name="calReturnWardTime" />
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                        <div id="divUpdateReturnError" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                            </h5>
                                            <p id="pUpdateReturnError"></p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelUpdateReturn" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveUpdateReturn" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Update Allocation Information</button>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="divUpdateEDD">

                            <div class="card">

                                <%--                                <div class="card-header bg-danger text-white">
                                    Update EDD
                                </div>--%>

                                <div class="card-body">
                                    <div class="form-horizontal">
                                        <div class="form-group">
                                            <%--<label for="calEDD" class="control-label col-xs-4">Update EDD</label>--%>
                                            <div class="row">
                                                <div class="col-xs-4">

                                                    <input type="text" data-bind="value: vm.formattedEDD()" class="form-control picker__input" id="calEDD" name="calEDD" />

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%--                                            <div id="divMoveBedError" class="alert alert-danger">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                                </h5>
                                                <p>Please select a bed to move the patient to</p>
                                            </div>--%>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <button id="btnCancelUpdateEDD" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                        </div>
                                        <div class="col-md-6">
                                            <button id="btnSaveUpdateEDD" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Update EDD</button>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>

                        <div id="divQuestionData">
                            <%-- <div class="card">--%>

                            <%--   <div class="card-header bg-info text-white">
                                    Update Status
                                </div>--%>

                            <%--<div class="card-body">--%>
                            <div id="formContainer">
                            </div>
                            <%--</div>--%>
                            <%--</div>--%>
                        </div>

                        <div id="divUpdateDemographics">

                            <div class="card">

                                <%--    <div class="card-header bg-success text-white">
                                    Patient Alias
                                </div>--%>

                                <div class="card-body">
                                    <div class="form-horizontal">

                                        <h3>Patient Alias&nbsp;
                                            <button id="btnClearAlias" class="btn btn-sm btn-danger"><i class="fa fa-exclamation-triangle"></i>&nbsp;Clear Alias Data</button></h3>
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="txtAliasFirstName" class="control-label col-xs-4">Alias First Name</label>
                                                <div class="col-xs-8">
                                                    <input id="txtAliasFirstName" type="text" class="form-control" data-bind="value: vm.eboardencounter().aliasfirstname" />
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="txtAliasLastName" class="control-label col-xs-4">Alias Last Name</label>
                                                <div class="col-xs-8">
                                                    <input id="txtAliasLastName" type="text" class="form-control" data-bind="value: vm.eboardencounter().aliaslastname" />
                                                </div>
                                            </div>
                                        </div>





                                        <h3>Likes to be known as</h3>
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="txtAliasLikesToBeKnownAs" class="control-label col-xs-4">Likes to be known as</label>
                                                <div class="col-xs-8">
                                                    <input id="txtAliasLikesToBeKnownAs" type="text" class="form-control" data-bind="value: vm.eboardencounter().likestobeknownas" />
                                                </div>
                                            </div>
                                        </div>

                                        <%-- <div class="alert alert-info">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                            </h5>
                                            <p>Updating the Patient Alias will change the name in any of the patient lists</p>
                                        </div>--%>


                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelUpdateDemographics" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveUpdateDemographics" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Update Patient Alias</button>
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div>



                        </div>

                    </div>



                </div>


                <div id="divModalLoading" data-bind="visible: IsModalLoading">

                    <%--<img src="img/ajax_loader.gif" style="max-height: 100%;"/>--%>

                    <div id="modal-loader-wrapper">
                        <div id="modal-loader"></div>

                        <div class="loader-section section-left"></div>
                        <div class="loader-section section-right"></div>

                    </div>

                </div>


            </div>
            <%-- <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
                            <span style="color: #b16060" aria-hidden="true">&times;</span>
                        </button>
                    </div>--%>
        </div>


        <div class="container-fluid" hidden>
            <div class="row bg-info text-white">
                <div class="col-md-4">
                    <button class="btn btn-info btn-sm">
                        <asp:Label ID="lblNavIMAPage" runat="server"></asp:Label>
                    </button>
                </div>
                <div class="col-md-4">
                </div>
                <div class="col-md-4" style="padding-top: 4px;">
                    <a href="Default.aspx" class="btn btn-info btn-sm float-right">Home</a>
                </div>
            </div>
        </div>


        <div class="container-fluid">


            <div class="row">


                <div class="col-md-6">


                    <div class="navbar sticky-top navbar-expand-lg navbar-light" style="background-color: #fff;">



                        <%--<a class="navbar-brand" href="#">iBoards</a>--%>


                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNavDropdown">



                            <ul class="navbar-nav mr-auto">
                                <li class="nav-item tabbedButton">
                                    <asp:LinkButton ID="lbtnNavCurrentPatients" runat="server" CssClass="nav-link" OnClick="lbtnNavCurrentPatients_Click">
                                        <asp:Label runat="server" ID="lblNavCurrentPatients" Text="Delivery"></asp:Label>
                                        &nbsp;
                            <asp:Label runat="server" ID="lblNavCurrentPatientsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                        &nbsp;&nbsp
                                    </asp:LinkButton>
                                </li>
                                <li class="nav-item tabbedButton">
                                    <asp:LinkButton ID="lbtnNavTCIs" runat="server" CssClass="nav-link" OnClick="lbtnNavTCIs_Click">
                                        <asp:Label runat="server" ID="lblNavTCIs" Text="Triage"></asp:Label>
                                        &nbsp;
                            <asp:Label runat="server" ID="lblNavTCIsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                        &nbsp;&nbsp
                                    </asp:LinkButton>
                                </li>
                                <li class="nav-item tabbedButton" hidden>
                                    <asp:LinkButton ID="lbtnNavWaitingArea" runat="server" CssClass="nav-link" OnClick="lbtnNavWaitingArea_Click">
                                        <asp:Label runat="server" ID="lblNavWaitingArea" Text="Waiting for a bed"></asp:Label>
                                        &nbsp;
                            <asp:Label runat="server" ID="lblNavWaitingAreaCount" Text="0" CssClass="badge badge-info"></asp:Label>
                                        &nbsp;&nbsp
                                    </asp:LinkButton>
                                </li>
                                <li class="nav-item tabbedButton hidden">
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

                <div class="col-md-6">


                    <div class="row" style="padding-top: 3px;">
                        <div class="col-md-6">

                            <div>
                                <div class="dropdown" style="z-index: 999;">
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

                                    <%--&nbsp;--%>

                                    <%--<a href="Default.aspx" class="btn btn-light btn-sm "><i class="fa fa-home"></i>&nbsp;</a>--%>
                                </div>
                            </div>

                        </div>
                        <div class="col-md-6" style="text-align: right; font-size: 0.8em;">
                            <div>
                                <%--class="bg-secondary text-white" style="padding: 5px; border-radius: 7px;">--%>
                                <table>
                                    <tr>
                                        <td>
                                            <span class="text-sm-left text-dark"> Refresh:                                
                                            </span>
                                        </td>
                                        <td style="padding-top: 4px;">
                                            <input type="checkbox" id="chkHandoverMode" class="custom-checkbox" />
                                        </td>
                                        <td>
                                            <div class="alert alert-danger" id="divHandoverEnabled">
                                                <span class="text-sm-left">
                                                    <i class="fa fa-bell"></i>&nbsp;Disabled
                                                </span>
                                               &nbsp;
                                                <span style="font-style: italic; font-size: 0.9em;" id="refreshMinutes"></span>
                                            </div>

                                            <div class="alert alert-success" id="divHandoverDisabled">
                                                <span class="text-sm-left">
                                                    <i class="fa fa-check"></i>&nbsp;Enabled
                                                </span>
                                            </div>
                                        </td>
                                    </tr>
                                </table>



                            </div>
                        </div>
                    </div>

                </div>


            </div>

        </div>

        <div class="container-fluid">



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

                <div class="hidden">
                    <asp:Literal ID="ltrlTopLeft" runat="server" Visible="false"></asp:Literal>
                </div>



                <div class="row">
                    <div class="col-md-5">
                        <asp:Literal ID="ltrlHeading" runat="server"></asp:Literal>
                    </div>
                    <div class="col-md-7">



                        <asp:Literal ID="ltrlTopRight" runat="server"></asp:Literal>




                    </div>
                </div>

                <div class="row" style="border-top: 1px solid gray; padding-top: 3px;">

                    <div class="col-md-4">
                        <div class="h5" style="margin-top: 4px;">
                            <asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                        </div>
                    </div>

                    <div class="col-md-4">

                        <%--Dropdown goes here--%>
                    </div>

                    <div class="col-md-4">
                        <span class="pull-right">
                            <asp:Label ID="lblSelectWard" runat="server" Text="Select Ward: "></asp:Label>
                        <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectedWard_SelectedIndexChanged" ID="ddlSelectedWard" CssClass="form-control-sm"></asp:DropDownList>
                        </span>
                    </div>

                </div>



                <div id="tableSection" style="margin-top: 0px;">
                    <table data-bind="css: TableCSS" id="tblList" class="table">
                        <thead class="thead-dark sticky-top">
                            <tr data-bind="foreach: ColumnData">
                                <th class="">
                                    <span data-bind="text: displayname"></span>
                                </th>
                            </tr>
                        </thead>
                        <tbody data-bind="foreach: DynamicListData">
                            <tr data-bind="foreach: $parent.columnNames, css: cssclass, click: $parent.loadQuestions">
                                <td data-bind="html: JSON.parse(ko.toJS($parent[$data])).attributevalue, css: JSON.parse(ko.toJS($parent[$data])).defaultcssclassname"></td>
                            </tr>
                        </tbody>
                    </table>
                </div>





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


        <div id="divLoading" data-bind="visible: IsLoading" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); transform: -webkit-translate(-50%, -50%); transform: -moz-translate(-50%, -50%); transform: -ms-translate(-50%, -50%); z-index: 9999;">

            <%--<img src="img/ajax_loader.gif" style="max-height: 100%;"/>--%>

            <div id="loader-wrapper">
                <div id="loader"></div>

                <div class="loader-section section-left"></div>
                <div class="loader-section section-right"></div>

            </div>

        </div>

        <%--</div>--%>
    </form>

</body>
</html>
