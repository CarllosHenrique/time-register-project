require "oj"

Oj.optimize_rails

Oj.default_options = {
  mode: :rails,
  time_format: :xmlschema,
  use_to_json: true,
  ignore_nil: false
}
