## Tokens

In order to create deployments on GitHub you need to configure tokens.

### Robot Token

The hubot-deploy script requires that you setup a `HUBOT_GITHUB_TOKEN` environmental variable. This is the default value you that will be used when deployments are created via the API. This maps directly to the 'creator' attribute in the deployment payload. For basic usage, this is perfectly fine. If you want the deployments to reflect the GitHub user properly then you'll need to configure per-user tokens.

### User Tokens

The hubot-deploy script provides a way to override the token from the environment and have user specific tokens for interacting with the API.

**To prevent chat networks from logging your password it's good practice to lock the room if available.**

To configure your own token, make a [personal OAuth token]() with both `user` and `repo_deployment` scopes. Then provide it to hubot.

    $ hubot deploy-token:set <mytoken>

Hubot will respond and tell you whether the token is sufficient or not. Subsequent deployments will be properly attributed to your user in the API.

If you want to go back having the robot token create your deployments you can reset things like.

    $ hubot deploy:token:reset

Hubot will respond and tell you that your token has been forgotten and removed from the robot's brain.
