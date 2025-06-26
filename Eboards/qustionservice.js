//Question Functions
function generateTextBox(id, labelText, defaultValue, questionID) {
    var html = '<div class="form-group" id="fg' + id + '"><label for="' + id + '" >' + labelText + '</label >' +
        '<input type="' + "text" + '" class="form-control" id="' + id + '" aria-describedby="hlp' + id + '" placeholder="' + labelText + '" maxlength="255">' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);

    $("#" + id).change(function () {
        postShortTextData(id, questionID);
    });

    $("#" + id).val(defaultValue);

}

function generateTextArea(id, labelText, defaultValue, questionID) {
    var html = '<div class="form-group" id="fg' + id + '"><label for="' + id + '" >' + labelText + '</label >' +
        '<textarea class="form-control" id="' + id + '" aria-describedby="hlp' + id + '" placeholder="' + labelText + '" rows="8"></textarea>' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);

    $("#" + id).change(function () {
        postLongTextData(id, questionID);
    });

    $("#" + id).val(defaultValue);
}

function generateSelect(id, labelText, options, defaultValue, questionID) {
    options = JSON.parse(options);
    var html = '' +

        '<div class="form-group" id="fg' + id + '">' + //Start Form Group
        '<label for="' + id + '" >' + labelText + '</label >' +

        '<div class="row">' +  //Start Row
        '<div class="col-md-9">' + //Start Column

        '<select class="form-control" id="' + id + '" aria-describedby="hlp' + id + '">';
    html += ' <option value="0">Please select . . .</option>';
    for (var i = 0; i < options.length; i++) {
        var obj = options[i];
        html += '<option value="' + obj.optionvaluetext + '">' + obj.optiondisplaytext + '</option>';
    }
    html += '</select>' +

        '</div>' + //End Column
        '<div class="col-md-3">' + //Start Column
        '<div id="selectWidget' + id + '">' +
        '</div > ' + //End Column
        '</div>' + //End Row

        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>' + // End Form Group

        '';

    $('#formContainer').append(html);

    $("#" + id).change(function () {
        postSelectData(id, options, questionID);
    });


    $("#" + id).val(defaultValue);

    var widget = getWidgetFromArray(defaultValue, options);
    $("#selectWidget" + id).html(widget);
}

function generateRadioImage(id, options, defaultValue, questionID) {
    options = JSON.parse(options);
    //console.log(options);
    var html = '' +

        '<div class="form-group" id="fg' + id + '">' + //Start Form Group


        '<div class="row">' +  //Start Row
        '<div class="col-md-12">'; //Start Column


    for (var i = 0; i < options.length; i++) {
        var obj = options[i];
        html += "<label>";
        html += "<input type='radio' name='" + questionID + "' value='" + obj.optionvaluetext + "'";
        //console.log("Initial: " + obj.optionvaluetext + ":" + defaultValue);
        if (obj.optionvaluetext == defaultValue) {
            //console.log('Match: ' + obj.optionvaluetext);
            html += " checked='checked' ";
            html += " />";
            html += '<div>' + obj.optionflag + '</div>';
        }
        else {
            html += " />";
            html += '<div>' + obj.optionflagalt + '</div>';
        }


        html += "</label>";
    }

    html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id="btnClear' + id + '" class=" btn-secondary btn-sm pull-right">Clear</button>' +

        '</div>' + //End Column

        '</div>' + //End Row

        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>' + // End Form Group

        '';

    $('#formContainer').append(html);



    $('input[name="' + questionID + '"]:radio').change(function () {
        //console.log("id:" + id);
        //console.log("question_id:" + questionID);
        //console.log("value:" + this.value);




        postRadioImageData(id, this.value, questionID, options);
    });




    $("#btnClear" + id).click(function () {
        postRadioImageData(id, "", questionID, options);
    });

    //$('input:radio').change(function () {
    //    alert('changed');
    //});


    //$("#" + id).val(defaultValue);


}

function generateRadioList(id, options, defaultValue, questionID) {
    options = JSON.parse(options);
    //console.log(options);
    var html = '' +

        '<div class="form-group" id="fg' + id + '">' + //Start Form Group


        '<div class="row">' +  //Start Row
        '<div class="col-md-12">'; //Start Column


    for (var i = 0; i < options.length; i++) {
        var obj = options[i];
        html += "<input type='radio' name='" + questionID + "' value='" + obj.optionvaluetext + "'";
        //console.log(obj.optionvaluetext + ":" + defaultValue);
        if (obj.optionvaluetext == defaultValue) {
            //console.log('Match: ' + obj.optionvaluetext);
            html += " checked='checked' ";
        }
        html += " />";
        html += " " + obj.optiondisplaytext + "<br />";
    }

    '</div>' + //End Column

        '</div>' + //End Row

        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>' + // End Form Group

        '';

    $('#formContainer').append(html);



    $('input[name="' + questionID + '"]:radio').change(function () {
        //console.log("id:" + id);
        //console.log("question_id:" + questionID);
        //console.log("value:" + this.value);
        postRadioData(id, this.value, questionID);
    });


    //$('input:radio').change(function () {
    //    alert('changed');
    //});


    //$("#" + id).val(defaultValue);


}

function generateCheckBoxList(id, labelText, options, questionID) {
    var optString = JSON.stringify(options);
    options = JSON.parse(options);

    var html = '<div class="form-group" id="fg' + id + '">'; // +
    //'<label for="' + id + '" >' + labelText + '</label >';
    for (var i = 0; i < options.length; i++) {
        var obj = options[i];
        html += '<div class="form-check" id="fc' + id + '-' + obj.optionvaluetext + '">' +
            '<input class="form-check-input" type="checkbox" value="' + obj.optionvaluetext + '" id="opt' + id + '-' + obj.optionvaluetext + '" name="opt' + id + '">' +
            '<label class="form-check-label" for="opt' + id + '-' + obj.optionvaluetext + '">' +
            obj.optiondisplaytext +
            '</label>' + '</div>';
    }
    html += '</div' +
        '<div id="selectWidget' + id + '"></div>' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);

    $("#" + id).change(function () {
        postCheckListBoxData(id, options, questionID);
    });

    $("input[name='opt" + id + "']").change(function () {
        // checkboxValues.push(this.value);
        postCheckListBoxData(id, options, questionID);
    });

}

function generateHTMLDiv(id, labelText) {
    var html = '<div class="form-group" id="fg' + id + '"><div>' + labelText + '</div></div>';
    $('#formContainer').append(html);

}

function generateAutoComplete(id, labelText, url, defaultValue, questionID) {
    var html = '<div class="form-group" id="fg' + id + '"><label for="' + id + '" >' + labelText + '</label >' +
        '<input class="form-control" id="' + id + '" aria-describedby="hlp' + id + '" placeholder="' + labelText + '" onchange="postShortTextData(\'' + id + '\')">' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);


    var options = {
        url: url,

        getValue: "optiondisplaytext",

        list: {
            match: {
                enabled: true
            }
        }

    };











    $("#" + id).easyAutocomplete(options);

    $("#" + id).focusout(function () {
        postSelectData(id, options, questionID);
    });

    //console.log('id:' + id);
    //console.log('options:' + options);
    //console.log('questionID:' + questionID);

    //$("#" + id).change(function () {
    //    postSelectData(id, options, questionID);
    //});
    $("#" + id).val(defaultValue);

}

function generateCheckBox(id, labelText, defaultValue, questionID, htmlSnippet, htmlSnippetAlt) {
    var html = '<div class="form-group" id="fg' + id + '">' +
        '<div class="row">' +
        '<div class="col-md-9">' +
        '<label class="containerCB">' +
        labelText +
        '<input type="checkbox" id="' + id + '" class="form-control">' +
        '<span class="checkmark"></span>' +
        '</label>' +
        '</div>' +
        '<div class="col-md-3" id="selected' + id + '">' +
        htmlSnippet +
        '</div>' +
        '</div > ' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);


    $("#selected" + id).hide();

    try {
        if (defaultValue.toLowerCase() === "true") {
            $("#" + id).prop('checked', true);
            $("#selected" + id).show();
        }
    }
    catch (ex) {
        //Nothing to do
    }





    $("#" + id).change(function () {
        $("#selected" + id).hide();

        if ($("#" + id).is(":checked")) {

            $("#selected" + id).show();
        }
        postCheckBoxData(id, questionID);
    });

    //$("#" + id).val(defaultValue);

}

function generateCheckBoxImage(id, labelText, defaultValue, questionID, htmlSnippet, htmlSnippetAlt) {

    var html = '<div class="row">' +  //Start Row
        '<div class="col-md-12">' +  //Start Column

        "<div style='display: none !important;'>" +
        '<input type="checkbox" id="' + id + '">' +
        "</div>" +
        '<div id="selected' + id + '">' + '<div id="selectedInner' + id + '">' + htmlSnippet + '</div>' + '</div>' +

        '</div>' + //End Column

        '</div>' + //End Row


        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>';

    $('#formContainer').append(html);



    //$("#selected" + id).hide();

    try {
        if (defaultValue.toLowerCase() === "true") {
            $("#" + id).prop('checked', true);

            $("#selectedInner" + id).html(htmlSnippet);
        }
        else {
            $("#" + id).prop('checked', false);
            $("#selectedInner" + id).html(htmlSnippetAlt);
        }
    }
    catch (ex) {
        $("#" + id).prop('checked', false);
        $("#selectedInner" + id).html(htmlSnippetAlt); //Default if null
    }



    $("#selected" + id).click(function () {
        if ($("#" + id).prop('checked')) {
            console.log('uncheck');
            $("#" + id).prop('checked', false);
            $("#selectedInner" + id).html(htmlSnippetAlt);
        } else {
            console.log('check');
            $("#" + id).prop('checked', true);
            $("#selectedInner" + id).html(htmlSnippet);
        }

        postCheckBoxData(id, questionID);
    });


    //if ($("#" + id).prop('checked')) {
    //    alert('Checked');
    //}



    //$("#" + id).change(function () {
    //    postCheckBoxData(id, questionID);
    //});

    //$("#" + id).val(defaultValue);

}

function generateCalendar(id, labelText, defaultValue, questionID) {
    var html = '<div class="form-group" id="fg' + id + '"><label for="' + id + '" >' + labelText + '</label >' +
        //'<input class="form-control" id="' + id + '" type="text" placeholder="Select Date . . ">' +
        '<div class="row"><div class="col-xs-3">' + 
        '<input type="text" class="form-control" id="' + id + '" aria-describedby="hlp' + id + '" placeholder="' + labelText + '">' +
        '</div></div>' + 
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';




    //var html =  '<div class="row">' + 
    //            '<div class="col-sm-6">' + 

    //    '<div class="form-group" id="fg' + id + '">' + '<label for="' + id + '" >' + labelText + '</label >' +
    //    '<div class="input-group date" id="' + id + '" data-target-input="nearest">' +
    //    '<input type="text" class="form-control datetimepicker-input" data-target="#' + id + '" />' +
    //    '<div class="input-group-append" data-target="#' + id + '" data-toggle="datetimepicker">' +
    //    '<div class="input-group-text"><i class="fa fa-calendar"></i></div>' +

    //    '</div>' +       
    //    '</div>';

    

    $('#formContainer').append(html);


    $("#" + id).pickadate({
        format: "yyyy-mm-dd",
        formatSubmit: "yyyy-mm-dd", //"dd/mm/yyyy",                
        hiddenName: true,
        selectYears: true,
        selectMonths: true
    });

    //$("#" + id).datetimepicker({
    //    format: 'L'
    //});


    $("#" + id).change(function () {
        console.log('fired');
        postCalendarData(id, questionID);
    });


    //$('#' + id).on('input', function () {
    //    alert("Hey there :)")
    ////});
    //$('#' + id).on('hide', function () {
    //    alert("Hey there, I won't trigger :(");
    //});



    try {
        $("#" + id).val(defaultValue.substring(0, 10));
    }
    catch (er) {
    }
}

function generateTimePicker(id, labelText, questionID) {
    var html = '<div class="form-group" id="fg' + id + '"><label for="' + id + '" >' + labelText + '</label >' +
        //'<input class="form-control" id="' + id + '" type="text" placeholder="Select Date . . ">' +
        '<input type="text" class="form-control" id="' + id + '" aria-describedby="hlp' + id + '" placeholder="' + labelText + '" onchange="postTimeData(\'' + id + '\')">' +
        '<div class="valid-feedback" id="success' + id + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + id + '"></div>' +
        '</div>';

    $('#formContainer').append(html);

    $("#" + id).pickatime();
}

//Dummy Variables
var listID = "";
var contextField = '';
var contextValue = '';
//var listQuestionID = id; 

function postCheckBoxData(listQuestionID, questionID) {

    var val = false; // $("#" + listQuestionID).val();
    //$("#selected" + listQuestionID).hide();

    if ($("#" + listQuestionID).is(":checked")) {
        val = true;
        //$("#selected" + listQuestionID).show();
    }

    //console.log('id:' + id + ' - val:' + val);

    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;
    data.question_id = questionID;
    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    //data.valueshorttext = val;
    //data.valuelongtext = "";
    //data.valuedate = "";
    data.valueboolean = val;
    data._createdby = synapseUserName;

    var json = JSON.stringify(data);

    return PostListQuestionData(url, json);

    //$("#success" + id).html("<div class='alert alert-success'>Saved</div>");

    //$("#success" + id).show().delay(5000).queue(function (n) {
    //    $(this).hide(); n();
    //});





    //Do something if fail
    //$("#" + id).addClass("is-invalid");
    //$("#failure" + id).html("Something went wrong");
}

function postShortTextData(listQuestionID, questionID) {

    var val = $("#" + listQuestionID).val();

    //console.log('id:' + id + ' - val:' + val);

    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;
    data.question_id = questionID;
    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    data.valueshorttext = val;
    data._createdby = synapseUserName;
    //data.valuelongtext = "";
    //data.valuedate = "";
    //data.valueboolean = false;

    var json = JSON.stringify(data);

    return PostListQuestionData(url, json);

    //$("#success" + id).html("<div class='alert alert-success'>Saved</div>");

    //$("#success" + id).show().delay(5000).queue(function (n) {
    //    $(this).hide(); n();
    //});





    //Do something if fail
    //$("#" + id).addClass("is-invalid");
    //$("#failure" + id).html("Something went wrong");
}

function postLongTextData(listQuestionID, questionID) {

    var val = $("#" + listQuestionID).val();

    //console.log('id:' + id + ' - val:' + val);

    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;
    data.question_id = questionID;
    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    //data.valueshorttext = val;
    data.valuelongtext = val;
    data._createdby = synapseUserName;
    //data.valuedate = "";
    //data.valueboolean = false;

    var json = JSON.stringify(data);

    return PostListQuestionData(url, json);

    //$("#success" + id).html("<div class='alert alert-success'>Saved</div>");

    //$("#success" + id).show().delay(5000).queue(function (n) {
    //    $(this).hide(); n();
    //});





    //Do something if fail
    //$("#" + id).addClass("is-invalid");
    //$("#failure" + id).html("Something went wrong");
}

function postCalendarData(listQuestionID, questionID) {
    var val = $("#" + listQuestionID).val();

    if (!val == "") {
        val += "T00:00:00.000Z";
    }
    else {
        val = null;
    }



    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;
    data.question_id = questionID;
    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    //data.valueshorttext = val;
    //data.valuelongtext = "";
    data.valuedate = val;
    data._createdby = synapseUserName;
    //data.valueboolean = false;

    var json = JSON.stringify(data);

    return PostListQuestionData(url, json);
}

function postTimeData(id) {
    var val = $("#" + id).val();
    //console.log(pk + '-' + id + '-' + val);

}

function postRadioImageData(listQuestionID, val, questionID, options) {



    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.question_id = questionID;
    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;

    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    data.valueshorttext = val;
    //data.valuelongtext = val;
    //data.valuedate = "";
    //data.valueboolean = false;
    data._createdby = synapseUserName;

    var json = JSON.stringify(data);

    //console.log("json:" + json);


    //console.log("Val:" + val);


    $('#fg' + listQuestionID).html("");

    var html = '<div class="row">' +  //Start Row
        '<div class="col-md-12">'; //Start Column


    for (var i = 0; i < options.length; i++) {
        var obj = options[i];
        html += "<label>";
        html += "<input type='radio' name='" + questionID + "' value='" + obj.optionvaluetext + "'";
        //console.log("Post:" + obj.optionvaluetext + ":" + val);
        //console.log('Selcted: ' + obj.optionflag + " - Unselected: " + obj.optionflagalt);
        if (obj.optionvaluetext == val) {
            //console.log('Match: ' + obj.optionflag);
            html += " checked='checked' ";
            html += " />";
            html += '<div>' + obj.optionflag + '</div>';
        }
        else {
            //console.log('No Match: ' + obj.optionflagalt);
            html += " />";
            html += '<div>' + obj.optionflagalt + '</div>';
        }


        html += "</label>";
    }

    html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button id="btnClear' + listQuestionID + '" class=" btn-secondary btn-sm pull-right">Clear</button>' +

        '</div>' + //End Column

        '</div>' + //End Row

        '<div class="valid-feedback" id="success' + listQuestionID + '"></div>' +
        '<div class="invalid-feedback"  id="failure' + listQuestionID + '"></div>'


    $('#fg' + listQuestionID).html(html);

    $('input[name="' + questionID + '"]:radio').change(function () {
        //console.log("id:" + id);
        //console.log("question_id:" + questionID);
        //console.log("value:" + this.value);




        postRadioImageData(listQuestionID, this.value, questionID, options);
    });


    $("#btnClear" + listQuestionID).click(function () {
        postRadioImageData(listQuestionID, "", questionID, options);
    });

    return PostListQuestionData(url, json);
}


function postRadioData(listQuestionID, val, questionID) {

    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.question_id = questionID;
    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;

    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    data.valueshorttext = val;
    //data.valuelongtext = val;
    //data.valuedate = "";
    //data.valueboolean = false;
    data._createdby = synapseUserName;

    var json = JSON.stringify(data);

    console.log("json:" + json);


    return PostListQuestionData(url, json);
}


function postSelectData(listQuestionID, options, questionID) {
    //console.log(options);

    //console.log('postSelectData');
    //console.log('-------------------------------');
    //console.log('id:' + listQuestionID);
    //console.log('options:' + options);
    //console.log('questionID:' + questionID);


    var val = $("#" + listQuestionID).val();

    //console.log("val:" + val);

    var widget = getWidgetFromArray(val, options);

    $("#selectWidget" + listQuestionID).html(widget);


    //console.log(pk + '-' + listQuestionID + '-' + val);

    var url = 'PostObject?synapsenamespace=core&synapseentityname=listquestionvalue';

    var data = new Object();

    data.question_id = questionID;
    data.listquestionvalue_id = questionID + "|" + contextValue;
    data.listquestion_id = listQuestionID;

    data.list_id = listID;
    data.contextfield = contextField;
    data.contextvalue = contextValue;
    data.valueshorttext = val;
    //data.valuelongtext = val;
    //data.valuedate = "";
    //data.valueboolean = false;
    data._createdby = synapseUserName;

    var json = JSON.stringify(data);

    console.log("json:" + json);


    return PostListQuestionData(url, json);






}

function getWidgetFromArray(val, json) {
    //console.log(json);
    //console.log(val);
    var ret = "";
    for (var i in json) {
        if (json[i].optionvaluetext === val) {
            ret = json[i].optionflag;
        }
    }
    return ret;
}

function postCheckListBoxData(listQuestionID, questionID) {
    //console.log(options);
    var val = $("#" + listQuestionID).val();

    var checkboxValues = [];


    //console.log(pk + '-' + listQuestionID + '-' + val);

    $("input[name='opt" + listQuestionID + "']:checked").each(function () {
        checkboxValues.push(this.value);
    });


    var values = checkboxValues.toString(); //Output Format: 1,2,3

    //console.log(values);

}
