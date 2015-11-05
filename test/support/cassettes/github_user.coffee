module.exports.cassettes =
  '/user-invalid-auth':
    host: 'https://api.github.com:443'
    path: '/user'
    code: 401
    body:
      message: "Bad credentials"
      documentation_url: "https://developer.github.com/v3"

  '/user-invalid-scopes':
    host: 'https://api.github.com:443'
    path: '/user'
    code: 200
    headers:
      "x-oauth-scopes": "public"
    body:
      id: 1
      login: "octocat"
      avatar_url: "https://github.com/images/error/octocat_happy.gif"


  '/user-valid':
    host: 'https://api.github.com:443'
    path: '/user'
    code: 200
    headers:
      "x-oauth-scopes": "gist, repo"
    body:
      id: 1
      login: "octocat"
      avatar_url: "https://github.com/images/error/octocat_happy.gif"
  
