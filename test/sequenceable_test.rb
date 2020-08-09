# frozen_string_literal: true

require "test_helper"

class SequenceableTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sequenceable::VERSION
  end

  def test_that_we_could_check_whether_a_model_is_sequenceable?
    refute Parent.sequenceable?
    assert Child.sequenceable?
    assert Independent.sequenceable?
  end

  def test_that_without_sequence_scope_removes_default_order
    parent = Parent.create(name: "Parent 1")

    parent.reversed_children.create(name: "Child 1")
    parent.reversed_children.create(name: "Child 2")
    parent.reversed_children.create(name: "Child 3")

    assert_equal [3, 2, 1], parent.reversed_children.map(&:sequence)
    assert_equal [1, 2, 3], parent.reversed_children.without_sequence_order.map(&:sequence)
  end

  ##
  # Tests with global scope for sequencing
  #
  def test_that_new_sequence_is_assigned_to_independent_records
    Independent.delete_all

    record_1 = Independent.create(name: "Record 1")
    record_2 = Independent.create(name: "Record 2")
    record_3 = Independent.create(name: "Record 3")

    assert_equal 1, record_1.sequence
    assert_equal 2, record_2.sequence
    assert_equal 3, record_3.sequence
  end

  def test_that_new_sequence_is_assigned_for_custom_column
    record_1 = IndependentCustomColumnName.create(name: "Record 1")
    record_2 = IndependentCustomColumnName.create(name: "Record 2")
    record_3 = IndependentCustomColumnName.create(name: "Record 3")

    assert_equal 1, record_1.display_order
    assert_equal 2, record_2.display_order
    assert_equal 3, record_3.display_order
  end


  ##
  # Tests with scoped sequencing
  #
  def test_that_new_sequence_is_assigned_to_records_with_scope
    parent_1 = Parent.create(name: "Parent 1")
    parent_2 = Parent.create(name: "Parent 2")

    child_11 = parent_1.children.create(name: "Child 11")
    child_12 = parent_1.children.create(name: "Child 12")
    child_13 = parent_1.children.create(name: "Child 13")

    child_21 = parent_2.children.create(name: "Child 21")
    child_22 = parent_2.children.create(name: "Child 22")

    assert_equal 1, child_11.sequence
    assert_equal 2, child_12.sequence
    assert_equal 3, child_13.sequence

    assert_equal 1, child_21.sequence
    assert_equal 2, child_22.sequence
  end

  def test_that_scope_warning_is_not_shown
    parent = Parent.create(name: "Parent 1")
    child = parent.children_with_deleted_scopes.without_deleted.create(name: "Child 11")
    assert_equal 1, child.sequence
  end

  def test_that_new_sequence_is_assigned_to_records_with_scope_id
    parent = Parent.create(name: "Parent 1")

    child_1 = parent.scope_id_children.create(name: "Child 1")
    child_2 = parent.scope_id_children.create(name: "Child 2")
    child_3 = parent.scope_id_children.create(name: "Child 3")

    assert_equal 1, child_1.sequence
    assert_equal 2, child_2.sequence
    assert_equal 3, child_3.sequence
  end

  def test_that_new_sequence_is_assigned_to_records_with_string_scope
    StringScopeIndependent.delete_all

    car_1 = StringScopeIndependent.create(name: "Car")
    car_2 = StringScopeIndependent.create(name: "Car")
    car_3 = StringScopeIndependent.create(name: "Car")

    truck_1 = StringScopeIndependent.create(name: "Truck")
    truck_2 = StringScopeIndependent.create(name: "Truck")
    truck_3 = StringScopeIndependent.create(name: "Truck")

    assert_equal 1, car_1.sequence
    assert_equal 2, car_2.sequence
    assert_equal 3, car_3.sequence

    assert_equal 1, truck_1.sequence
    assert_equal 2, truck_2.sequence
    assert_equal 3, truck_3.sequence
  end

  def test_that_new_scoped_sequence_is_assigned_for_custom_column
    parent = Parent.create(name: "Parent 1")

    child_1 = parent.custom_column_name_children.create(name: "Child 1")
    child_2 = parent.custom_column_name_children.create(name: "Child 2")
    child_3 = parent.custom_column_name_children.create(name: "Child 3")

    assert_equal 1, child_1.display_order
    assert_equal 2, child_2.display_order
    assert_equal 3, child_3.display_order
  end

  def test_that_default_order_for_scoped_sequence_is_maintained
    parent = Parent.create(name: "Parent 1")

    parent.children.create(name: "Child 1")
    parent.children.create(name: "Child 2")
    parent.children.create(name: "Child 3")

    assert_equal [1, 2, 3], parent.children.map(&:sequence)
  end

  def test_that_custom_order_for_scoped_sequence_is_maintained
    parent = Parent.create(name: "Parent 1")

    parent.reversed_children.create(name: "Child 1")
    parent.reversed_children.create(name: "Child 2")
    parent.reversed_children.create(name: "Child 3")

    assert_equal [3, 2, 1], parent.reversed_children.map(&:sequence)
  end
end
