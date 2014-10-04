module NulabBacklog
  module App
    class Issues < Base
      def run
        $stderr.puts "Loading #{myself.name}'s issues..."

        projectIds = Project.all.collect(&:id)
        issues = Issue.all('project_id' => projectIds, 'status_id' => [1, 2, 3], 'assignee_id' => [myself.id]).sort_by(&:due_date)
        url_width = issues.map {|issue| issue.issue_key.length}.max + "https://#{Model.space_key}.backlog.jp/view/".length
        today_output = false
        today = Date.today
        puts "#{issues.length} issues are assigned"
        puts ''
        issues.each do |issue|
          due_date = if issue.due_date.empty?
                       '(N/A)  '
                     else
                       date = Date.parse(issue.due_date)
                       "(%02d/%02d)" % [date.month, date.day]
                     end
          if date and !today_output and date > today
            today_output = true
            puts "------------ TODAY(#{today}) ------------"
          end
          puts [due_date, "https://#{space_key}.backlog.jp/view/#{issue.issue_key}".ljust(url_width), issue.summary].join(' ')
        end
      end
    end
  end
end
