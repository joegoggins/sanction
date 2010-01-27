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
  
  # If you are integrating with sanction_ui, don't forget to add elements to a
  # :having clause on one or more roles above (like :having => [:can_add_role])
  #
  # :can_view_sui_index
  #   => Show the root page of sanction_ui
  # 
  #   :can_view_sui_roles_index
  #   => The main page where permissions management happens
  #   
  #   :can_add_role
  #   => Add a role
  #   
  #   :can_remove_role
  #   => Remove a role
  #   
  #   :can_describe_role
  #   => Describe a role
end
