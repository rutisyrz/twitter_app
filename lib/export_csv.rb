require 'csv'

class ExportCsv

  def initialize(file_path, headers, content)
    @file_path = file_path
    @headers = headers
    @content = content
  end

  def save
    @file = CSV.open(@file_path, 'w', :force_quotes => true)
    write_headers
    write_content
    @file.close
  end

  private

  def write_headers
    @file << @headers
  end

  def write_content
    @content.each { |row| @file << row }
  end

end