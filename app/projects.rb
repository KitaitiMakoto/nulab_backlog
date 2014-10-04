module NulabBacklog
  module App
    class Projects < Base
      def run
        projects = Project.all.map {|project|
          name = project.delete_field(:name)
          project_key = project.delete_field(:project_key)
          project.title_field = "#{name}(#{project_key})"
          project
        }
        title_field_length = projects.max {|p, q| p.title_field <=> q.title_field}.title_field.length + 1
        projects.each do |project|
          title_field = project.delete_field(:title_field)
          print title_field.ljust(title_field_length), ' ', project.each_pair.map {|k, v| "#{k}=#{v}"}.join(' '), "\n"
        end
      end
    end
  end
end
