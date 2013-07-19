class Document
  SOURCE_DIR = Rails.root + "app/documents"

  def self.from_issue_number(issue_number)
    volume, issue, part = issue_number.split(".")
    
    identifier = "v#{volume}/#{issue.rjust(3, '0')}"
    identifier << ".#{part}" if part

    filename = Dir.glob(Rails.root + "#{SOURCE_DIR}/#{identifier}*.md").first

    new(File.read(filename))
  end

  def initialize(raw_text)
    @body = MdPreview::Parser.parse(raw_text)
  end

  attr_reader :body
end
