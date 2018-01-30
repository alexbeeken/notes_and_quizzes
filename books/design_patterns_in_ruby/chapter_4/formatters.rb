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

class PlainTextFormatter
  def output_report(title, text)
    puts "***** #{title} *****"
    text.each do |t|
      puts t
    end
  end
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really really well']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(@title, @text)
  end
end

puts 'html formatter'
report = Report.new(HTMLFormatter.new)
report.output_report

puts 'plain text formatter'
report = Report.new(PlainTextFormatter.new)
report.output_report

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really really well']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self)
  end
end


class HTMLFormatter < Formatter
  def output_report(context)
    puts '<html>'
    puts ' <head>'
    puts "  <title>#{context.title}</title>"
    puts ' <body>'
    context.text.each do |t|
      puts(" <p>#{t}</p>")
    end
    puts ' </body>'
    puts '</html>'
  end
end

class PlainTextFormatter
  def output_report(context)
    puts "***** #{context.title} *****"
    context.text.each do |t|
      puts t
    end
  end
end

class Report
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter)
    @title = 'Monthly Report'
    @text = ['Things are going', 'really really well']
    @formatter = formatter
  end

  def output_report
    @formatter.call(self)
  end
end

HTML_FORMATTER = lambda do |context|
  puts '<html>'
  puts ' <head>'
  puts "  <title>#{context.title}</title>"
  puts ' <body>'
  context.text.each do |t|
    puts(" <p>#{t}</p>")
  end
  puts ' </body>'
  puts '</html>'
end

PLAIN_TEXT_FORMATTER = lambda do |context|
  puts "***** #{context.title} *****"
  context.text.each do |t|
    puts t
  end
end

puts __LINE__

puts 'html formatter'
puts Report.new(&HTML_FORMATTER).output_report

puts 'plain text formatter'
puts Report.new(&PLAIN_TEXT_FORMATTER).output_report

# the advantage of this is that we can pass a block right in

report = Report.new do |context|
  puts "%^%^%^ #{context.title} %^%^%^"
  context.text.each do |t|
    puts '----'
    puts t
    puts '----'
  end
  puts 'END OF SPECIAL ANONYMOUS FORMATTER'
end

puts report.output_report
