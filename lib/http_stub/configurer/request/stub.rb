module HttpStub
  module Configurer
    module Request

      class Stub < Net::HTTP::Post

        def initialize(uri, options)
          super("/stubs")
          self.content_type = "application/json"
          self.body = {
              "uri" => HttpStub::Configurer::Request::Regexpable.format(uri),
              "method" => options[:method],
              "headers" => HttpStub::Configurer::Request::Regexpable.format(options[:headers] || {}),
              "parameters" => HttpStub::Configurer::Request::Regexpable.format(options[:parameters] || {}),
              "response" => {
                  "status" => options[:response][:status] || 200,
                  "body" => options[:response][:body]
              }
          }.to_json
        end

      end

    end
  end
end
