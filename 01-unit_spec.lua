local helpers = require "spec.helpers"
local kong = kong
local EncodePlugin = require "kong.plugins.encode-plugin.handler"

describe("EncodePlugin", function()

  local plugin

  before_each(function()
    -- Instantiate the plugin
    plugin = EncodePlugin:new()
  end)

  describe("header_filter", function()
    it("should Base64 encode the response body in header_filter", function()
      local fake_body = "Hello World!"
      ngx.arg = { fake_body }
      plugin:header_filter()
      assert.equals(ngx.ctx.encoded_body, "SGVsbG8gV29ybGQh")  -- Base64 of "Hello World!"
    end)
  end)

  describe("body_filter", function()
    it("should use the Base64-encoded body in body_filter", function()
      ngx.ctx.encoded_body = "SGVsbG8gV29ybGQh"  -- Base64-encoded "Hello World!"
      ngx.arg = { "Hello World!" }
      plugin:body_filter()
      assert.equals(ngx.arg[1], "SGVsbG8gV29ybGQh")
    end)
  end)

end)
