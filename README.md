# hubot-deploy [![Build Status](https://travis-ci.org/tampopo/hubot-deploy.png?branch=master)](https://travis-ci.org/tampopo/hubot-deploy)

Trigger [GitHub Deployments](http://developer.github.com/v3/repos/deployments/) from Hubot. This creates records on GitHub and dispatches deployment events to listeners.

# Examples

There are quite a few variants of this, but here are the basics.

    $ hubot deploy hubot
      ... Deploys the master branch of hubot to the default environment

    $ hubot deploy hubot/topic
      ... Deploys the topic branch of hubot to the default environment

    $ hubot deploy:migrate hubot
      ... Create a deployment where the task is set to `deploy:migrate` for the master branch of hubot

    $ hubot deploy! hubot
      ... Bypass all CI and ahead/behind checks on GitHub

    $ hubot deploy hubot/topic to staging/fe
      ... Deploy the topic branch of hubot to the staging environment for the host class of `fe`.

# Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.

# Configuration

## Runtime Environment

* **HUBOT\_GITHUB\_TOKEN**: A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo\_deployment scope](https://developer.github.com/v3/oauth/#scopes).

## apps.json

`hubot-deploy` looks for an `apps.json` file in the root of your deployed hubot to map names to specific repos that should be deployed. Here's what the format looks like.

```JSON
{
  "hubot": {
    "repository": "MyOrg/my-org-hubot",
    "environments": ["production"],

    "heroku_name": "my-orgs-hubot"
  },

  "dotcom": {
    "repository": "MyOrg/www",
    "environments": ["production","staging"],

    "heroku_name": "my-org-www",
    "heroku_staging_name": "my-org-www-staging"
  }
}
```

Each entry can take a few attributes.

* **environments**: An array of environments that you can deploy to.
* **heroku\_name**: The name of the heroku app to push to.
* **heroku\_staging\_name**: The name of the heroku app to push to.
