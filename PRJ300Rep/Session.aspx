<%@ Page Title="Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Session.aspx.cs" Inherits="PRJ300Rep.Session" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <script type="text/javascript" src="js/bootstrap.min.js"></script>
    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js%22%3E"></script>--%>
    <%--<script src="Scripts/jquery-3.1.1.min.js"></script>--%>
    <link href="Styles/StyleSheetSession.css" rel="stylesheet" />
    <style>
        #map {
            height: 600px;
            width: 70%;
            float: left;
        }
    </style>
    <script>

        var ipAddress = "";
        var User = '<%=CurrentUser%>';
        var Users = new Array();
        Users = JSON.parse('<%=JSArray%>');
        var Markers = new Array();
        Markers = JSON.parse('<%=JSMarkerArray%>');
        var pos = {};

        // Google Maps
        var map, infoWindow;
        function initMap() {

            var theCookies = document.cookie.split(';');
            var mapcenter = '';
            var mapzoom = '';
            /*for (var i = 1 ; i <= theCookies.length; i++) {
                aString += i + ' ' + theCookies[i - 1] + "\n";
                mapcenter = theCookies[i];
                mapzoom = theCookies[i]
            }*/
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: -34.397, lng: 150.644 },
                zoom: 16
            });
            infoWindow = new google.maps.InfoWindow;
        }

        // Get current Location

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {

                //get the position of the client user
                pos = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };


                infoWindow.setPosition(pos);
                infoWindow.setContent('Your Location');
                infoWindow.open(map);
                map.setCenter(pos);

               /* var markericon = {
                    url: 'Images/dancer.png',
                    scaledSize: new google.maps.Size(40, 40),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(15, 40),
                    labelOrigin: new google.maps.Point(17, 50)
                }

                var centericon = {
                    url: 'Images/currentposition.png',
                    scaledSize: new google.maps.Size(20, 20),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(15, 40),
                    labelOrigin: new google.maps.Point(17, 50)
                }



                var currentposition = {
                    url: 'Images/currentposition.png',
                    scaledSize: new google.maps.Size(40, 40),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(15, 40),
                    labelOrigin: new google.maps.Point(17, 50)
                }*/

                $(document).ready(function () {
                    //Create Marker Icons
                    var stage = {
                        url: 'Images/dj.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }

                    //Stop modal from firing if map if dragged
                    google.maps.event.addListener(map, 'dragend', function () {
                        $('#modalPlaceMarker').on('shown.bs.modal', function (e) {
                            e.stopPropagation();
                        });
                    });

                    //Read all markers and display
                    for (var i = 0; i < Markers.length; i++) {                        
                            latLng = new google.maps.LatLng(Markers[i].Lat, Markers[i].Lng);
                            var marker = new google.maps.Marker({
                                position: latLng,
                                visible: true,
                                icon: Markers[i].type
                            });
                            marker.setMap(map);
                    }

                    /*
                        [BUG REPORT]
                        THIS EVENT FIRES FOR EVERY CLICK THAT WAS PREVIOSLY CLICKED ON THE MAP. 
                        EVENTS STORING IN ARRAY AND RUNNING THROUGH THEM ALL.
                    */



                    google.maps.event.addListener(map, "click", function (event) {
                        placeMarker(event.latLng);
                    });


                    function placeMarker(location) {

                        $('#Stageiconmodal').one("click", function () {                         

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: stage
                            });

                            marker.setMap(map);
                            $("#hdnlatStage").val(location.lat);
                            $("#hdnlngStage").val(location.lng);

                        });

                        $('#TentIconmodal').one("click", function () {

                            var Tenticon = {
                                url: 'Images/event-tent.png',
                                scaledSize: new google.maps.Size(40, 40),
                                origin: new google.maps.Point(0, 0),
                                anchor: new google.maps.Point(15, 40),
                                labelOrigin: new google.maps.Point(17, 50)
                            }

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: Tenticon
                            });

                            marker.setMap(map);
                        });
                        $('#Starticonmodal').one("click", function () {

                            var Start = {
                                url: 'Images/start.png',
                                scaledSize: new google.maps.Size(40, 40),
                                origin: new google.maps.Point(0, 0),
                                anchor: new google.maps.Point(15, 40),
                                labelOrigin: new google.maps.Point(17, 50),
                                label: {
                                    text: 'Start',
                                    color: '#000000',
                                    fontsize: '20px',
                                    fontweight: 'bold'
                                },
                            }

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: Start
                            });

                            marker.setMap(map);
                        });
                        $('#FinishIconmodal').one("click", function () {

                            var Finish = {
                                url: 'Images/start.png',
                                scaledSize: new google.maps.Size(40, 40),
                                origin: new google.maps.Point(0, 0),
                                anchor: new google.maps.Point(15, 40),
                                labelOrigin: new google.maps.Point(17, 50),
                                label: {
                                    text: 'Finish',
                                    color: '#000000',
                                    fontsize: '20px',
                                    fontweight: 'bold'
                                },
                            }

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: Finish
                            });

                            marker.setMap(map);
                        });
                        $('#cariconmodal').one("click", function () {


                            var Car = {
                                url: 'Images/car.png',
                                scaledSize: new google.maps.Size(40, 40),
                                origin: new google.maps.Point(0, 0),
                                anchor: new google.maps.Point(15, 40),
                                labelOrigin: new google.maps.Point(17, 50)
                            }

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: Car
                            });

                            marker.setMap(map);
                        });
                        $('#cabinIconmodal').one("click", function () {

                            var Cabin = {
                                url: 'Images/cabin.png',
                                scaledSize: new google.maps.Size(40, 40),
                                origin: new google.maps.Point(0, 0),
                                anchor: new google.maps.Point(15, 40),
                                labelOrigin: new google.maps.Point(17, 50)
                            }

                            var marker = new google.maps.Marker({
                                position: location,
                                //map: map,
                                animation: google.maps.Animation.DROP,
                                icon: cabin
                            });

                            marker.setMap(map);
                        });
                    }
                });

                /*setInterval(function () {     

                    var marker = new google.maps.Marker({
                        icon: centericon,
                        position: map.getCenter(),
                        visible: true                        
                    });
                    marker.setMap(null);
                    marker.setMap(map);

                }, 100);*/

                for (var i = 0; i < Users.length; i++) {
                    if (Users[i].Username != User) {
                        latLng = new google.maps.LatLng(Users[i].Lat, Users[i].Lng);
                        var marker = new google.maps.Marker({
                            position: latLng,
                            title: Users[i].Username,
                            //animation: google.maps.Animation.DROP,
                            label: {
                                text: Users[i].Username,
                                color: '#000000',
                                fontsize: '20px',
                                fontweight: 'bold'
                            },
                            visible: true,
                            icon: markericon
                        });

                        marker.setMap(map);
                    }
                    else {

                    }
                }
                var center = map.getCenter();
                var zoom = map.getZoom();
                document.cookie = "MapPosition= " + center + "; MapZoom= " + zoom + ";";

                setInterval(function () {
                    if ($('.modal').hasClass('in')) {
                    }
                    else {
                        $("#mainForm").submit();
                    }
                }, 10000);


            }, function () {
                handleLocationError(true, infoWindow, map.getCenter());
            });
        } else {
            // Browser doesn't support Geolocation
            handleLocationError(false, infoWindow, map.getCenter());
        }
        function handleLocationError(browserHasGeolocation, infoWindow, pos) {
            infoWindow.setPosition(pos);
            infoWindow.setContent(browserHasGeolocation ?
                'Error: The Geolocation service failed.' :
                'Error: Your browser doesn\'t support geolocation.');
            infoWindow.open(map);
        }


        /*document.getElementById("TentIcon").addEventListener("click", TentMarker, false);
        function TentMarker() {
            var marker = new google.maps.Marker({
                icon: homeicon,
                position: map.getCenter(),
                visible: true
            });
            marker.setMap(map);
        }*/


        $(document).ready(function () {

            var adminID = '<%=adminID%>';
            for (var i = 0; i < Users.length; i++) {
                if (adminID == Users[i]) {
                    $(UserList).append('<li class="list-group-item"><span class="glyphicon glyphicon-asterisk"></span>' + Users[i].Username + '</li>');
                }
                else {
                    $(UserList).append('<li class="list-group-item">' + Users[i].Username + '</li>');
                }
            }
            <%--

            //set timer to submit form
            setInterval(function () {
                //save location in a hidden field 
                if (pos.lat != null && pos.lng != null) {
                    $("#hdnLat").val(pos.lat);
                    $("#hdnLng").val(pos.lng);
                }
                /*$("#hdnLat").serialize();
                $("#hdnLng").serialize();*/
                document.getElementById("mainForm").submit();
            }, 5000);
            --%>

            /* $("#markers").click(function () {
                 $('#modalMarker').modal('toggle');
             });*/

        });

    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD9pJLBoZZ0LrasUlwgXgyXcTVepaAwPn0&callback=initMap"
        async defer></script>
    <div id="divBackground">
        <div class="container" id="content">
            <div class="row">
                <h1 class="heading">Locate Your Mate!</h1>
            </div>

            <div class="row">

                <div id="wrapper" style="position: relative">
                    <div id="map" class="col-lg-8" style="z-index: 1;" data-toggle="modal" data-target="#modalPlaceMarker">
                    </div>
                    <div id="centerimg" style="position: absolute; z-index: 99;">
                        <img src="Images/currentposition.png" style="max-height: 10%; display: block; margin: auto; position: absolute;" />
                    </div>
                </div>

                <div id="list" class="col-lg-4">
                    <div>
                        <asp:Label ID="Label1" runat="server" CssClass="textFont label" Text="Your Session Code:"></asp:Label>
                        <asp:Label ID="tbxCode" runat="server" CssClass="label" Text=""></asp:Label>
                    </div>
                    <p class="textFont">List of Members in the Session</p>
                    <ul id="UserList" class="list-group textFont">
                        <!--List is populated in Javascript -->
                    </ul>
                    <asp:Button ID="leave" runat="server" Text="Leave Session" class="btn btn-danger" OnClick="leave_Click" />
                    <asp:Button ID="Close" runat="server" Text="Close Session" class="btn btn-danger" OnClick="Close_Click" />
                    <br />
                    <div id="markers" class="btn btn-success" data-toggle="modal" data-target="#modalMarker">Markers</div>
                </div>
            </div>
        </div>
    </div>
    <div id="formdata">
        <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngStage" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatStage" runat="server" ClientIDMode="Static"></asp:HiddenField>
    </div>

    <div id="modalMarker" class="modal fade" role="dialog">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Markers</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div style="text-align: center;">
                        <ul id="legendListl" class="list-group" style="list-style-type: none;">
                            <li><a id="Stageiconl" class="list-group-item">
                                <img src="Images/dj.png" alt="dj" width="30" height="30" />
                                - Stage Area </a></li>
                            <li><a id="TentIconl" class="list-group-item">
                                <img src="Images/event-tent.png" alt="tent" width="30" height="30" />
                                - Tent </a></li>
                            <li><a id="Starticonl" class="list-group-item">
                                <img src="Images/start.png" alt="start" width="30" height="30" />
                                - Start </a></li>
                            <li><a id="FinishIconl" class="list-group-item">
                                <img src="Images/start.png" alt="finish" width="30" height="30" />
                                - Finish </a></li>
                            <li><a id="cariconl" class="list-group-item">
                                <img src="Images/car.png" alt="car" width="30" height="30" />
                                - Car </a></li>
                            <li><a id="cabinIconl" class="list-group-item">
                                <img src="Images/cabin.png" alt="cabin" width="30" height="30" />
                                - Cabin </a></li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="modalPlaceMarker" class="modal fade" role="dialog">
        <div class="modal-dialog modal-md">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">Markers</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div style="text-align: center;">
                        <ul id="legendListmodal" class="list-group" style="list-style-type: none;">
                            <li><a id="Stageiconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/dj.png" alt="dj" width="30" height="30" />
                                - Stage Area </a></li>
                            <li><a id="TentIconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/event-tent.png" alt="tent" width="30" height="30" />
                                - Tent </a></li>
                            <li><a id="Starticonmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/start.png" alt="start" width="30" height="30" />
                                - Start </a></li>
                            <li><a id="FinishIconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/start.png" alt="finish" width="30" height="30" />
                                - Finish </a></li>
                            <li><a id="cariconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/car.png" alt="car" width="30" height="30" />
                                - Car </a></li>
                            <li><a id="cabinIconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/cabin.png" alt="cabin" width="30" height="30" />
                                - Cabin </a></li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>




    <script>
        ////https://developers.facebook.com/docs/javascript/quickstart
        //  window.fbAsyncInit = function() {
        //	FB.init({
        //	  appId            : '720598181452614',
        //	  autoLogAppEvents : true,
        //	  xfbml            : true,
        //	  version          : 'v2.9'
        //	});
        //	FB.AppEvents.logPageView();
        //	FB.ui(
        // {
        //  method: 'share',
        //  href: 'https://developers.facebook.com/docs/'
        //}, function(response){});
        //  };

        //  (function(d, s, id){
        //	 var js, fjs = d.getElementsByTagName(s)[0];
        //	 if (d.getElementById(id)) {return;}
        //	 js = d.createElement(s); js.id = id;
        //	 js.src = "//connect.facebook.net/en_US/sdk.js";
        //	 fjs.parentNode.insertBefore(js, fjs);
        //   }(document, 'script', 'facebook-jssdk'));
    </script>


    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AzureConnectionString %>" SelectCommand="Select UserId from userGroups as ug Inner Join Groups as g on ug.groupID = g.Id Inner Join Sessions as s on  s.groupID = g.Id Where SessionCode = @code">
        <SelectParameters>
            <asp:QueryStringParameter Name="code" QueryStringField="SessionCode" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
