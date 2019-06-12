require_relative "../../lib/outreach-s3/ruby-upload-s3"
require "test/unit"

class TestRestClient < Test::Unit::TestCase
    def test_connection()
        OutreachUploadS3.new(ENV['S3_ACCESS_KEY'], 
            ENV['S3_SECRET_KEY'], 
            'us-west-2', 
            'fb3e8922-fcb9-4042-b9f3-3f041602b5d3')
    end

    def test_connection_with_uploada_and_download_in_ram()
        # Get a connection to the bucket
        outreachClient = OutreachUploadS3.new(ENV['S3_ACCESS_KEY'], 
            ENV['S3_SECRET_KEY'], 
            'us-west-2', 
            'fb3e8922-fcb9-4042-b9f3-3f041602b5d3')

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

    def test_connection_with_uploada_and_download_on_disk()
        # Get a connection to the bucket
        outreachClient = OutreachUploadS3.new(ENV['S3_ACCESS_KEY'], 
            ENV['S3_SECRET_KEY'], 
            'us-west-2', 
            'fb3e8922-fcb9-4042-b9f3-3f041602b5d3')

        # Upload a file
        result = outreachClient.uploadFile('./5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', '5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
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
        outreachClient = OutreachUploadS3.new(ENV['S3_ACCESS_KEY'], 
            ENV['S3_SECRET_KEY'], 
            'us-west-2', 
            'fb3e8922-fcb9-4042-b9f3-3f041602b5d3')
        outreachClient.clearBucket()
        result = outreachClient.uploadFile('./5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary', 'uOttawa/5dceb1e7-d638-4f3e-81ef-321a282fe8bc.binary')
    end
end