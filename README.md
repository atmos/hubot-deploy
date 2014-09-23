# hubot-deploy [![Build Status](https://travis-ci.org/atmos/hubot-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-deploy)

[GitHub Flow][1] via [hubot][3]. Chatting with hubot creates [deployments][2] on GitHub and dispatches [Deployment Events][4].

![](https://f.cloud.github.com/assets/38/2331137/77036ef8-a444-11e3-97f6-68dab6975eeb.jpg)

## Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.
* [Configure](https://github.com/atmos/hubot-deploy/blob/master/docs/configuration.md) your runtime environment to interaction with the GitHub API.
* Understand how [apps.json](https://github.com/atmos/hubot-deploy/blob/master/docs/config-file.md) works.
* Learn about [ChatOps](https://github.com/atmos/hubot-deploy/blob/master/docs/chatops.md) deploys.

## See Also

* [hubot](https://github.com/github/hubot) - A chat robot with support for a lot of networks.
* [heaven](https://github.com/atmos/heaven) - Listens for Deployment events from GitHub and executes the deployment for you.
* [hubot-auto-deploy](https://github.com/atmos/hubot-auto-deploy) - Manage automated deployments on GitHub from chat.
* [github-credentials](https://github.com/github/hubot-scripts/blob/master/src/scripts/github-credentials.coffee) - Map your chat username to your GitHub username if they differ

[1]: https://guides.github.com/overviews/flow/
[2]: https://developer.github.com/v3/repos/deployments/
[3]: https://hubot.github.com
[4]: https://developer.github.com/v3/activity/events/types/#deploymentevent
[5]: https://developer.github.com/v3/repos/deployments/
