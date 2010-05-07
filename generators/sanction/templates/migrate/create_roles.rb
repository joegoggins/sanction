class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      <%-       
      # In many cases when integrating with legacy data, you
      # need string principal_id and permissionable_id rather than
      # integer's
      #
      if use_string_ids
      -%>
      t.string     :principal_id, :limit => 32
      t.string     :principal_type, :limit => 64
      t.string     :permissionable_id, :limit => 32
      t.string     :permissionable_type, :limit => 64
      <%- else -%>
      t.belongs_to :principal, :polymorphic => true
      t.belongs_to :permissionable, :polymorphic => true
      <%- end -%>
      t.string     :name
      t.boolean    :global, :default => false
    end
    
    add_index :roles, [:principal_id, :principal_type]
    add_index :roles, [:permissionable_id, :permissionable_type]
    add_index :roles, :name
    add_index :roles, :global
  end

  def self.down
    drop_table :roles
  end
end

