Pod::Spec.new do |s|
  s.name         = "FWTOverlayView"
  s.version      = "0.0.1"
  s.summary      = "FWTOverlayView extends scrollview and make it easy to add a floating overlay view."
  s.homepage     = "https://github.com/FutureWorkshops/FWTOverlayView"
  s.license      = { :type => 'Apache License Version 2.0', :file => 'LICENSE' }
  s.author       = { 'Marco Meschini' => 'marco@futureworkshops.com' }
  s.source       = { :git => "https://github.com/FutureWorkshops/FWTOverlayView.git", :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = 'FWTOverlayView/FWTOverlayView'
  s.framework    = 'QuartzCore'
end
