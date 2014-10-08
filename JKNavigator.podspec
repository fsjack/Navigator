Pod::Spec.new do |s|
  s.name         = 'JKNavigator'
  s.platform     = :ios, '5.0'
  s.summary      = 'Application Routing Map'
  s.version      = '1.0.0'
  s.author       = { "Jackie" => "fsjack@gmil.com" }

  s.homepage     = "https://github.com/fsjack/Navigator" 
  s.source       = { :git => "https://github.com/fsjack/Navigator.git", :tag => '1.0.1'}
  s.source_files = 'Navigator/**/*.{h,m}'
  s.resources = '**/*.{xib}'
  s.license      = 'MIT'

  s.requires_arc = true
  s.dependency 'CTObjectiveCRuntimeAdditions'
end
