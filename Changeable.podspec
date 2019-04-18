Pod::Spec.new do |s|
  s.name         = "Changeable"
  s.version      = "0.5"
  s.summary      = "Simple framework that allows to explicitly follow and observe changes made in an object/value."
  s.description  = <<-DESC
    Changable is a wrapper on an object regardless if it will be class or struct that can be changed using one exposed method set. What makes it different that normal set is that all of the changes made using set method won't be immediately applied but after using commit method. To fully cover needs Changeable also allows you to reset pending changes by reset method.
  DESC
  s.homepage     = "https://github.com/nonameplum/Changeable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Łukasz Śliwiński" => "sliwinski.lukas@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/nonameplum/Changeable.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
end
