require_relative "../../lib/release/release-ruby"
require "test/unit"

class TestReleaseRuby < Test::Unit::TestCase
 
    def test_split
        var_1 = Release.increaseVersion('1.1.8', 'minor')
        assert_equal('1.1.9', var_1)

        var_1 = Release.increaseVersion('1.1.9', 'minor')
        assert_equal('1.1.10', var_1)

        var_1 = Release.increaseVersion('1.1.9', 'major')
        assert_equal('1.2.9', var_1)
    end  
    
    def test_remove_snapshot
        var_1 = Release.removeSnapshot('1.1.8-SNAPSHOT')
        assert_equal('1.1.8', var_1)

        var_1 = Release.removeSnapshot('1.1.8')
        assert_equal('1.1.8', var_1)
    end  

    def test_file_parser
        file = File.read('resources/outreach.txt')
        new_content = Release.changeVersionNumber(file, 'com.outreach/pojotools.core/1.1.8-SNAPSHOT', 'com.outreach/pojotools.core/1.1.9')
        puts new_content

        assert_true(new_content.include? 'com.outreach/pojotools.core/1.1.9')
    end   
end