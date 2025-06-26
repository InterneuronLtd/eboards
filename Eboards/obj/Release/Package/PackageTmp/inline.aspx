<%--BEGIN LICENSE BLOCK--%> 
<%--Interneuron Terminus

Copyright(C) 2025  Interneuron Limited

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.If not, see<http://www.gnu.org/licenses/>. --%>
<%--END LICENSE BLOCK--%> 
﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="inline.aspx.cs" Inherits="EBoards.inline" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <%--<link href="css/bootstrap-editable.css" rel="stylesheet" />    --%>
    
    <%--<link href="Content/datetimepicker.css" rel="stylesheet" />--%>
    <link href="Content/font-awesome.css" rel="stylesheet" />
    <%--<link href="Content/typeahead.js-bootstrap.css" rel="stylesheet" />--%>

    <script src="Scripts/jquery-3.0.0.js"></script>
    <%--<script src="Scripts/popper_bootstrap4.js"></script>--%>
    <script src="Scripts/bootstrap.js"></script>
    <%--<script src="js/bootstrap4-editable.js"></script>--%>
    
    <script src="js/twittertypeahead.js"></script>
    <script src="js/typeaheadjs.js"></script>

    <style>
        body {
            background: #F1F3FA;
        }

        #frm select {
            width: auto;
        }


        #user > tbody > tr > td {
            height: 45px;
            padding: 4px 8px;
        }

        .muted {
            color: #999999;
        }

        .notready {
            color: #999999;
            font-style: italic;
        }

        .editable-container {
            width: 400px !important;
        }

        .editable-input {
            width: 300px !important;
        }

        .editable-checklist div label {
            display: block;
            text-align: left;
        }

   input .tt-hint {
    display: none;
}

   /***
	TYPEAHEAD for MDB
	by djibe
***/

.typeahead {
    z-index: 1051;
}


/*If using icon span before input, like <i class="fa fa-asterisk prefix"></i>*/

span.twitter-typeahead {
    width: calc(100% - 3rem);
    margin-left: 3rem;
}


/* Aspect of the dropdown of results*/

.typeahead.dropdown-menu,
span.twitter-typeahead .tt-menu {
    min-width: 100%;
	background: white;
    /*as large as input*/
    border: none;
    box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .16), 0 2px 10px 0 rgba(0, 0, 0, .12);
    border-radius: 0;
    font-size: 1.2rem;
}


/*Aspect of results, done*/

span.twitter-typeahead .tt-suggestion {
    color: #4285F4;
    cursor: pointer;
    padding: 1rem;
    text-transform: capitalize;
    font-weight: 400;
}


/*Hover a result, done*/

span.twitter-typeahead .active.tt-suggestion,
span.twitter-typeahead .tt-suggestion.tt-cursor,
span.twitter-typeahead .active.tt-suggestion:focus,
span.twitter-typeahead .tt-suggestion.tt-cursor:focus,
span.twitter-typeahead .active.tt-suggestion:hover,
span.twitter-typeahead .tt-suggestion.tt-cursor:hover {
    background-color: #EEEEEE;
    color: #4285F4;
}

label.active {
    color: #4285F4 !important;
}
    </style>


    <script>
        $(document).ready(function () {

            //$('#sex').editable({
            //    prepend: "not selected",
            //    source: [
            //        { value: 1, text: 'Male' },
            //        { value: 2, text: 'Female' }
            //    ]
            //});

            //$('#username').editable({

            //});

            //$('#vacation').editable({
            //    datepicker: {
            //        todayBtn: 'linked'
            //    }
            //});

            //$('#comments').editable({
            //    showbuttons: 'bottom'
            //});

            //$('#fruits').editable({
            //    pk: 1,
            //    limit: 3,
            //    source: [
            //        { value: 1, text: 'banana' },
            //        { value: 2, text: 'peach' },
            //        { value: 3, text: 'apple' },
            //        { value: 4, text: 'watermelon' },
            //        { value: 5, text: 'orange' }
            //    ]
            //});


            //$('#state2').editable({
            //    value: 'California',
            //    typeahead: {
            //        name: 'state',
            //        local: ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Dakota", "North Carolina", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
            //    }
            //});


            //var substringMatcher = function (strs) {
            //    return function findMatches(q, cb) {
            //        var matches, substringRegex;

            //        // an array that will be populated with substring matches
            //        matches = [];

            //        // regex used to determine if a string contains the substring `q`
            //        substrRegex = new RegExp(q, 'i');

            //        // iterate through the pool of strings and for any string that
            //        // contains the substring `q`, add it to the `matches` array
            //        $.each(strs, function (i, str) {
            //            if (substrRegex.test(str)) {
            //                matches.push(str);
            //            }
            //        });

            //        cb(matches);
            //    };
            //};

            // Bootstrap 4 + MDB + typeahead label fix
            //Add class typeahead to your text input invoking typeahead
            $('.typeahead').on('focus', function () {
                $(this).parent().siblings().addClass('active');
            }).on('blur', function () {
                if (!$(this).val()) {
                    $(this).parent().siblings().removeClass('active');
                }
            });

            var states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
                'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii',
                'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana',
                'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota',
                'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire',
                'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota',
                'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island',
                'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
                'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
            ];

        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>


         <%--   <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <h4>Text Box</h4>
                        <a href="#" id="username" data-type="text" data-pk="1" data-title="Enter username">superuser</a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <h4>Drop Down</h4>
                        <a href="#" id="sex" data-type="select" data-pk="1" data-value="" data-title="Select sex"></a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <h4>Calendar</h4>
                        <a href="#" id="vacation" data-type="date" data-viewformat="dd/mm/yyyy" data-pk="1" data-placement="top" data-title="When you want vacation to start?">25.02.2013</a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <h4>Text Area</h4>
                        <a href="#" id="comments" data-type="textarea" data-pk="1" data-placeholder="Your comments here..." data-title="Enter comments">awesome user!</a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12">
                        <h4>Check List</h4>
                        <a href="#" id="fruits" data-type="checklist" data-value="2,3" data-title="Select fruits"></a>
                    </div>
                </div>


                <div class="row">
                    <div class="col-md-12">
                        <h4>Twitter typeahead</h4>
                        <a href="#" id="state2" data-type="typeaheadjs" data-pk="1" data-placement="right" data-title="Start typing State.."></a
                    </div>
                </div>

            </div>--%>



<div class="container-fluid">
    <div class="row">
        <div class="col">
            <div class="jumbotron">
                <h1>Bootstrap 4 with Material Design Bootstrap (MDB) and Twitter Typeahead
</h1>
                <p class="lead">by djibe (and Bassjobsen CSS).
                    <br>Complete doc here : <a href="https://github.com/twitter/typeahead.js" target="_blank">Github page of Twitter Typeahead</a>.</p>
                <div class="md-form mt-4" id="the-basics">
                    <i class="fa fa-asterisk prefix"></i>
                    <input type="text" class="form-control typeahead" id="medicament">
                    <label for="medicament" id="medicament-label">Médicament (DCI, nom) ...</label>
                </div>
            </div>
        </div>
    </div>
</div>

        </div>
    </form>
</body>
</html>
