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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DynamicBedBoard.aspx.cs" Inherits="EBoards.DynamicBedBoard" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Bed Board</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="css/font-awesome.css" rel="stylesheet" />

    <style>
        html, body {
            height: 100% !important;
            margin: 0 !important;
            background-color: #fff;
        }

        #topSection {
            margin: 20px;
            padding: 20px;
            height: 30%;
        }

        #middleSection {
            margin: 20px;
            padding: 20px;
            height: 32%;
        }

        #bottomSection {
            margin: 20px;
            padding: 20px;
            height: 30%;
        }

        #detailSection {
            margin-left: 20px;
            margin-right: 20px;
            padding: 5px;
            height: 5%;
        }
    </style>
    <script src="Scripts/jquery-3.0.0.js"></script>
   <script>
        $(document).ready(function () {
             setInterval(function () {
                window.location.reload();
            }, 60000);
        })
    </script>
</head>
<body>



    <form id="form1" runat="server" style="height: 100%; background-color: #fff;">

        <div hidden="hidden">
            <asp:HiddenField ID="hdnBedBoardID" runat="server" />
            <asp:HiddenField ID="hdnWard" runat="server" />
            <asp:HiddenField ID="hdnBed" runat="server" />
        </div>

        <asp:Panel ID="pnlHasData" runat="server" Style="height: 100%;">

            <div id="topSection">
                <asp:Panel ID="pnlTopSingle" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 100%; height: 100%">
                                <asp:Literal ID="ltrlTop" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:Panel ID="pnlTopDouble" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlTopLeft" runat="server"></asp:Literal>
                            </td>
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlTopRight" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </div>

            <div id="middleSection">
                <asp:Panel ID="pnlMiddleSingle" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 100%; height: 100%">
                                <asp:Literal ID="ltrlMiddle" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:Panel ID="pnlMiddleDouble" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlMiddleLeft" runat="server"></asp:Literal>
                            </td>
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlMiddleRight" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>                            
            </div>

            <div id="bottomSection">
                <asp:Panel ID="pnlBottomSingle" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 100%; height: 100%">
                                <asp:Literal ID="ltrlBottom" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:Panel ID="pnlBottomDouble" runat="server">
                    <table style="width: 100%; height: 100%">
                        <tr style="width: 100%; height: 100%">
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlBottomLeft" runat="server"></asp:Literal>
                            </td>
                            <td style="width: 50%; height: 100%">
                                <asp:Literal ID="ltrlBottomRight" runat="server"></asp:Literal>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>                
            </div>

            <div id="detailSection">
                <div class="row" style="height: 100%;">
                    <div class="col-md-12" style="height: 100%;">
                        <asp:Literal ID="ltrlRefresh" runat="server"></asp:Literal>
                    </div>
                </div>
            </div>

        </asp:Panel>

        <asp:Panel ID="pnlNoData" runat="server">


            <div class="row" style="margin-top: 100px;">
                <div class="col-md-12">
                    <div class="alert alert-danger" style="text-align: center; margin: 40px;">


                        <div class="row" style="background-color: rgb(114, 28, 36); color: white; font-size: 3em;">
                            <div class="col-md-12" style="height: 100%;">
                                <h1>Bedside Board</h1>
                            </div>
                        </div>
                        <br />
                        <br />
                        <h3>Device not configured</h3>

                        <h4>Please use the Bed Device Manager in Studio to configure the settings for this device.
                        </h4>
                        <br />
                        <br />

                        <h4>The IP Address of this device is:
                        </h4>
                        <br />
                        <br />
                        <div class="row" style="background-color: rgb(114, 28, 36); color: white; font-size: 3em;">
                            <div class="col-md-12" style="height: 100%;">

                                <asp:Label ID="lblIPAddress" runat="server"></asp:Label>
                            </div>


                        </div>


                    </div>
                </div>
            </div>



        </asp:Panel>
    </form>



</body>
</html>
