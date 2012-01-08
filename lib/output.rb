class Output

  def initialize input_repo
    @input_repo = input_repo
  end

  def create output_dir
    @output_dir = output_dir
    
    if !File.exists? output_dir
      Dir::mkdir output_dir
    end

    public_source_dir = File.expand_path("../../view/public", __FILE__)
    if File.exists? public_source_dir
      public_dir = File.expand_path( "public", output_dir )
      if !File.exists? public_dir
        Dir::mkdir public_dir
      end

      cmd = "cp #{public_source_dir}/* #{public_dir}"
      system cmd
    end
    
    @input_path = Array.new
    @output_path = Array.new
    
    process_directory @input_repo
  end

  def process_directory dir
    Dir.foreach dir do |entry|
      if entry =~ /^\d\d\d_(.*)$/
        input_name = $1
        full_name = input_path + "/" + entry
        if File.directory?( full_name )
          @input_path.push entry
          @output_path.push input_name
          if !File.exists? output_path
            Dir.mkdir output_path
          end
          process_directory full_name
          @input_path.pop
          @output_path.pop
        else
          @content = File.read( input_path + "/" + entry )          
          create_file input_name
        end
      elsif entry =~ /.*\.png$/
        cmd = "cp #{input_path}/#{entry} #{output_path}/#{entry}"
        system cmd
      end
    end
  end

  def input_path
    @input_repo + "/" + @input_path.join( "/" )
  end
  
  def output_path
    @output_dir + "/" + @output_path.join( "/" )
  end
  
  def create_file input_name
    if input_name =~ /^(.*)\.(.*)$/
      file_basename = $1
      file_format = $2
      if file_format != "md"
        raise ParseError "Unsupported format '#{file_format}' in file " +
          "#{input_name}."
      end      
    else
      raise ParseError "Input file #{input_name} doesn't have an extension."
    end

    template_name = "../../view/template.haml"
    template = File.read File.expand_path(template_name, __FILE__)
    engine = Haml::Engine.new template

    output_filename = output_path + "/" + file_basename + ".html"
    
    File.open output_filename, "w" do |file|
      file.puts engine.render( binding )
    end
  end
  
  def css
    File.read File.expand_path("../../view/helphelp.css",__FILE__)
  end

  def title
    # FIXME: Extract title from page
    "SUSE Studio Online Help"
  end
  
  def render_content
    @out = ""

    doc = Maruku.new @content
    o doc.to_html

    @out
  end

  protected
  
  def o txt
    @out += txt.to_s
  end

  def on txt
    o txt + "\n"
  end
  
end
