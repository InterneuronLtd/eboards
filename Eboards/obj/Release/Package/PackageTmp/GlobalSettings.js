
var GlobalServiceURL = 'https://synapsedynamicapi.dev.interneuron.io/';
var virtualDirectoryEboardsSubFolderName = "";  // usage: /subfoldername, leave empty if no subfolder
var virtualDirectoryLocatorboardsSubFolderName = ""; // usage: /subfoldername, leave empty if no subfolder
var sessionExpiredPage = "SessionExpired.aspx";
var logoutPage = "LogOut.aspx";

if (!window.location.origin) {
    window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
}

var config = {

    //configure authority and client

    authority: "https://synapseidentityserver.dev.interneuron.io",
    client_id: "rnoh-ima",
    redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/callback.aspx",
    post_logout_redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/Logout.aspx?oidccallback=true",

    response_type: "id_token token",
    scope: "openid dynamicapi.read",

    //set default authentication provider for this client
    //acr_values: "idp:ADFS",

    //load userinfo from user info end point
    //disabled as SIS will copy userinfo into access token
    loadUserInfo: false,

    // This will get a new access_token via an iframe 60 secs before the old token is going to expire
    automaticSilentRenew: false,
    silent_redirect_uri: window.location.origin + virtualDirectoryEboardsSubFolderName + "/SilentRenew.aspx",

    // will revoke access tokens at logout timesilent
    revokeAccessTokenOnSignout: true,

    filterProtocolClaims: false,
    accessTokenExpiringNotificationTime: 60

};


//if (window.location.pathname.toLowerCase().indexOf(virtualDirectoryLocatorboardsSubFolderName) >= 0) {
//    console.log("inside locator config");
//    config.post_logout_redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/LocatorLogout.aspx?oidccallback=true";
//    config.redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/locatorcallback.aspx";
//    config.silent_redirect_uri = window.location.origin + virtualDirectoryLocatorboardsSubFolderName + "/SilentRenew.aspx";
//    sessionExpiredPage = "LocatorSessionExpired.aspx";
//    logoutPage = "LocatorLogout.aspx";

//}


