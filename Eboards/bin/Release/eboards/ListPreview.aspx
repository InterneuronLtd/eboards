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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ListPreview.aspx.cs" Inherits="EBoards.ListPreview" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>List Preview</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="css/font-awesome.css" rel="stylesheet" />

    <script src="Scripts/jquery-3.0.0.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/knockout-3.4.2.js"></script>
    <script src="Scripts/jquery.tablesorter.js"></script>
    <script src="globalsettings.js?v=1.0000010"></script>
    <script src="Scripts/oidc/oidc-client.js?v=1.0000010"></script>
    <script src="Scripts/oidc/OidcPageHelper.js"></script>
    <script type="text/javascript">

        //var listId = "08662d00-39f3-46bb-84fa-847da301df7b";
        var listId = getParameterByName('id'); //"aba2feb8-e00c-4aef-8c4f-cde7689543e7";        
        $('#lblID').val(listId);


        var globalURL = GlobalServiceURL;

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

            return $.getJSON(globalURL + "List/GetListData/" + listId, function (data) {

            });

        }

        var viewModel = function () {
            var self = this;



            self.DynamicListData = ko.observableArray();
            self.ColumnData = ko.observableArray();
            self.TableCSS = ko.observable();
            self.HeaderCSS = ko.observable();
            self.DefaultRowCSS = ko.observable();


            $.when(
                GetListDetails()
            ).done(
                function (
                    Details
                ) {
                    self.TableCSS(Details.tablecssstyle);
                    self.HeaderCSS(Details.tableheadercssstyle);
                    self.DefaultRowCSS(Details.defaultrowcssstyle);
                });



            $.when(
                GetColumns()
            ).done(
                function (
                    Columns
                ) {
                    self.ColumnData(Columns);

                });


            $.when(
                GetListData()
                //,
                //GetColumns()
            ).done(
                function (
                    ListData
                    //,
                    //Columns
                ) {
                    self.DynamicListData(ListData);
                    $("#tblList").tablesorter();
                    //self.ColumnData(Columns);

                });

            self.columnNames = ko.computed(function () {
                if (self.DynamicListData().length === 0)
                    return [];
                var props = [];
                var obj = self.DynamicListData()[0];
                for (var key in obj)
                    props.push(key);
                return props;
            });

            self.rowclass = ko.computed(function () {

                //var css = self.DefaultRowCSS();
                //ko.utils.arrayForEach(self.DynamicListData(), function (item) {



                //    item.cssclass = css;

                //});
                //return css;


                var css = "";

                ko.utils.arrayForEach(self.DynamicListData(), function (item) {

                    var row = item;



                    var rowcssfield = JSON.parse(row.col_0).rowcssfield;

                    if (rowcssfield === "") {

                        css = self.DefaultRowCSS();
                    }
                    else {
                        css = rowcssfield;
                    }



                    item.cssclass = css;

                });
                return css;


            }, self);


        }




        //function GetHeaders(obj) {
        //    var cols = [];
        //    var p = obj[0];
        //    for (var key in p) {
        //        //alert(' name=' + key + ' value=' + p[key]);
        //        cols.push({ "colName" : key });
        //    }
        //    return cols;
        //}


        $(document).ready(function () {

            var vm = new viewModel();

            ko.applyBindings(vm);


            //console.log(GetColumns());
            //ko.applyBindings(viewModel());





        });



        function getParameterByName(name, url) {
            if (!url) url = window.location.href;
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }


    </script>


</head>
<body>
    <form id="form1" runat="server">

        <div class="container-fluid" style="margin-top: 25px;">


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

    </form>
</body>
</html>
