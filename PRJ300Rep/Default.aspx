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
                        <asp:TextBox ID="tbxTimeout" runat="server"></asp:TextBox>
                        <asp:Button ID="continue" OnClick="continue_Click" runat="server" class="btn btn-success" Text="Continue" />
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
                        <asp:ListBox ID="lbxSessionlist" runat="server" OnSelectedIndexChanged="lbxSessionlist_SelectedIndexChanged" DataSourceID="SqlDataSource1" DataTextField="sessionCode" DataValueField="sessionCode"></asp:ListBox>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:FestivalFriendFinderConnectionString %>" SelectCommand="SELECT s.sessionCode FROM Sessions AS s INNER JOIN Groups AS g ON s.[groupID] = g.[Id] INNER JOIN userGroups AS ug ON ug.[GroupID] = g.[Id] WHERE ug.UserID = @user">
                            <SelectParameters>
                                <asp:CookieParameter CookieName="UserId" DefaultValue="null" Name="user" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Literal ID="ListSessions" runat="server"></asp:Literal>



                    </div>
                    <asp:Button ID="codeSubmit" OnClick="codeSubmit_Click" class="btn btn-success" runat="server" Text="Join Your Group!" />
                </div>

            </div>

        </div>
    </div>
</asp:Content>
