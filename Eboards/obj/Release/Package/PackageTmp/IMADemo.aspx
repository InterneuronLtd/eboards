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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IMADemo.aspx.cs" Inherits="EBoards.IMADemo" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Locator Board</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />

    <%-- <link href="libs/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />--%>

    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous" />
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

    <script src="Scripts/jquery.tablesorter.js"></script>

    <script src="Content/pickadate/legacy.js"></script>
    <script src="Content/pickadate/picker.js"></script>
    <script src="Content/pickadate/picker.date.js"></script>
    <script src="Content/pickadate/picker.time.js"></script>

    <%--<script src="Content/easyautocomplete/jquery.easy-autocomplete.js"></script>--%>


    <script src="globalsettings.js?v=1.0000010"></script>
    <script src="IMAListViewModel.js"></script>

    <script src="QustionService.js"></script>

    <script src="Scripts/oidc/oidc-client.js?v=1.0000010"></script>
    <script src="Scripts/oidc/OidcPageHelper.js"></script>


    <script type="text/javascript">

        //var listId = "08662d00-39f3-46bb-84fa-847da301df7b";

        var LocatorBoardID = "";
        //$('#lblLocatorBoardID').val(LocatorBoardID);

        var globalURL = GlobalServiceURL;

        var listId = "";

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
            var ordergroupbystatement = "";
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
            var service = service;
            var params = params;
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

        var vm = new viewModel();

        function LoadBoard() {

            LoadBoardWithoutVM();

            ko.applyBindings(vm);
            vm.getColumnsAndQuestions();
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
                vm.getListOnly();
            });

            $('#btnMoveWard').click(function (event) {
                $('#divLocationData').show();
                $('#divQuestionData').hide();
                $('#divReturnInformation').hide();
                event.preventDefault();
            });


            $('#btnSendToWardWaitingArea').click(function (event) {
                if (confirm("Are you sure that you want to remove this patient from this bed and send them to the Ward Waiting Area? They will drop off the current patient list and move to the Waiting Area List")) {
                    alert('Moved');
                }
                event.preventDefault();
            });

            $('#btnSendToHospitalWaitingArea').click(function (event) {
                if (confirm("Are you sure that you want to remove this patient from this ward and send them to the Hospital Waiting Area? They will drop off this list and move the Hospital Waiting Area List")) {
                    alert('Moved');
                }
                event.preventDefault();
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
                });

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

        }


    </script>
</head>
<body>



    <form id="form1" runat="server" style="height: 100%; background-color: #fff;">



        <div class="modal" tabindex="-1" role="dialog" id="detail-modal">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <%--   <div class="modal-header">

                        <button type="button" class="close pull-right" data-dismiss="modal" aria-label="Close">
                            <span style="color: #b16060" aria-hidden="true">&times;</span>
                        </button>

                        <h3 class="modal-title"><span id="modalTitle"></span></h3>
                    </div>--%>

                    <div class="modal-body" style="min-height: 600px;">


                        <div id="divModalView" data-bind="visible: !IsModalLoading()">
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="patientBanner"></div>
                                </div>
                            </div>



                        </div>

                        <div id="divLocationData" class="alert" style="border: 1px solid #5a5a5a;">
                            <div class="form-horizontal">
                            </div>

                            <div class="form-group">
                                <label for="chkIsReturning" class="control-label col-xs-4">Returning</label>
                                <div class="col-xs-8">
                                    <%--<label class="checkbox-inline">--%>

                                    <%--</label>--%>
                                </div>
                            </div>


                            <div id="divReturnInformation">
                                <h5>Return Location</h5>
                                <div class="form-group">
                                    <label for="ddlReturnWard" class="control-label col-xs-4">Ward</label>
                                    <div class="col-xs-8">
                                        <select id="ddlReturnWard" name="select" class="select form-control">
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="ddlReturnBay" class="control-label col-xs-4">Bay</label>
                                    <div class="col-xs-8">
                                        <select id="ddlReturnBay" name="select" class="select form-control">
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="ddlReturnBed" class="control-label col-xs-4">Bed</label>
                                    <div class="col-xs-8">
                                        <select id="ddlReturnBed" name="select" class="select form-control">
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="calReturnTime" class="control-label col-xs-4">Return Time</label>
                                    <div class="col-xs-8">
                                        <div class="input-group date" id="datetimepicker4" data-target-input="nearest">
                                            <input type="text" class="form-control datetimepicker-input" data-target="#datetimepicker4" />
                                            <div class="input-group-append" data-target="#datetimepicker4" data-toggle="datetimepicker">
                                                <div class="input-group-text"><i class="fa fa-calendar"></i></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>


                            <div class="row">
                                <div class="col-md-12">
                                    <button id="btnLocationDone" class="btn btn-secondary float-right">Done</button>
                                </div>
                            </div>
                        </div>

                        <div id="divQuestionData" class="alert" style="border: 1px solid #5a5a5a;">
                            <div id="formContainer">
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


        <nav class="navbar sticky-top navbar-expand-lg navbar-light" style="background-color: #fff;">
            <%--<a class="navbar-brand" href="#">iBoards</a>--%>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNavDropdown">


                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="DemoHomepage.aspx">&lt; Back to Demo Homepage </a>
                    </li>

                </ul>

                <div class="form-inline my-2 my-lg-0">
                    <span class="text-secondary">Location: &nbsp;</span>
                    <%--<asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectedWard_SelectedIndexChanged" id="ddlSelectedWard" cssclass="form-control" data-bind="options: Wards, optionsText: 'warddisplay', optionsValue: 'wardcode', value: selectedWard, event: { change: GetBedBoardDetails }"></asp:DropDownList>--%>
                    <asp:DropDownList runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlSelectedWard_SelectedIndexChanged" ID="ddlSelectedWard" CssClass="form-control"></asp:DropDownList>
                </div>

            </div>
        </nav>

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
                        <div class="col-md-6">
                            <asp:Literal ID="ltrlTopRight" runat="server"></asp:Literal>
                        </div>
                    </div>

                    <div id="tableSection" style="margin-top: 10px;">
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
