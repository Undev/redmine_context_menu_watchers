# Redmine Watchers Context Menu Plugin 

This plugin enables you to perform watchers-related batch operations in Redmine.

## Compatibility

This plugin version is compatible with Redmine 1.3.0 and later.

## Installation

*These installation instructions are based on Redmine 2.6.0. For instructions for previous versions, see [Redmine wiki](http://www.redmine.org/projects/redmine/wiki/Plugins).*

1. To install the plugin
    * Download the .ZIP archive, extract files and copy the plugin directory into #{REDMINE_ROOT}/plugins.
    
    Or

    * Change you current directory to your Redmine root directory:  

            cd {REDMINE_ROOT}
            
      Copy the plugin from GitHub using the following commands:
      
            git clone https://github.com/Undev/redmine_context_menu_watchers.git plugins/redmine_context_menu_watchers

2. Update the Gemfile.lock file by running the following commands:  

         rm Gemfile.lock  
         bundle install
            
3. Restart Redmine.

Now you should be able to see the plugin in **Administration > Plugins**.

## Usage

The plugin extends the issue context menu with several watchers-related items that allow you to perform batch operations on the selected issues:  
![watchers context menu](watchers_context_menu_1.PNG)

* **Add watchers** - allows you to select project members to be added as watchers of the selected issues.
* **Delete watchers** - allows you to select project members to be removed from the list of watchers of the selected issues.

All the issues selected for the **Add watchers** / **Delete watchers** batch operations must belong to the same project. Clicking **Add watchers** or **Delete watchers** opens a new Redmine page where all project members are listed:  
![watchers to add](watchers_context_menu_2.PNG)

To be able to add or delete watchers, you should have the appropriate watchers-related permissions:  
![watchers permissions](watchers_context_menu_3.PNG)

