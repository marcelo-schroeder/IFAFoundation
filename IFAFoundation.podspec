Pod::Spec.new do |s|
    s.name              = 'IFAFoundation'
    s.version           = '1.0.0'
    s.summary           = 'A Cocoa Touch framework to help you develop high quality iOS apps and app extensions faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/IFAFoundation'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/IFAFoundation.git', :tag => 'v1.0.0' }
    s.source_files      = 'IFAFoundation/IFAFoundation/classes/**/*.{h,m}'
end
