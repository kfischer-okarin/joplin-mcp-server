require 'bundler/setup'

require 'json'

require 'httparty'

class JoplinAPIClient
  include HTTParty

  headers 'Content-Type' => 'application/json'

  def initialize(port: 41184, token:)
    @base_uri = "http://localhost:#{port}"
    @token = token
  end

  def service_available?
    response = self.class.get('/ping', base_uri: @base_uri)
    response.code == 200 && response.parsed_response == 'JoplinClipperServer'
  end

  # Create a note in Joplin
  #
  # @param title [String] the title of the note
  # @param body [String] the body of the note
  # @param tags [Array<String>] an array of tags to apply to the note
  def create_note(title:, body:, tags: nil)
    request_body = {
      title: title,
      body: body,
    }
    request_body[:tags] = tags.join(',') if tags
    post('/notes', request_body)
  end

  # Get a note from Joplin
  #
  # @param id [String] the ID of the note
  # @param fields [String] a comma-separated list of fields to include in the response or '*' for all fields
  def get_note(id, fields: nil)
    get("/notes/#{id}", query: { fields: fields })
  end

  private

  def get(path, options = {})
    response = self.class.get(
      path,
      request_options(options)
    )

    response.parsed_response
  end

  def post(path, body, options = {})
    response = self.class.post(
      path,
      request_options(options).merge(body: body.to_json)
    )

    response.parsed_response
  end

  def request_options(options = {})
    {
      base_uri: @base_uri,
      query: {
        token: @token,
        **options.fetch(:query, {})
      },
      **options.except(:query)
    }
  end
end
