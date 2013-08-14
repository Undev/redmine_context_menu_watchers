
class ContextMenuWatchersController < ApplicationController
  unloadable

  before_filter :setup_environment
  #before_filter :authorize

  def watch_bulk
	  return unless @issues

	  @issues.each do |issue|
		  issue.set_watcher(User.current,params[:unwatch].blank? ? true : false) if (issue.respond_to?(:visible?) && issue.visible?(User.current)) || !issue.respond_to?(:visible?)
	  end
	  redirect_back_or_default({:controller => 'issues', :action => 'index', :project_id => params[:project_id]})
  end

	def manage_watchers_bulk
		return unless @issues && @issues.size > 0

		@project=@issues[0].project
		i=@issues.detect do |issue|
			true if issue.project!=@project
		end

		unless (params[:unwatch].blank? && User.current.allowed_to?(:add_issue_watchers,@project)) ||
			 (!params[:unwatch].blank? && User.current.allowed_to?(:delete_issue_watchers,@project))
			i=true
		end

		if i
			redirect_back_or_default({:controller => 'issues', :action => 'index', :project_id => params[:project_id]})
			return
		end
		if request.post?
			watcher_users=update_watchers_from_group_watchers(params['watcher_user_ids'],params['watcher_group_ids'])

			@issues.each do |issue|
				update_watchers_for_object(watcher_users,issue,params[:unwatch].blank? ? false : true)
			end

			redirect_back_or_default({:controller => 'issues', :action => 'index', :project_id => params[:project_id]})
			return
		else
			@users=[]
			if params[:unwatch].blank?
				@issues.each do |issue|
					@project.users.each do |user|
						@users << user if issue.watched_by?(user)
					end
				end
				@users.uniq!
			end
		end
	end
private

	def setup_environment
		unless params[:issues].blank?
			@issues=Issue.find_all_by_id(params[:issues])
		else
			@issues=nil
			redirect_back_or_default({:controller => 'issues', :action => 'index', :project_id => params[:project_id]})
		end
	end

  def update_watchers_from_group_watchers(watcher_user_ids,watcher_group_ids)
	  watcher_user_ids ||= []
	  if watcher_group_ids && watcher_group_ids.size > 0
		  watcher_group_ids.each do |wg|
			  grp=Group.find_by_id(wg.to_i)
			   if grp
					grp.users.each do |u|
						watcher_user_ids << u.id.to_s if u.active?
					end
				 end
		  end
		  watcher_user_ids.uniq!
	  end
	  watcher_users=[]
	  watcher_user_ids.each do |w|
		  u=User.find_by_id(w.to_i)
		  watcher_users << u if u
	  end
	  return watcher_users
  end

  def update_watchers_for_object(watcher_users,watched_object,unwatch=false)
	  return unless watched_object

	  watcher_users.each do |w|
		  if unwatch
			  watched_object.set_watcher(w,false) if watched_object.watched_by?(w)
		  else
			  unless watched_object.watched_by?(w)
				  watcher=Watcher.new({ 'user_id' => w.id.to_s })
				  watcher.watchable=watched_object
				  watcher.save
			  end
		  end
	  end
  end

end

