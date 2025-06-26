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
    public partial class IMA : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "script", "$(function () { LoadBoard(); });", true);

            GetIMAConfiguration();

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



            string id = "";
            try
            {
                id = Request.QueryString["id"].ToString();
            }
            catch {
                Response.Redirect("Default.aspx");
            }
            if (string.IsNullOrWhiteSpace(id))
            {
                Response.Redirect("Default.aspx");
            }
            Response.Cookies[Session["SynapseUser_UserID"].ToString().ToLower() + "_SynapseBedBoards_ReturnURL"].Value = "IMA.aspx?id=" + id;

            DataSet dsList = new DataSet();
            DataTable dtList = new DataTable();
            try
            {
                dsList = DataServices.DataSetFromSQL("SELECT * FROM eboards.v_imaboardlist WHERE boardid = '" + id + "';");
                dtList = dsList.Tables[0];
            }
            catch
            {

            }

          
            try
            {
                string currentPage =  dtList.Rows[0]["boardname"].ToString();
                //if(currentPage == "Current Patients")
                //{
                //    currentPage = "Delivery";
                //}
                //if (currentPage == "TCIs")
                //{
                //    currentPage = "Triage";
                //}
                this.lblCurrentPage.Text = currentPage;
            }
            catch { }

            this.lblUserFullName.Text = Session["SynapseUser_FullName"].ToString();

            if (!IsPostBack)
            {

                string imaPage = "";

                if (Request.Cookies["IMAPage"] != null)
                {                    
                    imaPage = Request.Cookies["IMAPage"].Value.ToString();
                }
                this.lblNavIMAPage.Text = imaPage;

                BindDropDownList(this.ddlSelectedWard, "SELECT * FROM baseview.eboards_wardswithwaitingarea ORDER BY wardorder;", "wardcode", "warddisplay", 0, null);


                string previouslySelectedWard = "";
                try
                {
                    previouslySelectedWard = Request.Cookies[Session["SynapseUser_UserID"].ToString().ToLower() + "_SynapseBedBoards_SelectedWard"].Value;
                }
                catch { }

                if (!string.IsNullOrWhiteSpace(previouslySelectedWard))
                {
                    SetDDLSource(this.ddlSelectedWard, previouslySelectedWard);
                }

               




            }



            this.pnlHasData.Visible = true;
            this.pnlNoData.Visible = false;

            string ipaddress = Request.UserHostAddress; //GetIPAddress();

            this.lblIPAddress.Text = ipaddress;
            this.lblHiddenIPAddress.Text = ipaddress;

            //GetAndLoadBedBoad();



            this.hdnlocatorboardID.Value = id; //Request.QueryString["id"].ToString(); // LocatorBoardID;
            this.lblLocatorBoardID.Text = id;  //Request.QueryString["id"].ToString();  //LocatorBoardID;


            this.lblLocationValue.Text = this.ddlSelectedWard.SelectedValue;

            GetNavLabelCounts();

            GetlocatorboardDetails();

            //if(id != "3a5015f7-85a3-4d96-a873-05405c509031" && id != "2263757e-b0f4-4164-a2b9-5806a6f232a7")
            //{
            //    Response.Cookies["IMAPage"].Value = "Current Patients";
            //    Response.Redirect("IMA.aspx?id=" + "3a5015f7-85a3-4d96-a873-05405c509031");
            //}

            //if (id == "2263757e-b0f4-4164-a2b9-5806a6f232a7")
            //{
            //    this.ddlSelectedWard.Enabled = false;
            //    this.lblSelectWard.Visible = false;
            //}
            //else
            //{
            //    this.ddlSelectedWard.Enabled = true;
            //    this.lblSelectWard.Visible = true;
            //}



        }

        private void GetNavLabelCounts()
        {
            //this.lblNavRecentPatients.Visible = false;

            this.lblNavCurrentPatientsCount.Visible = false;
            this.lblNavRecentPatientsCount.Visible = false;
            this.lblNavTCIsCount.Visible = false;
            this.lblNavWaitingAreaCount.Visible = false;
            //this.lblNavCurrentPatientsCount.Text = GetListCountByLocatorID(this.hdn_currentpatients_locatorboard_id.Value).ToString();
            //this.lblNavRecentPatientsCount.Text = GetListCountByLocatorID(this.hdn_recentpatients_locatorboard_id.Value).ToString();
            //this.lblNavTCIsCount.Text = GetListCountByLocatorID(this.hdn_tcis_locatorboard_id.Value).ToString();
            //this.lblNavWaitingAreaCount.Text = GetListCountByLocatorID(this.hdn_waitingarea_locatorboard_id.Value).ToString();
        }

        private int GetListCountByLocatorID(string locatorboard_id) 
        {
            string sql = "SELECT * FROM eboards.v_locatorboardlist WHERE locatorboard_id = @locatorboard_id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("locatorboard_id", locatorboard_id)
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
                return 0;
            }


            string baseview_id = "";
            try
            {
                baseview_id = dt.Rows[0]["baseview_id"].ToString();
            }
            catch
            {
                return 0;
            }

            string locationidfield = "";
            try
            {
                locationidfield = dt.Rows[0]["locationidfield"].ToString();
            }
            catch
            {
                return 0;
            }


            string sqlBV = "SELECT * FROM listsettings.baseviewmanager WHERE baseview_id = @baseview_id;";
            var paramListBV = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("baseview_id", baseview_id)
            };

            DataSet dsBV = new DataSet();
            DataTable dtBV = new DataTable();
            try
            {
                dsBV = DataServices.DataSetFromSQL(sqlBV, paramListBV);
                dtBV = dsBV.Tables[0];
            }
            catch (Exception ex)
            {
                return 0;
            }


            string baseview = "";
            try
            {
                baseview = dtBV.Rows[0]["baseviewnamespace"].ToString() + "_" + dtBV.Rows[0]["baseviewname"].ToString();
            }
            catch
            {
                return 0;
            }

            string sqlCount = "SELECT count(*) as recCount FROM baseview." + baseview + " WHERE " + locationidfield + " = @locationidfield;";
            var paramListCount = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("locationidfield", this.ddlSelectedWard.SelectedValue)
            };

            DataSet dsCount = new DataSet();
            DataTable dtCount = new DataTable();
            try
            {
                dsCount = DataServices.DataSetFromSQL(sqlCount, paramListCount);
                dtCount = dsCount.Tables[0];
            }
            catch (Exception ex)
            {
                return 0;
            }

            int recCount = 0;
            try
            {
                recCount = System.Convert.ToInt32(dtCount.Rows[0]["recCount"].ToString());
            }
            catch (Exception ex)
            {
                return 0;
            }

            return recCount;


        }


        private void GetIMAConfiguration()
        {
            String sql = "SELECT * FROM eboards.imaconfig WHERE imaconfig_id = '1d9517c4-9287-49e4-878f-cace9b2c18ea';";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {                
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

            

            
            try
            {
                this.hdn_currentpatients_locatorboard_id.Value = dt.Rows[0]["currentpatients_locatorboard_id"].ToString();
            }
            catch
            {
            }

            try
            {
                this.hdn_recentpatients_locatorboard_id.Value = dt.Rows[0]["recentpatients_locatorboard_id"].ToString();
            }
            catch
            {
            }

            try
            {
                this.hdn_tcis_locatorboard_id.Value = dt.Rows[0]["tcis_locatorboard_id"].ToString();
            }
            catch
            {
            }

            try
            {
                this.hdn_waitingarea_locatorboard_id.Value = dt.Rows[0]["waitingarea_locatorboard_id"].ToString();
            }
            catch
            {
            }
        }

        private void BindDropDownList(DropDownList ddl, string sql, string valueField, string displayField, int addPleaseSelect, List<KeyValuePair<string, string>> parameters = null)
        {
            DataSet ds = new DataSet();
            try
            {
                ds = DataServices.DataSetFromSQL(sql, parameters);
            }
            catch
            {

            }


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

            string defaultsortstatement = "";
            try
            {
                defaultsortstatement = dt.Rows[0]["defaultsortstatement"].ToString();
            }
            catch { }
            this.lblDefaultSortStatement.Text = defaultsortstatement;

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

            string heading = ""; //<span style='font-size: 0.7em;'>" + this.lblCurrentPage.Text + "</span><br />";
            try
            {
                heading += dtBoard.Rows[0]["headingfield"].ToString();
                this.ltrlHeading.Text =  heading;
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
            GetNavLabelCounts();
            Response.Cookies[Session["SynapseUser_UserID"].ToString().ToLower() + "_SynapseBedBoards_SelectedWard"].Value = this.ddlSelectedWard.SelectedValue;
        }


        protected void lbtnNavCurrentPatients_Click(object sender, EventArgs e)
        {
            Response.Cookies["IMAPage"].Value = "Current Patients";
            Response.Redirect("IMA.aspx?id=" + this.hdn_currentpatients_locatorboard_id.Value);
        }

        protected void lbtnNavWaitingArea_Click(object sender, EventArgs e)
        {
            Response.Cookies["IMAPage"].Value = "Waiting Area";
            Response.Redirect("IMA.aspx?id=" + this.hdn_waitingarea_locatorboard_id.Value);
        }

        protected void lbtnNavTCIs_Click(object sender, EventArgs e)
        {
            Response.Cookies["IMAPage"].Value = "TCIs";
            Response.Redirect("IMA.aspx?id=" + this.hdn_tcis_locatorboard_id.Value);
        }

        protected void lbtnNavRecentPatients_Click(object sender, EventArgs e)
        {
            Response.Cookies["IMAPage"].Value = "Recent Patients";
            Response.Redirect("IMA.aspx?id=" + this.hdn_recentpatients_locatorboard_id.Value);
        }

        protected void lbtnNavWardInfo_Click(object sender, EventArgs e)
        {
            Response.Redirect("WardInformation.aspx");
        }

        protected void lbtnNavManageBeds_Click(object sender, EventArgs e)
        {
            Response.Redirect("ManageBeds.aspx");
        }
    }
}