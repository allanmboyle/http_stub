describe HttpStub::Models::Headers do

  let(:non_http_env_elements) do
    {
        "GATEWAY_INTERFACE" => "CGI/1.1",
        "QUERY_STRING" => "some string",
        "REMOTE_ADDR" => "127.0.0.1",
        "SCRIPT_NAME" => "some script",
        "SERVER_NAME" => "localhost",
    }
  end
  let(:env) { non_http_env_elements.merge(request_headers) }
  let(:request) { double("HttpRequest", env: env) }

  let(:model) { HttpStub::Models::Headers.new(model_headers) }

  describe "#match?" do

    describe "when multiple headers are mandatory" do

      let(:model_headers) { { "KEY1" => "value1", "KEY2" => "value2", "KEY3" => "value3" } }

      describe "and the mandatory model headers are provided" do

        let(:request_headers) { { "HTTP_KEY1" => "value1", "HTTP_KEY2" => "value2", "HTTP_KEY3" => "value3" } }

        describe "and the casing of the header names is identical" do

          it "should return true" do
            model.match?(request).should be_true
          end

        end

        describe "and the casing of the header names is different" do

          let(:model_headers) { { "key1" => "value1", "KEY2" => "value2", "key3" => "value3" } }

          it "should return true" do
            model.match?(request).should be_true
          end

        end

      end

      describe "and the request headers have different values" do

        let(:request_headers) { { "HTTP_KEY1" => "value1", "HTTP_KEY2" => "doesNotMatch", "HTTP_KEY3" => "value3" } }

        it "should return false" do
          model.match?(request).should be_false
        end

      end

      describe "and some mandatory model headers are omitted" do

        let(:request_headers) { { "HTTP_KEY1" => "value1", "HTTP_KEY3" => "value3" } }

        it "should return false" do
          model.match?(request).should be_false
        end

      end

      describe "and all mandatory model headers are omitted" do

        let(:request_headers) { {} }

        it "should return false" do
          model.match?(request).should be_false
        end

      end

    end

    describe "when no headers are mandatory" do

      let(:model_headers) { {} }

      describe "and headers are provided" do

        let(:request_headers) { { "HTTP_KEY" => "value" } }

        it "should return true" do
          model.match?(request).should be_true
        end

      end

    end

    describe "when the mandatory model headers are nil" do

      let(:model_headers) { nil }

      describe "and headers are provided" do

        let(:request_headers) { { "HTTP_KEY" => "value" } }

        it "should return true" do
          model.match?(request).should be_true
        end

      end

    end

  end

  describe "#to_s" do

    describe "when multiple headers are provided" do

      let(:model_headers) { { "key1" => "value1", "key2" => "value2", "key3" => "value3" } }

      it "should return a string containing each header formatted as a conventional request header" do
        result = model.to_s

        model_headers.each { |key, value| result.should match(/#{key}:#{value}/) }
      end

      it "should comma delimit the headers" do
        model.to_s.should match(/key\d.value\d\, key\d.value\d\, key\d.value\d/)
      end

    end

    describe "when empty headers are provided" do

      let(:model_headers) { {} }

      it "should return an empty string" do
        model.to_s.should eql("")
      end

    end

    describe "when nil headers are provided" do

      let(:model_headers) { nil }

      it "should return an empty string" do
        model.to_s.should eql("")
      end

    end

  end

end