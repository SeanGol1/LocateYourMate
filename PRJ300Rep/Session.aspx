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



                $(document).ready(function () {
                    //Create Marker Icons
                    var markericon = {
                        url: 'Images/dancer.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var stage = {
                        url: 'Images/dj.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var Tenticon = {
                        url: 'Images/event-tent.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var Start = {
                        url: 'Images/flag.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var Finish = {
                        url: 'Images/flag2.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var Car = {
                        url: 'Images/car.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }
                    var Cabin = {
                        url: 'Images/cabin.png',
                        scaledSize: new google.maps.Size(40, 40),
                        origin: new google.maps.Point(0, 0),
                        anchor: new google.maps.Point(15, 40),
                        labelOrigin: new google.maps.Point(17, 50)
                    }



                    ////Stop modal from firing if map is dragged [NOT WORKING]
                    google.maps.event.addListener(map, 'dragend', function () {
                        $('#modalPlaceMarker').on('shown.bs.modal', function (e) {
                            e.stopPropagation();
                        });
                    });

                    //populate the user list            
                    for (var i = 0; i < Users.length; i++) {
                        //Place star next to the admin user of the group [Stopped Working]
                        //if (<%=adminID%> == Users[i].Username) {                            
                        //  $(UserList).append('<li class="list-group-item"><span class="glyphicon glyphicon-asterisk"></span>' + Users[i].Username + '</li>');
                        //}
                        //else {
                        $(UserList).append('<li class="list-group-item">' + Users[i].Username + '</li>');
                        //}
                    }

                    //Read and display all users
                    for (var i = 0; i < Users.length; i++) {
                        if (Users[i].Username != User) {
                            latLng = new google.maps.LatLng(Users[i].Lat, Users[i].Lng);
                            var marker = new google.maps.Marker({
                                position: latLng,
                                title: Users[i].Username,
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

                    //Read and display all markers
                    for (var i = 0; i < Markers.length; i++) {
                        var latLngmarker = new google.maps.LatLng(Markers[i].Lat, Markers[i].Lng);
                        var icon = Markers[i].Type;
                        if (icon == "stage") {
                            icon = stage;
                        }
                        else if (icon == "tent") {
                            icon = Tenticon;
                        }
                        else if (icon == "start") {
                            icon = Start;
                        }
                        else if (icon == "finish") {
                            icon = Finish;
                        }
                        else if (icon == "car") {
                            icon = Car;
                        }
                        else if (icon == "cabin") {
                            icon = Cabin;
                        }



                        var newmarker = new google.maps.Marker({
                            position: latLngmarker,
                            visible: true,
                            icon: icon

                        });
                        newmarker.setMap(map);
                    }

                    //Send the Position the map was clicked for marker
                    var MarkerLocation = "";
                    google.maps.event.addListener(map, "click", function (event) {
                        MarkerLocation = event.latLng;

                    });

                    document.getElementById('Stageiconmodal').addEventListener("click", function () {
                        var stage = {
                            url: 'Images/dj.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: stage
                        });

                        marker.setMap(map);
                        $("#hdnlatStage").val(MarkerLocation.lat);
                        $("#hdnlngStage").val(MarkerLocation.lng);
                    })

                    document.getElementById('TentIconmodal').addEventListener("click", function () {

                        var Tenticon = {
                            url: 'Images/event-tent.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: Tenticon
                        });

                        marker.setMap(map);
                        $("#hdnlatTent").val(MarkerLocation.lat);
                        $("#hdnlngTent").val(MarkerLocation.lng);

                    })

                    document.getElementById('Starticonmodal').addEventListener("click", function () {

                        var Start = {
                            url: 'Images/flag.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: Start
                        });

                        marker.setMap(map);
                        $("#hdnlatStart").val(MarkerLocation.lat);
                        $("#hdnlngStart").val(MarkerLocation.lng);

                    })

                    document.getElementById('FinishIconmodal').addEventListener("click", function () {

                        var Finish = {
                            url: 'Images/flag2.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: Finish
                        });

                        marker.setMap(map);
                        $("#hdnlatFinish").val(MarkerLocation.lat);
                        $("#hdnlngFinish").val(MarkerLocation.lng);

                    })

                    document.getElementById('cariconmodal').addEventListener("click", function () {

                        var Car = {
                            url: 'Images/car.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: Car
                        });

                        marker.setMap(map);
                        $("#hdnlatCar").val(MarkerLocation.lat);
                        $("#hdnlngCar").val(MarkerLocation.lng);

                    })

                    document.getElementById('cabinIconmodal').addEventListener("click", function () {

                        var Cabin = {
                            url: 'Images/cabin.png',
                            scaledSize: new google.maps.Size(40, 40),
                            origin: new google.maps.Point(0, 0),
                            anchor: new google.maps.Point(15, 40),
                            labelOrigin: new google.maps.Point(17, 50)
                        }

                        var marker = new google.maps.Marker({
                            position: MarkerLocation,
                            animation: google.maps.Animation.DROP,
                            icon: Cabin
                        });

                        marker.setMap(map);
                        $("#hdnlatCabin").val(MarkerLocation.lat);
                        $("#hdnlngCabin").val(MarkerLocation.lng);

                    })

                    $("#Submit").click($("#mainForm").submit());
                    //reload page every 10 seconds
                    setInterval(function () {
                        //save location in a hidden field 
                        if (pos.lat != null && pos.lng != null) {
                            $("#hdnLat").val(pos.lat);
                            $("#hdnLng").val(pos.lng);
                        }

                        //do not load page if modal open (placing a marker)
                        if ($('.modal').hasClass('in')) {
                        }
                        else {
                            //submit form
                            $("#mainForm").submit();
                        }
                    }, 10000);
                });

                //NOT WORKING
                //Save window state when page refreshes
                var center = map.getCenter();
                var zoom = map.getZoom();
                //document.cookie = "MapPosition= " + center + "; MapZoom= " + zoom + ";";

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


    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD9CgROIinEHm9PTIqlc_7CUK2KZb2TZdQ&callback=initMap"
        async defer></script>
    <div id="divBackground">
        <div class="container" id="content">
            <div class="row">
                <h1 class="heading">Locate Your Mate!</h1>
            </div>

            <div class="row">

                <div id="wrapper" style="position: relative">
                    <div id="map" class="col-lg-8" data-toggle="modal" data-target="#modalPlaceMarker"></div>
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
                    <asp:Button ID="Submit" class="btn btn-primary" runat="server" Text="Refesh" />
                </div>
            </div>
        </div>
    </div>
    <div id="formdata">
        <asp:HiddenField ID="hdnLat" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnLng" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngStage" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatStage" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngTent" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatTent" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngStart" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatStart" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngFinish" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatFinish" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngCar" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatCar" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlngCabin" runat="server" ClientIDMode="Static"></asp:HiddenField>
        <asp:HiddenField ID="hdnlatCabin" runat="server" ClientIDMode="Static"></asp:HiddenField>
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
                        <h3>To place a marker simply click on the map in the postition of choice and choose from the list!</h3>
                        <ul id="legendListl" class="list-group" style="list-style-type: none;">
                            <li><a id="Stageiconl" class="list-group-item">
                                <img src="Images/dj.png" alt="dj" width="30" height="30" />
                                - Stage Area </a></li>
                            <li><a id="TentIconl" class="list-group-item">
                                <img src="Images/event-tent.png" alt="tent" width="30" height="30" />
                                - Tent </a></li>
                            <li><a id="Starticonl" class="list-group-item">
                                <img src="Images/flag.png" alt="start" width="30" height="30" />
                                - Start </a></li>
                            <li><a id="FinishIconl" class="list-group-item">
                                <img src="Images/flag2.png" alt="finish" width="30" height="30" />
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
                                <img src="Images/dj.png" alt="tent" width="30" height="30" />
                                - Stage Area </a></li>
                            <li><a id="TentIconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/event-tent.png" alt="tent" width="30" height="30" />
                                - Tent </a></li>
                            <li><a id="Starticonmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/flag.png" alt="start" width="30" height="30" />
                                - Start</a></li>
                            <li><a id="FinishIconmodal" data-dismiss="modal" class="list-group-item">
                                <img src="Images/flag2.png" alt="finish" width="30" height="30" />
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
