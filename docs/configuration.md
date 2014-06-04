## Configuration

`hubot-deploy` looks for an `apps.json` file in the root of your deployed hubot to map names to specific repos that should be deployed. Here's what the format looks like.

```JSON
{
  "hubot": {
    "provider": "heroku",
    "auto_merge": false,
    "repository": "MyOrg/my-org-hubot",
    "environments": ["production"],

    "heroku_production_name": "my-orgs-hubot"
  },

  "dotcom": {
    "provider": "heroku",
    "repository": "MyOrg/www",
    "environments": ["production","staging"],
    "required_contexts": ["ci/janky", "security/brakeman"],

    "heroku_staging_name": "my-org-www-staging",
    "heroku_production_name": "my-org-www"
  }
}
```

Each entry can take a few attributes.

| Attributes              |                                                 |
|-------------------------|-------------------------------------------------|
| provider                | Either 'heroku' or 'capistrano'. **Required**   |
| repository              | The name with owner path to a repo on github. e.g. "atmos/heaven". **Required** |
| environments            | An array of environments that you can deploy to. Default: "production" |
| required_contexts       | An array of commit status context names to verify against.|
| heroku_<env>_name       | The name of the heroku app to push to. Multiple environments are available with things like 'heroku_production_name' and 'heroku_staging_name'. |

