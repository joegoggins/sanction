module Sanction
  # raised in eager_has? and eager_has_over? if :prinicpal_roles has not been eager loaded
  #
  class NotEagerLoadedException < Exception; end
  class InvalidEagerHasOverUse < Exception; end
  
  module Principal
    module EagerHas        
      def eager_load_check
        unless self.principal_roles.loaded? 
          raise Sanction::NotEagerLoadedException, "
          You must eager load :principal_roles if you want to use eager_has? or eager_has_over? 
          aka load your object via .find(:include => :principal_roles) or invoke .principal_roles
          before invoking eager_* methods
          "
        end
      end
            
      # Adding these to leverage eager loading for the default case
      # where permission checks are made in controllers and views, INSTEAD of using named_scopes
      # This was added to be MUCH faster than hitting the db
      #
      def eager_has?(*role_names)
        eager_load_check
        role_definitions = Sanction::Role::Definition.find_all do |role_def|
          role_names.include?(role_def.name) ||
          (role_def.permissions - role_names).length != role_def.permissions.length # if any role names are in the .permissions array,
        end
        self.principal_roles.each do |pr|
          role_definitions.each do |role_def|
            if pr.name.to_sym == role_def.name
              return true
            end
          end
        end
        return false
      end
    
      def eager_has_over?(*args)
        eager_load_check
        over_object = args.last
        if over_object.kind_of? Symbol
          raise Sanction::InvalidEagerHasOverUse, ".eager_has_over? is meant to be used like .eager_has_over?(:writer,:reader,@some_object), your last argument was a Symbol, that is invalid"
        elsif over_object.class == Class # for a case like eager_has_over?(:can_edit,Thing)
          over_any_instance = true
          effective_over_object_class = over_object
        else
          over_any_instance = false
          effective_over_object_class = over_object.class
        end
        
        role_names = args[0..-2] # everything but the last argument
        
        role_definitions = Sanction::Role::Definition.find_all do |role_def|
          (role_names.include?(role_def.name) || (role_def.permissions - role_names).length != role_def.permissions.length) &&
          role_def.permissionables.include?(effective_over_object_class.to_s)
        end
        self.principal_roles.each do |pr|
          role_definitions.each do |role_def|
            if pr.name.to_sym == role_def.name &&
              role_def.permissionables.include?(pr.permissionable_type)
              if over_any_instance # over_object is something like Thing rather than @thing
                return true
              else #(not over_any_instance)
                # can either match the permissionable_id or if its null, than the princpal role is defined to be over all instances
                if pr.permissionable_id.blank? # the rule is over all instances, we already know there is a match
                  return true
                else
                  if pr.permissionable_id.to_s == over_object.id.to_s # the rule is 
                    return true
                  end
                end
              end                
            end
          end
        end
        return false
      end    
    end
  end
end