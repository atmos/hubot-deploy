module.exports.cassettes =
  '/github-deployments-latest-production-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    code: 200
    params:
      environment: 'production'
    path: '/repos/atmos/hubot-deploy/deployments'
    body: [
    ]
  '/github-deployments-latest-staging-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/hubot-deploy/deployments'
    params:
      environment: 'southside'
    code: 200
    path: '/repos/atmos/hubot-deploy/deployments'
    body: [
    ]
