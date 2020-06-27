# frozen_string_literal: true

require "sequenceable/version"

require "active_record"
require "sequenceable/core"

module Sequenceable
  class Error < StandardError; end

  def sequenceable?
    included_modules.include?(Sequenceable::Core)
  end

  def has_valid_sequenceable_column?(column_name)
    [:integer, :float, :bigint, :decimal].include? self.column_for_attribute(column_name).type
  end

  def acts_in_sequence(options = {})
    raise ArgumentError, "acts_in_sequence => Hash expected, got #{options.class.name}" if !options.is_a?(Hash)

    class_attribute :sequencing_configuration

    self.sequencing_configuration = {
      scope: options[:scope],
      column_name: "sequence",
      default_order: "ASC"
    }

    if options[:column_name].present?
      sequencing_configuration[:column_name] = options[:column_name]
    end

    if !has_valid_sequenceable_column?(sequencing_configuration[:column_name])
      raise ArgumentError, "acts_in_sequence => Column `#{sequencing_configuration[:column_name]}` needs to be of type `:integer`"
    end

    if options[:default_order].present?
      sequencing_configuration[:default_order] = options[:default_order].to_s.downcase == "desc" ? "DESC" : "ASC"
    end

    return if sequenceable?

    include Sequenceable::Core

    # Scopes
    default_scope { order(sequencing_configuration[:column_name] => sequencing_configuration[:default_order]) }
    scope :without_sequence_order, -> { reorder("") }

    # Assign sequence before create
    before_create :assign_sequence_before_create
  end
end

# Extend ActiveRecord's functionality
ActiveRecord::Base.extend Sequenceable
