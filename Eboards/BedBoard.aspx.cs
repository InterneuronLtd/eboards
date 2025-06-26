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
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EBoards
{
    public partial class BedBoard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                string BedBoardID = "";
                try
                {
                    BedBoardID = Request.QueryString["BedBoardID"].ToString();
                }
                catch
                {
                    //Response.Redirect("Error.aspx");
                }
                hdnBedBoardID.Value = BedBoardID;

                string Ward = "";
                try
                {
                    Ward = Request.QueryString["Ward"].ToString();
                }
                catch
                {
                    //Response.Redirect("Error.aspx");
                }
                hdnWard.Value = Ward;

                string Bed = "";
                try
                {
                    Bed = Request.QueryString["Bed"].ToString();
                }
                catch
                {
                    //Response.Redirect("Error.aspx");
                }
                hdnBed.Value = Bed;


                this.pnlTopSingle.Visible = false;
                this.pnlTopDouble.Visible = false;
                this.pnlMiddleSingle.Visible = false;
                this.pnlMiddleDouble.Visible = false;
                this.pnlBottomSingle.Visible = false;
                this.pnlBottomDouble.Visible = false;

                GetBedBoardDetails();
            }


        }

        private void GetBedBoardDetails()
        {
            string sql = "SELECT * FROM eboards.bedboard WHERE bedboard_id = @bedboard_id;";
            DataSet ds = new DataSet();
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("bedboard_id", hdnBedBoardID.Value)
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
                baseview_id = dt.Rows[0]["baseview_id"].ToString();
            }
            catch { }

            string baseviewname = SynapseHelpers.GetBaseViewNameAndNamespaceFromID(baseview_id);


            string TopSetting = "";
            try
            {
                TopSetting = dt.Rows[0]["topsetting"].ToString();
            }
            catch { }
            if(TopSetting == "1")
            {
                this.pnlTopSingle.Visible = true;                
            }
            else if(TopSetting == "2")
            {
                this.pnlTopDouble.Visible = true;
            }

            string MiddleSetting = "";
            try
            {
                MiddleSetting = dt.Rows[0]["middlesetting"].ToString();
            }
            catch { }
            if(MiddleSetting == "1")
            {
                this.pnlMiddleSingle.Visible = true;                
            }
            else if(MiddleSetting == "2")
            {
                this.pnlMiddleDouble.Visible = true;
            }

            string BottomSetting = "";
            try
            {
                BottomSetting = dt.Rows[0]["bottomsetting"].ToString();
            }
            catch { }
            if(BottomSetting == "1")
            {
                this.pnlBottomSingle.Visible = true;
            }
            else if (BottomSetting == "2")
            {
                this.pnlBottomDouble.Visible = true;
            }


            string PersonIDField = "";
            try
            {
                PersonIDField = dt.Rows[0]["baseviewpersonidfield"].ToString();
            }
            catch { }

            string EncounterIDField = "";
            try
            {
                EncounterIDField = dt.Rows[0]["baseviewencounteridfield"].ToString();
            }
            catch { }

            string WardField = "";
            try
            {
                WardField = dt.Rows[0]["baseviewwardfield"].ToString();
            }
            catch { }

            string BedField = "";
            try
            {
                BedField = dt.Rows[0]["baseviewbedfield"].ToString();
            }
            catch { }



            string topfield = "";
            try
            {
                topfield = dt.Rows[0]["topfield"].ToString();
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


            string middlefield = "";
            try
            {
                middlefield = dt.Rows[0]["middlefield"].ToString();
            }
            catch { }
            string middleleftfield = "";
            try
            {
                middleleftfield = dt.Rows[0]["middleleftfield"].ToString();
            }
            catch { }
            string middlerightfield = "";
            try
            {
                middlerightfield = dt.Rows[0]["middlerightfield"].ToString();
            }
            catch { }

            string bottomfield = "";
            try
            {
                bottomfield = dt.Rows[0]["bottomfield"].ToString();
            }
            catch { }
            string bottomleftfield = "";
            try
            {
                bottomleftfield = dt.Rows[0]["bottomleftfield"].ToString();
            }
            catch { }
            string bottomrightfield = "";
            try
            {
                bottomrightfield = dt.Rows[0]["bottomrightfield"].ToString();
            }
            catch { }

            string sqlBoard = "SELECT " + PersonIDField + " as PersonID, " + EncounterIDField + " as EncounterID," + WardField + " as Ward, " + BedField + " as Bed," +
                              topfield + " as TopField," + topleftfield + " as TopLeftField," + toprightfield + " as TopRightField," +
                              middlefield + " as MiddleField," + middleleftfield + " as MiddleLeftField," + middlerightfield + " as MiddleRightField," +
                              bottomfield + " as BottomField," + bottomleftfield + " as BottomLeftField," + bottomrightfield + " as BottomRightField" +
                              " FROM baseview." + baseviewname + " WHERE " + WardField + " = @Ward AND " + BedField + " = @bed";

            var paramListbOARD = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("Ward", hdnWard.Value),
                new KeyValuePair<string, string>("bed", hdnBed.Value)
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
                this.ltrlTop.Text = dtBoard.Rows[0]["TopField"].ToString();
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

            try
            {
                this.ltrlMiddle.Text = dtBoard.Rows[0]["MiddleField"].ToString();
            }
            catch { }
            try
            {
                this.ltrlMiddleLeft.Text = dtBoard.Rows[0]["MiddleLeftField"].ToString();
            }
            catch { }
            try
            {
                this.ltrlMiddleRight.Text = dtBoard.Rows[0]["MiddleRightField"].ToString();
            }
            catch { }

            try
            {
                this.ltrlBottom.Text = dtBoard.Rows[0]["BottomField"].ToString();
            }
            catch { }
            try
            {
                this.ltrlBottomLeft.Text = dtBoard.Rows[0]["BottomLeftField"].ToString();
            }
            catch { }
            try
            {
                this.ltrlBottomRight.Text = dtBoard.Rows[0]["BottomRightField"].ToString();
            }
            catch { }


        }
    }
}