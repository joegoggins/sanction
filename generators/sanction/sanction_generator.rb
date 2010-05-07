class SanctionGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      if (args.grep /string_ids/).empty?
        use_string_ids = false
        puts "ps: if you are integrating sanction with legacy data with non-integer primary keys, you might want to
              do:
                 script/generate sanction string_ids=true
              instead.
             "
      else
        use_string_ids = true        
      end
      m.file 'initializer.rb', "config/initializers/sanction.rb"
      m.migration_template "migrate/create_roles.rb", "db/migrate", 
      :migration_file_name => "create_roles",
      :assigns => {:use_string_ids => use_string_ids}
    end
  end
end
