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
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class DynamicLocatorBoard : System.Web.UI.Page
    {
        string baseURL = System.Configuration.ConfigurationManager.AppSettings["DynamicAPIUri"]; //"http://synapsedynamicapiv2.azurewebsites.net/";//"https://localhost:44374/";//"https://synapsetest.rnoh.nhs.uk/synapsedynamicapi/";
        string token = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {

            getToken();

            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "script", "$(function () { LoadBoard(); });", true);

            if (!IsPostBack)
            {
                if (token != "")
                    getData();
            }

        }

        public void getData()
        {
            this.pnlHasData.Visible = false;
            this.pnlNoData.Visible = false;

            string ipaddress = Request.UserHostAddress; //GetIPAddress();

            this.lblIPAddress.Text = ipaddress;
            this.lblHiddenIPAddress.Text = ipaddress;

            GetAndLoadBedBoad();

            GetOccupiedBeds();
            GetAvailableBeds();
            GetNonAvailableBeds();

            GetTCIsIn24Hours();
            GetTCIsIn24HoursWithBeds();
            GetPatientsWaiting();
            GetPatientsWaitingWithBeds();
        }

        private void getToken()
        {
            bool getToken = false;
            if (Session["LocatorBoardAccessToken"] != null)
            {
                var jwttoken = SynapseHelpers.DecodeJWTToken(Session["LocatorBoardAccessToken"].ToString());

                if (!(jwttoken is JwtSecurityToken))
                {
                    //current token doesnt seem to be a valid one, get new. 
                    getToken = true;
                }

                if (((JwtSecurityToken)jwttoken).ValidTo <= DateTime.UtcNow.AddMinutes(-5))
                {
                    //current token is going to expire in 5 mins, get new. 
                    getToken = true;
                }
            }
            else //there isn't a token, get new. 
            {
                getToken = true;
            }

            if (getToken)
            {
                token = SynapseHelpers.RequestTokenSync();
                if (token != "")
                {
                    Session["LocatorBoardAccessToken"] = token;
                }
                else
                {
                    Response.Write("Unable to authenticate.");
                }
            }
            else
            {
                token = Session["LocatorBoardAccessToken"].ToString();
            }
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
            GetListByLocatorBoardID();
            GetListDetails();
            GetListColumns();
            GetRows();


        }


        //Start Counts

        private void GetOccupiedBeds()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_bedmanagement WHERE wardcode = @wardcode AND bedstatus = 1;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblNumberOfBedsOccupied.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblNumberOfBedsOccupied.Text = "0";
            }
        }

        private void GetAvailableBeds()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_bedmanagement WHERE wardcode = @wardcode AND bedstatus = 0;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblNumberOfBedsAvailable.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblNumberOfBedsAvailable.Text = "0";
            }
        }

        private void GetNonAvailableBeds()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_bedmanagement WHERE wardcode = @wardcode AND bedstatus = 2;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblNumberOfClosedBeds.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblNumberOfClosedBeds.Text = "0";
            }
        }

        private void GetTCIsIn24Hours()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_tcis WHERE wardcode = @wardcode; ";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblTCISIn24Hours.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblTCISIn24Hours.Text = "0";
            }
        }


        private void GetTCIsIn24HoursWithBeds()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_tcis WHERE wardcode = @wardcode AND allocatedbedcode is not null; ";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblTCISIn24HoursWithBeds.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblTCISIn24HoursWithBeds.Text = "0";
            }
        }


        private void GetPatientsWaiting()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_wardwaitingarea WHERE wardcode = @wardcode;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblPatientsWaiting.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblPatientsWaiting.Text = "0";
            }
        }

        private void GetPatientsWaitingWithBeds()
        {

            String sql = "SELECT COUNT(*) as records FROM baseview.eboards_wardwaitingarea WHERE wardcode = @wardcode AND allocatedbedcode is not null;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
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


            try
            {
                DataTable dt = ds.Tables[0];

                this.lblPatientsWaitingAllocatedBeds.Text = dt.Rows[0]["records"].ToString();
            }
            catch
            {
                this.lblPatientsWaitingAllocatedBeds.Text = "0";
            }
        }


        //Old Code

        //private void GetNumberOfBeds()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM entitystorematerialised.meta_wardbaybed WHERE wardcode = @wardcode;";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfBeds.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfBeds.Text = "0";
        //    }
        //}

        //private void GetNumberOfBedsClosed()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM entitystorematerialised.meta_wardbaybed WHERE wardcode = @wardcode AND bedstatus = 2;";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfClosedBeds.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfClosedBeds.Text = "0";
        //    }
        //}


        //private void GetNumberOfPatientsAllocated()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM baseview.eboards_wardwaitingarea WHERE wardcode = @wardcode;";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfPatientsAllocated.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfPatientsAllocated.Text = "0";
        //    }
        //}

        //private void GetNumberOfTCIsAllocated()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM baseview.eboards_tcis WHERE wardcode = @wardcode;";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfTCIS.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfTCIS.Text = "0";
        //    }
        //}

        //private void GetNumberOfTCIsAllocatedWithBeds()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM baseview.eboards_tcis WHERE wardcode = @wardcode AND COALESCE(wardbaybed_id,'') <> '';";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfTCIsWithBeds.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfTCIsWithBeds.Text = "0";
        //    }
        //}

        //private void GetNumberOfTCIsAllocatedWithoutBeds()
        //{

        //    String sql = "SELECT COUNT(*) as records FROM baseview.eboards_tcis WHERE wardcode = @wardcode AND COALESCE(wardbaybed_id,'') = '';";
        //    DataSet ds = new DataSet();
        //    var paramList = new List<KeyValuePair<string, string>>() {
        //        new KeyValuePair<string, string>("wardcode", this.lblLocationValue.Text)
        //    };
        //    try
        //    {
        //        ds = DataServices.DataSetFromSQL(sql, paramList);
        //    }
        //    catch (Exception ex)
        //    {
        //        StringBuilder sbe = new StringBuilder();
        //        //sbe.AppendLine("<div class='contentAlertDanger'><h3 style='color: #712f2f'>Sorry, there was an error:</h3>");
        //        sbe.AppendLine(ex.ToString());
        //        //sbe.AppendLine("</div>");
        //        //this.lblError.Visible = true;
        //        //this.lblError.Text = sbe.ToString();
        //        return;
        //    }

        //    DataTable dt = ds.Tables[0];

        //    try
        //    {
        //        this.lblNumberOfTCIsWithoutBeds.Text = dt.Rows[0]["records"].ToString();
        //    }
        //    catch
        //    {
        //        this.lblNumberOfTCIsWithoutBeds.Text = "0";
        //    }
        //}


        //End Count


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

            DataTable dt = new DataTable();

            string baseview_id = "";
            try
            {
                dt = ds.Tables[0];
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
                new KeyValuePair<string, string>("locationcode",  this.lblLocationValue.Text)
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

            DataTable dtBoard = new DataTable();

            try
            {
                dtBoard = dsBoard.Tables[0];

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


        private void GetListByLocatorBoardID()
        {
            string sql = "SELECT * FROM eboards.v_locatorboardlist WHERE locatorboard_id = @locatorboard_id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("locatorboard_id", this.hdnlocatorboardID.Value)
            };

            DataSet ds = new DataSet();
            try
            {
                ds = DataServices.DataSetFromSQL(sql, paramList);
                DataTable dt = ds.Tables[0];


                try
                {
                    this.lblListID.Text = dt.Rows[0]["list_id"].ToString();
                }
                catch { }


            }
            catch (Exception ex)
            {

            }

        }

        private void GetListDetails()
        {
            string sql = "SELECT * FROM listsettings.listmanager WHERE list_id = @list_id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("list_id", this.lblListID.Text)
            };

            DataSet ds = new DataSet();
            try
            {
                ds = DataServices.DataSetFromSQL(sql, paramList);
                DataTable dt = ds.Tables[0];

                try
                {
                    this.lbltablecssstyle.Text = dt.Rows[0]["tablecssstyle"].ToString();
                }
                catch { }

                try
                {
                    this.lbltableheadercssstyle.Text = dt.Rows[0]["tableheadercssstyle"].ToString();
                }
                catch { }

                try
                {
                    this.lbldefaultrowcssstyle.Text = dt.Rows[0]["defaultrowcssstyle"].ToString();
                }
                catch { }

            }
            catch
            {
            }
        }


        private void GetListColumns()
        {
            var url = baseURL + "List/GetListColumns/" + this.lblListID.Text;
            string cols = GetHTTPRequest(url);
            this.lblCols.Text = cols;
        }



        private void GetRows()
        {
            var url = baseURL + "List/GetListDataByPost/" + this.lblListID.Text;

            string json = "[{\"filters\":[{\"filterClause\":\"wardcode = @locationid\"}]},{\"filterparams\":[{\"paramName\":\"locationid\",\"paramValue\":\"" + this.lblLocationValue.Text + "\"}]},{\"selectstatement\":\"SELECT *\"},{\"ordergroupbystatement\":\"" + this.lblDefaultSortStatement.Text + "\"}]";

            using (WebClient wc = new WebClient())
            {
                try
                {
                    wc.Headers.Add("Authorization", string.Format("{0} {1}", "Bearer", token));

                    wc.Headers[HttpRequestHeader.ContentType] = "application/json; charset=UTF-8";
                    string HtmlResult = wc.UploadString(url, json);

                    this.lblRows.Text = HtmlResult;

                }
                catch { }
            }


        }





        private string GetHTTPRequest(string url)
        {

            StringBuilder sb = new StringBuilder();

            byte[] buf = new byte[8192];

            //do get request
            HttpWebRequest request = (HttpWebRequest)
                WebRequest.Create(url);
            request.Headers.Add("Authorization", string.Format("{0} {1}", "Bearer", token));

            HttpWebResponse response = (HttpWebResponse)
                request.GetResponse();


            Stream resStream = response.GetResponseStream();

            string tempString = null;
            int count = 0;
            //read the data and print it
            do
            {
                count = resStream.Read(buf, 0, buf.Length);
                if (count != 0)
                {
                    tempString = Encoding.ASCII.GetString(buf, 0, count);

                    sb.Append(tempString);
                }
            }
            while (count > 0);

            return sb.ToString();
        }

    }
}