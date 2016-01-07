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

    <!-- testing o365-icons.css -->
    <link rel="Stylesheet" type="text/css" href="../Lib/o365-icons/o365-icons.css" />

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
    </style>
</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Page Title
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div class="containerBox">
        <h2>HELLO :)</h2>
        <div>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer commodo egestas ligula a malesuada. Nullam at tincidunt orci, ut posuere mi. Aliquam egestas enim id massa faucibus, sed facilisis justo cursus. Donec ultrices nibh id fermentum vehicula. Sed dictum nulla elit, eu ultrices lacus hendrerit nec. Fusce neque lectus, iaculis vel velit ut, cursus vulputate massa. Maecenas id magna ut urna condimentum pharetra.

Mauris massa ipsum, rhoncus at luctus sed, commodo eu sapien. Praesent tristique ultrices lacus nec hendrerit. Praesent quis urna et turpis lacinia mollis. Vestibulum tincidunt accumsan lectus vel consectetur. Nunc purus arcu, volutpat ac lacus a, interdum bibendum ex. Donec feugiat consectetur ipsum non consequat. Maecenas sit amet mattis elit. Vestibulum vitae turpis non ipsum dictum rutrum ac in nisl. Donec sit amet dolor id massa fringilla molestie non fringilla odio. Aenean varius enim arcu, sit amet sagittis felis ornare vel. Nullam pulvinar ipsum eu ultrices cursus. Sed ultrices ac purus nec elementum. Aliquam auctor sagittis libero. Aliquam tellus tortor, laoreet at risus vitae, fringilla rutrum risus.

Maecenas venenatis aliquam purus, sit amet tempor sapien. Nullam aliquam nibh eget nibh tincidunt dapibus. Nam et semper nisi. Fusce vitae purus scelerisque, volutpat diam et, viverra risus. Nulla eget turpis vestibulum, ultrices sapien a, ultricies felis. Donec nisi ex, feugiat eu elementum vitae, porta in nisi. Integer quis rhoncus nisi. In luctus urna neque, in tempor ligula vulputate id. Sed luctus est ut lacus efficitur hendrerit. Fusce a quam augue. Donec a nisi sodales, iaculis justo ac, pulvinar nisl. Fusce dignissim vestibulum malesuada. Vivamus at finibus est. Nulla id ante eu velit commodo vehicula. Duis fermentum nibh dictum tortor suscipit viverra.
        </div>
    </div>
    <div>
        <p id="message">
            <!-- The following content will be replaced with the user name when you run the app - see App.js -->
            initializing...
        </p>
    </div>
    <a href="../Lists/PromotedLinks2.0">PromoLinks2.0</a>
    <br />
    <a href="../Lists/PromotedLinks2.0/NewForm.aspx">New Item PromoLinks2.0</a>
    <br />
    <a href="../Pages/PromoLinks2Webpart.aspx">webpart</a>

    <i class="o365i o365i-outlook"></i>
</asp:Content>
