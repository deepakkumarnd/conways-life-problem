class ConwayWorld
  OFFSETS = [
    [-1, -1], 
    [-1, 0], 
    [-1, 1], 
    [0, 1], 
    [1, 1], 
    [1, 0], 
    [1, -1], 
    [0, -1]
  ].freeze

  CLEAR = "\e[2J\e[f".freeze

  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @world = Array.new(width) { Array.new(height) { 0 } }
  end

  def fill!(percentage)
    cells_to_fill = percentage * width * height / 100
    points = []
    
    (0...width).each { |i| (0...height).each { |j| points.push([i, j]) } }

    points.shuffle!
    points.take(cells_to_fill).each { |point| make_alive!(point) }
  end

  def within_world?(point)
    x, y = point
    (x >= 0 && x < width) && (y >= 0 && x < height)
  end

  def get_live_neighbours(point)
    i, j = point
    neighbours = []
    
    OFFSETS.each do |x, y|
      point = [i + x, j + y]
      neighbours << point if within_world?(point) && alive?(point)
    end

    neighbours
  end

  def kill!(point)
    x, y = point
    @world[x][y] = 0
  end

  def make_alive!(point)
    x, y = point
    @world[x][y] = 1
  end

  def alive?(point)
    @world[point[0]][point[1]] == 1
  end

  def dead?(point)
    !alive?(point)
  end

  def print_map
    print CLEAR
    (0...width).each do |i|
      row = (0...height).map do |j|
        alive?([i, j]) ? '*' : ' '
      end

      puts row.join(' ')
    end
  end

  def underpopulation?(point, neighbours_count)
    alive?(point) && neighbours_count < 2
  end

  def overpopulation?(point, neighbours_count)
    alive?(point) && neighbours_count > 3
  end

  def survive?(point, neighbours_count)
    alive?(point) && (neighbours_count == 2 || neighbours_count == 3)
  end

  def reproduce?(point, neighbours_count)
    dead?(point) && neighbours_count == 3
  end

  def tick
    kill_list = []
    new_life = []

    (0...width).each do |i|
      (0...height).each do |j|
        point = [i, j]
        neighbours = get_live_neighbours(point)
        count = neighbours.length

        if underpopulation?(point, count) || overpopulation?(point, count)
          kill_list.push(point)
        elsif reproduce?(point, count)
          new_life.push(point)
        end
      end
    end

    kill_list.each { |point| kill!(point) }
    new_life.each { |point| make_alive!(point) }
  end

  def fingerprint
    @world.flatten.join('')
  end
end