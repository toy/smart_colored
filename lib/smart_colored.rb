require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /win32/

module SmartColored
  COLOR_CODES = {
    :black   => 30,
    :red     => 31,
    :green   => 32,
    :yellow  => 33,
    :blue    => 34,
    :magenta => 35,
    :cyan    => 36,
    :white   => 37
  }

  FORMAT_CODES = {
    :bold      => 1,
    :underline => 4,
    :inverse   => 7
  }

  CLEAR_SEQUENCE = "\e[0m"

  def apply_format(format = {})
    apply_attributes = {}
    if color = COLOR_CODES[format[:color]]
      apply_attributes[:color] = color
    end
    if background = COLOR_CODES[format[:background]]
      apply_attributes[:background] = background + 10
    end
    FORMAT_CODES.each do |key, value|
      if format[key]
        apply_attributes[value] = true
      end
    end

    previous_attributes = {}
    clear_sequence = false
    str = "#{CLEAR_SEQUENCE}#{self}"
    str.gsub!(/(?:(?:\e\[\d+(?:;\d+)*m)+)/) do |m|
      unless $'.empty?
        codes = m.scan(/\d+/).map(&:to_i).uniq
        sequence_attributes = {}
        codes.each do |code|
          case code
          when 0
          when 30..37
            sequence_attributes[:color] = code
          when 40..47
            sequence_attributes[:background] = code
          else
            sequence_attributes[code] = true
          end
        end

        current_attributes = apply_attributes.merge(codes.include?(0) ? sequence_attributes : previous_attributes.merge(sequence_attributes))
        sequence_attributes = if (previous_attributes.keys - current_attributes.keys).empty?
          current_attributes.to_a - previous_attributes.to_a
        else
          current_attributes.merge(0 => true)
        end
        codes = sequence_attributes.map do |key, value|
          key == :color || key == :background ? value : key
        end
        previous_attributes = current_attributes

        unless codes.empty?
          clear_sequence = true
          "\e[#{codes.sort.join(';')}m"
        end
      end
    end
    str << CLEAR_SEQUENCE if clear_sequence
    self.class.new(str)
  end

  @@name_to_attributes = {}
  def self.map_name_to_attributes(name, attributes)
    name = name.to_sym
    @@name_to_attributes[name] = attributes
    define_method name do
      apply_format(attributes)
    end
  end

  COLOR_CODES.each do |color, code|
    map_name_to_attributes color, {:color => color}
    map_name_to_attributes "on_#{color}", {:background => color}
  end
  FORMAT_CODES.each do |extra, code|
    map_name_to_attributes extra, {extra => true}
  end

  PART_REGEXP = "(?:on_)?(?:#{COLOR_CODES.keys.join('|')})|#{FORMAT_CODES.keys.join('|')}"
  COMBINED_REGEXP = /^(?:(?:#{PART_REGEXP})_){2,}$/
  COMBINED_REGEXP_PART = /#{PART_REGEXP}/

  def method_missing(method, *arguments, &block)
    if (method_s = "#{method}_") =~ COMBINED_REGEXP
      attributes = @@name_to_attributes.values_at(*method_s.scan(COMBINED_REGEXP_PART).map(&:to_sym)).inject(&:merge)
      SmartColored.map_name_to_attributes method, attributes
      apply_format(attributes)
    else
      super
    end
  end

  class String < ::String
    include SmartColored
  end
end

class String
  def colored
    SmartColored::String.new(self)
  end
end
