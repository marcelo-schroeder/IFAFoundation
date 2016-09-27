Pod::Spec.new do |s|
    s.name              = 'IFAFoundation'
    s.version           = '2.0.0'
    s.summary           = 'Collection of enhancements on top of Cocoa Touch foundation frameworks for iOS apps and app extensions.'
    s.homepage          = 'https://github.com/marcelo-schroeder/IFAFoundation'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '9.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/IFAFoundation.git', :tag => 'v' +  s.version.to_s }
    s.source_files      = 'IFAFoundation/IFAFoundation/classes/**/*.{h,m}'
end
