require 'dotenv'
Dotenv.load(File.expand_path('../.env.test.local', __dir__))
Dotenv.require_keys('JOPLIN_PORT', 'JOPLIN_TOKEN')

require 'minitest/autorun'

require_relative '../lib/joplin_api_client'

describe JoplinAPIClient do
  let(:client) {
    JoplinAPIClient.new(port: ENV.fetch('JOPLIN_PORT'), token: ENV.fetch('JOPLIN_TOKEN'))
  }

  it 'knows the service is available' do
    assert client.service_available?
  end

  it 'can create a note' do
    note = client.create_note(
      title: 'Test Note',
      body: 'This is a test note'
    )

    retrieved_note = client.get_note(note['id'], fields: 'id,title,body')

    assert_equal note['id'], retrieved_note['id']
    assert_equal note['title'], retrieved_note['title']
    assert_equal note['body'], retrieved_note['body']
  end
end
