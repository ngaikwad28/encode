local ngx = ngx
local kong = kong

local EncodePlugin = {}

-- Constructor
function EncodePlugin:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

-- Override the response filter phase to encode the response body in Base64
function EncodePlugin:header_filter()
  -- Ensure that we encode the response body only if it exists
  local body = ngx.arg[1]
  if body and body ~= "" then
    -- Store the encoded body in ngx.ctx for use in body_filter
    ngx.ctx.encoded_body = ngx.encode_base64(body)
  end
end

-- Optionally, handle body filtering for chunked responses
function EncodePlugin:body_filter()
  -- Use the previously encoded body if available
  if ngx.ctx.encoded_body then
    -- Replace the response body with the Base64-encoded version
    ngx.arg[1] = ngx.ctx.encoded_body
  end
end

-- Define the plugin priority (mandatory)
EncodePlugin.PRIORITY = 10

-- Define the plugin version (mandatory)
EncodePlugin.VERSION = "1.0.0"

-- Return the plugin object
return EncodePlugin
