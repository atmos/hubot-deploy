module.exports.cassettes =
  '/github-deployments-latest-production-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    code: 200
    params:
      environment: 'production'
    path: '/repos/atmos/hubot-deploy/deployments'
    body: [
      {
        id: 2332339,
        url: "https://api.github.com/repos/atmos/hubot-deploy/deployments/2332339"
        sha: "afa77dd02e61d86e73795796207e128206d670e2"
        ref: "master"
        task: "deploy"
        environment: "production",
        description: "deploy on production from hubot-deploy-v0.10.1",
        payload:
          name: "hubot"
          robotName: "hubot"
          notify:
            adapter: "slack"
            room: "#general"
            user: "341"
          config:
            provider: "heroku",
            repository: "atmos/hubot-deploy",
            environments: [
              "production"
              "staging"
            ]
            required_contexts: [
              "continuous-integration/travis-ci/push"
            ]
            heroku_production_name: "hubot-deploy-production"
            heroku_staging_name: "hubot-deploy-staging"
        creator:
          id: 38,
          login: "atmos",
          avatar_url: "https://avatars.githubusercontent.com/u/38?v=3"
      }
      {
        id: 2332369,
        url: "https://api.github.com/repos/atmos/hubot-deploy/deployments/2332369"
        sha: "afa77dd02e61d86e73795796207e128206d670e2"
        ref: "master"
        task: "deploy"
        environment: "production",
        description: "deploy on production from hubot-deploy-v0.10.1",
        payload:
          name: "hubot"
          robotName: "hubot"
          notify:
            adapter: "slack"
            room: "#general"
            user: "341"
          config:
            provider: "heroku",
            repository: "atmos/hubot-deploy",
            environments: [
              "production"
              "staging"
            ]
            required_contexts: [
              "continuous-integration/travis-ci/push"
            ]
            heroku_production_name: "hubot-deploy-production"
            heroku_staging_name: "hubot-deploy-staging"
        creator:
          id: 38,
          login: "atmos",
          avatar_url: "https://avatars.githubusercontent.com/u/38?v=3"
      }
    ]
  '/github-deployments-latest-staging-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    params:
      environment: 'staging'
    code: 200
    path: '/repos/atmos/hubot-deploy/deployments'
    body: [
      {
        id: 2332339,
        url: "https://api.github.com/repos/atmos/hubot-deploy/deployments/2332339"
        sha: "afa77dd02e61d86e73795796207e128206d670e2"
        ref: "master"
        task: "deploy"
        environment: "staging",
        description: "deploy on staging from hubot-deploy-v0.10.1",
        payload:
          name: "hubot"
          robotName: "hubot"
          notify:
            adapter: "slack"
            room: "#general"
            user: "341"
          config:
            provider: "heroku",
            repository: "atmos/hubot-deploy",
            environments: [
              "production"
              "staging"
            ]
            required_contexts: [
              "continuous-integration/travis-ci/push"
            ]
            heroku_production_name: "hubot-deploy-production"
            heroku_staging_name: "hubot-deploy-staging"
        creator:
          id: 38,
          login: "atmos",
          avatar_url: "https://avatars.githubusercontent.com/u/38?v=3"
      }
      {
        id: 2332369,
        url: "https://api.github.com/repos/atmos/hubot-deploy/deployments/2332369"
        sha: "afa77dd02e61d86e73795796207e128206d670e2"
        ref: "master"
        task: "deploy"
        environment: "staging",
        description: "deploy on staging from hubot-deploy-v0.10.1",
        payload:
          name: "hubot"
          robotName: "hubot"
          notify:
            adapter: "slack"
            room: "#general"
            user: "341"
          config:
            provider: "heroku",
            repository: "atmos/hubot-deploy",
            environments: [
              "production"
              "staging"
            ]
            required_contexts: [
              "continuous-integration/travis-ci/push"
            ]
            heroku_production_name: "hubot-deploy-production"
            heroku_staging_name: "hubot-deploy-staging"
        creator:
          id: 38,
          login: "atmos",
          avatar_url: "https://avatars.githubusercontent.com/u/38?v=3"
      }
    ]
  '/github-deployments-latest-production-bad-auth':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    code: 401
    path: '/repos/atmos/hubot-deploy/deployments'
    body:
      message: "Bad credentials"
      documentation_url: "https://developer.github.com/v3"
