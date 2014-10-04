require 'nulab_backlog/model'
require 'nulab_backlog/project'

module NulabBacklog
  class Wiki < Model
    def project
      self[:project] ||= Project.find(project_id)
    end
  end
end
