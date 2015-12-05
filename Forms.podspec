#
# Be sure to run `pod lib lint APIClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Forms"
  s.version          = "0.1.0"
  s.summary          = "Form UI Classes."  
  s.description      = "Form Elements, Form UI"
  s.homepage         = "https://github.com/mark-randall/Forms"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "mrandall" => "mark@markisgood.com" }
  s.source           = { :git => "https://github.com/mark-randall/Forms.git", :tag => s.version }
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/*.swift'
 
  s.module_name = 'Forms'
end
