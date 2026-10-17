require_relative 'conways2'
require 'benchmark'

def normalize(array, range)
  min_value = array.min
  max_value = array.max
  a = range.min
  b = range.max

  array.map do
    a + (it - min_value) * (b - a) / (max_value - min_value)
  end
end

def main
  ticks = Array.new(100) { 0 }

  (1..100).each do |percentage|
    world = ConwayWorld.new(50, 50)
    world.fill!(percentage)
    cycle = (0...3).cycle
    fingerprints = [nil, nil, nil]
    pos = 0
    tick_count = 0

    loop do
      # world.print_map()
      world.tick()
      fingerprints[pos] = world.fingerprint
      tick_count += 1
      
      if (tick_count > 300) || (fingerprints[pos] == fingerprints[pos - 2])
        ticks[percentage] = tick_count
        break
      end

      pos = cycle.next
    end
  end

  normalize(ticks, 0..100).each_with_index do |item, index|
    ticks.each_with_index do |item, index|
      puts "#{index}% - #{'*' * item}"
    end
  end
end

Benchmark.bm do |x|
  x.report { main() }
end