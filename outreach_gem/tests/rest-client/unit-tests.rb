require_relative "../../lib/rest-client/restfulclient"
require_relative "../../lib/rest-client/resttype"
require "test/unit"

class TestRestClient < Test::Unit::TestCase

    def test_setURI_1()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)
        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request')
    end

    def test_setURI_with_query_params()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, {'state' => 'started'})

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=started')
    end

    def test_setURI_with_multi_query_params()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, {'state' => 'started', 'another_state' => 'another_start'})

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=started&another_state=another_start')
    end

    def test_setURI_with_escaped_query_params()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, {'state' => 'AES-Outreach/Forms-Application'})

        assert_equal(restclient.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request?state=AES-Outreach%2FForms-Application')
    end

    def test_setURI_2()
        restclient_1 = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)
        assert_equal(restclient_1.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request')

        restclient_2 = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request2', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)
        assert_equal(restclient_2.getURI(), 'https://stackoverflow.com/questions/2024805/ruby-send-json-request2')
    end

    def test_get_port()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)
        assert_equal(restclient.getPort(), 443)
    end

    def test_get_host()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)
        assert_equal(restclient.getHost(), 'stackoverflow.com')
    end

    def test_set_body()
        restclient = RestClient.new('https://stackoverflow.com/questions/2024805/ruby-send-json-request', {
            'Content-Type' => 'application/json'
        }, RestTypes::POST, false, nil)

        restclient.setBody(
            {"action":"coreui_Repository","method":"update","data":[{"attributes":{"maven":{"versionPolicy":"RELEASE","layoutPolicy":"STRICT"},"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"}},"name":"maven-releases","format":"maven2","type":"hosted","url":"http://34.204.223.49:8080/repository/maven-releases/","online":true}],"type":"rpc","tid":90}.to_json
        )
        assert_equal(restclient.getBody(), '{"action":"coreui_Repository","method":"update","data":[{"attributes":{"maven":{"versionPolicy":"RELEASE","layoutPolicy":"STRICT"},"storage":{"blobStoreName":"default","strictContentTypeValidation":true,"writePolicy":"ALLOW"}},"name":"maven-releases","format":"maven2","type":"hosted","url":"http://34.204.223.49:8080/repository/maven-releases/","online":true}],"type":"rpc","tid":90}')
    end

    def test_get()
        restclient = RestClient.new('https://api.travis-ci.com/builds', {
            'Content-Type' => 'application/json',
            'Travis-API-Version' => '3',
            'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
        }, RestTypes::GET, true, nil)

        response = restclient.get()

        assert_not_nil(response)
        assert_equal(response.code, "200")
    end

    def test_get2()
        url = 'https://api.travis-ci.com/repo/AES-Outreach%2FForms-Application/builds'
        restclient = RestClient.new(url, {
            'Content-Type' => 'application/json',
            'Travis-API-Version' => '3',
            'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
        }, RestTypes::GET, true, {'state' => 'started'})

        response =  restclient.get()

        assert_not_nil(response)
        assert_equal(restclient.getURI(), 'https://api.travis-ci.com/repo/AES-Outreach%2FForms-Application/builds?state=started')
        assert_equal(response.code, "200")

        data =  JSON.parse(response.body)
        assert_not_nil(data)
    end

    def test_trigger_travis_build()
        restclient = RestClient.new('https://api.travis-ci.com/repo/AES-Outreach%2FWebconsole-Branding/requests', {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Travis-API-Version' => '3',
            'Authorization' => "token #{ENV['TRAVIS_TOKEN']}"
        }, RestTypes::POST, true, nil)

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
end