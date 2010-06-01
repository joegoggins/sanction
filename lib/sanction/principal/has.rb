module Sanction
  module Principal
    module Has
      def self.included(base)
        base.extend ClassMethods
        base.send(:include, InstanceMethods)   
      end
      
      module ClassMethods
        def self.extended(base)
          base.named_scope :has_scope_method, lambda {|*role_names| 
            if role_names.include? Sanction::Role::Definition::ANY_TOKEN
              {:conditions => [ROLE_ALIAS + ".name IS NOT NULL"]}
            else
              role_names = Sanction::Role::Definition.process_role_or_permission_names_for_principal(base, *role_names)

              conditions = role_names.map {|r| base.merge_conditions(["#{ROLE_ALIAS}.name = ?", r.to_s])}.join(" OR ")
              {:conditions => conditions}
            end
          }
        end
   
        def has(*role_names)
          self.as_principal_self.has_scope_method(*role_names) 
        end
       
        def has?(*role_names)
          !has(*role_names).blank?
        end
                
        def has_all?(*role_names)
          result = nil
          role_names.each do |role|
            if(result.nil?) 
              result = self.has(role)
            else
              result = result & has(role)
            end
          end
          
          !result.blank?
        end
      end
      
      module InstanceMethods     
        def has(*role_names)
          self.class.as_principal(self).has_scope_method(*role_names)
        end
        
        def has?(*role_names)
          !has(*role_names).blank? 
        end
        
        def has_all?(*role_names)
          self.class.as_principal(self).has_all?(*role_names)
        end
      end
    end
  end
end
