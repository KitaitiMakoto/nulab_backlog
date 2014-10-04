require 'ostruct'
require 'active_model'
require 'active_support/concern'
require 'active_support/inflector'
require 'nulab_backlog/connection'

module NulabBacklog
  class Model < OpenStruct
    include ActiveModel
    extend ActiveSupport::Concern

    BASE_URI_TEMPLATE = 'https://%s.backlog.jp'.freeze
    PATH_PREFIX = '/api/v2/'.freeze

    def connection
      self.class.connection
    end

    def space_key
      self.class.space_key
    end

    def api_key
      self.class.api_key
    end

    def end_point_name
      self.class.end_point_name
    end

    def end_point
      self.class.end_point + "/#{id}"
    end

    def load_detail
      connection.request_json(path: end_point).each_pair do |key, value|
        self[key] = value
      end
      self
    end

    module ClassMethods
      def setup_connection(space_key:, api_key:)
        @@connection = Connection.new(uri: (BASE_URI_TEMPLATE % space_key), api_key: api_key)
        @@space_key = space_key
        @@api_key = api_key
      end

      def space_key
        @@space_key
      end

      def api_key
        @@api_key
      end

      def connection
        @@connection
      end

      def all(params = {})
        connection.request_json(path: end_point, params: params).map {|project_params| new(project_params)}
      end

      def find(id)
        new(connection.request_json(path: end_point + "/#{id}"))
      end

      def end_point_name
        @end_point_name ||= self.to_s.demodulize.underscore.pluralize
      end

      def end_point
        PATH_PREFIX + end_point_name
      end
    end
    extend ClassMethods
  end
end
