class Page

  attr_accessor :children, :directory_path, :path, :target, :level,
    :content, :file_format, :output_file
  
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

  def title
    if !@title_processed && @content
      @content.each_line do |line|
        if line =~ /^# (.*)$/
          @title = $1
          break
        end
      end
      @title_processed = true
    end
    @title
  end
  
end
