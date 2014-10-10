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

angular.module('elzoido.auth', []).constant 'elzoidoAuthModule',
  install: ($httpProvider) ->
    # register auth interceptor to handle requests
    $httpProvider.responseInterceptors.push ['$q', '$rootScope', ($q, $rootScope) ->
      success = (response) ->
        # return response
        response
      error = (response) ->
        # handle response
        if response.status is 401
          # fire unauthenticated event
          $rootScope.$broadcast "event:elzoido-auth-unauthenticated", response.status
          # reject respone
          $q.reject response
        else if response.status is 403
          # fire unauthorized event
          $rootScope.$broadcast "event:elzoido-auth-unauthorized", response.status
          # reject respone
          $q.reject response
        else
          # fire unauthorized event
          $rootScope.$broadcast "event:elzoido-auth-error", response.status
          # reject respone
          $q.reject response
      (promise) ->
        promise.then success, error
    ]
  # all those need to be implemented in the application
  config:
    userProvider: null
    pathProfile: null
    functionSignin: null
    functionSignout: null