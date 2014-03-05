# hubot-deploy [![Build Status](https://travis-ci.org/atmos/hubot-deploy.png?branch=master)](https://travis-ci.org/atmos/hubot-deploy)

Trigger [GitHub Deployments](http://developer.github.com/v3/repos/deployments/) from Hubot. This creates records on GitHub and dispatches deployment events to listeners.

## apps.json is your config file

`hubot-deploy` looks for an `apps.json` file in the root of your deployed hubot to map names to specific repos that should be deployed. Here's what the format looks like.

```JSON
{
  "hubot": {
    "provider": "heroku",
    "repository": "MyOrg/my-org-hubot",
    "environments": ["production"],

    "heroku_name": "my-orgs-hubot"
  },

  "dotcom": {
    "provider": "heroku",
    "repository": "MyOrg/www",
    "environments": ["production","staging"],

    "heroku_name": "my-org-www",
    "heroku_staging_name": "my-org-www-staging"
  }
}
```

Each entry can take a few attributes.

* **provider**: One of dpl's [supported providers](https://github.com/travis-ci/dpl#supported-providers).
* **environments**: An array of environments that you can deploy to.
* **heroku\_name**: The name of the heroku app to push to.
* **heroku\_staging\_name**: The name of the heroku app to push to.

## Chatops

There are quite a few variants of this, but here are the basics.

You can always check the version that you're running against.

    $ hubot deploy:version
      hubot-deploy v0.3.2/hubot v2.7.1/node v0.10.26

You can also trigger a variety of deployments with custom payloads.

    $ hubot deploy hubot
      ... Deploys the master branch of hubot to the default environment

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1077",
  "id": 1077,
  "sha": "cfbc1c744e106c2aa869fae6452ed249f12d8713",
  "payload": {
    "task": "deploy",
    "hosts": "",
    "branch": "master",
    "notify": {
      "room": "danger",
      "user": "atmos",
      "adapter": "unknown"
    },
    "environment": "production",
    "config": {
      "provider": "heroku",
      "repository": "MyOrg/my-org-hubot",
      "environments": [
        "production"
      ],
      "heroku_name": "my-org-hubot",
    }
  },
  "description": "Deploying from hubot-deploy-v0.3.8",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1077/statuses"
}
```

    $ hubot deploy hubot/topic
      ... Deploys the topic branch of hubot to the default environment

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1078",
  "id": 1078,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": {
    "task": "deploy",
    "hosts": "",
    "branch": "topic",
    "notify": {
      "room": "danger",
      "user": "atmos",
      "adapter": "unknown"
    },
    "environment": "production",
    "config": {
      "provider": "heroku",
      "repository": "MyOrg/my-org-hubot",
      "environments": [
        "production"
      ],
      "heroku_name": "my-org-hubot",
    }
  },
  "description": "Deploying from hubot-deploy-v0.3.8",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1078/statuses"
}
```
    $ hubot deploy:migrate hubot
      ... Create a deployment where the task is set to `deploy:migrate` for the master branch of hubot

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1079",
  "id": 1079,
  "sha": "cfbc1c744e106c2aa869fae6452ed249f12d8713",
  "payload": {
    "task": "deploy:migrate",
    "hosts": "",
    "branch": "master",
    "notify": {
      "room": "danger",
      "user": "atmos",
      "adapter": "unknown"
    },
    "environment": "production",
    "config": {
      "provider": "heroku",
      "repository": "MyOrg/my-org-hubot",
      "environments": [
        "production"
      ],
      "heroku_name": "my-org-hubot",
    }
  },
  "description": "Deploying from hubot-deploy-v0.3.8",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1079/statuses"
}
```

    $ hubot deploy! hubot
      ... Bypass all CI and ahead/behind checks on GitHub

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1080",
  "id": 1080,
  "sha": "cfbc1c744e106c2aa869fae6452ed249f12d8713",
  "payload": {
    "task": "deploy",
    "hosts": "",
    "branch": "master",
    "notify": {
      "room": "danger",
      "user": "atmos",
      "adapter": "unknown"
    },
    "environment": "production",
    "config": {
      "provider": "heroku",
      "repository": "MyOrg/my-org-hubot",
      "environments": [
        "production"
      ],
      "heroku_name": "my-org-hubot",
    }
  },
  "description": "Deploying from hubot-deploy-v0.3.8",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1080/statuses"
}
```

    $ hubot deploy hubot/topic to staging/fe
      ... Deploy the topic branch of hubot to the staging environment for the host class of `fe`.

```JSON
{
  "url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1081",
  "id": 1081,
  "sha": "03ed31c1312478561d677bfe743eb13290b10d42",
  "payload": {
    "task": "deploy",
    "hosts": "fe",
    "branch": "topic",
    "notify": {
      "room": "danger",
      "user": "atmos",
      "adapter": "unknown"
    },
    "environment": "production",
    "config": {
      "provider": "heroku",
      "repository": "MyOrg/my-org-hubot",
      "environments": [
        "production"
      ],
      "heroku_name": "my-org-hubot",
    }
  },
  "description": "Deploying from hubot-deploy-v0.3.8",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1081/statuses"
}
```

## Installation

* Add hubot-deploy to your `package.json` file.
* Add hubot-deploy to your `external-scripts.json` file.

## Runtime Environment

* **HUBOT\_GITHUB\_TOKEN**: A [GitHub token](https://github.com/settings/applications#personal-access-tokens) with [repo\_deployment](https://developer.github.com/v3/oauth/#scopes), and gist scope.

# See Also

* [heaven](https://github.com/atmos/heaven)
* [heaven-notifier](https://github.com/atmos/heaven-notifier)
