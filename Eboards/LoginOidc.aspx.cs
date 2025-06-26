//BEGIN LICENSE BLOCK 
//Interneuron Terminus

//Copyright(C) 2025  Interneuron Limited

//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

//See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with this program.If not, see<http://www.gnu.org/licenses/>.
//END LICENSE BLOCK 
﻿using SynapseStudio;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class LoginOidc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string token = string.Empty;
            try
            {
                token = Session["access_token"].ToString();

            }
            catch
            {
                //not authenticated; browser will invoke oidc signin-redirect to SIS               
            }

            if (token != string.Empty)
            {
                var jwttoken = SynapseHelpers.DecodeJWTToken(token);

                if (!(jwttoken is JwtSecurityToken))
                {
                    Response.Redirect("SessionExpired.aspx");
                }

                if (((JwtSecurityToken)jwttoken).ValidTo <= DateTime.Now)
                {
                    Response.Redirect("Logout.aspx");
                }

                string returnURL = "Default.aspx";
                try
                {
                    returnURL = Request.Cookies[Session["SynapseUser_UserID"].ToString().ToLower() + "_SynapseBedBoards_ReturnURL"].Value.ToString(); ;
                }
                catch { }

                Response.Redirect(returnURL);
            }
            else
            { //not authenticated; Do Nothing. Browser will invoke oidc signin-redirect to SIS     

            }
        }


    }
}