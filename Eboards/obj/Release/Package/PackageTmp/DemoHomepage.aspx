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
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DemoHomepage.aspx.cs" Inherits="EBoards.DemoHomepage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">

    <title>eBoards</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="css/font-awesome.css" rel="stylesheet" />

    <style>
        html,
        body {
            height: 100%;
        }

        body {
            display: -ms-flexbox;
            display: -webkit-box;
            display: flex;
            -ms-flex-align: center;
            -ms-flex-pack: center;
            -webkit-box-align: center;
            align-items: center;
            -webkit-box-pack: center;
            justify-content: center;
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #fff;
        }

        /*.div-info {
            width: 100%;
            max-width: 550px;
            padding: 15px;
            margin: 0 auto;
        }*/

        .div-form {
            border: 4px solid #343762;
            padding: 15px;
        }

        .form-signin {
            width: 100%;
            max-width: 550px;
            margin: 0 auto;
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

        <div class="div-form">

            <asp:Panel ID="pnlLogin" runat="server">


                <img class="mb-4" src="img/iBoards.png" style="max-width: 75%;" />

              
                <br />
                <br />

                <a href="IMADemo.aspx?id=1e24f02b-99f9-4fcf-a19f-c00e3be1b557"><h1>IMA Demo</h1></a>

                <br />
                <br />
                <a href="LocatorDemo.aspx?id=1e24f02b-99f9-4fcf-a19f-c00e3be1b557"><h1>Locator Demo</h1></a>
                
                <br />
                <br />

                <img class="mb-4"  src="img/RNOHLogo.png"  style="max-width: 75%;"/>
            </asp:Panel>






        </div>

        <div class="div-info">
            <p class="mt-5 mb-3 text-muted">Powered by <a href="http://www.interneuron.org" target="_blank">Interneuron CIC &copy; 2018</a></p>
        </div>

    </form>



</body>
</html>
