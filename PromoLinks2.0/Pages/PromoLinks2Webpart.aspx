
<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<WebPartPages:AllowFraming ID="AllowFraming" runat="server" />

<html>
<head>
    <title></title>

    <script type="text/javascript" src="../Lib/jquery-1.11.3/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    
    <!-- font-awesome -->
    <link rel="stylesheet" href="../Lib/font-awsome-4.5.0/css/font-awesome.css">
    <!-- o365icons -->
    <link rel="stylesheet" href="../Lib/o365-icons/o365-icons.css">
    <!-- Bootstrap Glyphicon -->
    <link rel="Stylesheet" type="text/css" href="../Lib/bootstrap-3.3.6/css/bootstrap-glyphicons-only.css" />
    <!-- ionIcons -->
    <link rel="Stylesheet" type="text/css" href="../Lib/ionicons-2.0.1/css/ionicons.css" />

    <!-- Tile.css -->
    <link rel="stylesheet" href="../Content/Tile.css">

    <script type="text/javascript">
        // Set the style of the client web part page to be consistent with the host web.
        (function () {
            'use strict';

            var hostUrl = '';
            if (document.URL.indexOf('?') != -1) {
                var params = document.URL.split('?')[1].split('&');
                for (var i = 0; i < params.length; i++) {
                    var p = decodeURIComponent(params[i]);
                    if (/^SPHostUrl=/i.test(p)) {
                        hostUrl = p.split('=')[1];
                        document.write('<link rel="stylesheet" href="' + hostUrl + '/_layouts/15/defaultcss.ashx" />');
                        break;
                    }
                }
            }
            if (hostUrl == '') {
                document.write('<link rel="stylesheet" href="/_layouts/15/1033/styles/themable/corev15.css" />');
            }
        })();

    </script>
    <script>
        //resize
        resizeIFrame('300px', '100%');
        $(document).ready(function () {
            //init resize
            var height = jQuery('#webpartMain').outerHeight(true);
            var width = "100%";
            resizeIFrame(height,width);
            
            //Generate Tiles 
            refreshPreview();

            //resize
            resizeIFrame($('#webpartMain').outerHeight(true), '100%');
        });

        function resizeIFrame(height, width) {
            if (!window.parent)
                return;
            var senderId = decodeURIComponent(getQueryStringParameter("SenderId"));
            var message = "<Message senderId=" + senderId + " >"
                    + "resize(" + width + "," + height + ")</Message>";
            parent.postMessage(message, '*');
        }

        function getQueryStringParameter(param) {
            if (document.URL.split("?").length > 1) {
                var params = document.URL.split("?")[1].split("&");
                var strParams = "";
                for (var i = 0; i < params.length; i = i + 1) {
                    var singleParam = params[i].split("=");
                    if (singleParam[0] == param) {
                        return singleParam[1];
                    }
                }
            }
            return null;
        }

        //example openDialog({url: "https://beetea-d230574feadda0.sharepoint.com/PromoLinks20/Pages/PromoLinks2Webpart.aspx"})
        function openDialog(options) {
            //default option settings
            if (!(options.height)) {
                options.height = window.innerHeight * .75;
            }
            if (!(options.width)) {
                options.width = window.innerWidth * .75;
            }
            if (!(options.allowMaximize)) {
                options.allowMaximize = true;
            }

            /*// Example of options
            options = {
                height: window.innerHeight * .75,
                width: window.innerWidth * .75,
                url: "https://beetea-d230574feadda0.sharepoint.com/PromoLinks20/Pages/PromoLinks2Webpart.aspx",
                allowMaximize: true
            }
            //*/
            SP.SOD.execute('sp.ui.dialog.js', 'SP.UI.ModalDialog.showModalDialog', options);
            //SP.UI.ModalDialog.showModalDialog(options);
        }

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

                        /*// use this script in default.aspx. to replace href with edit tile links. (Otherwise comment this out)
                        HTML_a = $(HTML_a).attr('href', '../Lists/PromotedLinks2.0/EditForm.aspx?ID=' + value.ID + '&Source=../../Pages/Default.aspx').attr('target', '_blank');
                        //*/

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
</head>
<body>
    <!-- Example
    <ul id="webpartMain">
        <a href="#">
            <li class="PLItem PLIcon fa fa-stop-circle-o">
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLImg">
                <img src="../Images/AppIcon.png" />
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLImg">
                <img src="../Images/AppIcon.png" />
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLIcon fa fa-stop-circle-o">
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLIcon fa fa-stop-circle-o">
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLImg">
                <img src="../Images/AppIcon.png" />
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLIcon fa fa-stop-circle-o">
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
        <a href="#">
            <li class="PLItem PLImg">
                <img src="../Images/AppIcon.png" />
                <div class="PLOverlay">
                    Hello<span> - descriptiong here</span>
                </div>
            </li>
        </a>
    </ul>-->
    <ul id="webpartMain" class="PLul"></ul>
</body>
</html>
