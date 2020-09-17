require_relative '../dev_seed'
require_relative '../dev_simulation'

desc 'Seed the development database with test data'
task dev_seed: ['db:check_protected_environments', 'db:reset'] do
  DevSeed.run
end

task simulate_platform_use: ['db:check_protected_environments'] do
  DevSimulation.simulate_platform_use
end
