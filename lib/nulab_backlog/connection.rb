require 'forwardable'
require 'json'
require 'faraday'

module NulabBacklog
  class Connection
    def initialize(uri:, api_key:)
      @connection = Faraday.new(uri, request: {params_encoder: ParamsEncoder})
      @api_key = api_key
    end

    def request_json(method: :get, path: , params: nil, body: nil, headers: {})
      response = request(method: method, path: path, params: params, body: body, headers: headers)
      case res = JSON.load(response.body)
      when Array
        res.map {|project_params| underscore_keys(project_params)}
      when Hash
        underscore_keys(res)
      else
        raise "Unknown response type: #{res.class}"
      end
    end

    def request(method: :get, path: , params: nil, body: nil, headers: {})
      response = @connection.run_request(method, path, body, headers) {|request|
        request.params.update(camelize_keys(params)) if params
        request.params['apiKey'] ||= @api_key
      }
      if response.status != 200
        raise response.inspect
      end
      response
    end

    def camelize_keys(hash)
      hash.inject({}) {|ps, (key, value)|
        valur = value.camelize if key == "sort"
        ps[key.to_s.camelize(:lower)] = value
        ps
      }
    end

    def underscore_keys(hash)
      hash.inject({}) {|ps, (key, value)|
        value = value.map {|v| underscore_keys(v)} if value.kind_of? Array
        value = underscore_keys(value) if value.kind_of? Hash
        value = value.underscore if key == 'field'
        ps[key.to_s.underscore] = value
        ps
      }
    end

    module ParamsEncoder
      class << self
        extend Forwardable
        def_delegators :'Faraday::NestedParamsEncoder', :escape, :unescape, :decode

        def encode(params)
          return nil if params == nil

          if !params.is_a?(Array)
            if !params.respond_to?(:to_hash)
              raise TypeError,
                "Can't convert #{params.class} into Hash."
            end
            params = params.to_hash
            params = params.map do |key, value|
              key = key.to_s if key.kind_of?(Symbol)
              [key, value]
            end
            # Useful default for OAuth and caching.
            # Only to be used for non-Array inputs. Arrays should preserve order.
            params.sort!
          end

          # Helper lambda
          to_query = lambda do |parent, value|
            if value.is_a?(Hash)
              value = value.map do |key, val|
                key = escape(key)
                [key, val]
              end
              value.sort!
              buffer = ""
              value.each do |key, val|
                new_parent = "#{parent}[#{key}]"
                buffer << "#{to_query.call(new_parent, val)}&"
              end
              return buffer.chop
            elsif value.is_a?(Array)
              buffer = ""
              value.each_with_index do |val, i|
                new_parent = "#{parent}[]"
                buffer << "#{to_query.call(new_parent, val)}&"
              end
              return buffer.chop
            else
              encoded_value = escape(value)
              return "#{parent}=#{encoded_value}"
            end
          end

          # The params have form [['key1', 'value1'], ['key2', 'value2']].
          buffer = ''
          params.each do |parent, value|
            encoded_parent = escape(parent)
            buffer << "#{to_query.call(encoded_parent, value)}&"
          end
          return buffer.chop
        end
      end
    end
  end
end
