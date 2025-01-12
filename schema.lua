local typedefs = require "kong.db.schema.typedefs"

return {
  name = "encode-plugin",
  fields = {
    { config = {
        type = "record",
        fields = {
          { encode_response = { type = "boolean", default = true, required = true } }
        }
      }
    }
  }
}
