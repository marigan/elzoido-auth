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

angular.module('elzoido.auth').factory 'elzoidoAuthUser', ($rootScope, $injector, elzoidoAuth) ->
  # guest user
  guest =
    name: 'Guest'
    roles: ['guest']
  # helper method
  currentUserHasRoles = (roles) ->
    not _.isEmpty(_.intersection(currentUser.roles, roles.split(',')))
  changeUser = (user) ->
    _.merge(user,
      isGuest: ->
        currentUserHasRoles('guest')
      isAdmin: ->
        currentUserHasRoles('admin')
      hasRoles: (roles) ->
        currentUserHasRoles(roles))
  # default user
  currentUser = changeUser(guest)
  # listening for the signin event
  $rootScope.$on 'event:elzoido_auth_signin', (event) ->
    # trying to signin and getting personal data
    $injector.get(elzoidoAuth.config.userProvider).profile (data) ->
      # set current user
      currentUser = changeUser(data.user)
      # fire event
      $rootScope.$broadcast 'event:elzoido_auth_user'
  # listening for the signout
  $rootScope.$on 'event:elzoido_auth_signout', (event) ->
    # set current user
    currentUser = guest
  # check for autosignin
  $rootScope.$broadcast 'event:elzoido_auth_signin' if elzoidoAuth.config.autoSignin
  # return user
  get: ->
    currentUser