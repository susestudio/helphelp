require File.expand_path('../test_helper', __FILE__)

class ChangeWatcherTest < Test::Unit::TestCase

  def test_run_if_modified
    test_dir = "/var/tmp/helphelp-test"
    
    FileUtils.mkdir_p test_dir
    
    input_file = test_dir + "/testfile"
    
    File.open( input_file, "w") do |file|
      file.puts "Test data"
    end
    
    w = ChangeWatcher.new test_dir

    ran = false
    w.run_if_changed input_file do
      ran = true
    end
    
    assert ran
    
    ran = false    
    w.run_if_changed input_file do
      ran = true
    end

    assert !ran

    File.open( input_file, "w") do |file|
      file.puts "Test data 2"
    end

    ran = false    
    w.run_if_changed input_file do
      ran = true
    end

    assert ran

    w.save
    
    w = ChangeWatcher.new test_dir

    ran = false    
    w.run_if_changed input_file do
      ran = true
    end

    assert !ran
    
    File.open( input_file, "w") do |file|
      file.puts "Test data 3"
    end

    ran = false    
    w.run_if_changed input_file do
      ran = true
    end

    assert ran
  end
  
end
