Pod::Spec.new do |s|
  s.name                  = "ABMultiton"
  s.version               = "2.1.1"
  s.summary               = "Multiton is a better alternative to singleton."
  s.homepage              = "https://github.com/belkevich/multiton"
  s.social_media_url      = 'https://twitter.com/okolodev'
  s.license               = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author                = { "Alexey Belkevich" => "belkevich.alexey@gmail.com" }
  s.source                = { :git => "https://github.com/belkevich/multiton.git", :tag => s.version.to_s }
  s.requires_arc          = true

  s.ios.deployment_target      = "5.0"
  s.osx.deployment_target      = "10.7"
  s.watchos.deployment_target  = '2.0'
  s.tvos.deployment_target     = '9.0'

  s.subspec 'Core' do |ss|
    ss.source_files = 'ABMultiton/P*/*.{h,m}'
  end

  s.subspec 'SetInstance' do |ss|
    ss.dependency 'ABMultiton/Core'
    ss.source_files = 'ABMultiton/Subspecs/*.{h,m}'
  end

  s.subspec 'All' do |ss|
    ss.dependency 'ABMultiton/Core'
    ss.dependency 'ABMultiton/SetInstance'
  end

  s.default_subspec = 'Core'

end
