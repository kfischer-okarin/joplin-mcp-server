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

  def delete(path, options = {})
    response = self.class.delete(
      path,
      request_options(options)
    )

    response.parsed_response
  end

  def put(path, body, options = {})
    response = self.class.put(
      path,
      request_options(options).merge(body: body.to_json)
    )

    response.parsed_response
  end

  private

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
