0.7.0
=====

* Support different api endpoints(enterprise) on a per application basis.
* Support `deploy-token:set` commands to have chat user specific tokens for
  deployment creation.
* The `task` attribute is first class and not in the payload anymore.
* Support recent deployments listing in chat `/deploys hubot`
* Support required_contexts in deployment API
* Use user tokens if present for fetching recent deployments

0.6.x
=====

* Loosen required hubot version >= 2.7.2
* Loosin node engine requirements to work with 0.8 and 0.10
* Customizable script prefix, defaults to 'deploy' still

0.4.1
=====

* Use robot.adapterName made available in https://github.com/github/hubot/pull/663
* Explicitly load the hubot script so it supports the help command.
* Break up the docs into separate files for examples.
