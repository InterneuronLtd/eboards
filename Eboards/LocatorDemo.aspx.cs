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
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class LocatorDemo : System.Web.UI.Page
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

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "script", "$(function () { LoadBoard(); });", true);

            if (!IsPostBack)
            {

                BindDropDownList(this.ddlSelectedWard, "SELECT * FROM entityview.meta_ward ORDER BY warddisplay;", "wardcode", "warddisplay", 0, null);

            }

            this.pnlHasData.Visible = true;
            this.pnlNoData.Visible = false;

            string ipaddress = Request.UserHostAddress; //GetIPAddress();

            this.lblIPAddress.Text = ipaddress;
            this.lblHiddenIPAddress.Text = ipaddress;

            //GetAndLoadBedBoad();



            this.hdnlocatorboardID.Value = Request.QueryString["id"].ToString(); // LocatorBoardID;
            this.lblLocatorBoardID.Text = Request.QueryString["id"].ToString();  //LocatorBoardID;


            this.lblLocationValue.Text = this.ddlSelectedWard.SelectedValue;



            GetlocatorboardDetails();

        }

        private void BindDropDownList(DropDownList ddl, string sql, string valueField, string displayField, int addPleaseSelect, List<KeyValuePair<string, string>> parameters = null)
        {
            DataSet ds = DataServices.DataSetFromSQL(sql, parameters);
            ddl.DataSource = ds;
            ddl.DataValueField = valueField;
            ddl.DataTextField = displayField;
            ddl.DataBind();

            if (addPleaseSelect == 1)
            {
                ListItem[] items = new ListItem[1];
                items[0] = new ListItem("Please select ...", "0");
                ddl.Items.Insert(0, items[0]);
            }
        }

        private void SetDDLSource(DropDownList ddl, string val)
        {
            if (val.Length > 0)
            {
                int idx = 9999;

                try
                {
                    idx = ddl.Items.IndexOf(ddl.Items.FindByValue(val));
                }
                catch
                {
                    idx = 9999;
                }

                if (idx == 9999 || idx < 0)
                {
                    ListItem[] items = new ListItem[1];
                    items[0] = new ListItem(val + " (old value)", val);
                    ddl.Items.Insert(1, items[0]);
                }
            }

            ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(val));
        }


        public string GetIPAddress()
        {
            string IPAddress = "";
            IPHostEntry Host = default(IPHostEntry);
            string Hostname = null;
            Hostname = System.Environment.MachineName;
            Host = Dns.GetHostEntry(Hostname);
            foreach (IPAddress IP in Host.AddressList)
            {
                if (IP.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    IPAddress = Convert.ToString(IP);
                }
            }
            return IPAddress;
        }

        private void GetAndLoadBedBoad()
        {
            String sql = "SELECT * FROM eboards.locatorboarddevice WHERE deviceipaddress = @deviceipaddress;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("deviceipaddress", this.lblIPAddress.Text)
            };
            try
            {
                ds = DataServices.DataSetFromSQL(sql, paramList);
            }
            catch (Exception ex)
            {
                StringBuilder sbe = new StringBuilder();
                //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
                sbe.AppendLine(ex.ToString());
                //sbe.AppendLine("</div>");
                //this.lblError.Visible = true;
                //this.lblError.Text = sbe.ToString();
                return;
            }

            DataTable dt = ds.Tables[0];

            if (dt.Rows.Count == 0)
            {
                this.pnlNoData.Visible = true;
                return;
            }
            else
            {
                this.pnlHasData.Visible = true;
            }

            string LocatorBoardID = "";
            try
            {
                LocatorBoardID = dt.Rows[0]["locatorboard_id"].ToString();
            }
            catch
            {
                //Response.Redirect("Error.aspx");
            }
            this.hdnlocatorboardID.Value = LocatorBoardID;
            this.lblLocatorBoardID.Text = LocatorBoardID;

            string locationid = "";
            try
            {
                locationid = dt.Rows[0]["locationid"].ToString();
            }
            catch
            {
                //Response.Redirect("Error.aspx");
            }
            this.lblLocationValue.Text = locationid;




            GetlocatorboardDetails();


        }

        private void GetlocatorboardDetails()
        {
            string sql = "SELECT * FROM eboards.v_locatorboardlist WHERE locatorboard_id = @locatorboard_id;";
            //string sql = "SELECT * FROM eboards.v_locatorboardlist LIMIT 1;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("locatorboard_id", hdnlocatorboardID.Value)
            };
            try
            {
                ds = DataServices.DataSetFromSQL(sql, paramList);
            }
            catch (Exception ex)
            {
                StringBuilder sbe = new StringBuilder();
                sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
                sbe.AppendLine(ex.ToString());
                sbe.AppendLine("</div>");
                //this.ltrlError.Visible = true;
                //this.ltrlError.Text = sbe.ToString();
                return;
            }

            DataTable dt = ds.Tables[0];

            string baseview_id = "";
            try
            {
                baseview_id = dt.Rows[0]["locationbaseview_id"].ToString();
            }
            catch { }

            string baseviewname = SynapseHelpers.GetBaseViewNameAndNamespaceFromID(baseview_id);


            string locationcode = "";
            try
            {
                locationcode = dt.Rows[0]["locationidfield"].ToString();
            }
            catch { }
            this.lblLocationField.Text = locationcode;

            string headingfield = "";
            try
            {
                headingfield = dt.Rows[0]["locationdisplayfield"].ToString();
            }
            catch { }

            string topleftfield = "";
            try
            {
                topleftfield = dt.Rows[0]["topleftfield"].ToString();
            }
            catch { }
            string toprightfield = "";
            try
            {
                toprightfield = dt.Rows[0]["toprightfield"].ToString();
            }
            catch { }


            string sqlBoard = "SELECT " + locationcode + " as locationcode, " + topleftfield + " as TopLeftField," + toprightfield + " as TopRightField," + headingfield + " as headingfield" +
                              " FROM baseview." + baseviewname + " WHERE " + locationcode + " = @locationcode LIMIT 1;";

            var paramListbOARD = new List<KeyValuePair<string, string>>()
            {
                new KeyValuePair<string, string>("locationcode", this.ddlSelectedWard.SelectedValue)
            };

            DataSet dsBoard = new DataSet();
            try
            {
                dsBoard = DataServices.DataSetFromSQL(sqlBoard, paramListbOARD);
            }
            catch (Exception ex)
            {
                StringBuilder sbe = new StringBuilder();
                sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
                sbe.AppendLine(ex.ToString());
                sbe.AppendLine("</div>");
                //this.ltrlError.Visible = true;
                //this.ltrlError.Text = sbe.ToString();
                return;
            }

            DataTable dtBoard = dsBoard.Tables[0];

            try
            {
                this.ltrlHeading.Text = dtBoard.Rows[0]["headingfield"].ToString();
            }
            catch { }

            try
            {
                this.ltrlTopLeft.Text = dtBoard.Rows[0]["TopLeftField"].ToString();
            }
            catch { }
            try
            {
                this.ltrlTopRight.Text = dtBoard.Rows[0]["TopRightField"].ToString();
            }
            catch { }




        }

        protected void ddlSelectedWard_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}