class PureValidator::ValidationErrors
  attr_reader :messages

  def initialize
    @messages = {}
  end

  # Clear the error messages.
  #
  #   errors.full_messages # => ["name can not be nil"]
  #   errors.clear
  #   errors.full_messages # => []
  def clear
    messages.clear
  end

  # Returns +true+ if the error messages include an error for the given key
  # +attribute+, +false+ otherwise.
  #
  #   errors.messages        # => {:name=>["can not be nil"]}
  #   errors.include?(:name) # => true
  #   errors.include?(:age)  # => false
  def include?(attribute)
    (v = messages[attribute]) && v.any?
  end
  # aliases include?
  alias :has_key? :include?

  # Get messages for +key+.
  #
  #   errors.messages   # => {:name=>["can not be nil"]}
  #   errors.get(:name) # => ["can not be nil"]
  #   errors.get(:age)  # => nil
  def get(key)
    messages[key]
  end

  # Set messages for +key+ to +value+.
  #
  #   errors.get(:name) # => ["can not be nil"]
  #   errors.set(:name, ["can't be nil"])
  #   errors.get(:name) # => ["can't be nil"]
  def set(key, value)
    messages[key] = value
  end

  # Delete messages for +key+. Returns the deleted messages.
  #
  #   errors.get(:name)    # => ["can not be nil"]
  #   errors.delete(:name) # => ["can not be nil"]
  #   errors.get(:name)    # => nil
  def delete(key)
    messages.delete(key)
  end

  # When passed a symbol or a name of a method, returns an array of errors
  # for the method.
  #
  #   errors[:name]  # => ["can not be nil"]
  #   errors['name'] # => ["can not be nil"]
  def [](attribute)
    get(attribute.to_sym) || set(attribute.to_sym, [])
  end

  # Adds to the supplied attribute the supplied error message.
  #
  #   errors[:name] = "must be set"
  #   errors[:name] # => ['must be set']
  def []=(attribute, error)
    self[attribute] << error
  end

  # Iterates through each error key, value pair in the error messages hash.
  # Yields the attribute and the error for that attribute. If the attribute
  # has more than one error message, yields once for each error message.
  #
  #   errors.add(:name, "can't be blank")
  #   errors.each do |attribute, error|
  #     # Will yield :name and "can't be blank"
  #   end
  #
  #   errors.add(:name, "must be specified")
  #   errors.each do |attribute, error|
  #     # Will yield :name and "can't be blank"
  #     # then yield :name and "must be specified"
  #   end
  def each
    messages.each_key do |attribute|
      self[attribute].each { |error| yield attribute, error }
    end
  end

  # Returns the number of error messages.
  #
  #   errors.add(:name, "can't be blank")
  #   errors.size # => 1
  #   errors.add(:name, "must be specified")
  #   errors.size # => 2
  def size
    values.flatten.size
  end

  # Returns all message values.
  #
  #   errors.messages # => {:name=>["can not be nil", "must be specified"]}
  #   errors.values   # => [["can not be nil", "must be specified"]]
  def values
    messages.values
  end

  # Returns all message keys.
  #
  #   errors.messages # => {:name=>["can not be nil", "must be specified"]}
  #   errors.keys     # => [:name]
  def keys
    messages.keys
  end

  # Returns an array of error messages, with the attribute name included.
  #
  #   errors.add(:name, "can't be blank")
  #   errors.add(:name, "must be specified")
  #   errors.to_a # => ["name can't be blank", "name must be specified"]
  def to_a
    full_messages
  end

  # Returns the number of error messages.
  #
  #   errors.add(:name, "can't be blank")
  #   errors.count # => 1
  #   errors.add(:name, "must be specified")
  #   errors.count # => 2
  def count
    to_a.size
  end

  # Returns +true+ if no errors are found, +false+ otherwise.
  # If the error message is a string it can be empty.
  #
  #   errors.full_messages # => ["name can not be nil"]
  #   errors.empty?        # => false
  def empty?
    messages.all? { |k, v| v && v.empty? && !v.is_a?(String) }
  end
  # aliases empty?
  alias_method :blank?, :empty?

  # Returns a Hash of attributes with their error messages. If +full_messages+
  # is +true+, it will contain full messages (see +full_message+).
  #
  #   errors.to_hash       # => {:name=>["can not be nil"]}
  #   errors.to_hash(true) # => {:name=>["name can not be nil"]}
  def to_hash(full_messages = false)
    if full_messages
      messages = {}
      self.messages.each do |attribute, array|
        messages[attribute] = array.map { |message| full_message(attribute, message) }
      end
      messages
    else
      self.messages.dup
    end
  end

  # Adds +message+ to the error messages on +attribute+. More than one error
  # can be added to the same +attribute+
  #
  #   errors.add(:name, 'is invalid')
  #   # => ["is invalid"]
  #   errors.add(:name, 'must be implemented')
  #   # => ["is invalid", "must be implemented"]
  #
  #   errors.messages
  #   # => {:name=>["must be implemented", "is invalid"]}
  #
  # If +message+ is a proc, it will be called, allowing for things like
  # <tt>Time.now</tt> to be used within an error.
  #
  #   errors.messages # => {}
  def add(attribute, message)
    self[attribute] << message
  end

  # Adds +messages+ to the error messages on +attribute+.
  #
  #   errors.add(:name, ['is invalid', 'must present'])
  #   # => ["is invalid", "must present"]
  def add_all(attribute, errors)
    messages[attribute] ||= []
    messages[attribute] += errors
  end

  # Returns +true+ if an error on the attribute with the given message is
  # present, +false+ otherwise. +message+ is treated the same as for +add+.
  #
  #   errors.add :name, :blank
  #   errors.added? :name, :blank # => true
  def added?(attribute, message)
    self[attribute].include? message
  end

  # Returns all the full error messages in an array.
  #
  #   class PersonValidator
  #     validates :name, :address, :email, presence: true
  #     validates :name, length: { min: 5, max: 30 }
  #   end
  #
  #   = create(address: '123 First St.')
  #   errors.full_messages
  #   # => ["Name is too short (minimum is 5 characters)", "Name can't be blank", "Email can't be blank"]
  def full_messages
    messages.map { |attribute, message| full_message(attribute, message) }
  end

  # Returns all the full error messages for a given attribute in an array.
  #
  #   class PersonValidator
  #     validates :name, :address, :email, presence: true
  #     validates :name, length: { min: 5, max: 30 }
  #   end
  #
  #   = create()
  #   errors.full_messages_for(:name)
  #   # => ["Name is too short (minimum is 5 characters)", "Name can't be blank"]
  def full_messages_for(attribute)
    (get(attribute) || []).map { |message| full_message(attribute, message) }
  end

  # Returns a full message for a given attribute.
  #
  #   errors.full_message(:name, 'is invalid') # => "Name is invalid"
  def full_message(attribute, message)
    return message if attribute == :base
    attr_name = humanize(attribute.to_s.tr('.', '_'))
    # attr_name = @base.class.human_attribute_name(attribute, default: attr_name)
    I18n.t(:"errors.format", {
      default:  "%{attribute} %{message}",
      attribute: attr_name,
      message:   message
    })
  end

  def humanize(value, options = {})
    PureValidator::Humanize.humanize(value, options)
  end
end
