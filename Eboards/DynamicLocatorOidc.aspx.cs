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
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class DynamicLocatorOidc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool getToken = false;
            if (Session["LocatorBoardAccessToken"] != null)
            {
                var jwttoken = SynapseHelpers.DecodeJWTToken(Session["LocatorBoardAccessToken"].ToString());

                if (!(jwttoken is JwtSecurityToken))
                {
                    getToken = true;
                }

                if (((JwtSecurityToken)jwttoken).ValidTo <= DateTime.UtcNow)
                {
                    getToken = true;
                }
            }
            else
            {
                getToken = true;
            }

            if (getToken)
            {
                RegisterAsyncTask(new PageAsyncTask(GetToken));
            }
            Session["LocatorBoardAccessToken1"] = "token.AccessToken";
        }
        public async Task GetToken()
        {
            var token = await SynapseHelpers.RequestTokenAsync();
            Session["LocatorBoardAccessToken"] = token.AccessToken;
            if (Request.QueryString["returnurl"] != null)
                Response.Redirect(Request.QueryString["returnurl"], false);
        }

    }
}