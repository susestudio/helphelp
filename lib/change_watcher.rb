class ChangeWatcher
  
  def initialize dir
    if !File.exists? dir
      raise StandardError.new "Directory '#{dir}' not found"
    end
    if !File.directory? dir
      raise StandardError.new "'#{dir}' is not a directory"
    end
    @meta_file = dir + "/.change_watcher"

    @checksum = Hash.new
    
    load    
  end
  
  def run_if_changed input_file
    if !File.exists? input_file
      raise StandardError.new "File #{input_file} not found"
    end
    
    md5sum = `md5sum #{input_file}`.split.first
    if @checksum[input_file] != md5sum
      yield
      @checksum[input_file] = md5sum
    end
  end
  
  def load
    @checksum.clear
    if File.exists? @meta_file
      File.open(@meta_file).each_line do |line|
        @checksum[line.split[0]] = line.split[1]
      end
    end
  end
  
  def save
    File.open(@meta_file,"w") do |file|
      @checksum.each do |key,value|
        file.puts "#{key} #{value}"
      end
    end
  end
  
end
