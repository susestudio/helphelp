require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name              = "helphelp"
  s.version           = Helphelp::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Online help generator"
  s.homepage          = "http://github.com/susestudio/helphelp"
  s.email             = "cschum@suse.de"
  s.authors           = [ "Cornelius Schumacher" ]
  s.has_rdoc          = false

  s.files             = %w( README Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("view/**/*")
  s.files            += Dir.glob("test/**/*")

  s.executables       = %w( helphelp )
  s.description       = <<desc
Generator for turning a directory hierarchy of markdown files into a static
set of HTML pages. It's targeted at providing online help for web application.
desc

  s.add_dependency "maruku"
  s.add_dependency "haml"
end
