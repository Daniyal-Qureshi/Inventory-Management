require_relative '../dev_seed'

desc 'Seed the development database with test data'
task dev_seed: ['db:check_protected_environments', 'db:reset'] do
  DevSeed.run
end
