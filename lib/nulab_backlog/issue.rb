require 'nulab_backlog/model'

module NulabBacklog
  class Issue < Model
    def project
      self[:project] ||= Project.find(id)
    end
  end
end
