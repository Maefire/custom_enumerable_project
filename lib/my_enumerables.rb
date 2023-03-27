module Enumerable
  # Your code goes here
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    for i in 0...length
      yield self[i], i
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    results = []
    my_each { |el| results.push(el) if yield(el) }
    results
  end

  def my_all?
    lambdall = block_given? ? ->(el) { yield el } : ->(el) { el.nil? }

    my_each { |el| return false unless lambdall.call(el) }
    true
  end

  def my_any?
    lambdany = block_given? ? ->(el) { yield el } : ->(el) { el.nil? }

    my_each { |el| return true if lambdany.call(el) }
    false
  end

  def my_none?
    lambdone = block_given? ? ->(el) { yield el } : ->(el) { el.nil? }

    my_each { |el| return false if lambdone.call(el) }
    true
  end

  def my_count
    count = 0
    lambcount = block_given? ? ->(el) { count += 1 if yield(el) } : ->(el) { count += 1 unless el.nil? }
    my_each { |el| lambcount.call(el) }
    count
  end

  def my_map
    return to_enum(:my_map) unless block_given? || block.nil?

    result = []
    lambmap = block_given? ? ->(el) { yield(el) } : ->(el) { el.nil? }
    my_each { |el| result << lambmap.call(el) }
    result
  end

  def my_inject(*args)
    case args
    in [a] if a.is_a? Symbol
      sym = a
    in [a] if a.is_a? Object
      accumulator = a
    in [a, b]
      accumulator = a
      sym = b
    else
      accumulator = nil
      sym = nil
    end

    memo = accumulator || first

    my_each_with_index do |el, index|
      next if accumulator.nil? && index.zero?

      memo =
        if block_given?
          yield(memo, el)
        elsif sym
          memo.__send__(sym, el)
        end
    end
    memo
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here

  # this iterates over each element in a given block, and returns itself
  def my_each
    return to_enum(:my_each) unless block_given?

    for el in self do
      yield(el)
    end
    self
  end
end
