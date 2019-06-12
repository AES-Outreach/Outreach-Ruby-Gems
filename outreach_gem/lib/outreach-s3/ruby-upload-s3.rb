require 'aws-sdk-s3'

class OutreachUploadS3

    # @param key [String] Name of the key used to access AWS
    # @param secret [String] Name of the secret key used to access AWS
    # @param region [String] Name of the region of the bucket
    # @param bucketName [String] Name of the S3 Bucket
    def initialize(key, secretKey, region, bucketName)
        if secretKey.empty?
            raise 'secretKey cannot be empty'
        end

        if key.empty?
            raise 'key cannot be empty'
        end

        if region.empty?
            raise 'region cannot be empty'
        end

        if bucketName.empty?
            raise 'bucketName cannot be empty'
        end
        @region = region
        @bucketName = bucketName
       
        Aws.config.update({
            credentials: Aws::Credentials.new(key, secretKey)
        })
        @s3_client = Aws::S3::Client.new({
            region:            @region,
            access_key_id:     key,
            secret_access_key: secretKey
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

    # Retrieve an item from S3
    # @param [string] The key representing the item in the bucket
    # @return [S3Object] Return the S3 Object if it exists, if not then nil
    def getItem(item_name)
        if item_name.nil? or item_name.empty?
            raise 'Cannot have an empty or nil item to retrieve from S3'
        end
        object = @s3_client.get_object(bucket: @bucketName, key: item_name)
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