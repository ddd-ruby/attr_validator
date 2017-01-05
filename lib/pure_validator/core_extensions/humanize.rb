module PureValidator
  module Humanize
    # poor mans humanize... (to not depend on inflector)
    # puts humanize "hello_there", format: :class
    def self.humanize(value, options = {})
      options[:format] = :sentence if options.empty?

      values = if value.include? '_'
       value.split('_')
      else
        [value]
      end
      values.each { |v| v.downcase! }

      if options[:format] == :allcaps
        values.each do |value|
          value.capitalize!
        end

        if options.empty?
          options[:seperator] = " "
        end

        return values.join " "
      end

      if options[:format] == :class
        values.each do |value|
          value.capitalize!
        end
        return values.join ""
      end

      if options[:format] == :sentence
        values[0].capitalize!
        return values.join " "
      end

      if options[:format] == :nocaps
        return values.join " "
      end
    end
  end
end
