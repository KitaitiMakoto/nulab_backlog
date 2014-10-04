require 'nulab_backlog/model'

module NulabBacklog
  class File < Model
    class << self
      undef :all

      def find(end_point:)
        response = connection.request(path: end_point)
        file = new(content_type: response['Content-Type'], content_length: response['Content-Length'].to_i)
        match_data = /\Aattachment; *filename\*=(?<encoding>[^']*)(?:'(?<lang>[^']*)')*(?<filename>.*)/.match(response['Content-Disposition'])
        file.encoding = match_data['encoding']
        file.lang = match_data['lang'] if match_data['lang'] and !match_data['lang'].empty?
        file.filename = match_data['filename']
        file.body = response.body
        file
      end
    end
  end
end
