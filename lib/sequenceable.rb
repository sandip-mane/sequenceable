# frozen_string_literal: true

require "sequenceable/version"

require "active_record"
require "sequenceable/core"

module Sequenceable
  class Error < StandardError; end

  def sequenceable?
    included_modules.include?(Sequenceable::Core)
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
