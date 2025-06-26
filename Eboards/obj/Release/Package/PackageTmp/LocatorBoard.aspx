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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocatorBoard.aspx.cs" Inherits="EBoards.LocatorBoard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-title" content="Locator Boards" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    <%--<meta name="viewport" content="width=device-width, initial-scale=1.0"/>--%>
    <link rel="apple-touch-icon" href="img/LocatorIcon.png" />
    <link rel="shortcut icon" type="image/x-icon" href="img/LocatorIcon.png" />

    <title>Locator Board</title>


    <link href="css/custom.css?v=1.0000010" rel="stylesheet" />
    <link href="Content/bootstrap.css?v=1.0000010" rel="stylesheet" />



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


    <script src="globalsettings.js?v=1.0000010"></script>
    <script src="IMAListViewModel.js"></script>

    <script src="QustionService.js"></script>
    <script src="Scripts/oidc/oidc-client.js?v=1.0000010"></script>
    <script src="Scripts/oidc/OidcPageHelper.js?v=1.0000010"></script>



    <script type="text/javascript">


        var synapseUserName = "";

        var questionModalOpen = false;

        //var listId = "08662d00-39f3-46bb-84fa-847da301df7b";

        var LocatorBoardID = "";
        //$('#lblLocatorBoardID').val(LocatorBoardID);

        var globalURL = GlobalServiceURL;

        var listId = "";

        var vm = new viewModel();

        function LoadBoard() {

            synapseUserName = $('#lblUserFullName').text();

            LoadBoardWithoutVM();

            ko.applyBindings(vm);
            vm.getColumnsAndQuestions();

            setInterval(function () {
                reloadPageIfNotEditing();
            }, 60000);
        }

        function GetBedBoardDetails() {
            console.log("LocatorBoardID:" + LocatorBoardID);

            return $.getJSON(globalURL + "List/GetListByLocatorBoardID/" + LocatorBoardID, function (data) {
                //console.log(data);
            });

        }



        function GetWards() {
            return $.getJSON(globalURL + "GetList?synapsenamespace=meta&synapseentityname=ward&orderby=warddisplay", function (data) {
            });
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


            var service = "GetBaseViewListByPost/eboards_bedstatus";


            return PostData(service, "", postData);
        }



        function GetEBoardEncounterDetails(encounterID) {
            return $.getJSON(globalURL + "GetObjectWithInsert?synapsenamespace=local&synapseentityname=eboards_encounter&synapseattributename=encounter_id&attributevalue=" + encounterID + "&keyvalue=" + encounterID + "&returnsystemattributes=1", function (data) {
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

            console.log("IP Address: " + $('#lblIPAddress').text());
            console.log("Locator Board ID: " + $('#lblLocatorBoardID').text());
            console.log("Location Field: " + $('#lblLocationField').text());
            console.log("Location Value: " + $('#lblLocationValue').text());
            var defaultsortstatementString = $('#lblDefaultSortStatement').text();

            if (!defaultsortstatementString) {
                defaultsortstatementString = " " + "ORDER BY firstname ASC ";
            }
            console.log("Default Sort Statement: " + defaultsortstatementString);

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

            console.log('Selected Ward: ' + vm.selectedWard());

            paramList.push(param);
            //Select Statement
            var selectstatement = "SELECT *";
            //Order and Group By Statement
            var ordergroupbystatement = defaultsortstatementString;
            //Get the data to post from the helper function
            var postData = GenerateFilterData(filterList, paramList, selectstatement, ordergroupbystatement);

            console.log('Params:' + JSON.stringify(paramList));


            var service = "List/GetListDataByPost/" + listId;


            return PostData(service, "", postData);

            //return $.getJSON(globalURL + "List/GetListData/" + listId, function (data) {

            //});

        }

        function PostData(service, params, data) {

            var serviceURL = GlobalServiceURL;

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
            //console.log("questionModalOpen:" + questionModalOpen);
            if (!questionModalOpen) {
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

                    vm.getReturnBeds();

                    $('#divUpdateReturnBed').show();
                }
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
                $("#ddlMoveWardReturn").val($("#ddlMoveWardReturn option:first").val());

                $("#calMoveWardDate").val("");
                $("#calMoveWardTime").val("");

                $('#divMoveWardPatientReturning').hide();
                $('#divMoveWardReturn').hide();
                $('#divMoveWardError').hide();

                event.preventDefault();
            });

            $('#btnSaveWardMove').click(function (event) {
                event.preventDefault();
                $('#divMoveWardError').hide();
                var selectedWard = $('#ddlWard').find(":selected").text();
                if (selectedWard === "Please select ...") {
                    $('#divMoveWardError').show();
                    event.preventDefault();
                    return;
                }

                selectedWard = $('#ddlWard').find(":selected").val();
                vm.bedcode(null);

                var MoveWardReturn = $('#ddlMoveWardReturn').find(":selected").val();
                vm.returncode(MoveWardReturn);
                console.log("MoveWardReturn:" + MoveWardReturn);

                var selectedReturnDate = $("#calMoveWardDate").val();
                if (!selectedReturnDate == "") {
                    selectedReturnDate += "T00:00:00.000Z";
                }
                else {
                    selectedReturnDate = null;
                }


                var selectedReturnTime = $("#calMoveWardTime").val();
                if (!selectedReturnTime == "") {
                    //Do nothing
                }
                else {
                    selectedReturnTime = null;
                }


                switch (MoveWardReturn) {
                    case "Not Returning":
                        vm.returnwardcode(null);
                        vm.returnbedcode(null);
                        vm.returndate(null);
                        vm.returntime(null);
                        break;
                    case "Returning to Ward":
                        vm.returnwardcode(vm.originalwardcode());
                        vm.returnbedcode(null);
                        vm.returndate(selectedReturnDate);
                        vm.returntime(selectedReturnTime);
                        break;
                    case "Returning to Bed on Ward":
                        vm.returnwardcode(vm.originalwardcode());
                        vm.returnbedcode(vm.originalbedcode());
                        vm.returndate(selectedReturnDate);
                        vm.returntime(selectedReturnTime);
                        break;
                    default:
                        console.log("Something else");
                        break;
                }

                //Set after return information set
                vm.wardcode(selectedWard);

                SaveEBoardEncounter(true);



                $('#divQuestionData').show();
                hideAllModalDivs();
                //alert('Ward move completed');

            });

            $('#ddlMoveWardReturn').change(function (event) {
                if ($('#ddlMoveWardReturn').val() === 'Not Returning') {
                    $('#divMoveWardPatientReturning').hide();
                    $('#divMoveWardReturn').hide();
                }
                else {
                    $('#divMoveWardPatientReturning').show();
                    $('#divMoveWardReturn').show();
                }
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
                $('#divQuestionData').show();
                hideAllModalDivs();
                vm.bedcode(null);
                vm.wardcode(null);
                SaveEBoardEncounter(true);
                event.preventDefault();
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


            //Move Bed
            $('#btnMoveBed').click(function (event) {
                event.preventDefault();
                $.when(
                    vm.getBeds()
                ).done(
                    function (

                    ) {
                        vm.geteboardEncounter();
                        $('#divQuestionData').hide();
                        hideAllModalDivs();
                        $('#divChangeBed').show();
                        $('#divMoveBedError').hide();
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

            $('#btnSaveBedMove').click(function (event) {
                event.preventDefault();
                $('#divMoveBedError').hide();
                var selectedBed = $('#ddlBed').find(":selected").text();

                if (selectedBed === "Please select ...") {
                    $('#divMoveBedError').show();
                    event.preventDefault();
                    return;
                }

                selectedBed = $('#ddlBed').find(":selected").val();
                vm.bedcode(selectedBed);

                SaveEBoardEncounter(true);

                hideAllModalDivs();
                $('#divQuestionData').show();


            });


            //Clear Bed
            $('#btnClearBed').click(function (event) {
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divClearBed').show();
                if (!vm.wardcode()) {
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
                vm.bedcode(null);
                SaveEBoardEncounter(true);
                $('#divQuestionData').show();
                hideAllModalDivs();
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
                SaveEBoardEncounter(true);

                $('#divQuestionData').show();
                hideAllModalDivs();
                event.preventDefault();
            });

            //Update Return Information
            $('#btnUpdateReturn').click(function (event) {
                vm.getReturnBeds();
                vm.geteboardEncounter();
                $('#divQuestionData').hide();
                hideAllModalDivs();
                $('#divUpdateReturnInformation').show();
                $('#divUpdateReturnInfo').hide();
                $('#divUpdateReturnFields').hide();
                $('#divUpdateReturnError').hide();
                //$('#divUpdateReturnBed').hide();
                $('#pUpdateReturnError').val("");
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
                vm.aliasfirstname($('#txtAliasFirstName').val());
                vm.aliaslastname($('#txtAliasLastName').val());
                vm.likestobeknownas($('#txtAliasLikesToBeKnownAs').val());
                SaveEBoardEncounter(false);

                $('#divQuestionData').show();
                hideAllModalDivs();
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

            data._createdby = synapseUserName;

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

            vm.IsModalLoading(true);


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

                        <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
                            <span style="color: #b16060" aria-hidden="true">&times;</span>
                        </button>

                        <h3 class="modal-title">
                            <%--<span id="modalTitle" data-bind="text: vm.selectedEncounterID"></span>--%>
                        </h3>




                    </div>

                    <div class="modal-body" style="min-height: 600px;">


                        <div id="divModalView" data-bind="visible: !IsModalLoading()">
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="patientBanner"></div>
                                </div>
                            </div>

                            <br />

                            <div id="divModalMenu" class="row">
                                <div class="col-md-12">
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-block btn-info dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Huddle
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" id="btnReturnToHuddle" type="button">Return to Huddle</button>
                                        </div>
                                    </div>
                                    &nbsp;
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-block btn-secondary dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Ward
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" id="btnMoveWard" type="button">Change Ward</button>
                                            <button class="dropdown-item" id="btnSendToHospitalWaitingArea" type="button">Send to Hospital Waiting Area</button>
                                            <button class="dropdown-item" id="btnSendToWardWaitingArea" type="button">Send to Ward Waiting Area</button>
                                        </div>
                                    </div>
                                    &nbsp;
                                <div class="btn-group">
                                    <button type="button" class="btn btn-block btn-secondary dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        Bed
                                    </button>
                                    <div class="dropdown-menu">
                                        <button class="dropdown-item" id="btnMoveBed" type="button">Change Bed</button>
                                        <button class="dropdown-item" id="btnClearBed" type="button">Clear Bed</button>
                                    </div>
                                </div>
                                    &nbsp;

                                    <%--<button id="btnMoveWard" class="btn btn-block btn-secondary">Move Ward</button>--%>

                                    <div class="btn-group">
                                        <button type="button" class="btn btn-block btn-secondary dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            EDD
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" id="btnUpdateEDD" type="button">Update EDD</button>
                                        </div>
                                    </div>
                                    &nbsp;
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-block btn-secondary dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Return Information
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" id="btnUpdateReturn" type="button">Update Return Info</button>
                                        </div>
                                    </div>
                                    &nbsp;
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-block btn-secondary dropdown-toggle" style="width: 100% !important;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Demographics
                                        </button>
                                        <div class="dropdown-menu">
                                            <button class="dropdown-item" id="btnUpdateDemographics" type="button">Update Alias</button>
                                        </div>
                                    </div>



                                </div>
                            </div>

                            <hr />

                            <div id="divChangeWard">

                                <div class="card">

                                    <div class="card-header bg-secondary text-white">
                                        Change Ward
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



                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="ddlMoveWardReturn" class="control-label col-xs-4">Return to Ward or Bed</label>
                                                    <div class="col-xs-8">
                                                        <select id="ddlMoveWardReturn" name="select" class="select form-control">
                                                            <option value="Not Returning">Not Returning</option>
                                                            <option value="Returning to Ward">Returning to current ward (Bed not specified)</option>
                                                            <option value="Returning to Bed on Ward">Returning to same bed on the current ward</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>



                                            <div id="divMoveWardPatientReturning" class="alert alert-success">
                                                <i class="fa fa-bed"></i>&nbsp;
                                                <label id="lblMoveWardReturn">Patient to return</label>
                                            </div>

                                            <div id="divMoveWardReturn" class="form-group">
                                                <label class="control-label col-xs-4">Return Date \ Time</label>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <small>Date</small>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <input type="text" class="form-control picker__input" id="calMoveWardDate" name="calReturnWardDate" />
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <small>Time</small>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-12">
                                                        <input type="text" class="form-control picker__input" id="calMoveWardTime" name="calReturnWardTime" />
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="alert alert-info">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                                </h5>
                                                <p>Changing the ward will make this patient drop off the current ward list and move to the current list of the newly selected ward</p>
                                                <p>The patient will still be available under the Recent Patient's list</p>
                                                <p>This <span style="text-decoration: underline;">will</span> overwrite any return infromation entered</p>
                                            </div>

                                            <div id="divMoveWardError" class="alert alert-danger">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                                </h5>
                                                <p>Please select a ward to move the patient to</p>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6">
                                                    <button id="btnCancelWardMove" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                                </div>
                                                <div class="col-md-6">
                                                    <button id="btnSaveWardMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move Ward</button>
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

                                    <div class="card-header bg-secondary text-white">
                                        Change Bed
                                    </div>



                                    <div class="card-body">

                                        <div id="divOkayToMoveBed">
                                            <div class="form-group">
                                                <label for="ddlWardBed" class="control-label col-xs-4">Ward</label>
                                                <div class="col-xs-8">
                                                    <select id="ddlWardBed" name="ddlWardBed" class="select form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: vm.wardcode(), optionsCaption: 'No ward selected', disable: true">
                                                    </select>

                                                </div>
                                            </div>

                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="ddlBed" class="control-label col-xs-4">Select Bed</label>
                                                    <div class="col-xs-8">
                                                        <select id="ddlBed" name="ddlBed" class="select form-control"
                                                            data-bind="options: Beds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id', value: vm.bedcode(), optionsCaption: 'Please select ...', optionsBind: 'attr: { disabled: !enabled }'">
                                                        </select>

                                                    </div>
                                                </div>
                                            </div>

                                            <div id="divMoveBedError" class="alert alert-danger">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Incomplete 
                                                </h5>
                                                <p>Please select a bed to move the patient to</p>
                                            </div>
                                        </div>

                                        <div id="divNotOkayToMoveBed" class="alert alert-danger">
                                            <h5>
                                                <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to move bed 
                                            </h5>
                                            <p>This patient is not currently allocated to a ward</p>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <button id="btnCancelBedMove" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                            </div>
                                            <div class="col-md-6">
                                                <button id="btnSaveBedMove" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move Bed</button>
                                            </div>
                                        </div>



                                    </div>
                                </div>

                            </div>

                            <div id="divClearBed">
                                <div class="card">

                                    <div class="card-header bg-secondary text-white">
                                        Clear Bed
                                    </div>

                                    <div class="card-body">
                                        <div class="form-horizontal">

                                            <div id="divOkayToClearBed">
                                                <div class="alert alert-info">
                                                    <h5>
                                                        <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                                    </h5>
                                                    <p>Clearing the bed will make this patient drop off the current ward list and move to the ward waiting area for the current area</p>
                                                    <p>The patient will still be available under the Recent Patient's list</p>
                                                </div>
                                            </div>

                                            <div id="divNotOkayToClearBed" class="alert alert-danger">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Unable to clear bed 
                                                </h5>
                                                <p>This patient is not currently allocated to a ward</p>
                                            </div>

                                            <div class="row">
                                                <div class="col-md-6">
                                                    <button id="btnCancelClearBed" class="btn btn-light btncancel"><i class="fa fa-thumbs-down"></i>&nbsp;Cancel</button>
                                                </div>
                                                <div class="col-md-6">
                                                    <button id="btnSaveClearBed" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Clear Bed</button>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="divUpdateReturnInformation">
                                <div class="card">

                                    <div class="card-header bg-secondary text-white">
                                        Update Return Information
                                    </div>

                                    <div class="card-body">
                                        <div class="form-horizontal">




                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="ddlUpdateReturn" class="control-label col-xs-4">Return to Ward or Bed</label>
                                                    <div class="col-xs-8">
                                                        <select id="ddlUpdateReturn" name="ddlUpdateReturn" class="select form-control" data-bind="value: vm.returncode()">
                                                            <option value="Not Returning">Not Returning</option>
                                                            <option value="Returning to Ward">Returning to selected ward (No bed specified)</option>
                                                            <option value="Returning to Bed on Ward">Returning to a specified bed on the selected ward</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <div id="divUpdateReturnInfo" class="alert alert-success">
                                                <i class="fa fa-bed"></i>&nbsp;
                                                <label id="lblUpdateReturn">Patient to return</label>
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
                                                        <select id="ddlUpdateReturnBed" name="ddlUpdateReturnBed" class="select form-control" data-bind="options: ReturnBeds, optionsText: 'bedbaystatusdisplay', optionsValue: 'wardbaybed_id', value: vm.returnbedcode(), optionsCaption: 'Please select ...'">
                                                        </select>
                                                    </div>
                                                </div>



                                                <div class="form-group" id="divUpdateReturnDates">
                                                    <label class="control-label col-xs-4">Return Date \ Time</label>
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
                                                    <button id="btnSaveUpdateReturn" class="btn btn-success float-right"><i class="fa fa-thumbs-up"></i>&nbsp;Okay, Move Update Return Information</button>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="divUpdateEDD">

                                <div class="card">

                                    <div class="card-header bg-secondary text-white">
                                        Update EDD
                                    </div>

                                    <div class="card-body">
                                        <div class="form-horizontal">
                                            <div class="form-group">
                                                <label for="calEDD" class="control-label col-xs-4">Update EDD</label>
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
                                <div class="card">

                                    <div class="card-header bg-info text-white">
                                        Huddle
                                    </div>

                                    <div class="card-body">
                                        <div id="formContainer">
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div id="divUpdateDemographics">

                                <div class="card">

                                    <div class="card-header bg-secondary text-white">
                                        Patient Alias
                                    </div>

                                    <div class="card-body">
                                        <div class="form-horizontal">

                                            <h3>Patient Alias</h3>
                                            <div class="form-horizontal">
                                                <div class="form-group">
                                                    <label for="txtAliasFirstName" class="control-label col-xs-4">Alias Fist Name</label>
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

                                            <div class="alert alert-info">
                                                <h5>
                                                    <i class="fa fa-exclamation-triangle"></i>&nbsp;Please note 
                                                </h5>
                                                <p>Updating the Patient Alias will change the name in any of the patient lists</p>
                                            </div>


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
        </div>

        <div class="container-fluid">
            <div class="row bg-secondary text-white">
                <div class="col-md-8">
                    <button class="btn btn-secondary btn-sm">
                        <asp:Label ID="lblNavIMAPage" runat="server"></asp:Label>
                    </button>
                </div>
                <div class="col-md-4" style="padding-top: 4px;">
                    <a href="LocatorDefault.aspx" class="btn btn-secondary btn-sm float-right">Home</a>
                </div>
            </div>
        </div>

        <nav class="navbar sticky-top navbar-expand-lg navbar-light" style="background-color: #fff;">
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNavDropdown">


                <ul class="navbar-nav mr-auto">
                    <%-- <li class="nav-item active">
                        <asp:LinkButton ID="lbtnNavCurrentPatients" runat="server" CssClass="nav-link" OnClick="lbtnNavCurrentPatients_Click">
                            <asp:Label runat="server" ID="lblNavCurrentPatients" Text="Current Patients"></asp:Label>
                            &nbsp;
                            <asp:Label runat="server" ID="lblNavCurrentPatientsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                        </asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="lbtnNavWaitingArea" runat="server" CssClass="nav-link" OnClick="lbtnNavWaitingArea_Click">
                            <asp:Label runat="server" ID="lblNavWaitingArea" Text="Waiting Area"></asp:Label>
                            &nbsp;
                            <asp:Label runat="server" ID="lblNavWaitingAreaCount" Text="0" CssClass="badge badge-info"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                        </asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="lbtnNavTCIs" runat="server" CssClass="nav-link" OnClick="lbtnNavTCIs_Click">
                            <asp:Label runat="server" ID="lblNavTCIs" Text="TCIs"></asp:Label>
                            &nbsp;
                            <asp:Label runat="server" ID="lblNavTCIsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                        </asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="lbtnNavRecentPatients" runat="server" CssClass="nav-link" OnClick="lbtnNavRecentPatients_Click">
                            <asp:Label runat="server" ID="lblNavRecentPatients" Text="Recent Patients"></asp:Label>
                            &nbsp;
                            <asp:Label runat="server" ID="lblNavRecentPatientsCount" Text="0" CssClass="badge badge-info"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                        </asp:LinkButton>
                    </li>
                    <li class="nav-item">
                        <asp:LinkButton ID="lbtnNavWardInfo" runat="server" CssClass="nav-link" OnClick="lbtnNavWardInfo_Click">
                            <asp:Label runat="server" ID="lblNavWardInfo" Text="Ward Information"></asp:Label>
                            &nbsp;&nbsp;&nbsp;
                        </asp:LinkButton>
                    </li>--%>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-user"></i>
                            <asp:Label ID="lblUserFullName" runat="server"></asp:Label>
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="LocatorLogOut.aspx">Sign Out</a>
                        </div>
                    </li>
                </ul>

                <div class="form-inline my-2 my-lg-0">
                    <span class="text-secondary">Location: &nbsp;</span>
                    <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectedWard_SelectedIndexChanged" ID="ddlSelectedWard" CssClass="form-control"></asp:DropDownList>
                </div>

            </div>
        </nav>

        <div class="container-fluid">

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


                    <div class="row">
                        <div class="col-md-6">
                            <asp:Literal ID="ltrlHeading" runat="server"></asp:Literal>
                        </div>
                        <div class="hidden">
                            <asp:Literal ID="ltrlTopLeft" runat="server" Visible="false"></asp:Literal>
                        </div>
                        <div class="col-md-6" hidden="hidden">
                            <asp:Literal ID="ltrlTopRight" runat="server"></asp:Literal>
                        </div>
                        <%--<div class="col-md-3">                            
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
                                        <asp:Label ID="lblNumberOfBedsAvailable" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>Available
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblNumberOfClosedBeds" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td>Out of Use
                                    </td>
                                </tr>                                
                            </table>
                        </div>
                        <div class="col-md-3">                           
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
                        </div>--%>

                        <div class="col-md-3 h4">                            
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

                    <%--<div id="tableSection" style="margin-top: 10px;">
                        <table data-bind="css: TableCSS" id="tblList" class="table">
                            <thead class="thead-dark sticky-top">
                                <tr data-bind="foreach: ColumnData">
                                    <th class="">
                                        <span data-bind="text: displayname"></span>
                                    </th>
                                </tr>
                            </thead>
                            <tbody data-bind="foreach: DynamicListData">
                                <tr data-bind="foreach: $parent.columnNames, css: cssclass">
                                    <td data-bind="html: JSON.parse(ko.toJS($parent[$data])).attributevalue, css: JSON.parse(ko.toJS($parent[$data])).defaultcssclassname"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>--%>

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
                                <tr data-bind="foreach: $parent.columnNames, css: cssclass">
                                    <td data-bind="html: JSON.parse(ko.toJS($parent[$data])).attributevalue, css: JSON.parse(ko.toJS($parent[$data])).defaultcssclassname"></td>
                                </tr>
                            </tbody>
                        </table>
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


            <div id="divLoading" data-bind="visible: IsLoading" style="position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); transform: -webkit-translate(-50%, -50%); transform: -moz-translate(-50%, -50%); transform: -ms-translate(-50%, -50%); z-index: 9999;">

                <%--<img src="img/ajax_loader.gif" style="max-height: 100%;"/>--%>

                <div id="loader-wrapper">
                    <div id="loader"></div>

                    <div class="loader-section section-left"></div>
                    <div class="loader-section section-right"></div>

                </div>

            </div>

        </div>

    </form>

</body>
</html>
