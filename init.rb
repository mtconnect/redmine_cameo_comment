require 'redmine'

Redmine::Plugin.register :cameo_comment do
  name 'Cameo Comment plugin'
  author 'William Sobel'
  description 'Converts the Dessault MagicDraw Web Report Comment to create a new redmine issue'
  version '0.0.1'
  url 'https://github.com/mtconnect/cameo_comment'
  author_url 'mailto:will@metalogi.io'


  requires_redmine :version_or_higher => '4.0'
  
  settings :default => {
    'tracker_id' => nil,
    'project_id' => nil      
  }, :partial => 'settings/cameo_comment'
end


