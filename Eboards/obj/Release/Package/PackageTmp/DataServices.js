function GetData(service, params) {

    var serviceURL = GlobalServiceURL;

    //Get Request Information
    var service = service;
    var params = params;
    var uri = serviceURL + service + params;


    //return $.getJSON({
    //    dataType: "json",
    //    url: encodeURI(uri)
    //});

    return serverRequest(service, params, "GET", null);
}

function serverRequest(service, params, type, data) {
    console.log("in server request")
        ;    var serviceURL = GlobalServiceURL;

    //Get Request Information
    var uri = serviceURL + service + params;

    return jQuery.ajax({
        beforeSend: function (request) {
            request.setRequestHeader("Authorization", 'Bearer ');
        },
        data: data,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        url: encodeURI(uri),
        type: type
    });

}
function DeleteData(service, params) {

    var serviceURL = GlobalServiceURL;

    //Get Request Information
    var service = service;
    var params = params;
    var uri = serviceURL + service + params;


    return jQuery.ajax({
        dataType: "json",
        url: encodeURI(uri),
        type: 'DELETE',
        success: function (result) {
            // Do something with the result
        }
    });
}

function PostData(service, params, data) {

    var serviceURL = GlobalServiceURL;

    //Get Request Information
    var service = service;
    var params = params;
    var uri = serviceURL + service + params;

    return jQuery.ajax({
        data: data,
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        url: encodeURI(uri),
        type: 'POST',
        success: function (result) {
            // Do something with the result
        }
    });
}


//---------------------------------------------------------------------------------
//Patient attributes
//---------------------------------------------------------------------------------

function GetCOFRecord(encounterID) {
    var service = "GetObjectWithInsert?synapsenamespace=local&synapseentityname=cof_record&synapseattributename=encounter_id&attributevalue=" + encounterID + "&keyvalue=" + encounterID;
    var params = "";
    return GetData(service, params);
}


function GetEncounterAttendanceOutcomeValues(encounterID) {
    //var service = "GetCOFAttendanceStatuses";
    //var params = "/" + encounterID;
    //return GetData(service, params);
}

function GetPatientBanner(encounterID) {
    var service = "GetBaseViewListObjectByAttribute/cof_patientbannerfinal?synapseattributename=encounter_id&attributevalue=";
    var params = encounterID;
    return GetData(service, params);
}

function GetCOFAppointmentHistoryByEncounterID(encounterID) {
    var service = "GetBaseViewListByAttribute/cof_opappointmenthistory?synapseattributename=encounter_id&attributevalue=";
    var params = encounterID;
    return GetData(service, params);
}

function GetTaskHistoryByTaskID(COFAdminTaskId) {
    var service = "GetListByAttribute?synapsenamespace=local&synapseentityname=cof_admintaskhistory&synapseattributename=cof_admintask_id&attributevalue=";
    var params = COFAdminTaskId;
    return GetData(service, params);
}



function GetRiskFlagsByPersonID(personID) {
    var service = "GetListByAttribute?synapsenamespace=local&synapseentityname=cof_personrisk&synapseattributename=person_id&attributevalue=";
    var params = personID;
    return GetData(service, params);
}


function GetCOFAppointmentHistoryByPersonID(personID) {
    var service = "GetBaseViewListByAttribute/cof_opappointmenthistory?synapseattributename=person_id&attributevalue=";
    var params = personID;
    return GetData(service, params);
}


function GetCOFTreatmentsByEncounterID(encounterID) {
    var service = "GetListByAttribute?synapsenamespace=local&synapseentityname=cof_treatment&synapseattributename=encounter_id&attributevalue=";
    var params = encounterID;
    return GetData(service, params);
}


function GetCOFAppointmentsByEncounterID(encounterID) {
    var service = "GetBaseViewListByAttribute/cof_appointmentswithlookups?synapseattributename=encounter_id&attributevalue=";
    var params = encounterID;
    return GetData(service, params);
}


function GetCOFAdminTasksByCOFAdminTaskID(COFAdminTaskID) {
    var service = "GetObject?synapsenamespace=local&synapseentityname=cof_admintask&id=";
    var params = COFAdminTaskID;
    return GetData(service, params);
}


function DeleteCOFTreatmentByCOFRecordId(cofRecordId) {
    var service = "DeleteObjectByAttribute?synapsenamespace=local&synapseentityname=cof_treatment&synapseattributename=cof_record_id&attributevalue=";
    var params = cofRecordId;
    return DeleteData(service, params);
}


function DeleteCOFAppointmentsByCOFRecordId(cofRecordId) {
    var service = "DeleteObjectByAttribute?synapsenamespace=local&synapseentityname=cof_appointment&synapseattributename=cof_record_id&attributevalue=";
    var params = cofRecordId;
    return DeleteData(service, params);
}


function DeleteAllActiveAdminTasksById(cofRecordId) {
    var service = "DeleteObjectByAttribute?synapsenamespace=local&synapseentityname=cof_admintask&synapseattributename=cof_record_id&attributevalue=";
    var params = cofRecordId;
    return DeleteData(service, params);
}

function DeleteHL7MessagesByCoFRecordID(cof_record_id) {
    var service = "DeleteObjectByAttribute?synapsenamespace=local&synapseentityname=cof_hl7messaging&synapseattributename=cof_record_id&attributevalue=";
    var params = cof_record_id;
    return DeleteData(service, params);
}



//---------------------------------------------------------------------------------
//Lookups
//---------------------------------------------------------------------------------

function GetClinicOutcomeValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupclinicoutcome&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetCOFRiskFlagsValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupriskflag&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetDischargeReasonValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupdischargereason&orderby=orderby";
    var params = "";
    return GetData(service, params);
}


function GetAttendanceStatusValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupappointmentattendstatus&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetAttendanceOutcomeValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupattendanceoutcome&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetDecisionsToTreatValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupdecisiontotreatreason&orderby=orderby";
    var params = "";
    return GetData(service, params);
}


function GetAppointmentTypeValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupappointmenttype&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetInactiveRTTValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupinactivertt&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetAppointmentReasonValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupappointmentreason&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetAppointmentPeriodValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupnextappointment&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetWeeksMonths() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupscheduleperriod&orderby=orderby";
    var params = "";
    return GetData(service, params);
}


function GetAppointmentPriorityValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupappointmentpriority&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetRTTPathwayTypeValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookuprttpathwaytype&orderby=description";
    var params = "";
    return GetData(service, params);
}

function GetGeneralValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupgeneral&orderby=description";
    var params = "";
    return GetData(service, params);
}

function GetSystemAttributes() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_systemattributes&orderby=attributename";
    var params = "";
    return GetData(service, params);
}

function GetProcedureValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupprocedure&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetLateralityValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookuplaterality&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetSiteValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupsite&orderby=orderby";
    var params = "";
    return GetData(service, params);
}


function GetSubTypeName() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_subtype&orderby=subtypename";
    var params = "";
    return GetData(service, params);
}

function GetTaskAttendanceMappingValues() {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookuptaskattendancemapping&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetNextAppointmentScheduleValues(skipDisabled) {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupnextappointment&orderby=orderby";
    var params = "";
    return GetData(service, params);
}

function GetAppointmentCanBeWithValues(skipDisabled) {
    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookupappointmentassignedto&orderby=orderby";
    var params = "";
    return GetData(service, params);
}





//Work List Functions

function GetAllAppointments() {
    var service = "GetBaseViewList/cof_cofappointmentlist";
    var params = "";
    return GetData(service, params);
}


function GetAllTasks() {

    var service = "GetBaseViewList/cof_admintasklist";
    var params = "";
    return GetData(service, params);
}


function GetAllMessages() {

    var service = "GetList?synapsenamespace=local&synapseentityname=cof_hl7messaging";
    var params = "";
    return GetData(service, params);
}


function DeleteCOFTreatmentsByTreatmentID(treatmentID) {
    var service = "DeleteObject?synapsenamespace=local&synapseentityname=cof_treatment&id=";
    var params = treatmentID;
    return DeleteData(service, params);
}

function DeleteCOFAppointmentsByAppointmentID(appointmentID) {
    var service = "DeleteObject?synapsenamespace=local&synapseentityname=cof_appointment&id=";
    var params = appointmentID;
    return DeleteData(service, params);
}

//function GetSpecialtiesByDateRange(startDate, endDate)
//{
//    var service = "GetSpecialtiesByDateRange";
//    var params = "/" + startDate + "/" + endDate;
//    return GetData(service, params);
//}


//function GetSpecialtiesByDate(selectedDate) {
//    var service = "GetSpecialtiesByDate";
//    var params = "/" + selectedDate;
//    return GetData(service, params);
//}

//function GetAdminListByDateRangeAndCounsultant(startDate, endDate, consultant) {
//    var service = "GetAdminListByDateRangeAndCounsultant";
//    var params = "/" + startDate + "/" + endDate + "/" + consultant;
//    return GetData(service, params);
//}

function GetConsultantsByDateRangeAndSpecialty(params, data) {
    //console.log("data:" + data);
    var service = "GetBaseViewListByPost/cof_cofappointmentlist";
    return PostData(service, params, data);
}

//function GetConsultantsByDateRange(startDate, endDate) {
//    var service = "GetConsultantsByDateRange";
//    var params = "/" + startDate + "/" + endDate;
//    return GetData(service, params);
//}

//function GetClinicsByDateRangeAndConsultantCode(startDate, endDate, consultant)
//{
//    var service = "GetClinicsByDateRangeAndConsultantCode";
//    var params = "/" + startDate + "/" + endDate + "/" + consultant;
//    return GetData(service, params);
//}


//function GetClinicsByDateRange(startDate, endDate) {
//    var service = "GetClinicsByDateRange";
//    var params = "/" + startDate + "/" + endDate;
//    return GetData(service, params);
//}

//function GetAdminListByDateRangeAndTaskType(startDate, endDate, taskType) {
//    var service = "GetAdminListByDateRangeAndTaskType";
//    var params = "/" + startDate + "/" + endDate + "/" + taskType;
//    return GetData(service, params);
//}

//function GetAdminListByPatientMRN(hospitalNumber) {
//    var service = "GetAdminListByPatientMRN";
//    var params = "/" + hospitalNumber;
//    return GetData(service, params);
//}


//function GetOverDueCOFFormsByConsultantClinicCodeAndDateRange(consultant, clinic, startDate, endDate)
//{
//    var service = "GetOverDueCOFFormsByConsultantClinicCodeAndDateRange";
//    var params = "/" + consultant + "/" + clinic + "/" + startDate + "/" + endDate;
//    return GetData(service, params);
//}

//function GetOverDueCOFFormsByDateRange(startDate, endDate) {
//    var service = "GetOverDueCOFFormsByDateRange";
//    var params = "/" + startDate + "/" + endDate;
//    return GetData(service, params);
//}

//function GetConsultantsByDate(date)
//{
//    var service = "GetConsultantsByDate";
//    var params = "/" + date;
//    return GetData(service, params);
//}


function GetClinicsByDateAndConsultant(params, data) {
    var service = "GetBaseViewListByPost/cof_cofappointmentlist";
    return PostData(service, params, data);
}

function GetAppointmentsList(params, data) {
    var service = "GetBaseViewListByPost/cof_cofappointmentlist";
    return PostData(service, params, data);
}




function GetTaskListByPost(params, data) {
    var service = "GetBaseViewListByPost/cof_admintasklist";
    return PostData(service, params, data);
}

function GetIncorrectRTTReportByPost(params, data) {
    var service = "GetBaseViewListByPost/cof_incorrectrttreport";
    return PostData(service, params, data);
}






function GetTaskTypes() {

    var service = "GetList?synapsenamespace=local&synapseentityname=cof_lookuptaskattendancemapping";
    var params = "";
    return GetData(service, params);
}



//    function CreateTCIRequestTask(encounterId, assignedTo) {
//        var service = "CreateTCIRequestTask";
//        var params = "/" + encounterId + "/" + assignedTo;
//        return GetData(service, params);
//    }