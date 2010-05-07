module Sanction
  module Principal
    module Base
      def self.extended(base)
        base.class_eval %q{
          def principal_roles
            Sanction::Role.for(self)
          end
          # functionally equivilent to .principal_roles on a principal instance
          # used by eager_has? and eager_has_over?
          #
          has_many :eager_principal_roles, :as => :principal, :class_name => "Sanction::Role", 
                   :finder_sql => 'SELECT * FROM #{Sanction::Role.table_name} 
                                   WHERE roles.principal_type = "#{self.class.name.to_s}" 
                                   AND (roles.principal_id = "#{id}" OR roles.principal_id IS NULL)'
         
         
          def self.principal_roles
            Sanction::Role.for(self)
          end

          has_many :specific_principal_roles, :as => :principal, :class_name => "Sanction::Role", :dependent => :destroy
          
          
        }

        base.named_scope :as_principal_self, lambda {
          already_joined = Sanction::Extensions::Joined.already? base, ROLE_ALIAS
 
          returned_scope = {:conditions => ["#{ROLE_ALIAS}.principal_type = ?", base.name.to_s], :select => "DISTINCT #{base.table_name}.*"}
          unless already_joined
            returned_scope.merge( {:joins => "INNER JOIN #{Sanction::Role.table_name} AS #{ROLE_ALIAS} ON 
              (#{ROLE_ALIAS}.principal_id = #{base.table_name}.#{base.primary_key.to_s} OR #{ROLE_ALIAS}.principal_id IS NULL)
              AND #{ROLE_ALIAS}.principal_type = '#{base.name.to_s}'"} )
          end
        }

        base.named_scope :as_principal, lambda {|klass_instance|
          already_joined = Sanction::Extensions::Joined.already? base, ROLE_ALIAS
         
          returned_scope = {:conditions => ["#{klass_instance.class.table_name}.#{klass_instance.class.primary_key.to_s} = ?", klass_instance.id], :select => "DISTINCT #{klass_instance.class.table_name.to_s}.*"}
          unless already_joined
            returned_scope.merge({:joins => "INNER JOIN #{Sanction::Role.table_name} AS #{ROLE_ALIAS} ON
              (#{ROLE_ALIAS}.principal_id = '#{klass_instance.id}' OR #{ROLE_ALIAS}.principal_id IS NULL) AND
              #{ROLE_ALIAS}.principal_type = '#{klass_instance.class.name.to_s}'"})
          end
        }
      end
    end
  end
end
