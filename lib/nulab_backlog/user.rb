require 'nulab_backlog/model'

module NulabBacklog
  class User < Model
    class << self
      def myself
        new(connection.request_json(path: end_point + '/myself'))
      end
    end

    def icon
      connection.request(path: end_point + '/icon')
    end
  end
end
