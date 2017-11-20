Pod::Spec.new do |s|
  s.name         = "Changeable"
  s.version      = "0.1"
  s.summary      = "Simple framework that allows to explicitly follow and observe changes made in an object/value."
  s.description  = <<-DESC
    Simple framework that allows to explicitly follow and observe changes made in an object/value.
  DESC
  s.homepage     = "https://github.com/nonameplum/Changeable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Łukasz Śliwiński" => "sliwinski.lukas@gmail.com" }
  s.social_media_url   = ""
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/nonameplum/Changeable.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "Foundation"
end
