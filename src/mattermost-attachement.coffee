module.exports = (robot) ->
  options =
    webhook: process.env.MATTERMOST_INCOME_URL
  robot.on "slack.attachment",(data) ->
    console.info "=========================== event testing=================="
    robot.logger.debug "msgData is:#{options.webhook}"
    robot.logger.debug "msgData: "+ JSON.stringify(data)
    if typeIsArray data["attachments"]
       data["icon_url"] = "#{process.env.MATTERMOST_ICON_URL}"
       data["username"] = "#{process.env.MATTERMOST_HUBOT_USERNAME}"
       robot.logger.debug "testing ICON is : #{process.env.MATTERMOST_ICON_URL}"
       robot.logger.debug "msgData: "+ JSON.stringify(data)
    else
       attachment = data["attachments"]
       data["attachments"] = []
       data["attachments"][0]=attachment
       data["icon_url"] = "#{process.env.MATTERMOST_ICON_URL}"
       data["username"] = "#{process.env.MATTERMOST_HUBOT_USERNAME}"
       robot.logger.debug "msgData: "+ JSON.stringify(data)
    robot.http(options.webhook)
         .header("Content-Type", "application/json")
         .post(JSON.stringify(data)) (err, res, body) ->
            return if res.statusCode == 200
            robot.logger.error "Error!", res.statusCode, body

typeIsArray = ( value ) ->
    value and
        typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and
        not ( value.propertyIsEnumerable 'length' )
