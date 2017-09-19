Pod::Spec.new do |s|
  s.name           =  'GKImagePicker'
  s.version        =  '0.1.0'
  s.license        =  'MIT'
  s.platform       =  :ios, '9.0'
  s.summary        =  'Image Picker with support for custom crop areas.'
  s.description    =  'Ever wanted a custom crop area for the UIImagePickerController?' \
                      'Now you can have it with GKImagePicker. Just set your custom'    \
                      'crop area and thats it. Just 4 lines of code. If you dont'       \
                      'set it it uses the same crop area as the default'                \
                      'UIImagePickerController.'
  s.homepage       =  'https://github.com/gekitz/GKImagePicker'
  s.author         =  { 'Georg Kitz' => 'info@aurora-apps.com' }
  s.source         =  { :git => 'https://github.com/animeshp/GKImagePicker.git', :commit => '5d57319bb3f1b5b794baf6d7df8d1d1cda4f81fd' }
  s.resources      =  'GKImages/*.png'
  s.source_files   =  'GKClasses/*.{h,m}'
  s.preserve_paths =  'GKClasses', 'GKImages'
  s.frameworks     =  'UIKit'
  s.requires_arc   =  true
end
