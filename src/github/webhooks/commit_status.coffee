class CommitStatus
  constructor: (@id, @payload) ->
    @state       = @payload.state
    @targetUrl   = @payload.target_url
    @description = @payload.description
    @context     = @payload.context
    @sha         = @payload.sha.substring(0,7)
    @name        = @payload.repository.name
    @repoName    = @payload.repository.full_name

  toSimpleString: ->
    msg = "hubot-deploy: commit status for #{@name}/#{@sha} (#{@context}) "
    switch @state
      when "success"
        msg += "was successful."
      when "failure", "error"
        msg += "failed."
      else
        msg += "is running."

    if @targetUrl?
      msg += " " + @targetUrl

    msg

exports.CommitStatus = CommitStatus
