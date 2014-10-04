require 'nulab_backlog'

module NulabBacklog
  module App
    class Base
      def initialize(space_key:, api_key:)
        Model.setup_connection space_key: space_key, api_key: api_key
      end

      def space_key
        Model.space_key
      end

      def myself
        @myself ||= User.myself
      end
    end
  end
end

require_relative 'projects'
require_relative 'issues'
require_relative 'backup_wikis'
