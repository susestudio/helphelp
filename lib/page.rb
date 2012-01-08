class Page

  attr_accessor :children, :directory_path, :path, :target, :title, :level
  
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

end
