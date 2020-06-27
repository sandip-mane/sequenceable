# frozen_string_literal: true

module Sequenceable
  module Core
    protected
      def assign_sequence_before_create
        self[sequencing_configuration[:column_name]] = deduce_last_sequence + 1
      end

      def deduce_last_sequence
        build_sequencing_query.maximum(sequencing_configuration[:column_name]).to_i
      end

      def build_sequencing_query
        for_name = sequencing_configuration[:scope]
        return self.class if for_name.blank?

        for_assoc = self.class.reflect_on_all_associations(:belongs_to).find { |x| x.name == for_name }
        self.class.where(for_assoc.foreign_key => self[for_assoc.foreign_key])
      end
  end
end
