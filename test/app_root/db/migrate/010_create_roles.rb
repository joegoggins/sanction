class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      # In many cases when integrating with legacy data, you
      # need string principal_id and permissionable_id rather than
      # integer's, to test this, test with:
      #   rake test string_ids=true
      if ENV['string_ids']
        t.string :principal_id, :limit => 30
        t.string :principal_type
        t.string :permissionable_id, :limit => 30
        t.string :permissionable_type
      else
        t.belongs_to :principal, :polymorphic => true
        t.belongs_to :permissionable, :polymorphic => true
      end
      
      t.string     :name
      t.boolean    :global, :default => false
    end
    
    add_index :roles, [:principal_id, :principal_type]
    add_index :roles, :name
  end

  def self.down
    drop_table :roles
  end
end

