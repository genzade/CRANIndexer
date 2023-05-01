# frozen_string_literal: true

class ControlFileParser < DebControl::ControlFileBase
  def self.parse_paragraph(lines)
    # Force the encoding to UTF-8 to ensure that the data is properly parsed
    # and can be saved to the database.
    lines = lines.map do |line|
      line.encode!("UTF-8", "ISO-8859-1")
    end

    super(lines)
  end
end
