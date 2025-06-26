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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LogOut.aspx.cs" Inherits="EBoards.LogOut" %>

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
    <script src="globalsettings.js?v=1.0000010"></script>
    <script src="Scripts/oidc/oidc-client.js?v=1.0000010"></script>
    <script src="Scripts/oidc/OidcLoginHelper.js"></script>

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

    <title>Inpatients</title>
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


                            <img class="mb-4" src="img/IMALogo.png" style="max-width: 75%;" />


                            <div id="divLoggingOut" visible="false" runat="server" class="alert alert-danger">
                                We are logging you out, please wait.
                            </div>

                            <div id="divLoggedOut" visible="false" runat="server" class="alert alert-danger">
                                <h3>Logged out successfully</h3>

                                Your session has ended, please click on the link below to login again.

                                   <a href="LoginOidc.aspx" class="btn btn-lg btn-primary btn-block">Click here to login again</a>
                            </div>
                            <%--<button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>--%>
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
