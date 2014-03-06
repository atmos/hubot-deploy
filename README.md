# hubot-deploy [![Build Status](https://travis-ci.org/atmos/hubot-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-deploy)

Trigger [GitHub Deployments][1] from Hubot. Create records on GitHub and dispatch Deployment events to listeners.

![](https://f.cloud.github.com/assets/38/2331137/77036ef8-a444-11e3-97f6-68dab6975eeb.jpg)

## Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.

## Runtime Environment

* [ChatOps](https://github.com/atmos/hubot-deploy/blob/master/doc/chatops.md): What to expect from telling hubot to deploy.
* [Configuration](https://github.com/atmos/hubot-deploy/blob/master/doc/apps.json.md): Config file for easy aliasing of repos and extra configuration.
* Environmental variable **HUBOT\_GITHUB\_TOKEN**: A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo\_deployment](https://developer.github.com/v3/oauth/#scopes). The owner of this token creates [Deployments][1].

## See Also

* [heaven](https://github.com/atmos/heaven) - Listens for Deployment events from GitHub and executes the deployment for you.
* [heaven-notifier](https://github.com/atmos/heaven-notifier) - Listens for DeploymentStatus events from GitHub and notifies you.

[1]: http://developer.github.com/v3/repos/deployments/
