require File.expand_path('../test_helper', __FILE__)

class PageTest < Test::Unit::TestCase

  def test_title
    p = Page.new
    p.content = "# Hallo"
    
    assert_equal "Hallo", p.title
  end

  def test_preprocess
    content = ""
    content += "# My Title\n"
    content += "\n"
    content += "Some text"
    content += "\n"
    content += "## Sub Title\n"
    content += "\n"
    content += "# Sneaky wrong title"
    
    p = Page.new
    p.content = content
    
    assert_equal content, p.content
    assert_equal "My Title", p.title
  end
  
end
