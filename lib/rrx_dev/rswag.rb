# Rswag schema helpers

def ref(to)
  { '$ref': "#/components/schemas/#{to}" }
end

def object(optional: {}, additional: false, **properties)
  {
    type:                 :object,
    required:             properties.keys.map(&:to_s),
    properties:           properties.update(optional),
    additionalProperties: additional
  }.freeze
end

def prop_type(type, description = nil, **options)
  t = { type: }.update(options)
  t[:description] = description if description
  t.freeze
end

def integer(description = nil)
  prop_type :integer, description
end

def string(description = nil, **options)
  prop_type :string, description, **options
end

def date_time(description = nil)
  string description, format: :dateTime
end

def boolean(description = nil)
  prop_type :boolean, description
end

def array(type, description = nil)
  prop_type :array, description, items: type
end

def enum(vals, description = nil)
  string description, enum: vals
end

class SwaggerConfig
  def initialize
    @docs = {}
  end

  def doc(file, name, version, **schemas)
    @docs[file] = {
      openapi:    '3.0.1',
      info:       {
        title:   name,
        version:
      },
      components: { schemas: }
    }
  end

  def config
    RSpec.configure do |config|
      config.swagger_root = Rails.root.join('swagger').to_s
      config.swagger_format = :yaml
      config.swagger_docs = @docs
    end
  end
end

def swagger(&block)
  swagger_config = SwaggerConfig.new
  swagger_config.instance_exec(&block)
  swagger_config.config
end
