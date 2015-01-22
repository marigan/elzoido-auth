/**
 * @license
 * elzoido-auth 0.3.0
 * (c) 2015 marigan.net
 * License: GPL-3.0+
 */
angular.module("elzoido.auth",[]).constant("elzoidoAuthModule",{config:{userProvider:null,providersProvider:null,functionProfile:null,functionSignin:null,functionSignout:null}}),angular.module("elzoido.auth").run(["$templateCache",function(e){e.put("partials/user.html",'<!--\n# Copyright (C) 2014 marigan.net\n#\n# This file is part of elzoido-auth.\n#\n# elzoido-auth is free software: you can redistribute it and/or modify\n# it under the terms of the GNU General Public License as published by\n# the Free Software Foundation, either version 3 of the License, or\n# (at your option) any later version.\n#\n# elzoido-auth is distributed in the hope that it will be useful,\n# but WITHOUT ANY WARRANTY; without even the implied warranty of\n# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n# GNU General Public License for more details.\n#\n# You should have received a copy of the GNU General Public License\n# along with elzoido-auth. If not, see <http://www.gnu.org/licenses/>.\n#\n# Authors: Michal Mocnak <michal@marigan.net>\n-->\n\n<li class="dropdown">\n    <a ng-show="user.isGuest()" href="#" class="dropdown-toggle" data-toggle="dropdown">Sign In <span class="fa fa-sign-in"></span></a>\n    <ul ng-show="user.isGuest()" class="dropdown-menu">\n        <li ng-repeat="provider in providers">\n            <a href="#" ng-click="signin(provider)"><span class="fa fa-{{icon(provider)}}"></span> {{provider | elzoidoAuthCapitalize}}</a>\n        </li>\n    </ul>\n\n    <a ng-hide="user.isGuest()" href="#" class="dropdown-toggle" data-toggle="dropdown">\n        <span class="fa fa-user"></span>\n        <span class="left-buffer-10">{{user.name}}</span>\n        <span class="caret"></span>\n    </a>\n    <ul ng-hide="user.isGuest()" class="dropdown-menu">\n        <li><a href="#" ng-click="profile()"><span class="fa fa-wrench"></span> Profile</a></li>\n        <li><a href="#" ng-click="signout()"><span class="fa fa-sign-out"></span> Sign Out</a></li>\n    </ul>\n</li>')}]),angular.module("elzoido.auth").directive("elzoidoAuthAccess",["$animate","elzoidoAuthUser",function(e,n){return{restrict:"A",scope:{roles:"@elzoidoAuthAccess"},link:function(o,t){var r;return r=function(){return _.isUndefined(o.roles)?void 0:e[n.get().hasRoles(o.roles)||_.isEmpty(o.roles)?"removeClass":"addClass"](t,"ng-hide")},r(),o.$on("event:elzoido-auth-user",function(){return r()})}}}]),angular.module("elzoido.auth").directive("elzoidoAuthUser",function(){return{restrict:"A",transclude:!0,scope:{},controller:["$scope","$rootScope","$injector","elzoidoAuthModule","elzoidoAuthUser","elzoidoAuthAPI",function(e,n,o,t,r,i){return e.user=r.get(),o.get(t.config.providersProvider).providers(function(n){return e.providers=n.providers}),e.signin=function(e){return i.signin(e)},e.signout=function(){return i.signout()},e.profile=function(){return t.config.functionProfile()},e.icon=function(e){return _.isEqual(e,"developer")?"user":e},n.$on("event:elzoido-auth-user",function(){return e.user=r.get()})}],templateUrl:"partials/user.html",replace:!1}}),angular.module("elzoido.auth").filter("elzoidoAuthCapitalize",function(){return function(e){return e.charAt(0).toUpperCase()+e.substr(1).toLowerCase()}}),angular.module("elzoido.auth").factory("elzoidoAuthAPI",["$rootScope","$injector","elzoidoAuthModule","elzoidoAuthUser",function(e,n,o,t){return{signin:function(n){return o.config.functionSignin(n).then(function(){return e.$broadcast("event:elzoido-auth-signin"),t.signin()})},signout:function(){return o.config.functionSignout().then(function(){return e.$broadcast("event:elzoido-auth-signout"),t.signout()})}}}]),angular.module("elzoido.auth").factory("elzoidoAuthInterceptor",["$q","$rootScope",function(e,n){return{responseError:function(o){return 401===o.status?(n.$broadcast("event:elzoido-auth-unauthenticated",o.status),e.reject(o)):403===o.status?(n.$broadcast("event:elzoido-auth-unauthorized",o.status),e.reject(o)):(n.$broadcast("event:elzoido-auth-error",o.status),e.reject(o))}}}]),angular.module("elzoido.auth").factory("elzoidoAuthUser",["$rootScope","$injector","elzoidoAuthModule",function(e,n,o){var t,r,i,u;return u={name:"Guest",roles:["guest"]},i=function(e){return!_.isEmpty(_.intersection(r.roles,e.split(",")))},t=function(e){return _.merge(e,{isGuest:function(){return i("guest")},isAdmin:function(){return i("admin")},hasRoles:function(e){return i(e)}})},r=t(u),{get:function(){return r},signin:function(){return n.get(o.config.userProvider).profile(function(n){return r=t(n.user),e.$broadcast("event:elzoido-auth-user")})},signout:function(){return r=u}}}]);