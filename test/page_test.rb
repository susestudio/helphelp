require File.expand_path('../test_helper', __FILE__)

class PageTest < Test::Unit::TestCase

  def test_title
    p = Page.new
    p.content = "# Hallo"
    
    assert_equal "Hallo", p.title
  end
  
end
