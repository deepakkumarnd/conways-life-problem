require_relative 'conways2'

world = ConwayWorld.new(50, 50)
world.fill!(50)

loop do
  world.print_map()
  world.tick()
  sleep(0.5)
end
