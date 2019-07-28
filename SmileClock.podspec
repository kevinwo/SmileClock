Pod::Spec.new do |s|
  s.name         = "SmileClock"
  s.version      = "0.0.1"
  s.summary      = "A library for make Clock UI simple."
  s.description  = <<-DESC
                   1. Live rendering in Storyboard.
                   2. Support customize Clock UI.
                   3. Data model easy to use.
                   DESC

  s.homepage     = "https://github.com/liu044100/SmileClock"
  s.screenshots  = "https://raw.githubusercontent.com/liu044100/SmileClock/master/SmileClock-Example/demo_gif/pro_banner.jpg"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { 'Rain' => 'liu044100@gmail.com' }
  s.social_media_url   = "https://dribbble.com/yuchenliu"


  s.platform     = :ios, '11.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/liu044100/SmileClock.git", :tag => s.version.to_s}
  s.source_files  = 'SmileClock/Classes/*.{swift}'
  s.frameworks = 'UIKit'
  s.swift_version = '5.0'

end
