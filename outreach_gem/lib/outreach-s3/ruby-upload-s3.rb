require 'aws-sdk-s3'

class OutreachUploadS3

    # @param parameters Is an object that represents the parameters for the initialization of this component 
    # example of input format: 
    # outreachClient = OutreachUploadS3.new(
    #     key: ENV['S3_ACCESS_KEY'], [String] Name of the key used to access AWS
    #     secretKey: ENV['S3_SECRET_KEY'], [String] Name of the secret key used to access AWS
    #     region: 'us-west-2', [String] Name of the region of the bucket
    #     bucketName: 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3' [String] Name of the S3 Bucket
    # )

    def initialize(parameters)
        if parameters.fetch(:key, nil).nil?
            raise 'key cannot be empty'
        end
        
        if parameters.fetch(:secretKey, nil).nil?
            raise 'secretKey cannot be empty'
        end

        if parameters.fetch(:region, nil).nil?
            raise 'region cannot be empty'
        end

        if parameters.fetch(:bucketName, nil).nil?
            raise 'bucketName cannot be empty'
        end

        @region = parameters.fetch(:region)
        @bucketName = parameters.fetch(:bucketName)
       
        Aws.config.update({
            credentials: Aws::Credentials.new(parameters.fetch(:key), parameters.fetch(:secretKey))
        })
        @s3_client = Aws::S3::Client.new({
            region:            @region,
            access_key_id:     parameters.fetch(:key),
            secret_access_key: parameters.fetch(:secretKey)
        })
    end

    # When it comes to binary files you should be doing open then the read
    # operations to it. Must not forget to close the file when performing 
    # an open operation on it.
    # @param path [String] path to the file that needs to be uploaded
    # @param key [String] the name of the object to upload
    # @return obj [Hashes] the resulting object being returned from AWS S3
    def uploadFile(path, key)
        if path.nil? or path.empty?
            raise 'Cannot have an empty path when attempting to upload an object to AWS S3'
        end

        if key.nil? or key.empty?
            raise 'Cannot have an empty key when uploading an Object to S3'
        end

        begin
            # Open the file and get it ready to be read
            file = File.open(path, 'rb')

            # Stream the file into the S3 bucket
            return @s3_client.put_object(bucket: @bucketName, key: key, body: file)
        ensure
            unless file.nil?
                file.close
            end
        end
    end

    # Retrieve an item from S3 and return it in memory
    # @param [string] The key representing the item in the bucket
    # @return [S3Object] Return the S3 Object if it exists, if not then nil
    def getItemInRam(item_name)
        if item_name.nil? or item_name.empty?
            raise 'Cannot have an empty or nil item to retrieve from S3'
        end
        object = @s3_client.get_object(bucket: @bucketName, key: item_name)
        if object.nil?
            return nil
        end
        return object
    end

    # Retrieve an item from S3 and return it on disk
    # @param [string] The key representing the item in the bucket
    # @return [S3Object] Return the S3 Object if it exists, if not then nil
    def getItemOnDisk(item_name, file_path)
        if item_name.nil? or item_name.empty?
            raise 'Cannot have an empty or nil item to retrieve from S3'
        end
        object = @s3_client.get_object(
            response_target: file_path,
            bucket: @bucketName, 
            key: item_name)
        if object.nil?
            return nil
        end
        return object
    end

    # Delete the S3Object
    # @param s3_object [S3Object] Delete the S3 Object from the bucket
    # @raise RuntimeError object cannot be nil 
    def deleteFile(key)
        result = @s3_client.delete_object({
            bucket: @bucketName, 
            key: key
        })
        return result
    end

    # Delete the content of the entire bucket
    def clearBucket()
        Aws::S3::Resource.new(region:@region).bucket(@bucketName).clear!
    end
end