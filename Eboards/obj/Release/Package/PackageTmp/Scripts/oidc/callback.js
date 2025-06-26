

$(document).ready(function () {
    var mgr = new Oidc.UserManager(config);

    if (!window.location.origin) {
        window.location.origin = window.location.protocol + "//" + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
    }


    mgr.signinRedirectCallback().then(function (user) {
        // console.log(user);
        document.getElementById('hTkn').value = user.access_token;
        window.history.replaceState({},
            window.document.title,
            window.location.origin + window.location.pathname);
        document.getElementById('btnPostback').click();

    });

    // commenting catch as JS6 is not supported by ie 11
    //    .catch(e => {
    //    document.getElementById("error").innerHTML = e.message;
    //});

});