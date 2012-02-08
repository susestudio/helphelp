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
  
  def test_has_parent
    parent = Page.new
    child1 = Page.new
    parent.add_child child1
    child2 = Page.new
    parent.add_child child2
    grandchild11 = Page.new
    child1.add_child grandchild11
    grandchild12 = Page.new
    child1.add_child grandchild12
    grandchild21 = Page.new
    child2.add_child grandchild21
    
    assert_equal true, child1.has_parent( parent )
    assert_equal true, child2.has_parent( parent )
    assert_equal true, grandchild11.has_parent( child1 )
    assert_equal false, grandchild11.has_parent( child2 )
    assert_equal true, grandchild11.has_parent( parent )
    assert_equal true, grandchild12.has_parent( child1 )
    assert_equal true, grandchild12.has_parent( parent )
    assert_equal false, grandchild12.has_parent( child2 )
    assert_equal true, grandchild12.has_parent( child1 )
    assert_equal true, grandchild21.has_parent( child2 )
    assert_equal false, grandchild21.has_parent( child1 )
    assert_equal true, grandchild21.has_parent( parent )    
  end
  
end
