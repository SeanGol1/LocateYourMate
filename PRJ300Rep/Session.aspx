<%@ Page Title="Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Session.aspx.cs" Inherits="PRJ300Rep.Session" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Styles/StyleSheetSession.css" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>



   <script>

		// Google Maps
	  var map, infoWindow;
	  function initMap() {
		map = new google.maps.Map(document.getElementById('map'), {
		  center: {lat: -34.397, lng: 150.644},
		  zoom: 12
		});
		infoWindow = new google.maps.InfoWindow;
	  }
	  
	  
	  // Get current Location
	  
	  if(navigator.geolocation) {
		  navigator.geolocation.getCurrentPosition(function(position) {
			var pos = {
			  lat: position.coords.latitude,
			  lng: position.coords.longitude
			};

			infoWindow.setPosition(pos);
			infoWindow.setContent('Your Location');
			infoWindow.open(map);
			map.setCenter(pos);
		  }, function() {
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
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD9pJLBoZZ0LrasUlwgXgyXcTVepaAwPn0&callback=initMap"
	async defer></script>

    
    <h2><%: Title %>.</h2>



    <h1>Festival Friend Finder</h1>
    <asp:Label ID="Label1" runat="server" Text="Your Session Code:"></asp:Label>
    <asp:Label ID="tbxCode" runat="server" Text="Label"></asp:Label>
<div id="map"></div>

	
	<div id="list">
    
	<h3>List of Members in the Session</h3>
	<div id="memberList">
	<table>
	
	<tr>
	<th>Name</th>
	<th></th>	
	</tr>
	
	<tr>
	<td id="pname"></td>
	</tr>
		
	
	</table>
	
	</div>
	<a id="leave" class="btn btn-danger" href="Index.html">Leave Session</a>
	</div>
	<script>
//https://developers.facebook.com/docs/javascript/quickstart
  window.fbAsyncInit = function() {
	FB.init({
	  appId            : '720598181452614',
	  autoLogAppEvents : true,
	  xfbml            : true,
	  version          : 'v2.9'
	});
	FB.AppEvents.logPageView();
	FB.ui(
 {
  method: 'share',
  href: 'https://developers.facebook.com/docs/'
}, function(response){});
  };

  (function(d, s, id){
	 var js, fjs = d.getElementsByTagName(s)[0];
	 if (d.getElementById(id)) {return;}
	 js = d.createElement(s); js.id = id;
	 js.src = "//connect.facebook.net/en_US/sdk.js";
	 fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
</script>



</asp:Content>
