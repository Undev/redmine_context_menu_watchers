require 'context_menus_helper'

class IssuesCtxtMenuWatchersHelperHook < Redmine::Hook::ViewListener
  include ContextMenusHelper

  # * :issues
  # * :can
  # * :back
  def view_issues_context_menu_end(context={})

    ret_str=''

    watched_list=[]
    nonwatched_list=[]
    target_project=context[:issues][0].project
    menu_exists=false

    context[:issues].each do |issue|
	    if issue.author != User.current
				issue.watched_by?(User.current) ? watched_list << issue : nonwatched_list << issue
	    end
	    target_project=nil if target_project!=nil && issue.project!=target_project
    end

    ret_str << "<li class=\"folder\">"
    ret_str << "<a href=\"#\" class=\"submenu\" onclick=\"return false;\">#{l(:label_issue_watchers)}</a>"
    ret_str << '<ul>'

    if target_project && User.current.allowed_to?(:add_issue_watchers,target_project)
	    ret_str << "<li>#{context_menu_link("#{l(:permission_add_issue_watchers)}",
	                      {:controller => 'context_menu_watchers', :action => 'manage_watchers_bulk', :issues => context[:issues], :back_url => context[:back]})}</li>"
      menu_exists=true
    end

    if target_project && User.current.allowed_to?(:delete_issue_watchers,target_project)
      ret_str << "<li>#{context_menu_link("#{l(:permission_delete_issue_watchers)}",
	                      {:controller => 'context_menu_watchers', :action => 'manage_watchers_bulk', :unwatch => true, :issues => context[:issues], :back_url => context[:back]})}</li>"
      menu_exists=true
		end

    if nonwatched_list.size > 0
	    ret_str << "<li>#{context_menu_link("#{l(:button_watch)}",
	                      {:controller => 'context_menu_watchers', :action => 'watch_bulk', :issues => nonwatched_list.collect(&:id), :back_url => context[:back]},
	                      :class => 'icon icon-fav')}</li>"
	    menu_exists=true
    end
    if watched_list.size > 0
	    ret_str << "<li>#{context_menu_link("#{l(:button_unwatch)}",
	                      {:controller => 'context_menu_watchers', :action => 'watch_bulk', :issues => watched_list.collect(&:id), :back_url => context[:back], :unwatch => true},
	                      :class => 'icon icon-fav-off')}</li>"
	    menu_exists=true
    end

    ret_str << "</ul></li>"

    ret_str='' unless menu_exists

    return ret_str
  end

end


