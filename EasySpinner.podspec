Pod::Spec.new do |spec|

  spec.name         = "EasySpinner"
  spec.version      = "1.0.0"
  spec.summary      = "A simple UIView subclass which can be used in place of UIActivityIndicatorView"

  spec.description  = <<-DESC
  EasySpinner is a UIView subclass which can be used as an activity indicator. It provides a multitude of customization options such as animation duration, layer color, dot color, dot scale, etc.
                   DESC

  spec.homepage     = "https://github.com/DomBabic/EasySpinner"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author       = { "Dominik Babić" => "domynick93@hotmail.com" }
  spec.platform     = :ios, "10.0"
  spec.swift_version = '5.0'

  spec.source       = { :git => "https://github.com/DomBabic/EasySpinner.git", :tag => spec.version }
  spec.source_files  = "EasySpinner", "EasySpinner/**/*.{h,m}"

end
