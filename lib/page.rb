class Page

  attr_accessor :children, :directory_path, :path, :target, :level,
    :file_format, :output_file, :parent, :file_basename
  attr_reader :content, :title
  
  def initialize
    @level = 0
    @children = Array.new
  end

  def add_child child
    @children.push child
    child.parent = self
    child.level = self.level + 1
  end
  
  def has_children?
    !@children.empty?
  end

  def has_parent p
    if self.parent == p
      return true
    else
      if self.parent.nil?
        return false
      else
        return self.parent.has_parent p
      end
    end
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
