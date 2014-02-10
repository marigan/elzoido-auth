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

angular.module('elzoido.auth').directive 'elzoidoAuthAccess', ($animate, elzoidoAuthUser) ->
  restrict: 'A'
  link: (scope, element, attr) ->
    # helper method
    animate = (value) ->
      $animate[if elzoidoAuthUser.get().hasRoles(value) then 'removeClass' else 'addClass'](element, 'ng-hide')

    # check for our directive and its value
    scope.$watch attr.elzoidoAuthAccess, ->
      # animate
      animate(attr.elzoidoAuthAccess) unless _.isUndefined(attr.elzoidoAuthAccess)

    # when user is logged in refresh directive
    scope.$on 'event:elzoido-auth-user', ->
      # animate
      animate(attr.elzoidoAuthAccess) unless _.isUndefined(attr.elzoidoAuthAccess)