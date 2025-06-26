//var GlobalServiceURL = "http://dynamicapi.interneuron.io/";
//var GlobalServiceURL = "http://localhost:50769/";
//var GlobalServiceURL = 'https://interneuron.rnoh.nhs.uk/synapsedynamicapi/';
//var GlobalServiceURL = 'https://localhost:44374/';
////var GlobalServiceURL = 'http://synapsedynamicapiv2.azurewebsites.net/';
//var GlobalServiceURL = 'https://synapsetest.rnoh.nhs.uk:8102/';
var GlobalServiceURL = 'https://synapsetest.rnoh.nhs.uk:8102/';
var virtualDirectoryEboardsSubFolderName = "/siseboards";  // usage: /subfoldername, leave empty if no subfolder
var virtualDirectoryLocatorboardsSubFolderName = "/locatorboards"; // usage: /subfoldername, leave empty if no subfolder
var sessionExpiredPage = "SessionExpired.aspx";
var logoutPage = "LogOut.aspx";

if (!window.location.origin) {
    window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
}

var config = {

    //configure authority and client
    // authority: "https://localhost:44332",
    authority: "https://synapsetest.rnoh.nhs.uk:5000",
    client_id: "rnoh-ima",
    redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/callback.aspx",
    post_logout_redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/Logout.aspx?oidccallback=true",

    response_type: "id_token token",
    scope: "openid dynamicapi.read",

    //set default authentication provider for this client
    acr_values: "idp:ADFS",

    //load userinfo from user info end point
    //disabled as SIS will copy userinfo into access token
    loadUserInfo: false,

    // This will get a new access_token via an iframe 60 secs before the old token is going to expire
    automaticSilentRenew: true,
    silent_redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/SilentRenew.aspx",

    // will revoke access tokens at logout timesilent
    revokeAccessTokenOnSignout: true,

    filterProtocolClaims: false,
    accessTokenExpiringNotificationTime: 60

};

if (window.location.pathname.toLowerCase().indexOf(virtualDirectoryLocatorboardsSubFolderName) >= 0) {
    config.post_logout_redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/LocatorLogout.aspx?oidccallback=true";
    config.redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/locatorcallback.aspx";
    config.silent_redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/SilentRenew.aspx";
    sessionExpiredPage = "LocatorSessionExpired.aspx";
    logoutPage = "LocatorLogout.aspx";

}

