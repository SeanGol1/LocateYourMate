<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PRJ300Rep._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="StyleSheet1.css" rel="stylesheet" />
    <script>



        $(document).ready(function (e) {

            $("#Create").on("click", function () {
                /*$("#createCode").animate({				
                    height: '+= 250px',
                    width: '+= 350px',
                },"slow").show();*/

                $("#createCode").show();
            });

            $("#Join").click(function () {
                $("#enterLink").show();
            });
        });

        //https://developers.facebook.com/docs/javascript/quickstart
        window.fbAsyncInit = function () {
            FB.init({
                appId: '450204495362227',
                autoLogAppEvents: true,
                xfbml: true,
                version: 'v2.8'
            });
            //FB.AppEvents.logPageView();

            /*FB.getLoginStatus(function(response) {
                statusChangeCallback(response);
            });*/
            FB.getLoginStatus(function (response) {
                if (response.status == 'connected') {
                    console.log('Logged in.');
                }
                else {
                    FB.login();
                }
            });
        };

        (function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) { return; }
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
    <div id="divBackground">
        <div id="Content">
            <h1 class="Jumbotron">Festival Friend Finder </h1>
            <p>Welcome to festival friend finder.<br />
                Creating a group will begin a session.<br />
                You will recieve a code.
                <br />
                Then click join group.
                <br />
                You and your friends pop in the code.
                <br />
                Begin Partying.<br />
                THAT EASY!</p>

            <div class="row">
                <div class="col-md-6">
                    <div id="createCode">
                        <h2 id="Create" class="jumbotron">Create Group</h2>
                        <p>Set Timeout (Hours):</p>
                        <input id="timeout" type="datetime" />
                        <a id="continue" class="btn btn-success">Continue</a>
                    </div>


                </div>
                <div class="col-md-6">
                    <div id="enterLink">
                        <h2 id="Join" class="jumbotron">Join Group</h2>
                        <p>Enter 6 Digit Pin:</p>
                        <input id="code" type="text" placeholder="Enter 6-Digit Code" />
                        <button id="codeSubmit"  class="btn btn-success">Join Your Group!</button>
                    </div>
                </div>

            </div>

        </div>
    </div>
</asp:Content>
