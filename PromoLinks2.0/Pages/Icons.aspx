<%-- The following 4 lines are ASP.NET directives needed when using SharePoint components --%>

<%@ Page Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" MasterPageFile="~masterurl/default.master" Language="C#" %>

<%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<%-- The markup and script in the following Content element will be placed in the <head> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderAdditionalPageHead" runat="server">
    <SharePoint:ScriptLink name="sp.js" runat="server" OnDemand="true" LoadAfterUI="true" Localizable="false" />
    <meta name="WebPartPageExpansion" content="full" />

    <!-- Add your CSS styles to the following file -->
    <link rel="Stylesheet" type="text/css" href="../Content/App.css" />

    <!-- o365-icons.css -->
    <link rel="Stylesheet" type="text/css" href="../Lib/o365-icons/o365-icons.css" />
    <!-- fontawsome.css -->
    <link rel="Stylesheet" type="text/css" href="../Lib/font-awsome-4.5.0/css/font-awesome.css" />

    <!-- ng -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.5/angular.js"></script>
    <script type="text/javascript">
        angular.module("ngApp", [])
        .controller("mainCtrl", function ($scope, $http) {
            $scope.icons = [];
            $http.get('../Lib/icon-list.json.txt').then(function (results) {
                $scope.icons = results.data;
            })
        })
    </script>
</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Page Title
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div ng-app="ngApp" ng-controller="mainCtrl">
        Search for an Icon: <input ng-model="search" />
        <span ng-repeat="iconGroup in icons">
            <i ng-repeat="icon in iconGroup.icons | filter:search" class="{{iconGroup.class}} {{iconGroup.class}}-2x {{icon.className}}" title=".{{icon.className}}" style="margin:5px"></i>
        </span>
    </div>
</asp:Content>
