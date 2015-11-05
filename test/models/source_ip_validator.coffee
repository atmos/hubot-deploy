Path = require('path')

GitHubWebHookIpVerifier = require(Path.join(__dirname, "..", "..", "src", "models", "github_webhook_ip_verifier"))

describe "GitHubWebHookIpVerifier", () ->
  it "verifies correct ip addresses", () ->
    verifier = new GitHubWebHookIpVerifier.GitHubWebHookIpVerifier

    assert.isTrue verifier.ipIsValid("192.30.252.1")
    assert.isTrue verifier.ipIsValid("192.30.253.1")
    assert.isTrue verifier.ipIsValid("192.30.254.1")
    assert.isTrue verifier.ipIsValid("192.30.255.1")

  it "rejects incorrect ip addresses", () ->
    verifier = new GitHubWebHookIpVerifier.GitHubWebHookIpVerifier

    assert.isFalse verifier.ipIsValid("192.30.250.1")
    assert.isFalse verifier.ipIsValid("192.30.251.1")
    assert.isFalse verifier.ipIsValid("192.168.1.1")
    assert.isFalse verifier.ipIsValid("127.0.0.1")
