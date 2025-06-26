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
﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices;
using System.DirectoryServices.AccountManagement;
using System.DirectoryServices.ActiveDirectory;
using System.IO;
using System.Text;
using System.Data;
using SynapseStudio;

namespace EBoards
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            Response.Redirect("LoginOidc.aspx");
            
            if (!IsPostBack)
            {
                //Kill any existing sessions
                Session.Clear();

                string sql = "SELECT domainname FROM systemsettings.domainconfig;";
                var paramList = new List<KeyValuePair<string, string>>()
                {
                };
                BindDropDownList(this.ddlDomain, sql, "domainname", "domainname", 0, paramList);

                //Focus on the username textbox
                this.txtUsername.Focus();
            }
        }

        //Drop Down Lists
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
        }


        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string IPAddress = "";
            try
            {
                IPAddress = GetIPAddress();
            }
            catch { }

            Session["SynapseUser_UserID"] = this.txtUsername.Text;
            Session["SynapseUser_FullName"] = "";

            string returnURL = "Default.aspx";
            try
            {
                returnURL = Request.Cookies[Session["SynapseUser_UserID"].ToString().ToLower() + "_SynapseBedBoards_ReturnURL"].Value.ToString(); ;
            }
            catch { }


            string domain = this.ddlDomain.SelectedValue;
            if (this.ddlLoginType.SelectedValue == "AD")
            {

                bool auth = AuthenticateActiveDirectory(this.txtUsername.Text, this.txtPassword.Text, domain);
                if (auth == true)
                {
                    this.pnlFailed.Visible = false;
                    GetUserDetails(this.txtUsername.Text);
                    Response.Redirect(returnURL);
                }
                else
                {
                    recordFailedLoginAttempt(this.txtUsername.Text, IPAddress, "Active Directory");
                    this.pnlFailed.Visible = true;
                }
            }
            else
            {
                bool authDB = AuthenticateDatabase(this.txtUsername.Text, this.txtPassword.Text);
                if (authDB)
                {
                    Response.Redirect(returnURL);
                }
                else
                {
                    this.pnlFailed.Visible = true;
                    this.lblError.Text = "Invalid Username or Password";
                }
            }

        }


        private bool AuthenticateActiveDirectory(string userName, string password, string domain)
        {
            bool authentic = false;
            DirectoryEntry entry = new DirectoryEntry();

            object nativeObject = new object();
            try
            {
                entry = new DirectoryEntry("LDAP://" + domain, userName, password);

            }
            catch (DirectoryServicesCOMException) { }

            try
            {
                nativeObject = entry.NativeObject;
                authentic = true;
            }
            catch (Exception ex)
            {
                //this.lblError.Text = ex.ToString();
            }



            return authentic;
        }

        private bool AuthenticateDatabase(string username, string password)
        {
            string IPAddress = "";
            try
            {
                IPAddress = GetIPAddress();
            }
            catch { }

            string sql = "SELECT * FROM systemsettings.app_user WHERE emailaddress = @email AND userpassword = crypt(@password, userpassword);";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("email", this.txtUsername.Text),
                new KeyValuePair<string, string>("password", this.txtPassword.Text)
            };



            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                //Valid User
                Session["UserDetailsSxn"] = dt;

                //Record Login
                string userid = "0";
                try
                {
                    userid = dt.Rows[0]["userid"].ToString();
                }
                catch { }
                Session["userID"] = userid;

                string emailconfirmed = "False";
                try
                {
                    emailconfirmed = dt.Rows[0]["emailconfirmed"].ToString();
                }
                catch { }

                string userFullName = "";
                try
                {
                    userFullName = dt.Rows[0]["firstname"].ToString() + " " + dt.Rows[0]["lastname"].ToString();
                }
                catch { }
                Session["userFullName"] = userFullName;
                Session["SynapseUser_FullName"] = userFullName;
                //string userType = "";
                //try
                //{
                //    userType = dt.Rows[0]["usertype"].ToString();
                //}
                //catch
                //{
                //    //Response.Redirect("Login.aspx");
                //}
                //Session["userType"] = userType;

                //string matchedclinicianid = "";
                //try
                //{
                //    matchedclinicianid = dt.Rows[0]["matchedclinicianid"].ToString();
                //}
                //catch
                //{
                //    //Response.Redirect("Login.aspx");
                //}
                //Session["matchedclinicianid"] = matchedclinicianid;


                //this.hdnEmail.Value = this.txtEmail.Text;

                if (emailconfirmed == "False")
                {
                    this.lblError.Text = "Your account has been created but you have not confirmed your email address yet.<br /><br />Please check your spam folder for the email containing the link to confirm your account";
                    //this.btnResendValidationEmail.Visible = true;
                    this.lblError.Visible = true;
                    return false;
                }

                string isauthorised = "False";
                try
                {
                    isauthorised = dt.Rows[0]["isauthorised"].ToString();
                }
                catch { }

                if (isauthorised == "False")
                {
                    this.lblError.Text = "Your account has not been authorised yet";
                    this.lblError.Visible = true;
                    return false;
                }


                recordSuccessfulLoginAttempt(userid, this.txtUsername.Text, IPAddress, "SQL");
                //Response.Redirect(this.lblRedirect.Text);
                return true;
            }
            else
            {
                //Invalid User
                recordFailedLoginAttempt(username, IPAddress, "SQL");

                return false;
            }
        }


        private void recordSuccessfulLoginAttempt(string userid,  string username, string IPAddress, string logintype)
        {
            string sql = "INSERT INTO systemsettings.loginhistory (userid, emailaddress, ipaddress) VALUES (CAST(@userid AS INT), @emailaddress, @ipaddress);";
            var paramList = new List<KeyValuePair<string, string>>() {
                    new KeyValuePair<string, string>("userid", userid),
                    new KeyValuePair<string, string>("emailaddress", username),
                    new KeyValuePair<string, string>("ipaddress",IPAddress)
                };
            DataServices.executeSQLStatement(sql, paramList);
        }

        private void recordFailedLoginAttempt(string userid, string IPAddress, string logintype)
        {
            string sql = "INSERT INTO systemsettings.failedlogin(emailaddress, ipaddress)	VALUES ( @emailaddress, @ipaddress); ";
            var paramListFail = new List<KeyValuePair<string, string>>() {
                    new KeyValuePair<string, string>("emailaddress", this.txtUsername.Text),
                    new KeyValuePair<string, string>("ipaddress",IPAddress)
                };
            DataServices.executeSQLStatement(sql, paramListFail);
        }

        private string GetIPAddress()
        {
            System.Web.HttpContext context = System.Web.HttpContext.Current;
            string ipAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

            if (!string.IsNullOrEmpty(ipAddress))
            {
                string[] addresses = ipAddress.Split(',');
                if (addresses.Length != 0)
                {
                    return addresses[0];
                }
            }

            return context.Request.ServerVariables["REMOTE_ADDR"];
        }

        private void GetUserDetails(string accountName)
        {
            var domain = this.ddlDomain.SelectedValue;
            accountName = accountName.ToUpper();
            accountName = accountName.Replace(domain + "\\", "");

            var context = new PrincipalContext(ContextType.Domain);
            string server = context.ConnectedServer; // "pdc.examle.com"
            string[] splitted = server.Split('.'); // { "pdc", "example", "com" }
            IEnumerable<string> formatted = splitted.Select(s => String.Format("DC={0}", s));// { "DC=pdc", "DC=example", "DC=com" }
            string joined = String.Join(",", formatted); // "DC=pdc,DC=example,DC=com"        
            string pdc = String.Join(",", context.ConnectedServer.Split('.').Select(s => String.Format("DC={0}", s)));

            //Domain domain = Domain.GetCurrentDomain();
            DirectoryEntry entry = new DirectoryEntry("LDAP://" + domain.ToString());
            DirectorySearcher search = new DirectorySearcher(entry);

            search.Filter = "(&(objectCategory=person)(objectClass=user)(samaccountname=" + accountName + "))";

            search.PropertiesToLoad.Add("mail");
            search.PropertiesToLoad.Add("sn");
            search.PropertiesToLoad.Add("givenName");
            search.PropertiesToLoad.Add("telephoneNumber");
            search.PropertiesToLoad.Add("department");
            search.PropertiesToLoad.Add("pager");
            search.PropertiesToLoad.Add("title");
            search.PropertiesToLoad.Add("samaccountname");
            search.PropertiesToLoad.Add("usergroup");
            search.PropertiesToLoad.Add("thumbnailPhoto");


            SearchResult result;

            try
            {
                result = search.FindOne(); //finding the mail id        
            }
            catch
            {
                result = null;
            }

            string firstName = "";
            string Surname = "";
            string Title = "";
            string Department = "";
            string Email = "";
            string Telephone = "";
            string Bleep = "";
            string SAMAccountName = "";
            string userThumbnail = "";

            if (result != null)
            {
                // print you email id

                try
                {
                    firstName = result.Properties["givenName"][0].ToString();
                }
                catch { }

                try
                {
                    Surname = result.Properties["sn"][0].ToString();
                }
                catch { }

                try
                {
                    Title = result.Properties["title"][0].ToString();
                }
                catch { }

                try
                {
                    Department = result.Properties["department"][0].ToString();
                }
                catch { }

                try
                {
                    Email = result.Properties["mail"][0].ToString();
                }
                catch { }

                try
                {
                    Telephone = result.Properties["telephoneNumber"][0].ToString();
                }
                catch { }

                try
                {
                    Bleep = result.Properties["pager"][0].ToString();
                }
                catch { }

                try
                {
                    SAMAccountName = result.Properties["samaccountname"][0].ToString();
                }
                catch { }

                try
                {
                    userThumbnail = result.Properties["thumbnailPhoto"][0].ToString();
                }
                catch { userThumbnail = ""; }

                if (string.IsNullOrWhiteSpace(userThumbnail))
                {
                    userThumbnail = "img/user.png";
                }
                else
                {
                    userThumbnail = "UserImages/" + createImage(Convert.ToBase64String((byte[])result.Properties["thumbnailPhoto"][0]), firstName + Surname);
                }


                try
                {
                    this.lblForname.Text = firstName;
                }
                catch { }

                try
                {
                    this.lblSurname.Text = Surname;
                }
                catch { }

                try
                {
                    this.lblTitle.Text = Title;
                }
                catch { }

                try
                {
                    this.lblUserImage.Text = "<img src='" + userThumbnail + "' class='userImage'//>";
                }
                catch { }

                string IPAddress = "";
                try
                {
                    IPAddress = GetIPAddress();
                }
                catch { }

                Session["SynapseUser_FullName"] = firstName + " " + Surname; 

                recordSuccessfulLoginAttempt("0", SAMAccountName, IPAddress, "Active Directory");

                StringBuilder sb = new StringBuilder();
                sb.AppendLine("<div class='row-fluid'>");

                sb.AppendLine("<div class='span2'>");
                sb.AppendLine("<img src='" + userThumbnail + "'/>");
                sb.AppendLine("</div>");

                sb.AppendLine("<div class='span10'>");
                sb.AppendLine("<h4>");
                sb.AppendLine(firstName + " " + Surname);
                sb.AppendLine("</h4>");

                sb.AppendLine("<span>");
                sb.AppendLine(Title);
                sb.AppendLine("</span>");

                sb.AppendLine("<br />");

                sb.AppendLine("<span>");
                sb.AppendLine(Department);
                sb.AppendLine("</span>");

                sb.AppendLine("</div>");

                sb.AppendLine("</div>");

                Session["userDiv"] = sb.ToString();

            }
            else
            {
                //Session["errrorMessage"] = "<h1>Error</h1>Sorry, we have been unable to the supplied user credentials";
                //Response.Redirect("error.aspx");
            }

        }

        private static string RemoveSpecialCharacters(string str)
        {
            StringBuilder sb = new StringBuilder();
            foreach (char c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '.' || c == '_')
                {
                    sb.Append(c);
                }
            }
            return sb.ToString();
        }

        private string createImage(string base64String, string user)
        {
            string fileName = RemoveSpecialCharacters(user) + ".jpg";
            string filePath = Server.MapPath(".") + "\\UserImages\\" + fileName;
            var bytes = Convert.FromBase64String(base64String);
            using (var imageFile = new FileStream(filePath, FileMode.Create))
            {
                imageFile.Write(bytes, 0, bytes.Length);
                imageFile.Flush();
            }
            return fileName;
        }

        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            this.pnlLogin.Visible = true;
            this.pnlSuccess.Visible = false;
            this.pnlFailed.Visible = false;
        }

        protected void btnAccessSystem_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}