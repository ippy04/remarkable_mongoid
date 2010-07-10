module Remarkable::Mongoid
  module Matchers
    def validate_uniqueness_of(attr)
      ValidateUniquenessOfMatcher.new(attr)
    end
    
    class ValidateUniquenessOfMatcher
      attr_accessor :attr, :validation_type, :message

      def initialize(attr)
        self.attr = attr.to_sym
      end
      
      def with_message(message)
        self.message = message
        self
      end

      def matches?(subject)
        @subject    = subject
        validations = @subject._validators[attr]
        if validations
          validation = validations.detect { |k| k.class == ::Mongoid::Validations::UniquenessValidator }

          if validation && self.message
            validation.options[:message] == self.message
          else
            validation != nil
          end
        else
          false
        end
      end

      def description
        "validates that :#{attr} is unique"
      end

      def failure_message_for_should
        "\nUniqueness validation failure\nExpected: '#{attr}' to be unique"
      end
      

    end
  end
end