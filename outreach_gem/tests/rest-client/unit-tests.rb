require_relative "../../lib/rest-client/restfulclient"
require_relative "../../lib/rest-client/resttype"
require "test/unit"

class TestRestClient < Test::Unit::TestCase

    def test_setURI_1()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )
        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request')
    end

    def test_setURI_with_query_params()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => {'state' => 'started'}
            )

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=started')
    end

    def test_setURI_with_multi_query_params()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => {'state' => 'started', 'another_state' => 'another_start'}
            )

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=started&another_state=another_start')
    end

    def test_setURI_with_escaped_query_params()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => {'state' => 'AES-Outreach/Forms-Application'}
            )

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=AES-Outreach%2FForms-Application')
    end

    def test_setURI_2()
        restclient_1 = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )
        assert_equal(restclient_1.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request')

        restclient_2 = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request2', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )
        assert_equal(restclient_2.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request2')
    end

    def test_get_port()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )
        assert_equal(restclient.getPort(), 443)
    end

    def test_get_host()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )
        assert_equal(restclient.getHost(), 'stackoverflow.com')
    end

    def test_set_body()
        restclient = RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request', 
            :headers => {
                'Content-Type' => 'application/json'
                }, 
            :rest_type => RestTypes::POST, 
            :ssl => false, 
            :params => nil
            )

        restclient.setBody(
            {"action":"coreui_Repository","method":"update","data":[{"attributes":{"maven":{"versionPolicy":"RELEASE","layoutPolicy":"STRICT"},"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"}},"name":"maven-releases","format":"maven2","type":"hosted","url":"http://34.204.223.49:8080/repository/maven-releases/","online":true}],"type":"rpc","tid":90}.to_json
        )
        assert_equal(restclient.getBody(), '{"action":"coreui_Repository","method":"update","data":[{"attributes":{"maven":{"versionPolicy":"RELEASE","layoutPolicy":"STRICT"},"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"}},"name":"maven-releases","format":"maven2","type":"hosted","url":"http://34.204.223.49:8080/repository/maven-releases/","online":true}],"type":"rpc","tid":90}')
    end

    def test_get()

        restclient = RestClient.new(
            :uri => 'https://api.travis-ci.com/builds', 
            :headers => {
                'Content-Type' => 'application/json',
                'Travis-API-Version' => '3',
                'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
            },
            :rest_type => RestTypes::GET, 
            :ssl => true, 
            :params => nil
            )
        response = restclient.get()

        assert_not_nil(response)
        assert_equal(response.code, "200")
    end

    def test_get2()
        restclient = RestClient.new(
            :uri => 'https://api.travis-ci.com/repo/AES-Outreach%2FForms-Application/builds', 
            :headers => {
                'Content-Type' => 'application/json',
                'Travis-API-Version' => '3',
                'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
            },
            :rest_type => RestTypes::GET, 
            :ssl => true, 
            :params =>  {'state' => 'started'}
            )

        response =  restclient.get()

        assert_not_nil(response)
        assert_equal(restclient.getURI(), 'https://api.travis-ci.com/repo/AES-Outreach%2FForms-Application/builds?state=started')
        assert_equal(response.code, "200")

        data =  JSON.parse(response.body)
        assert_not_nil(data)
    end

    def test_trigger_travis_build()

        restclient = RestClient.new(
            :uri => 'https://api.travis-ci.com/repo/AES-Outreach%2FWebconsole-Branding/requests', 
            :headers => {
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'Travis-API-Version' => '3',
                'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
            },
            :rest_type => RestTypes::POST, 
            :ssl => true, 
            :params =>  nil
            )
        restclient.setBody({
            "request": {
                "message": "Trigger the start of the QA build process [ci skip]",
                "branch": "master",
                "consig": {
                    "env": {
                        "matrix": ["OUTREACH_TYPE=rebuild_qa"]
                    }
                }
            }            
        }.to_json)
        
        response = restclient.post()

        assert_not_nil(response)
        assert_equal(response.code, "202")
    end

    def test_uri_not_nil() 
        exception = assert_raise() {
            RestClient.new(
            :headers => {
                'Content-Type' => 'application/json',
            },
            :rest_type => RestTypes::POST, 
            :ssl => true, 
            :params =>  nil
            )
        }
        assert_equal("uri cannot be empty", exception.message) 
    end

    def test_headers_not_nil() 
        exception = assert_raise() {
            RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request',
            :rest_type => RestTypes::POST, 
            :ssl => true, 
            :params =>  nil
            )
        }
        assert_equal("headers cannot be empty", exception.message) 
    end

    def test_rest_type_not_nil() 
        exception = assert_raise() {
            RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request',
            :headers => {
                'Content-Type' => 'application/json',
            },
            :ssl => true, 
            :params =>  nil
            )
        }
        assert_equal("rest_type cannot be empty", exception.message) 
    end

    def test_ssl_not_nil() 
        exception = assert_raise() {
            RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request',
            :headers => {
                'Content-Type' => 'application/json',
            },
            :rest_type => RestTypes::POST, 
            :params =>  nil
            )
        }
        assert_equal("ssl cannot be empty", exception.message) 
    end

    def test_params_can_be_ommited() 
        assert_nothing_raised do
            RestClient.new(
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request',
            :headers => {
                'Content-Type' => 'application/json',
            },
            :rest_type => RestTypes::POST, 
            :ssl => true
            )
        end
    end


    def test_other_order_initialization() 
        assert_nothing_raised do
            RestClient.new(
            :params =>  nil,
            :headers => {
                'Content-Type' => 'application/json',
            },
            :uri => 'https://stackoverflow.com/questions/2024805/ruby-send-json-request',
            :ssl => true, 
            :rest_type => RestTypes::POST, 
            )
        end
    end


end