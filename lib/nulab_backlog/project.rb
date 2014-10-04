require 'active_support/inflector'
require 'nulab_backlog/model'
require 'nulab_backlog/wiki'

module NulabBacklog
  class Project < Model
    def wikis
      self[:wikis] ||= Wiki.all(project_id_or_key: id).each {|wiki|
        wiki.project = self
      }
    end

    def issues
      self[:issues] ||= Issue.all(project_id: [id]).each {|issue|
        issue.project = self
      }
    end
  end
end
