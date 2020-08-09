# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  ##
  # Tables with global scope for sequencing
  #
  create_table :independents, force: true do |t|
    t.string  :name
    t.integer :sequence

    t.timestamps
  end

  create_table :independent_custom_column_names, force: true do |t|
    t.string  :name
    t.integer :display_order

    t.timestamps
  end

  ##
  # Tables with scoped sequencing
  #
  create_table :parents, force: true do |t|
    t.string :name

    t.timestamps
  end

  create_table :children, force: true do |t|
    t.string    :name
    t.integer   :sequence
    t.integer   :parent_id
    t.datetime  :deleted_at

    t.timestamps
  end

  create_table :reversed_children, force: true do |t|
    t.string  :name
    t.integer :sequence
    t.integer :parent_id

    t.timestamps
  end

  create_table :custom_column_name_children, force: true do |t|
    t.string  :name
    t.integer :display_order
    t.integer :parent_id

    t.timestamps
  end
end