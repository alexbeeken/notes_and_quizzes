class Formatter
  def output_report(title, text)
    raise 'Abstract method called'
  end
end

class HTMLFormatter < Formatter
  def output_report(title, text)
    puts '<html>'
    puts ' <head>'
    puts "  <title>#{title}</title>"
    puts ' <body>'
    text.each do |t|
      puts(" <p>#{t}</p>")
    end
    puts ' </body>'
    puts '</html>'
  end
end
