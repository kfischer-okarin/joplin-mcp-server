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

  def get_all_items(path, options = {})
    page = 1
    items = []
    loop do
      response = get(path, merge_request_options(options, { query: { page: page } }))
      items.concat(response['items'])
      page += 1
      break unless response['has_more']
    end
    items
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
    merge_request_options(
      {
        base_uri: @base_uri,
        query: { token: @token }
      },
      options
    )
  end

  def merge_request_options(options1, options2)
    {
      query: {
        **options1.fetch(:query, {}),
        **options2.fetch(:query, {})
      },
      **options1.except(:query),
      **options2.except(:query)
    }
  end
end
