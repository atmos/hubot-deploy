## Configuration

In order to create deployments on GitHub you need to configure a few things. Fallback configurations are configured by environmental variables.

| Common Attributes       |                                                 |
|-------------------------|-------------------------------------------------|
| HUBOT_GITHUB_API        | A String of the full URL to the GitHub API. Default: "https://api.github.com" |
| HUBOT_GITHUB_TOKEN      | A [personal oauth token][1] with repo_deployment scope. |

### The Highlander Token

If you're only going to use the `HUBOT_GITHUB_TOKEN` then all deployments will be created by a single user. Since you're deploying from chat, it's nice to know who requested the actual deployment.

### User Tokens

The hubot-deploy script provides a way to have user specific tokens for interacting with the API.

**To prevent chat networks from logging your password it's good practice to lock the room if available.**

To configure your own token, make a [personal OAuth token][1] with both `user` and `repo_deployment` scopes. Then provide it to hubot.

    $ hubot deploy-token:set <mytoken>

Hubot will respond and tell you whether the token is sufficient or not. Subsequent deployments will be properly attributed to your user in the API.

If you want to go back having the highlander token create your deployments you can reset things like.

    $ hubot deploy-token:reset

Hubot will respond and tell you that your token has been forgotten and removed from the robot's brain.

[1]: https://github.com/settings/tokens
