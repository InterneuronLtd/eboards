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
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string SynapseUser_UserIDSession = "";
            try
            {
                SynapseUser_UserIDSession = Session["SynapseUser_UserID"].ToString();
            }
            catch { }

            string SynapseUser_FullName = "";
            try
            {
                SynapseUser_FullName = Session["SynapseUser_FullName"].ToString();
            }
            catch { }

            if (String.IsNullOrWhiteSpace(SynapseUser_UserIDSession))
            {
                Response.Redirect("SessionExpired.aspx");
            }


            Response.Redirect("IMA.aspx?id=3a5015f7-85a3-4d96-a873-05405c509031");

            //GetPublishedLocatorBoards();
        }

        private void GetPublishedLocatorBoards()
        {
            string sql = "SELECT locatorboard_id, locatorboardname FROM eboards.locatorboard WHERE locatorboard_id IN (SELECT locatorboard_id FROM eboards.publishedlocatorboard) ORDER BY locatorboardname;";
            var paramList = new List<KeyValuePair<string, string>>() {                
            };

            DataSet ds = new DataSet();
            DataTable dt = new DataTable();
            try
            {
                ds = DataServices.DataSetFromSQL(sql, paramList);
                dt = ds.Tables[0];
            }
            catch (Exception ex)
            {
                return;
            }

            //this.rptLocatorBoards.DataSource = dt;
            //this.rptLocatorBoards.DataBind();

        }

    }
}