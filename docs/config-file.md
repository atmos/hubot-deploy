## Configuration File

`hubot-deploy` looks for an `apps.json` file in the root of your deployed hubot to map names to specific repos that should be deployed. Here's what the format looks like.

It's a javascript object where application aliases are used as the names(keys). This allows you to easily reference projects even if the repository name is long, hard to type, or easy to forget. The object itself tells GitHub enough information for deployment systems to handle the who(name), what(repository), where(environment), and how(provider).

| Common Attributes       |                                                 |
|-------------------------|-------------------------------------------------|
| provider                | Either 'heroku' or 'capistrano'. **Required**   |
| repository              | The name with owner path to a repo on github. e.g. "atmos/heaven". **Required** |
| environments            | An array of environments that you can deploy to. Default: "production" |
| required_contexts       | An array of commit status context names to verify against.|
| github_api              | A String with the full URL to the API. Useful for enterprise installs. Default: "https://api.github.com" |
| github_token            | A token for creating deployments in the GitHub API specific to the specific repository.|
| allowed_rooms           | An array of room id's for restricting the deployments to be started only in those rooms.|

Any extra parameters will be passed along to GitHub in the `payload` field. This should allow for a decent amount of customization.

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

## Supported GitHub Services

GitHub has really simple integrations for Heroku and OpsWorks. The cool thing about these is that you can get deployment support without having to setup and services of your own.

### Heroku

GitHub provides a repo integration for deploying to [heroku](https:///heroku.com). [Docs](http://www.atmos.org/github-services/heroku/).

| Provider Attributes     |                                                 |
|-------------------------|-------------------------------------------------|
| heroku_<env>_name       | The name of the heroku app to push to. Multiple environments are available with things like 'heroku_production_name' and 'heroku_staging_name'. |

### OpsWorks

There's also a repo integration for deploying to [Aws OpsWorks](http://aws.amazon.com/opsworks/). OpsWorks supports multi-environment deployments by specifying different stack and app ids. [Docs](http://www.atmos.org/github-services/aws-opsworks/).

## Supported Heaven Services

The [heaven](https://github.com/atmos/heaven) exists if you need to write your own custom stuff or don't want to share your keys with GitHub. This requires you to stand up your own service, but deploys to heroku relatively easily. The best docs are probably the readme.

