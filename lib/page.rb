class Page

  attr_accessor :children, :directory_path, :path, :target, :level,
    :file_format, :output_file
  attr_reader :content, :title
  
  def initialize
    @level = 0
    @children = Array.new
  end

  def add_child child
    @children.push child
    child.level = self.level + 1
  end
  
  def has_children?
    !@children.empty?
  end

  def content= content
    @content = preprocess content
  end

  protected
  
  def preprocess content
    out = ""
    content.each_line do |line|
      out += line
      if !@title && line =~ /^# (.*)$/
        @title = $1
      end
    end
    out
  end
  
end
