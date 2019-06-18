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
        if parameters.fetch(:secretKey, nil).nil?
            raise 'secretKey cannot be empty'
        end

        if parameters.fetch(:key, nil).nil?
            raise 'key cannot be empty'
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

    # @param path [String] path to the file that needs to be uploaded
    # @param key [String] the name of the object to upload
    def uploadFile(path, key)
        content = File.read path
        obj = @s3_client.put_object({
            body: content,
            bucket: @bucketName,
            key: key
        })
        return obj
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