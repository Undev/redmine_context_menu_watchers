require 'redmine'

unless Redmine::Plugin.registered_plugins.keys.include?(:redmine_context_menu_watchers)
	Redmine::Plugin.register :redmine_context_menu_watchers do
	  name 'Context menu watchers plugin'
	  author 'Vitaly Klimov'
	  author_url 'mailto:vitaly.klimov@snowbirdgames.com'
	  description 'Plugin adds watch/unwatch menu items to context menu'
	  version '0.0.3'

    requires_redmine :version_or_higher => '1.3.0'

	end

	require 'ctxt_menu_watchers_hooks'

end

