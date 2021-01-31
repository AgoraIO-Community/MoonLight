#
#  Be sure to run `pod spec lint MoonLight_macOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "MoonLight_macOS"
  spec.version      = "2.0.4"
  spec.summary      = "MoonLight_macOS is a Performance Test Kit for macOS."
  spec.description  = <<-DESC
	MoonLight is a performance test kit on iOS and macOS. It can capture App Memory, App CPU, System CPU and GPU accurately and easily.
                   DESC
  spec.homepage     = "https://github.com/AgoraIO-Community/MoonLight"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "LiuJunJie" => "liujunjie@agora.io" }
  spec.platform     = :osx, "10.11"  
  spec.source       = { :git => "https://github.com/AgoraIO-Community/MoonLight.git", :tag => "#{spec.version}" }
  spec.source_files = "MoonLight_macOS/**/**/*"
  spec.public_header_files = ['MoonLight_macOS/MoonLight/*.h', 'MoonLight_macOS/MoonLight/AppCPU/*.h', 'MoonLight_macOS/MoonLight/AppMemory/*.h', 'MoonLight_macOS/MoonLight/MacGPU/*.h', 'MoonLight_macOS/MoonLight/SystemCPU/*.h']
  spec.requires_arc = true

end
