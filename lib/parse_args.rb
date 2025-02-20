require 'dotenv'

if ARGV.include?('--env-file')
  env_file_index = ARGV.index('--env-file')
  env_file = ARGV[env_file_index + 1]
  ARGV.delete_at(env_file_index)
  ARGV.delete_at(env_file_index)
  Dotenv.load(env_file)
end
