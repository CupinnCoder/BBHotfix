Pod::Spec.new do |s|
  s.name         = "BBHotfix"
  s.version      = "0.0.1"
  s.summary      = "iOS hotfix框架"
  s.homepage     = "https://github.com/CupinnCoder/BBHotfix"
  s.license      = "Copyright (C) 2016 Gary, Inc.  All rights reserved."
  s.author             = { "zhuguanyu" => "zhuguanyu.cn" }
  s.social_media_url   = "http://www.cupinn.com"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/CupinnCoder/BBHotfix.git"}
  s.source_files  = "BBHotfix/BBHotfix/**/*.{h,m,c}"
  s.requires_arc = true
  s.dependency 'JSPatch'
end
