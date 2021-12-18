class CameoCommentController < ApplicationController
  unloadable

  def check
    projectId = Setting.plugin_cameo_comment['project_id']
    project = Project.find(projectId)
    if User.current.allowed_to?(:view_issues, project, :global => true)
      respond_to do |format|
        format.json { render plain: '{ "status": "Success" }' }
        format.text { render plain: 'success' }
        format.html { render plain: "Success" }
      end
    else
      respond_to do |format|
        format.json { render plain: "unauthorized", status: 401 }
        format.text { render plain: "unauthorized", status: 401 }
        format.html { render plain: "unauthorized", status: 401 }
      end      
    end
  end

  def create
    projectId = Setting.plugin_cameo_comment['project_id']
    project = Project.find(projectId)
    unless project
      raise ::Unauthorized
    end
    
    unless User.current.allowed_to?(:add_issues, project, :global => true)
      raise ::Unauthorized
    end
    
    tracker = Tracker.find(Setting.plugin_cameo_comment['tracker_id'])
    unless tracker
      raise ::Unauthorized
    end
    
    title = params[:contentTitle].empty? ? 'General' : params[:contentTitle]          
    subject = "#{title}: #{params[:commentSummary]}"

    link = params[:url]
    if link[0] == '#'
      url = "/model/index.html#{link}"
    else
      url = link
    end      
    
    description = <<EOT
# Topic: #{title}

## Comment

#{params[:comment]}

## Link to Model

[#{title}](#{url})

EOT
    
    @issue = Issue.new(:project => project,
                       :author => User.current,
                       :tracker => tracker,
                       :subject => subject,
                       :description => description)

    call_hook(:controller_issues_new_before_save, {:params => params, :issue => @issue})
    @issue.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))
    if @issue.save
      call_hook(:controller_issues_new_after_save, {:params => params, :issue => @issue})
      respond_to do |format|
        format.json { render plain: '{ "status": "Success" }' }
        format.text { render plain: 'success' }
        format.html { render plain: "Success" }
        format.api  {render_api_ok}
      end
    else
      respond_to do |format|
        format.json { render plain: "unauthorized", status: 401 }
        format.text { render plain: "unauthorized", status: 401 }
        format.html { render plain: "unauthorized", status: 401 }
        format.api  { render plain: "unauthorized", status: 401 }
      end      
    end
  end
end

