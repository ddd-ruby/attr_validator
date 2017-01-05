# Helper class for arguments validation
module PureValidator::ArgsValidator
  class ArgError < StandardError; end

  class << self

    # Checks that specifid +obj+ is a symbol
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_symbol!(obj, obj_name)
      allow!(obj, [Symbol], "#{obj_name} should be a Symbol")
    end

    # Checks that specifid +obj+ is a boolean
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_boolean!(obj, obj_name)
      allow!(obj, [TrueClass, FalseClass], "#{obj_name} should be a Boolean")
    end

    # Checks that specifid +obj+ is an integer
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_integer!(obj, obj_name)
      allow!(obj, [Integer], "#{obj_name} should be an Integer")
    end

    # Checks that specifid +obj+ is an Array
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_array!(obj, obj_name)
      allow!(obj, [Array], "#{obj_name} should be an Array")
    end

    # Checks that specifid +obj+ is a Hash
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_hash!(obj, obj_name)
      allow!(obj, [Hash], "#{obj_name} should be a Hash")
    end

    # Checks that specifid +obj+ is an integer or float
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_integer_or_float!(obj, obj_name)
      allow!(obj, [Integer, Float], "#{obj_name} should be an Integer or Float")
    end

    # Checks that specifid +obj+ is a string or regexp
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_string_or_regexp!(obj, obj_name)
      allow!(obj, [String, Regexp], "#{obj_name} should be a String or Regexp")
    end

    # Checks that specifid +obj+ is a symbol or class
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_class_or_symbol!(obj, obj_name)
      allow!(obj, [Symbol, Class], "#{obj_name} should be a Symbol or Class")
    end

    # Checks that specifid +obj+ is a symbol or block
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_symbol_or_block!(obj, obj_name)
      allow!(obj, [Symbol, Proc], "#{obj_name} should be a Symbol or Proc")
    end

    # Checks that specifid +hash+ has a specified +key+
    # @param hash some hash
    # @param key hash's key
    def has_key!(hash, key)
      unless hash.has_key?(key)
        raise ArgError, "#{hash} should have '#{key}' key"
      end
    end

    def not_nil!(obj, obj_name)
      if obj.nil?
        raise ArgError, "#{obj_name} can't be nil"
      end
    end

    def has_only_allowed_keys!(hash, keys, obj_name)
      remaining_keys = hash.keys - keys
      unless remaining_keys.empty?
        raise ArgError, "#{obj_name} has unacceptable options #{remaining_keys}"
      end
    end

    # Checks that specified +block+ is given
    # @param block some block
    def block_given!(block)
      unless block
        raise ArgError, "Block should be given"
      end
    end

    private

    def allow!(obj, klasses, msg)
      return if klasses.any?{|klass| obj.is_a?(klass)}
      raise ArgError, msg
    end
  end
end
