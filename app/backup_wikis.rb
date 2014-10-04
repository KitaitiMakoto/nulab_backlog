require 'pathname'
require 'yaml'

module NulabBacklog
  module App
    class BackupWikis < Base
      def run(dir)
        dir = Pathname(dir).expand_path
        Project.all.each do |project|
          project_dir = dir + project.project_key
          project_dir.mkpath unless project_dir.directory?
          project.wikis.each do |wiki|
            filename = project_dir + normalize_filename(wiki.name)
            metadata_path = filename.sub_ext('.yaml')
            if metadata_path.file?
              old_metadata = YAML.load_file(metadata_path.to_path)
              old_metadata = Wiki.new(Model.connection.underscore_keys(old_metadata))
              last_updated = Time.parse(old_metadata.updated) rescue nil
              updated = Time.parse(wiki.updated) rescue nil
              next if last_updated and updated and last_updated >= updated
            end
            wiki.load_detail
            content = wiki.delete_field(:content)
            metadata_path.write(wiki.to_h.to_yaml)
            content_path = filename.sub_ext('.' + project.text_formatting_rule)
            content_path.write(content)
          end
        end
      end

      def normalize_filename(filename)
        filename.gsub(/\x0|\//, ':')
      end
    end
  end
end
