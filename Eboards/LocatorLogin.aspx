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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LocatorLogin.aspx.cs" Inherits="EBoards.LocatorLogin" %>


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

        .form-signin {

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

                            <label for="ddlLoginType" class="sr-only">Login Type</label>
                            <asp:DropDownList ID="ddlLoginType" runat="server" class="form-control" Style="min-height: 50px;">
                                <asp:ListItem Value="AD" Selected="True" Text="Active Directory"></asp:ListItem>
                                <asp:ListItem Value="SQL" Text="Database"></asp:ListItem>
                            </asp:DropDownList>
                            <span>&nbsp;</span>
                            <label for="ddlDomain" class="sr-only">Domain</label>
                            <asp:DropDownList ID="ddlDomain" runat="server" class="form-control" Style="min-height: 50px;">
                            </asp:DropDownList>
                            <hr />
                            <label for="txtUsername" class="sr-only">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" class="form-control" placeholder="Username" required autofocus></asp:TextBox>
                            <span>&nbsp;</span>
                            <label for="inputPassword" class="sr-only">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" class="form-control" placeholder="Password" required></asp:TextBox>

                            <%--<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>--%>
                            <asp:Button ID="btnLogin" runat="server" CssClass="btn btn-lg btn-primary btn-block" Text="Login" OnClick="btnLogin_Click" />


                        </asp:Panel>


                        <asp:Panel ID="pnlFailed" runat="server" Visible="false">
                            <br />
                            <div class="alert alert-danger">
                                <div class="mediumLoginLabel">
                                    <strong>Unable to validate credentials</strong>
                                    <asp:Label ID="lblError" runat="server"></asp:Label>
                                </div>
                            </div>
                        </asp:Panel>



                        <asp:Panel ID="pnlSuccess" runat="server" Visible="false" Width="390px">
                            <div class="span12">
                                <table class="table successTable">
                                    <tr>
                                        <td style="width: 65%; vertical-align: top;">
                                            <div class="bigLoginLabel">
                                                <asp:Label ID="lblForname" runat="server"></asp:Label>
                                            </div>
                                            <div class="bigLoginLabel">
                                                <asp:Label ID="lblSurname" runat="server"></asp:Label>
                                            </div>
                                            <h4>
                                                <asp:Label ID="lblTitle" runat="server"></asp:Label></h4>
                                        </td>
                                        <td style="width: 35%; vertical-align: top;">
                                            <asp:Label ID="lblUserImage" runat="server"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:Button ID="btnAccessSystem" runat="server" CssClass="btn btn-success" Text="Access System" OnClick="btnAccessSystem_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </div>

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