module.exports.cassettes =
  '/repos-atmos-hubot-deploy-deployment-production-create-bad-auth':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    method: 'post'
    code: 401
    path: '/repos/atmos/hubot-deploy/deployments'
    body:
      message: 'Bad credentials'
      documentation_url: 'https://developer.github.com/v3'
  '/repos-atmos-hubot-deploy-deployment-production-create-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    method: 'post'
    code: 201
    path: '/repos/atmos/hubot-deploy/deployments'
    body:
      deployment:
        url: "https://api.github.com/repos/atmos/hubot-deploy/deployments/1875476"
        id: 1875476
        sha: "3c9f42c76ce057eaabc3762e3ec46dd830976963"
        ref: "heroku"
        task: "deploy"
        environment: "production"
        description: "Deploying from hubot-deploy-v0.6.53"
        payload:
          name: "hubot-deploy"
          hosts: ""
          notify:
            room: "ops",
            user: "atmos",
            adapter: "slack",
          config:
            provider: "heroku",
            auto_merge: true,
            repository: "atmos/hubot-deploy",
            environments: [ "production" ]
            allowed_rooms: []
            heroku_name: "zero-fucks-hubot"
        creator:
          id: 6626297,
          login: "atmos",
          avatar_url: "https://avatars.githubusercontent.com/u/6626297?v=3"
      repository:
        id: 42524818
        name: "hubot-deploy"
        private: true
        full_name: "atmos/hubot-deploy"
        owner:
          login: "atmos",
          type: "User",
          site_admin: false
      sender:
        id: 6626297
        login: "atmos"
        avatar_url: "https://avatars.githubusercontent.com/u/6626297?v=3"

