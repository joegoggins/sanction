##
# This file contains the principals, permissionables, and roles
# that define this configuration of Sanction.
#
Sanction.configure do |config|
  # Define your principals
  # config.principals = [Person]

  # Define your permissionables
  # config.permissionables = [Person, Magazine]

  # Define your roles
  # config.role :reader, Person => Magazine, :having => [:can_read]
  # config.role :editor, Person => Magazine, :having => [:can_edit],  :includes => [:reader]
  # config.role :writer, Person => Magazine, :having => [:can_write], :includes => [:reader]
  # config.role :owner,  Person => Magazine, :includes => [:editor, :writer]
  # config.role :boss,   Person => Person
  
  # If you are integrating with sanction_ui, don't forget to add a role something like:
  # config.role :permission_manager, 
  #             Person => :global, 
  #             :having => [:can_add_role,:can_view_permissions,:can_remove_role,:can_describe_role], 
  #             :purpose => "to manage who can access what in the application"
  # 
end
