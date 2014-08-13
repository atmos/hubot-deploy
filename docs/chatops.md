## Chatops

There are quite a few variants of this, but here are the basics.

You can always check the version that you're running against.

    $ hubot deploy:version
      hubot-deploy v0.6.43/hubot v2.7.4/node v0.10.26

You can also trigger a variety of deployments with custom payloads.

    $ hubot deploy hubot
      ... Deploys the master branch of hubot to the default environment

If you already have `/deploy` style syntax you can override the deploy command prefix with the `HUBOT_DEPLOY_PREFIX` environmental variable.

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
  "description": "Deploying from hubot-deploy-v0.5.1",
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
  "description": "Deploying from hubot-deploy-v0.5.1",
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
  "description": "Deploying from hubot-deploy-v0.5.1",
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
  "description": "Deploying from hubot-deploy-v0.5.1",
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
  "description": "Deploying from hubot-deploy-v0.5.1",
  "creator": {
    "login": "fakeatmos"
  },
  "statuses_url": "https://api.github.com/repos/MyOrg/my-org-hubot/deployments/1081/statuses"
}
```
