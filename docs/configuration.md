## Configuration

In order to create deployments on GitHub you need to configure a few things. Fallback configurations are configured by environmental variables.

| Common Attributes       |                                                 |
|-------------------------|-------------------------------------------------|
| HUBOT_GITHUB_API        | A String of the full URL to the GitHub API. Default: "https://api.github.com" |
| HUBOT_GITHUB_TOKEN      | A [personal oauth token][1] with repo_deployment scope. This is normally a bot account. |
| HUBOT_DEPLOY_FERNET_SECRETS    | The key used for encrypting your tokens in the hubot's brain. A comma delimited set of different key tokens. To create one run `dd if=/dev/urandom bs=32 count=1 2>/dev/null | openssl base64` on a UNIX system.  |
| HUBOT_DEPLOY_EMIT_GITHUB_DEPLOYMENTS | If set to true a `github_deployment` event emit emitted instead of posting directly to the GitHub API. This allows for customization, check out the examples. |
| HUBOT_DEPLOY_DEFAULT_ENVIRONMENT | Allow for specifying which environment should be the default when it is omitted from the deployment request in chat. |
| HUBOT_DEPLOY_GITHUB_SUBNETS | Allow for specifying the subnets for your GitHub install, useful for GitHub Enterprise. Defaults to github.com's IP range. |

### Robot Users

If you already have a user on GitHub that is essentially a bot account you can create a [personal OAuth token][1] for that user with the `user` and `repo` scopes. Unfortunately GitHub won't be able to differentiate between different users deploying, they'll all be created in the API as the bot user.

### User Tokens

The hubot-deploy script provides a way to have user specific tokens for interacting with the API. You need to be using a chat service that supports private messages like [SlackHQ][2] or [Hipchat][3].

To configure your own token, make a [personal OAuth token][1] with both `user`, `repo` scopes. Then provide it to hubot via private message.

    deploy-token:set:github <mytoken>

Hubot will respond and tell you whether the token is sufficient or not. If your token is good future deployments will be properly attributed to your user in the API.

If things are being weird you can verify your token.

    deploy-token:verify:github

If you want to go back having the highlander token create your deployments you can reset things like.

    deploy-token:reset:github

Hubot will respond and tell you that your token has been forgotten and removed from the robot's brain.

[1]: https://github.com/settings/tokens
[2]: https://slack.com/is
[3]: https://www.hipchat.com
