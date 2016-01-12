<%-- The following 4 lines are ASP.NET directives needed when using SharePoint components --%>

<%@ Page Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" MasterPageFile="~masterurl/default.master" Language="C#" %>

<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%-- The markup and script in the following Content element will be placed in the <head> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <script type="text/javascript" src="../Lib/jquery-1.11.3/jquery-1.11.3.js"></script>
    <SharePoint:ScriptLink name="sp.js" runat="server" OnDemand="true" LoadAfterUI="true" Localizable="false" />
    <meta name="WebPartPageExpansion" content="full" />

    <!-- Add your CSS styles to the following file -->
    <link rel="Stylesheet" type="text/css" href="../Content/App.css" />

    <!-- Add your JavaScript to the following file -->
    <script type="text/javascript" src="../Scripts/App.js"></script>
    
    <!-- font-awesome -->
    <link rel="stylesheet" href="../Lib/font-awsome-4.5.0/css/font-awesome.css">
    <!-- testing o365-icons.css -->
    <link rel="Stylesheet" type="text/css" href="../Lib/o365-icons/o365-icons.css" />
    <!-- Bootstrap Glyphicon -->
    <link rel="Stylesheet" type="text/css" href="../Lib/bootstrap-3.3.6/css/bootstrap-glyphicons-only.css" />
    <!-- ionIcons -->
    <link rel="Stylesheet" type="text/css" href="../Lib/ionicons-2.0.1/css/ionicons.css" />
    
    <!-- Tile.css -->
    <link rel="stylesheet" href="../Content/Tile.css">

    <style>
       .containerBox {
            padding: 0 13px;
            margin-bottom: 10px;
            background: #EEE;
            border: 4px solid #DDD;
        }
        .containerBox > h2 {
            text-align: left;
            padding: 5px 0 5px;
            border-bottom: 4px solid #ddd;
            margin-bottom: 10px;
        }
        .containerBox > div {
            margin-bottom: 10px;
        }
        .settingContainerBox {
            display: inline-block;
            vertical-align: top;
        }
        .PLSetting {
            margin-bottom: 7px;
        }
    </style>
    <script>
        $(document).ready(function () {
            //Generate Tiles
            refreshPreview();


            //setting_OverallWidth
            $.ajax({
                url: "../_api/web/lists/getByTitle('Settings')/items?$select=Value&$filter=Key eq 'OverallWidth'&top=1",
                contentType: "application/json;odata=verbose;",
                headers: { "accept": "application/json;odata=verbose;" },
                success: function (data) {
                    $('#setting_OverallWidth textarea').val(data.d.results[0].Value);
                    //TODO: need keyup/keydown functionality here
                    $('#setting_OverallWidth textarea').keyup(function () {
                        $('#setting_OverallWidth .setting_action_save').show();
                        $('#setting_OverallWidth .setting_action_saved').hide();
                    });
                    $('#setting_OverallWidth .setting_action_save').keyup(function () {
                        $('#setting_OverallWidth .setting_action_save').hide();
                        $('#setting_OverallWidth .setting_action_saved').show();
                    });
                },
                error: function (err) {
                    console.error(err);
                    $('#setting_OverallWidth .setting_action_save').hide();
                    $('#setting_OverallWidth textarea').css('background-color', '#F00');
                    alert('Failed to load Overall Width Data');
                }
            });
        })

        function refreshPreview() {
            //Set Overall Width
            $.ajax({
                url: "../_api/web/lists/getByTitle('Settings')/items?$select=Value&$filter=Key eq 'OverallWidth'&top=1",
                contentType: "application/json;odata=verbose;",
                headers: { "accept": "application/json;odata=verbose;" },
                success: function (data) {
                    $('#webpartMain').width(data.d.results[0].Value);
                },
                error: function (err) {
                    console.error(err);
                    alert('Failed to load Overall Width Data');
                }
            });
            //Get Tiles
            $.ajax({
                url: "../_api/web/lists/getByTitle('Promoted Links 2.0')/items?$orderBy=TileOrder",
                contentType: "application/json;odata=verbose;",
                headers: { "accept": "application/json;odata=verbose;" },
                success: function (data) {
                    $.each(data.d.results, function (index, value) {

                        var HTML_a = '<a></a>';

                        switch (value.LaunchBehavior) {
                            case "In page navigation":
                                HTML_a = $(HTML_a).attr('href', value.LinkLocation.Url);
                                break;
                            case "Dialog":
                                HTML_a = $(HTML_a).attr('href', value.LinkLocation.Url);
                                break;
                            case "New Tab":
                                HTML_a = $(HTML_a).attr('href', value.LinkLocation.Url).attr('target', '_blank');
                                break;
                        }

                        //PLItem Structure
                        HTML_a = $(HTML_a).html('<li class="PLItem"><div class="PLOverlay"><div class="PLTitle"></div><div class="PLDescription"></div></div></li>')

                        //TileWidth
                        HTML_a = $(HTML_a).children().width(value.Width).parent();

                        //TileHeight
                        HTML_a = $(HTML_a).children().height(value.Height).parent();

                        //BackgroundImageType, IconPath, BackgroundImage
                        if (value.BackgroundImageType == 'Icon') {
                            var iconLib = value.IconPath.substring(0, value.IconPath.indexOf('-'))
                            HTML_a = $(HTML_a).children().addClass('PLIcon ' + iconLib + ' ' + value.IconPath).parent()
                        }
                        else if (value.BackgroundImageType == 'Image') {
                            HTML_a = $(HTML_a).children().addClass('PLImg').prepend('<img src="' + value.BackgroundImage.Url + '" />').parent()
                        }

                        //IconSize
                        HTML_a = $(HTML_a).children().css('font-size', value.IconSize).parent();

                        //IconColor
                        HTML_a = $(HTML_a).children().css('color', value.IconColor).parent();

                        //BackgroundColor
                        HTML_a = $(HTML_a).children().css('background-color', value.BackgroundColor).parent();

                        //Title
                        HTML_a = $(HTML_a).find('.PLTitle').prepend(value.Title).closest('a');

                        //Description
                        if (value.Description) {
                            HTML_a = $(HTML_a).find('.PLDescription').html(value.Description.replace(/\n/g, "<br/>")).closest('a')
                        }


                        /*
                        <a href="#">
                            <li class="PLItem PLIcon fa fa-stop-circle-o">
                                <div class="PLOverlay">
                                    Hello<span> - descriptiong here</span>
                                </div>
                            </li>
                        </a>
                        */


                        $('#webpartMain').append(HTML_a);
                    });
                }
            });
        }
    </script>
</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Promo Links 2.0
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div class="containerBox">
        <h2>Preview</h2>
        <div>
            <ul id="webpartMain" class="PLul"></ul>
        </div>
    </div>
    <div class="containerBox settingContainerBox" style="width:500px">
        <h2>Tile Configuration</h2>
        <div>
            <ul class="PLul">
	            <a href="../Lists/PromotedLinks2.0/NewForm.aspx?Source=../../Pages/Default.aspx">
		            <li class="PLItem PLIcon fa fa-plus" style="width: 150px; height: 150px; font-size: 100px; color: #ffffff; background-color: rgb(140, 143, 247);">
			            <div class="PLOverlay">
				            <div class="PLTitle">New Tile</div>
				            <div class="PLDescription">Add a new tile to your collection</div>
			            </div>
		            </li>
	            </a>
	            <a href="../Lists/PromotedLinks2.0">
		            <li class="PLItem PLIcon fa fa-list" style="width: 150px; height: 150px; font-size: 100px; color: #ffffff; background-color: rgb(140, 143, 247);">
			            <div class="PLOverlay">
				            <div class="PLTitle">Modify Tiles</div>
				            <div class="PLDescription">Add, Modify, Delete Tiles</div>
			            </div>
		            </li>
	            </a>
	            <a href="Icons.aspx">
		            <li class="PLItem PLIcon fa fa-search" style="width: 150px; height: 150px; font-size: 100px; color: #ffffff; background-color: rgb(140, 143, 247);">
			            <div class="PLOverlay">
				            <div class="PLTitle">Explorer Icons</div>
				            <div class="PLDescription">Click here to search for an icon you like.</div>
			            </div>
		            </li>
	            </a>
            </ul>
        </div>
    </div>
    <div class="containerBox settingContainerBox" style="min-width:450px">
        <h2>Settings</h2>
        <div style="text-align:right">
            <div id="setting_OverallWidth" class="PLSetting" title="Overall Width is the conainter width of all your tiles. If you have more tiles than the overall width. It will start stacking your tiles in the next line.">
                <span>Overall Width</span>
                <span><textarea cols="40" rows="2"></textarea></span>
                <span>
                    <button type="button" class="setting_action_save" style="display:none"><i class="fa fa-floppy-o"></i></button>
                    <button type="button" class="setting_action_saved"><i class="fa fa-check-circle"></i></button>
                </span>
            </div>
        </div>
    </div>
    <div>
        <p id="message">
            <!-- The following content will be replaced with the user name when you run the app - see App.js -->
            initializing...
        </p>
    </div>
    <a href="../Lists/PromotedLinks2.0">PromoLinks2.0 List</a>
    <br />
    <a href="../Lists/PromotedLinks2.0/NewForm.aspx">New Item PromoLinks2.0</a>
    <br />
    <a href="../Lists/Settings">PromoLinks2.0 Settings</a>
    <br />
    <a href="../Pages/PromoLinks2Webpart.aspx">Webpart Page</a>
    <br />
    <br />
</asp:Content>
