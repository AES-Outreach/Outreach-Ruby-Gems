require 'net/http'
require 'json'

require_relative 'resttype'

# Class used to perform HTTP Post and Get operations over the HTTP protocol
class RestClient

    # Initalize the object to perform the operations
    # @param uri [String] The URL to perform the request against
    # @param headers [Hash] Object that resembles the following structure
    # {
    #    'Content-Type' => 'application/json'
    # }
    # @param rest_type [resttype] Module that defines the type of operation that we are about to perform
    # @param ssl [Boolean] True -> SSL is enabled. False -> SSL is disabled
    # @param params [Hash] Is an object that represents the query string parameters to assign to the URL within the give
    # restful invocation {'state' => 'started'}
    def initialize(uri, headers, rest_type, ssl, params)
        @uri = URI(uri)
        @http = Net::HTTP.new(@uri.host, @uri.port)

        if ssl === true
            @http.use_ssl = true
        end
        
        if params.nil?
            if RestTypes::POST === rest_type
                @req = Net::HTTP::Post.new(@uri.path, headers)
            elsif  RestTypes::GET === rest_type
                @req = Net::HTTP::Get.new(@uri.path, headers)
            end
        else
            @uri.query = URI.encode_www_form( params )
            if RestTypes::POST === rest_type
                @req = Net::HTTP::Post.new(@uri.path + '?' + @uri.query, headers)
            elsif  RestTypes::GET === rest_type
                @req = Net::HTTP::Get.new(@uri.path + '?' + @uri.query, headers)
            end
        end
        
    end    

    # Return the URI of the web request
    # @return [String] URL
    def getURI()
        return @uri.to_s
    end

    # Return the URL's HOST
    # @return [String] the URL's HOST
    def getHost()
        return @uri.host
    end

    # Return the URL's PORT
    # @return [Number] the URL's PORT
    def getPort()
        return @uri.port
    end

    # Return the URL's PATH (URI)
    # @return [String] the URL's URI
    def getPath()
        return @uri.path
    end

    # Return the URL's Query string params
    # @return [String] the URL's query string params
    def getQuery()
        return @uri.query
    end

    # Set the URL's Query string params
    # @param params [Hash] The params for the URL
    def setQueryStringParams(params)
        @uri.query = URI.encode_www_form( params )
    end

    # Set the URL's Body
    # @param content [Hash] The body of the web request.
    # An example of this is the following data: 
    # {"action":"coreui_Repository",
    #     "method":"update"
    # }.to_json
    def setBody(content)
        @req.body = content
    end

    # Return the body that the webrequest is about the send
    # @return [Hash] JSON body of the web request
    def getBody()
        return @req.body
    end

    # Perform the HTTP Post request with the given information set within the object
    # @return [HTTPResponse] Object containing all of the response information
    def post()
        return @http.request(@req)
    end

    # Perform the HTTP GET request with the given information set within the object
    # @return [HTTPResponse] Object containing all of the response information
    def get()
        return @http.request(@req)
    end
end