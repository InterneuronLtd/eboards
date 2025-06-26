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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EBoards.Default" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>eBoards</title>
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


                            <img class="mb-4" src="img/IMALogo.png" style="max-width: 75%;" />


                            <%--                <div class="alert alert-secondary">
                    <h3>Welcome to eBoards</h3>

                    Please select a link from below:
                </div>--%>

                            <br />
                            <hr />
                            <h4 class="text-secondary">Inpatient Management App</h4>

                            <a href="IMA.aspx?id=344ebb08-eeb6-4590-80a3-94ed9325592b" class="btn btn-lg btn-info btn-block">Inpatient Management App</a>

                            <br />
                            <hr />

                           
                            <h4 class="text-secondary">Log Out</h4>

                            <a href="Logout.aspx" class="btn btn-lg btn-danger btn-block">Log Out</a>

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
