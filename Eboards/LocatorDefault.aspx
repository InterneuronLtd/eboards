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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocatorDefault.aspx.cs" Inherits="EBoards.LocatorDefault" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="apple-mobile-web-app-capable" content="yes"/>
    <meta name="apple-mobile-web-app-title" content="Locator Boards"/>
    <meta name="apple-mobile-web-app-status-bar-style" content="black"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="apple-touch-icon" href="img/LocatorIcon.png"/>
    <link rel="shortcut icon" type="image/x-icon" href="img/LocatorIcon.png"/>

    <title>Locator Board</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="css/font-awesome.css" rel="stylesheet" />

    <style>
        .div-form {
            border: 4px solid #343762;
            padding: 15px;
        }



        .form-signin .checkbox {
            font-weight: 400;
        }

        .form-signin .form-control {
            position: relative;
            box-sizing: border-box;
            height: auto;
            padding: 10px;
            font-size: 16px;
        }

            .form-signin .form-control:focus {
                z-index: 2;
            }

        .form-signin input[type="email"] {
            margin-bottom: -1px;
            border-bottom-right-radius: 0;
            border-bottom-left-radius: 0;
        }

        .form-signin input[type="password"] {
            margin-bottom: 10px;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
    </style>
</head>

<body class="text-center">
    <form id="form1" runat="server" class="form-signin">

        <div style="padding-top: 80px;">

            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-3">
                        &nbsp;
                    </div>
                    <div class="col-md-6 div-form">

                        <asp:Panel ID="pnlLogin" runat="server">


                            <img class="mb-4" src="img/LocatorLogo.png" style="max-width: 75%;" />


                            <%--                <div class="alert alert-secondary">
                    <h3>Welcome to eBoards</h3>

                    Please select a link from below:
                </div>--%>

                            <br />
                            <hr />
                          

                            
                            <h4 class="text-secondary">Locator Boards</h4>

                            <%--<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>--%>
                            <%--<a href="LocatorBoard.aspx?id=1e24f02b-99f9-4fcf-a19f-c00e3be1b557" class="btn btn-lg btn-secondary btn-block">Locator Board</a>--%>

                            <asp:Repeater ID="rptLocatorBoards" runat="server">

                                <HeaderTemplate>
                                </HeaderTemplate>

                                <ItemTemplate>
                                    <%--<asp:Label ID="lblLocatorBoardName" runat="server" Text='<%#Eval("locatorboardname") %>'/>--%>

                                    <asp:HyperLink ID="hlLocatorBoards" runat="server" CssClass="btn btn-lg btn-secondary btn-block text-white"
                                        NavigateUrl='<%# DataBinder.Eval(Container.DataItem, "locatorboard_id", "LocatorBoard.aspx?id={0}") %>'>
                            <%# DataBinder.Eval(Container.DataItem, "locatorboardname") %>
                                    </asp:HyperLink>

                                </ItemTemplate>

                                <FooterTemplate>
                                </FooterTemplate>

                            </asp:Repeater>
                            
                            <hr />

                            <h4 class="text-secondary">Log Out</h4>

                            <a href="LocatorLogout.aspx" class="btn btn-lg btn-danger btn-block">Log Out</a>

                            <hr />


                        </asp:Panel>




                        <div class="col-md-3">
                            &nbsp;
                        </div>

                    </div>
                </div>
            </div>

        </div>


        <div class="div-info">
            <p class="mt-5 mb-3 text-muted">Powered by <a href="http://www.interneuron.org" target="_blank">Interneuron CIC &copy; 2018</a></p>
        </div>

    </form>



</body>
</html>

