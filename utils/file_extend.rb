require 'pathname'

class File
    def self.file_same? file_path1, file_path2
        # todo
    end

    def self.read_all file_name
        content = ""
        File.readlines(file_name).each do |line|
            content << line
        end
        content
    end
end
