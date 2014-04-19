# hubot-deploy [![Build Status](https://travis-ci.org/atmos/hubot-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-deploy)

[GitHub Flow][1] via [hubot][3]. Chatting with hubot creates [deployments][2] on GitHub and dispatches [Deployment Events][4].

![](https://f.cloud.github.com/assets/38/2331137/77036ef8-a444-11e3-97f6-68dab6975eeb.jpg)

There's a bunch of [ChatOps](https://github.com/atmos/hubot-deploy/blob/master/docs/chatops.md) commands.

## Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.
* [Configure](https://github.com/atmos/hubot-deploy/blob/master/docs/configuration.md) your repos and providers for easy aliasing and custom options.

## Runtime Environment

You need to set the following environmental variables.

* **HUBOT\_GITHUB\_TOKEN**: A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo\_deployment](https://developer.github.com/v3/oauth/#scopes). The owner of this token creates [Deployments][1].

Optional environmental variables

* **HUBOT\_GITHUB\_DEPLOYMENT\_AUTO\_MERGE**: Enable/Disable the `auto-merge` github process, pass `'0'` or `'1'`. (Default to `'1'`)

## See Also

* [heaven](https://github.com/atmos/heaven) - Listens for Deployment events from GitHub and executes the deployment for you.
* [heaven-notifier](https://github.com/atmos/heaven-notifier) - Listens for DeploymentStatus events from GitHub and notifies you.

[1]: https://guides.github.com/overviews/flow/
[2]: https://developer.github.com/v3/repos/deployments/
[3]: https://hubot.github.com
[4]: https://developer.github.com/v3/activity/events/types/#deploymentevent
