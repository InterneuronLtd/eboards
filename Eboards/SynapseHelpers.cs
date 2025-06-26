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
using System.Collections.Specialized;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using IdentityModel;
using IdentityModel.Client;
using Newtonsoft.Json.Linq;

namespace SynapseStudio
{
    public class SynapseHelpers
    {

        //Entity Helpers
        public static string GetNamespaceNameFromID(string id)
        {
            string sql = "SELECT synapseNamespacename as retStr FROM entitysettings.synapseNamespace WHERE synapseNamespaceid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetAPIURL()
        {
            string sql = "SELECT apiurl AS retStr FROM  systemsettings.systemsetup;";
            var paramList = new List<KeyValuePair<string, string>>()
            {
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetEntityNameFromID(string id)
        {
            string sql = "SELECT entityname as retStr FROM entitysettings.entitymanager WHERE entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetNamepsaceFromEntityID(string id)
        {
            string sql = "SELECT synapseNamespacename as retStr FROM entitysettings.entitymanager WHERE entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetCurrentEntityVersionFromID(string id)
        {
            string sql = "SELECT entityversionid AS retStr FROM entitysettings.entityversion WHERE entityid = @id ORDER BY _sequenceid desc limit 1;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetNextOrdinalPositionFromID(string id)
        {
            string sql = "SELECT max(ordinal_position)+ 1 AS retStr FROM entitysettings.entityattribute WHERE entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static DataTable GetEntityDSFromID(string id)
        {
            string sql = "SELECT * FROM entitysettings.entitymanager WHERE entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }

        public static DataTable GetEntityKeyAttributeFromID(string id)
        {
            string sql = "SELECT attributeid, attributename FROM entitysettings.entityattribute WHERE iskeycolumn = 1 AND entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }

        public static string GetEntityIDFromAttributeID(string id)
        {
            string sql = "SELECT entityid AS retStr FROM entitysettings.entityattribute WHERE attributeid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetAttributeNameFromAttributeID(string id)
        {
            string sql = "SELECT attributename AS retStr FROM entitysettings.entityattribute WHERE attributeid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static DataTable GetEntitySampleJSON(string id)
        {
            string sql = "SELECT entitysettings.getjsonmodel(@id);";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }

        public static string GetEntityNameAndNamespaceFromID(string id)
        {
            string sql = "SELECT synapsenamespacename || '_' || case when length(coalesce(localnamespacename,'')) = 0 then '' else localnamespacename || '_' end || entityname as retStr FROM entitysettings.entitymanager WHERE entityid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetDataTypeFromID(string id)
        {
            string sql = "SELECT datatype as retStr FROM entitysettings.systemdatatype WHERE datatypeid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }


        //Baseview Helpers
        public static string GetBaseviewNamespaceNameFromID(string id)
        {
            string sql = "SELECT baseviewnamespace as retStr FROM listsettings.baseviewnamespace WHERE baseviewnamespaceid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }



        public static string GetBaseViewNameAndNamespaceFromID(string id)
        {
            string sql = "SELECT baseviewnamespace || '_'  || baseviewname as retStr FROM listsettings.baseviewmanager WHERE baseview_id = @id";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static DataTable GetBaseviewDTByID(string id)
        {
            string sql = "SELECT * FROM listsettings.baseviewmanager WHERE baseview_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }


        public static string GetBaseviewNameFromID(string id)
        {
            string sql = "SELECT baseviewname as retStr FROM listsettings.baseviewmanager WHERE baseview_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }


        public static string GetBaseviewNameSpaceIDFromBaseViewID(string id)
        {
            string sql = "SELECT baseviewnamespaceid as retStr FROM listsettings.baseviewmanager WHERE baseview_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetBaseviewNameSpaceNameFromBaseViewID(string id)
        {
            string sql = "SELECT baseviewnamespace as retStr FROM listsettings.baseviewmanager WHERE baseview_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static string GetBaseviewCommentsFromBaseViewID(string id)
        {
            string sql = "SELECT baseviewdescription as retStr FROM listsettings.baseviewmanager WHERE baseview_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }



        public static DataTable GetEntityBaseviewsDT(string id)
        {
            string sql = "SELECT * FROM entitysettings.v_entitydependentbaseviews WHERE entityid = @id ORDER BY source_schema, source_table;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }


        //List Helpers
        public static string GetListNamespaceNameFromID(string id)
        {
            string sql = "SELECT listnamespace as retStr FROM listsettings.listnamespace WHERE listnamespaceid = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }


        public static DataTable GetListDT(string id)
        {
            string sql = "SELECT * FROM  listsettings.listmanager WHERE list_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            return dt;

        }

        public static string GetListNextOrdinalPositionFromID(string id)
        {
            string sql = "SELECT coalesce(max(ordinalposition),0) + 1 AS retStr FROM listsettings.listattribute WHERE list_id = @id;";
            var paramList = new List<KeyValuePair<string, string>>() {
                new KeyValuePair<string, string>("id", id)
            };

            DataSet ds = DataServices.DataSetFromSQL(sql, paramList);
            DataTable dt = ds.Tables[0];

            string retStr = "";

            try
            {
                retStr = dt.Rows[0]["retStr"].ToString();
            }
            catch { }

            return retStr;

        }

        public static object DecodeJWTToken(string tokenString)
        {
            JwtSecurityTokenHandler j = new JwtSecurityTokenHandler();
            JwtSecurityToken jwttoken = new JwtSecurityToken();

            try
            {
                jwttoken = j.ReadJwtToken(tokenString);
            }
            catch
            {
                return null;
            }
            return jwttoken;
        }

        public static async Task<TokenResponse> RequestTokenAsync()
        {
            var disco = await DiscoveryClient.GetAsync(System.Configuration.ConfigurationManager.AppSettings["SISAuthority"]);
            //if (disco.IsError) throw new Exception(disco.Error);

            var client = new TokenClient(
                disco.TokenEndpoint,
                System.Configuration.ConfigurationManager.AppSettings["ClientId"],
               System.Configuration.ConfigurationManager.AppSettings["ClientSecret"], null,
                AuthenticationStyle.PostValues);

            var test = client.RequestClientCredentialsAsync(System.Configuration.ConfigurationManager.AppSettings["ClientScope"]);
            return test.Result;
        }

        public static string RequestTokenSync()
        {
            string token = "";
            using (var wb = new WebClient())
            {
                try
                {
                    var data = new NameValueCollection();
                    data["grant_type"] = "client_credentials";
                    data["client_id"] = System.Configuration.ConfigurationManager.AppSettings["ClientId"];
                    data["client_secret"] = System.Configuration.ConfigurationManager.AppSettings["ClientSecret"];
                    data["scope"] = System.Configuration.ConfigurationManager.AppSettings["ClientScope"];

                    var response = wb.UploadValues(System.Configuration.ConfigurationManager.AppSettings["SISAuthority"] + "connect/token", "POST", data);
                    token = Encoding.UTF8.GetString(response);
                }
                catch
                {
                    return "";
                }
            }

            if (token != "")
            {
                JObject json = JObject.Parse(token);
                if (json.ContainsKey("access_token"))
                    return json["access_token"].ToString();
                else
                    return "";
            }
            else
                return "";

        }
    }
}