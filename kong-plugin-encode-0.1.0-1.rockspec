package = "kong-plugin-encode"
version = "0.1.0-1"
rockspec_format = "1.0"

dependencies = {
  "kong >= 2.0.0",
}

source = {
  url = "/home/kong/Desktop/kong-plugin-master",
}

description = {
  summary = "Kong plugin that Base64 encodes the backend response.",
  homepage = "file:///home/kong/Desktop/kong-plugin-master",  -- Use file URL for local paths
  license = "Apache 2.0",
}

build = {
  type = "lua",
   modules = {
    ["kong.plugins.encode.handler"] = "/home/kong/Desktop/kong-plugin-master/kong/plugins/encode/handler.lua",
    ["kong.plugins.encode.schema"] = "/home/kong/Desktop/kong-plugin-master/kong/plugins/encode/schema.lua",
  },
}

dependencies = {
  "kong",  -- You can specify Kong's version if needed (e.g., "kong >= 2.0.0")
}
