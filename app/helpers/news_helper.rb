module NewsHelper
  def format_extended(extended)
    return '' if extended.nil?
    extended.sub(/\r?\n\r?\n/, "</p>\n\n<p>")
  end
end
