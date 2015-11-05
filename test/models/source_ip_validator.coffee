Path = require('path')

Address4 = require("ip-address").Address4

describe "GitHubSourceValidator", () ->
  it "rejects things that don't start with deploy", () ->
    topic = new Address4("192.30.252.0/22")
    goodRangeOfIps = [
      "192.30.252.1/24",
      "192.30.253.1/24",
      "192.30.254.1/24",
      "192.30.255.1/24"
    ]
    badRangeOfIps = [
      "192.30.250.1/24",
      "192.30.251.1/24",
      "192.168.1.1/24"
    ]

    for ip in goodRangeOfIps
      address = new Address4(ip)
      assert.isTrue address.isInSubnet(topic)

    for ip in badRangeOfIps
      address = new Address4(ip)
      assert.isFalse address.isInSubnet(topic)
