class Push
  constructor: (@id, @payload) ->
    @ref   = @payload.ref
    @actor = @payload.pusher.name
    @count = @payload.commits.length
    @isTag = @ref.match(/^refs\/tags\//)

    @commits = @payload.commits

    @refName   = @ref.replace(/^refs\/(heads|tags)\//, "")

    @afterSha  = @payload.after[0..7]
    @beforeSha = @payload.before[0..7]
    @repoName  = @payload.repository.name
    @ownerName = @payload.repository.owner.name

    @baseRef     = @payload.base_ref
    @baseRefName = @payload.base_ref_name

    @forced  = @payload.forced or false
    @deleted = @payload.deleted or @payload.after.match(/0{40}/)
    @created = @payload.created or @payload.before.match(/0{40}/)

    @repoUrl       = @payload.repository.url
    @branchUrl     = "#{@repoUrl}/commits/#{@refName}"
    @compareUrl    = @payload.compare
    @afterShaUrl   = "#{@repoUrl}/commit/#{@afterSha}"
    @beforeShaUrl  = "#{@repoUrl}/commit/#{@beforeSha}"
    @nameWithOwner = "#{@ownerName}/#{@repoName}"

    @distinctCommits = (commit for commit in @commits when commit.distinct and commit.message.length > 0)

    if @count > 1
      @commitMessage = "#{@count} commits"
    else
      @commitMessage = "a commit"

  formatCommitMessage: (commit) ->
    short = commit.message.split("\n", 2)[0]
    "[#{@repoName}/#{@refName}] #{short} - #{commit.author.name}"

  summaryUrl: ->
    if @created
      if @distinctCommits.length is 0
        @branchUrl
      else
        @compareUrl
    else if @deleted
      @beforeShaUrl
    else if @forced
      @branchUrl
    else if @commits.length is 1
      @commits[0].url
    else
      @compareUrl

  summaryMessage: ->
    message = []
    message.push("[#{@repoName}] #{@actor}")

    if @created
      if @isTag
        message.push("tagged #{@refName} at")
        message.push(if @baseRef? then @baseRefName else @afterSha)
      else
        message.push("created #{@refName}")

        if @baseRef
          message.push("from #{@baseRefName}")
        else if @distinctCommits.empty?
          message.push("at #{@afterSha}")

        if @distinctCommits.length > 0
          num = @distinctCommits.length
          message << "(+#{@commitMessage})"

    else if @deleted
      message.push("deleted #{@refName} at #{@beforeSha}")

    else if @forced
      message.push("force-pushed #{@refName} from #{@beforeSha} to #{@afterSha}")

    else if @commits.length > 0 and @distinctCommits.length is 0
      if @baseRef
        message.push("merged #{baseRefName} into #{@refName}")
      else
        message.push("fast-forwarded #{@refName} from #{@beforeSha} to #{@afterSha}")

    else if @distinctCommits.length > 0
      num = @distinctCommits.length
      message.push("pushed #{num} new commit#{if num > 1 then 's' else ''} to #{@refName}")
    else
      message.push("pushed nothing")

    message.join(" ")

  toSimpleString: ->
    "hubot-deploy: #{@actor} pushed #{@commitMessage}"

exports.Push = Push
