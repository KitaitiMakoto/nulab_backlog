require 'nulab_backlog/model'

module NulabBacklog
  class Notification < Model
    class << self
      undef :all

      def find
        new(connection.request_json(path: end_point))
      end

      def end_point_name
        @end_point_name ||= '/space/' + self.to_s.demodulize.underscore
      end
    end
  end
end
