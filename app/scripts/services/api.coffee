# Copyright (C) 2014 marigan.net
#
# This file is part of elzoido-auth.
#
# elzoido-auth is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# elzoido-auth is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with elzoido-auth. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@marigan.net>

angular.module('elzoido.auth').factory 'elzoidoAuthAPI', ($rootScope, $injector, elzoidoAuthModule, elzoidoAuthUser) ->
  # signin API function
  signin: ->
    elzoidoAuthModule.config.functionSignin().then ->
      # fire event
      $rootScope.$broadcast 'event:elzoido-auth-signin'
      # update user directive
      elzoidoAuthUser.signin()
  # signout API function
  signout: ->
    elzoidoAuthModule.config.functionSignout().then ->
      # fire event
      $rootScope.$broadcast 'event:elzoido-auth-signout'
      # update user directive
      elzoidoAuthUser.signout()