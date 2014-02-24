# hubot-deploy [![Build Status](https://travis-ci.org/atmos/hubot-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-deploy)

Trigger [GitHub Deployments](http://developer.github.com/v3/repos/deployments/) from Hubot. This creates records on GitHub and dispatches deployment events to listeners.

# Examples

There are quite a few variants of this, but here are the basics.

You can always check the version that you're running against.

    $ hubot deploy:version
      hubot-deploy:v0.2.6 running hubot 2.7.1 on node v0.10.26 [pid: 2]

You can also trigger a variety of deployments with custom payloads.

    $ hubot deploy hubot
      ... Deploys the master branch of hubot to the default environment

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/786",
  "id": 786,
  "sha": "70aff8ebbf9dcbc085a9fe53d7456950ad286e30",
  "payload": "{\"task\":\"deploy\",\"hosts\":\"\",\"branch\":\"master\",\"room_id\":\"danger\",\"deployer\":\"atmos\",\"environment\":\"production\",\"heroku_name\":\"my-org-hubot\",\"heroku_staging_name\":\"my-org-hubot-staging\"}",
  "description": "Deploying from hubot",
  "creator": {
    "login": "atmos"
  }
}
```

    $ hubot deploy hubot/topic
      ... Deploys the topic branch of hubot to the default environment

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/787",
  "id": 787,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": "{\"task\":\"deploy\",\"hosts\":\"\",\"branch\":\"topic\",\"room_id\":\"danger\",\"deployer\":\"atmos\",\"environment\":\"production\",\"heroku_name\":\"my-org-hubot\",\"heroku_staging_name\":\"my-org-hubot-staging\"}",
  "description": "Deploying from hubot",
  "creator": {
    "login": "atmos"
  }
}
```
    $ hubot deploy:migrate hubot
      ... Create a deployment where the task is set to `deploy:migrate` for the master branch of hubot

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/788",
  "id": 788,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": "{\"task\":\"deploy:migrate\",\"hosts\":\"\",\"branch\":\"master\",\"room_id\":\"danger\",\"deployer\":\"atmos\",\"environment\":\"production\",\"heroku_name\":\"my-org-hubot\",\"heroku_staging_name\":\"my-org-hubot-staging\"}",
  "description": "Deploying from hubot",
  "creator": {
    "login": "atmos"
  }
}
```

    $ hubot deploy! hubot
      ... Bypass all CI and ahead/behind checks on GitHub

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/789",
  "id": 789,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": "{\"task\":\"deploy\",\"hosts\":\"\",\"branch\":\"master\",\"room_id\":\"danger\",\"deployer\":\"atmos\",\"environment\":\"production\",\"heroku_name\":\"my-org-hubot\",\"heroku_staging_name\":\"my-org-hubot-staging\"}",
  "description": "Deploying from hubot",
  "creator": {
    "login": "atmos"
  }
}
```

    $ hubot deploy hubot/topic to staging/fe
      ... Deploy the topic branch of hubot to the staging environment for the host class of `fe`.

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/790",
  "id": 790,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": "{\"task\":\"deploy\",\"hosts\":\"fe\",\"branch\":\"topic\",\"room_id\":\"danger\",\"deployer\":\"atmos\",\"environment\":\"staging\",\"heroku_name\":\"my-org-hubot\",\"heroku_staging_name\":\"my-org-hubot-staging\"}",
  "description": "Deploying from hubot",
  "creator": {
    "login": "atmos"
  }
}
```

# Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.

# Configuration

You need a resource file to easily name your apps and a token from GitHub.

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
