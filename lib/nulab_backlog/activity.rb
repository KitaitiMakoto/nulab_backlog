require 'nulab_backlog/model'

module NulabBacklog
  class Activity < Model
    class << self
      def end_point_name
        @end_point_name ||= 'space/' + super
      end
    end
  end
end
