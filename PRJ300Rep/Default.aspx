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


            //MODAL SETTINGS
            $('#HowToModal').modal('toggle');

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
                            <div style="text-align:center;">
                                <h2><strong>Welcome to Festival Friend Finder.</strong></h2><br />
                                <h4><strong>Want to create a new group?</strong></h4>
                                <p>Clicking on <strong>Create a Group</strong> will begin a session.</p>
                                <p>(Optional to enter a timeout to set when the connection will end)</p>
                                <p>You will recieve a code that you can give to others to join your group easily.</p><br />
                                <h4><strong>Recieved a code from a friend?</strong></h4>
                                <p>Simply pop it into the box that says <strong>Enter 6-Digit Code</strong> </p>
                                <p>and click on <strong>Join Your Group</strong> to join your friends </p><br />
                                <h4><strong>ReJoining a group you were already part of?</strong></h4>
                                <p>Choose the Session number from the box below the 6 digit pin and click <strong>Join Your Group!</strong> button. </p>   <br />                     
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
                    <div id="createCode">
                        <h2 id="Create" class="jumbotron">Create Group</h2>
                        <p>Set Timeout (Hours):</p>
                        <asp:TextBox ID="tbxTimeout" runat="server" placeholder="Defaults to 24 hours"></asp:TextBox>
                        <asp:Button ID="continue" OnClick="continue_Click" runat="server" class="btn btn-success" Text="Create a Group" />
                    </div>
                </div>
                <div class="col-md-6">
                    <div id="enterLink">
                        <h2 id="Join" class="jumbotron">Join Group</h2>
                        <p>Enter 6 Digit Pin:</p>
                        <asp:TextBox ID="inputcode" placeholder="Enter 6-Digit Code" runat="server"></asp:TextBox>

                    </div>
                    <div id="SessionsList">
                        <h2>Already part of a group?</h2>
                        <asp:ListBox ID="lbxSessionlist" runat="server" OnSelectedIndexChanged="lbxSessionlist_SelectedIndexChanged" DataSourceID="SqlDataSource1" DataTextField="sessionCode" DataValueField="sessionCode" AutoPostBack="True"></asp:ListBox>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings: AzureConnectionString %>" SelectCommand="SELECT s.sessionCode FROM Sessions AS s INNER JOIN Groups AS g ON s.[groupID] = g.[Id] INNER JOIN userGroups AS ug ON ug.[GroupID] = g.[Id] WHERE ug.UserID = @user">
                            <SelectParameters>
                                <asp:CookieParameter CookieName="UserId" DefaultValue="null" Name="user" />
                            </SelectParameters>
                        </asp:SqlDataSource>



                    </div>
                    <asp:Button ID="codeSubmit" OnClick="codeSubmit_Click" class="btn btn-success" runat="server" Text="Join Your Group!" />
                    <asp:HiddenField ID="HdnLat" runat="server" />
                    <asp:HiddenField ID="HdnLng" runat="server" />
                </div>

            </div>

        </div>
    </div>
</asp:Content>
