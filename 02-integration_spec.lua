local helpers = require "spec.helpers"

describe("EncodePlugin Integration", function()

  local admin_client
  local proxy_client

  lazy_setup(function()
    -- Setup Kong with the plugin
    local strategy = "postgres"
    local opts = {
      database = strategy,
      plugins = "encode-plugin"
    }

    assert(helpers.start_kong(opts))
  end)

  before_each(function()
    admin_client = helpers.admin_client()
    proxy_client = helpers.proxy_client()
  end)

  after_each(function()
    if admin_client then
      admin_client:close()
    end
    if proxy_client then
      proxy_client:close()
    end
  end)

  it("should Base64 encode the response body", function()
    -- Add a service and route
    local res = admin_client:post("/services", {
      body = {
        name = "test-service",
        url = "http://httpbin.org"
      },
      headers = { ["Content-Type"] = "application/json" }
    })

    local service = assert.res_status(201, res)

    local res = admin_client:post("/routes", {
      body = {
        service = { id = service.id },
        hosts = { "example.com" }
      },
      headers = { ["Content-Type"] = "application/json" }
    })

    local route = assert.res_status(201, res)

    -- Send request to the proxy and check Base64 encoding
    local res = proxy_client:get("/anything", {
      headers = { host = "example.com" }
    })

    local body = assert.res_status(200, res)
    assert.matches("SGVsbG8gV29ybGQh", body)  -- Check if the response body is Base64-encoded

  end)

end)
