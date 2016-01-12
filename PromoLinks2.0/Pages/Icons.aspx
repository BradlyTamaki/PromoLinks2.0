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
    <!-- Bootstrap Glyphicon -->
    <link rel="Stylesheet" type="text/css" href="../Lib/bootstrap-3.3.6/css/bootstrap-glyphicons-only.css" />
    <!-- ionIcons -->
    <link rel="Stylesheet" type="text/css" href="../Lib/ionicons-2.0.1/css/ionicons.css" />
    
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
        .iconSearch {
            width: 100%;
            border: 0;
            font-size: 21px;
            padding: 3px 10px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            -webkit-box-sizing: border-box;
        }
        .iconInfo {
            float: right;
            margin-top: 3px;
            color: #484848 !important;
            font-size: 1.3em;
        }
        .selectedIcon-tdicon {
            background-color: #ddd;
            font-size: 8em;
            padding: 15px;
        }
        selectedIcon-tdclassName {
            padding-left:15px;
        }

        .selectedIcon-tdicon > i{
            margin:0;
            padding:5px;
        }
        .icons {
            padding: 2px;
            cursor: pointer;
            font-size: 2em;
        }
        .icons.selected {
            background-color: rgba(0, 114, 198, 0.76);
        }
    </style>

    <!-- ng -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.5/angular.js"></script>
    <script type="text/javascript">
        angular.module("ngApp", [])
        .controller("mainCtrl", function ($scope, $http, $anchorScroll, $location) {
            $scope.icons = [];
            $http.get('../Lib/icon-list.json.txt').then(function (results) {
                $scope.icons = results.data;
                console.log($scope);
            });

            $scope.selectedIcon;
            $scope.selectIcon = function (selected, iconSet) {
                $scope.selectedIcon = {className: selected, set: iconSet};
                $location.hash('DeltaPlaceHolderMain');
                $anchorScroll();
            }
        })
    </script>
</asp:Content>

<%-- The markup in the following Content element will be placed in the TitleArea of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderPageTitleInTitleArea" runat="server">
    Explorer Icons
</asp:Content>

<%-- The markup and script in the following Content element will be placed in the <body> of the page --%>
<asp:Content ContentPlaceHolderID="PlaceHolderMain" runat="server">
    <div ng-app="ngApp" ng-controller="mainCtrl">
        <div class="containerBox">
            <h2>Search for Icons!</h2>
            <div><input class="iconSearch" ng-model="search" /></div>
            <h2 ng-show="selectedIcon.className" id="selectedIcon-h2">Selected Icon</h2>
            <div ng-show="selectedIcon.className" class="selectedIcon">
                <table>
                    <tr>
                        <td class="selectedIcon-tdicon"><i class="{{selectedIcon.set}} {{selectedIcon.className}}"></i></td>
                        <td class="selectedIcon-tdclassName"><h1>{{selectedIcon.className}}</h1></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="containerBox" ng-repeat="iconGroup in icons">
            <a class="iconInfo" ng-href="{{iconGroup.url}}" target="_blank"><i class="fa fa-info-circle"></i></a>
            <h2>{{iconGroup.packageName}} ({{iconGroup.icons.length}})</h2>
            <div>
                <i ng-repeat="icon in iconGroup.icons | filter:search"
                    ng-click="selectIcon(icon.className, iconGroup.class)"
                    ng-class="{'selected': selectedIcon.className == icon.className}"
                    class="icons {{iconGroup.class}} {{icon.className}}"
                    title="{{icon.className}}"
                    style="margin:5px"></i>
            </div>
        </div>
    </div>
</asp:Content>
