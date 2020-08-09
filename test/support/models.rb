# frozen_string_literal: true


##
# Models with global scope for sequencing
#
class Independent < ActiveRecord::Base
  acts_in_sequence
end

class IndependentCustomColumnName < ActiveRecord::Base
  acts_in_sequence column_name: :display_order
end


##
# Models with scoped sequencing
#
class StringScopeIndependent < ActiveRecord::Base
  self.table_name = "independents"

  acts_in_sequence scope: :name
end

class Parent < ActiveRecord::Base
  has_many :children, dependent: :destroy
  has_many :scope_id_children, dependent: :destroy
  has_many :string_scope_children, dependent: :destroy
  has_many :reversed_children, dependent: :destroy
  has_many :custom_column_name_children, dependent: :destroy
  has_many :children_with_deleted_scopes, dependent: :destroy
end

class Child < ActiveRecord::Base
  acts_in_sequence scope: :parent

  belongs_to :parent
end

class ChildrenWithDeletedScope < ActiveRecord::Base
  self.table_name = "children"

  acts_in_sequence scope: :parent

  scope :without_deleted, -> { where(deleted_at: nil) }

  belongs_to :parent
end

class ScopeIdChild < ActiveRecord::Base
  self.table_name = "children"

  acts_in_sequence scope: :parent_id

  belongs_to :parent
end

class ReversedChild < ActiveRecord::Base
  acts_in_sequence scope: :parent, default_order: :desc

  belongs_to :parent
end

class CustomColumnNameChild < ActiveRecord::Base
  acts_in_sequence scope: :parent, column_name: :display_order

  belongs_to :parent
end
