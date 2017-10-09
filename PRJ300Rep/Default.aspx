<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="PRJ300Rep._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="StyleSheet1.css" rel="stylesheet" />
    <script> 
        //set to only show on first load
        $(document).one('ready', function () {
            //MODAL SETTINGS
            $('#HowToModal').modal('toggle');
        });

        $(document).ready(function (e) {
           
            //take array from c# and display in list 
            var list = eval('[<% =string.Join(", ", SessionCodes) %>]');
            var i = 0;
            for (var i = 0; i < list.length; i++) {
                //set href to redirect to page with the chosen code
                $('#SessionsList').append("<a href='Session.aspx?SessionCode=" + list[i] + "' class='list-group-item'>" + list[i] + "</a>");
            }


        });

        //https://developers.facebook.com/docs/javascript/quickstart  facebook login
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
        <div class="container" id="Content">

            <!------------ MODAL TUTORIAL ------------>
            <div id="HowToModal" class="modal fade" role="dialog">
                <div class="modal-dialog modal-md">

                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">How To Connect</h4>
                        </div>
                        <div class="modal-body">
                            <div style="text-align: center;">
                                <h2><strong>Welcome to Festival Friend Finder.</strong></h2>
                                <br />
                                <h4><strong>Want to create a new group?</strong></h4>
                                <p>Clicking on the <strong>Create a Group</strong> button will begin a session.</p>
                                <p>(Optional to enter a timeout to set when the connection will end)</p>
                                <p>You will recieve a code that you can give to others to join your group easily.</p>
                                <br />
                                <h4><strong>Received a code from a friend?</strong></h4>
                                <p>Simply pop it into the box that says <strong>Enter 6-Digit Code</strong> </p>
                                <p>and click on the <strong>Join Your Group</strong> button to join your friends. </p>
                                <br />
                                <h4><strong>Re-Joining a group you were already part of?</strong></h4>
                                <p>If you are already part of a session(s), they should appear on the screen in a listbox</p>
                                <p>Simply click on your session listed by the <strong>Session Code</strong></p>
                                <br />
                                <h3>THAT EASY!</h3>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-success" data-dismiss="modal">Get Started</button>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-md-6">
                    <div id="createCode" class="form-group" style="text-align: center; align-content: center;">
                        <h2 id="Create" class="jumbotron">Create Group</h2>
                        <p>Set Timeout (Hours):</p>
                        <asp:TextBox ID="tbxTimeout" CssClass="form-control input-lg" runat="server" placeholder="Defaults to 24 hours"></asp:TextBox>
                    </div>

                    <asp:Button ID="continue" OnClick="continue_Click" runat="server" class="btn btn-success btn-lg" Text="Create a Group" />

                </div>
                <div class="col-md-6">
                    <div id="enterLink" class="form-group" style="text-align: center; align-content: center;">
                        <h2 id="Join" class="jumbotron">Join Group</h2>
                        <p>Enter 6 Digit Pin:</p>
                        <asp:TextBox ID="inputcode" CssClass="form-control input-lg" placeholder="Enter 6-Digit Code" runat="server"></asp:TextBox>

                    </div>

                    <asp:Button ID="codeSubmit" OnClick="codeSubmit_Click" class="btn btn-success btn-lg" runat="server" Text="Join Your Group!" />

                    <div>
                        <h2>Already part of a group?</h2>

                        <div id="SessionsList" class="list-group">
                            <!--list is populated in javacript tag -->
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
