class Output

  def initialize input_repo
    @input_repo = input_repo
    
    @content_width = 600
  end

  def create output_dir
    @output_dir = output_dir
    
    if !File.exists? output_dir
      Dir::mkdir output_dir
    end

    public_source_dir = File.expand_path("_view/public", @input_repo )
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

    @root_page = Page.new
    @root_page.directory_path = @output_path
    @root_page.level = -1
    
    process_directory @input_repo, @root_page

    postprocess_page @root_page
    
    create_pages @root_page
  end

  def postprocess_page parent_page
    parent_page.postprocess
    parent_page.children.each do |page|
      postprocess_page page
    end
  end
  
  def process_directory dir, parent_page
    Dir.entries( dir ).sort.each do |entry|
      if entry =~ /^\d\d\d_(.*)$/
        input_name = $1
        full_name = input_path + "/" + entry
        if File.directory?( full_name )
          @input_path.push entry
          @output_path.push input_name
          if !File.exists? output_path
            Dir.mkdir output_path
          end

          page = Page.new
          parent_page.add_child page
          page.directory_path = full_name
          
          process_directory full_name, page
          @input_path.pop
          @output_path.pop
        else
          file_basename = nil
          file_format = nil
          if input_name =~ /^(.*)\.(.*)$/
            file_basename = $1
            file_format = $2
            if file_format != "md"
              raise ParseError "Unsupported format '#{file_format}' in file " +
                "#{input_name}."
            end
          else
            raise ParseError "Input file #{input_name} doesn't have an
extension."
          end

          page = nil
          if file_basename == "index"
            page = parent_page
          else
            page = Page.new
            parent_page.add_child page
          end

          page.file_basename = file_basename
          page.path = input_path + "/" + entry
          page.content = File.read( input_path + "/" + entry )
          page.file_format = file_format

          output_file_name = file_basename + ".html"
          if ( @output_path.empty? )
            page.target = output_file_name
          else
            page.target = @output_path.join( "/" ) + "/" + output_file_name
          end
          page.output_file = output_path + "/" + output_file_name
        end
      elsif entry =~ /.*\.png$/
        cmd = "cp #{input_path}/#{entry} #{output_path}/#{entry}"
        system cmd
        cmd = "mogrify -resize #{@content_width}x5000 #{output_path}/#{entry}"
        STDERR.puts "MOGRIFY: #{cmd}"
        system cmd
      end
    end
  end

    def create_pages parent_page
    parent_page.children.each do |page|
      if page.content
        create_page page
      end
      create_pages page
    end
  end

  def input_path
    @input_repo + "/" + @input_path.join( "/" )
  end
  
  def output_path
    @output_dir + "/" + @output_path.join( "/" )
  end
  
  def create_page page
    puts "CREATE PAGE #{page.path} #{page.output_file}"
    @page = page
    create_file "_view/template.haml", page.output_file
  end
  
  def create_file template_name, output_filename
    template = File.read File.expand_path(template_name, @input_repo )
    engine = Haml::Engine.new template
    
    File.open output_filename, "w" do |file|
      file.puts engine.render( binding )
    end
  end

  def css name
    "<link rel='stylesheet' href='#{@page.relative_site_root}public/#{name}.css'" + 
    " type='text/css'>"
  end

  def title
    @page.title
  end
  
  def render_content
    @out = ""

    doc = Maruku.new @page.content
    o doc.to_html

    @out
  end

  def render_toc
    @out = ""

    on "<h1>Table of contents</h1>"
    render_toc_section @root_page

    @out
  end
  
  def render_toc_section parent_page
    on "<ul>"
    parent_page.children.each do |page|
      o "<li>"
      title = page.title
      if page.has_children?
        title += " >"
      end
      if page == @page
        o "<span class=\"current-page\">#{title}</span>"
      else
        if page.title && !page.title.empty?
          o "<a href='#{@page.relative_site_root}#{page.target}'>#{title}</a>"
        end
      end
      on "</li>"
      if @page == page || ( page.has_children? && @page.has_parent( page ) )
        render_toc_section page
      end
    end
    on "</ul>"
  end
    
  protected
  
  def o txt
    @out += txt.to_s
  end

  def on txt
    o txt + "\n"
  end
  
end
