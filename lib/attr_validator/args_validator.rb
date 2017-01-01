# Helper class for arguments validation
module AttrValidator::ArgsValidator
  class ArgError < StandardError; end

  class << self

    # Checks that specifid +obj+ is a symbol
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_symbol!(obj, obj_name)
      unless obj.is_a?(Symbol)
        raise ArgError, "#{obj_name} should be a Symbol"
      end
    end

    # Checks that specifid +obj+ is a boolean
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_boolean!(obj, obj_name)
      if !obj.is_a?(TrueClass) && !obj.is_a?(FalseClass)
        raise ArgError, "#{obj_name} should be a Boolean"
      end
    end

    # Checks that specifid +obj+ is an integer
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_integer!(obj, obj_name)
      unless obj.is_a?(Integer)
        raise ArgError, "#{obj_name} should be an Integer"
      end
    end

    # Checks that specifid +obj+ is an Array
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_array!(obj, obj_name)
      unless obj.is_a?(Array)
        raise ArgError, "#{obj_name} should be an Array"
      end
    end

    # Checks that specifid +obj+ is a Hash
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_hash!(obj, obj_name)
      unless obj.is_a?(Hash)
        raise ArgError, "#{obj_name} should be a Hash"
      end
    end

    # Checks that specifid +obj+ is an integer or float
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_integer_or_float!(obj, obj_name)
      if !obj.is_a?(Integer) && !obj.is_a?(Float)
        raise ArgError, "#{obj_name} should be an Integer or Float"
      end
    end

    # Checks that specifid +obj+ is a string or regexp
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_string_or_regexp!(obj, obj_name)
      if !obj.is_a?(String) && !obj.is_a?(Regexp)
        raise ArgError, "#{obj_name} should be a String or Regexp"
      end
    end

    # Checks that specifid +obj+ is a symbol or class
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_class_or_symbol!(obj, obj_name)
      if !obj.is_a?(Symbol) && !obj.is_a?(Class)
        raise ArgError, "#{obj_name} should be a Symbol or Class"
      end
    end

    # Checks that specifid +obj+ is a symbol or block
    # @param obj some object
    # @param obj_name object's name, used to clarify error causer in exception
    def is_symbol_or_block!(obj, obj_name)
      if !obj.is_a?(Symbol) && !obj.is_a?(Proc)
        raise ArgError, "#{obj_name} should be a Symbol or Proc"
      end
    end

    # Checks that specifid +hash+ has a specified +key+
    # @param hash some hash
    # @param key hash's key
    def has_key!(hash, key)
      unless hash.has_key?(key)
        raise ArgError, "#{hash} should have #{key} key"
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
  end
end
