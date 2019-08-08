require_relative "../../lib/outreach-s3/ruby-upload-s3"
require "test/unit"

class TestRestClient < Test::Unit::TestCase
    def test_connection()
        OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )
    end

    def test_connection_with_uploada_and_download_in_ram()
        # Get a connection to the bucket

        outreachClient = OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )

        # Upload a file
        result = outreachClient.uploadFile('./5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', '5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
        assert_false(result.nil?)

        # Retrieve the uploaded item
        object = outreachClient.getItemInRam('5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')

        # Make sure that there is stuff in it
        content = object.body.read
        assert_false(content.nil?)
        assert_equal('Pat was here', content)

        # Be gone file vilan!
        assert_true(outreachClient.deleteFile('5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary').delete_marker)
    end

    def test_connection_with_upload_and_fail_nil_path()
        # Get a connection to the bucket

        outreachClient = OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )

        exception = assert_raise() {
            # Upload a file
            result = outreachClient.uploadFile(nil, '5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
        }
        assert_equal('Cannot have an empty path when attempting to upload an object to AWS S3', exception.message) 
    end

    def test_connection_with_upload_and_fail_nil_key()
        # Get a connection to the bucket

        outreachClient = OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )

        exception = assert_raise() {
            # Upload a file
            result = outreachClient.uploadFile('nil', nil)
        }
        assert_equal('Cannot have an empty key when uploading an Object to S3', exception.message) 
    end

    def test_connection_with_uploada_and_download_on_disk()
        # Get a connection to the bucket
        outreachClient = OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )

        # Upload a file
        result = outreachClient.uploadFile('./5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', '5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
        puts result
        assert_false(result.nil?)

        # Retrieve the uploaded item
        path = './file'.freeze
        object = outreachClient.getItemOnDisk('5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', path)
        File.read path
        File.delete path

        # Be gone file vilan!
        assert_true(outreachClient.deleteFile('5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary').delete_marker)
    end

    def test_delete_bucket()
        # Get a connection to the bucket
        outreachClient = OutreachUploadS3.new(
            :key => ENV['S3_ACCESS_KEY'], 
            :secretKey => ENV['S3_SECRET_KEY'], 
            :region => 'us-west-2', 
            :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
        )
        outreachClient.clearBucket()
        result = outreachClient.uploadFile('./5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', 'uOttawa/5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
    end

    def test_upload_s3_key_not_nil() 
        exception = assert_raise() {
            outreachClient = OutreachUploadS3.new(
                :secretKey => ENV['S3_SECRET_KEY'], 
                :region => 'us-west-2', 
                :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
            )
        }
        assert_equal("key cannot be empty", exception.message) 
    end

    def test_upload_s3_secretKey_not_nil() 
        exception = assert_raise() {
            outreachClient = OutreachUploadS3.new(
                :key => ENV['S3_ACCESS_KEY'], 
                :region => 'us-west-2', 
                :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
            )
        }
        assert_equal("secretKey cannot be empty", exception.message) 
    end

    def test_upload_s3_region_not_nil() 
        exception = assert_raise() {
            outreachClient = OutreachUploadS3.new(
                :key => ENV['S3_ACCESS_KEY'], 
                :secretKey => ENV['S3_SECRET_KEY'], 
                :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3'
            )
        }
        assert_equal("region cannot be empty", exception.message) 
    end

    def test_upload_s3_bucketName_not_nil() 
        exception = assert_raise() {
            outreachClient = OutreachUploadS3.new(
                :key => ENV['S3_ACCESS_KEY'], 
                :secretKey => ENV['S3_SECRET_KEY'], 
                :region => 'us-west-2'
            )
        }
        assert_equal("bucketName cannot be empty", exception.message) 
    end

    def test_upload_s3_other_order_initialization() 
        assert_nothing_raised do
            outreachClient = OutreachUploadS3.new(
                :region => 'us-west-2',
                :key => ENV['S3_ACCESS_KEY'], 
                :bucketName => 'fb3e8922-fcb9-4042-b9f3-3f041602b5d3',
                :secretKey => ENV['S3_SECRET_KEY']
            )
        end
    end 
end