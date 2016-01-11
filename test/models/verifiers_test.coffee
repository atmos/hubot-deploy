VCR  = require "ys-vcr"
Path = require('path')

Verifiers = require(Path.join(__dirname, "..", "..", "src", "models", "verifiers"))

describe "GitHubWebHookIpVerifier", () ->
  afterEach () ->
    delete process.env.HUBOT_DEPLOY_GITHUB_SUBNETS

  it "verifies correct ip addresses", () ->
    verifier = new Verifiers.GitHubWebHookIpVerifier

    assert.isTrue verifier.ipIsValid("192.30.252.1")
    assert.isTrue verifier.ipIsValid("192.30.253.1")
    assert.isTrue verifier.ipIsValid("192.30.254.1")
    assert.isTrue verifier.ipIsValid("192.30.255.1")

  it "rejects incorrect ip addresses", () ->
    verifier = new Verifiers.GitHubWebHookIpVerifier

    assert.isFalse verifier.ipIsValid("192.30.250.1")
    assert.isFalse verifier.ipIsValid("192.30.251.1")
    assert.isFalse verifier.ipIsValid("192.168.1.1")
    assert.isFalse verifier.ipIsValid("127.0.0.1")

  it "verifies correct ip addresses with custom subnets", () ->
    process.env.HUBOT_DEPLOY_GITHUB_SUBNETS = '207.97.227.0/22,,   198.41.190.0/22'
    verifier = new Verifiers.GitHubWebHookIpVerifier

    assert.isTrue verifier.ipIsValid("207.97.224.1")
    assert.isTrue verifier.ipIsValid("198.41.188.1")

    assert.isFalse verifier.ipIsValid("192.30.252.1")
    assert.isFalse verifier.ipIsValid("207.97.228.1")
    assert.isFalse verifier.ipIsValid("198.41.194.1")
    assert.isFalse verifier.ipIsValid("192.168.1.1")
    assert.isFalse verifier.ipIsValid("127.0.0.1")

describe "ApiTokenVerifier", () ->
  it "returns false when the GitHub token is invalid", (done) ->
    VCR.play "/user-invalid-auth"
    verifier = new Verifiers.ApiTokenVerifier("123456789")
    verifier.valid (result) ->
      assert.isFalse result
      done()

  it "returns false when the GitHub token has incorrect scopes", (done) ->
    VCR.play "/user-invalid-scopes"
    verifier = new Verifiers.ApiTokenVerifier("123456789")
    verifier.valid (result) ->
      assert.isFalse result
      done()

  it "tells you when your provided GitHub token is valid", (done) ->
    VCR.play "/user-valid"
    verifier = new Verifiers.ApiTokenVerifier("123456789")
    verifier.valid (result) ->
      assert.isTrue result
      done()
