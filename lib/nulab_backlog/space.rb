require 'nulab_backlog/model'
require 'nulab_backlog/file'

module NulabBacklog
  class Space < Model
    class << self
      undef :all

      def find
        new(connection.request_json(path: end_point))
      end

      def image
        File.find(end_point: end_point + '/image')
      end

      def notification
        Notification.find
      end

      def disk_usage
        OpenStruct(connection.request_json(path: end_point + '/diskUsage'))
      end

      def end_point_name
        @end_point_name ||= self.to_s.demodulize.underscore
      end
    end
  end
end
