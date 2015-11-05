module.exports.cassettes =
  '/repos-atmos-my-robot-deployments-1875476-statuses-success':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/my-robot/deployments/1875476/statuses'
    method: 'post'
    code: 200
    body:
      id: 1
      url: "https://api.github.com/repos/atmos/my-robot/deployments/1875476/statuses/1"
      state: "success"
      creator:
        id: 1
        login: "octocat"
        avatar_url: "https://github.com/images/error/octocat_happy.gif"
      description: "Deployment finished successfully.",
      target_url: "https://example.com/deployment/1875476/output",
      created_at: "2012-07-20T01:19:13Z",
      updated_at: "2012-07-20T01:19:13Z",

  '/repos-atmos-my-robot-deployments-1875476-statuses-failure':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/my-robot/deployments/1875476/statuses'
    method: 'post'
    code: 200
    body:
      id: 1
      url: "https://api.github.com/repos/atmos/my-robot/deployments/1875476/statuses/1"
      state: "failure"
      creator:
        id: 1
        login: "octocat"
        avatar_url: "https://github.com/images/error/octocat_happy.gif"
      description: "Deployment failed to complete.",
      target_url: "https://example.com/deployment/1875476/output",
      created_at: "2012-07-20T01:19:13Z",
      updated_at: "2012-07-20T01:19:13Z",

  '/repos-atmos-my-robot-deployments-1875476-statuses-pending':
    host: 'https://api.github.com:443'
    path: '/repos/atmos/my-robot/deployments/1875476/statuses'
    method: 'post'
    code: 200
    body:
      id: 1
      url: "https://api.github.com/repos/atmos/my-robot/deployments/1875476/statuses/1"
      state: "pending"
      creator:
        id: 1
        login: "octocat"
        avatar_url: "https://github.com/images/error/octocat_happy.gif"
      description: "Deployment running.",
      target_url: "https://example.com/deployment/1875476/output",
      created_at: "2012-07-20T01:19:13Z",
      updated_at: "2012-07-20T01:19:13Z",
