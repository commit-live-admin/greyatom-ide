fetch = require './fetch'
_token = require './token'
localStorage = require './local-storage'
{name} = require '../package.json'

callStart = (token, instanceId) ->
  headers = new Headers(
    {'Authorization': token }
  )
  apiEndpoint = atom.config.get(name).apiEndpoint
  AUTH_URL = "#{apiEndpoint}/aws/toggleServer/#{instanceId}?action=start"
  fetch(AUTH_URL, {method:'PUT',headers}).then (response) ->
    console.log 'Start Instance Response'
    console.log response
    if response.publicIp
      userInfo = JSON.parse(localStorage.get('commit-live:user-info'))
      userInfo.servers.student.host = response.publicIp
      userInfo.servers.ftp_config.host = response.publicIp
      localStorage.set('commit-live:user-info', JSON.stringify(userInfo))
      return response
    else
      return false

module.exports = ->
  token = _token.get()
  instanceId = _token.getInstanceID()

  if !token
    console.log 'Not Authorized!'
  else
    callStart(token, instanceId)
