# Ensure being in the same directory as the main.rb file so bundler can find the Gemfile
Dir.chdir(File.dirname(__FILE__))
require 'bundler/setup'

require_relative 'lib/parse_args'
Dotenv.require_keys('JOPLIN_PORT', 'JOPLIN_TOKEN')

require 'mcp'

# Your code using the mcp-rb gem goes here

puts 'mcp-rb gem setup complete!'
