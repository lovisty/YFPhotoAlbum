#
# Be sure to run `pod lib lint BHPhotoAlbum.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "YFPhotoAlbum"
  s.version          = "1.0"
  s.summary          = "A Custome PhotoAlbum."
  s.description      = <<-DESC
                       A Custome PhotoAlbum Which Support AssetsLibrary And PhotoKit.
                       Support for single or multi.
                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/lovisty/YFPhotoAlbum"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Zhao Yafei" => "nihao1992@163.com" }
  s.source           = { :git => "https://github.com/lovisty/YFPhotoAlbum", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.{h,m}'
  s.resources = "Pod/Assets/*.png"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit','Photos','AssetsLibrary'
end
