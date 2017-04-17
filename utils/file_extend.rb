require 'pathname'

class File
    def self.file_same? file_path1, file_path2
        # todo
    end

    def self.read_all_lines file_name
        File.readlines(file_name).join('\n')
    end
end
