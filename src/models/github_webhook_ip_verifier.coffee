Address4 = require("ip-address").Address4

class GitHubWebHookIpVerifier
  constructor: () ->
    @subnets = [ new Address4("192.30.252.0/22") ]

  ipIsValid: (ipAddress) ->
    address = new Address4("#{ipAddress}/24")
    for subnet in @subnets
      return true if address.isInSubnet(subnet)
    false

exports.GitHubWebHookIpVerifier = GitHubWebHookIpVerifier
