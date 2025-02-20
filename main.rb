# Ensure being in the same directory as the main.rb file so bundler can find the Gemfile
Dir.chdir(File.dirname(__FILE__))
require 'bundler/setup'

require_relative 'lib/parse_args'
Dotenv.require_keys('JOPLIN_PORT', 'JOPLIN_TOKEN')

require 'mcp'

require_relative 'lib/joplin_api_client'
require_relative 'lib/tools'

api_client = JoplinAPIClient.new(port: ENV['JOPLIN_PORT'], token: ENV['JOPLIN_TOKEN'])

name 'joplin-mcp-server'

tool 'list_notebooks' do
  description 'Retrieve the complete notebook hierarchy from Joplin'

  call do
    Tools::ListNotebooks.new(api_client).call
  end
end
