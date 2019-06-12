require_relative "../../lib/helpers/helpers"
require "test/unit"

class TestUpdateRepo < Test::Unit::TestCase

    def test_character_split_1()
        var_1 = Helpers.removeLastCharacterIf('C:\\Users\\', '\\')
        assert_equal(var_1, 'C:\\Users')
    end

    def test_character_split_2()
        var_1 = Helpers.removeLastCharacterIf('C:\\Users', '\\')
        assert_equal('C:\\Users', var_1)
    end

    def test_character_split_3()
        assert_raise TypeError do
            Helpers.removeLastCharacterIf('C:\\Users', ['\\'])
        end
    end

    def test_character_multiple_split_1()
        var_1 = Helpers.removeMultipleLastCharacterIf('C:\\Users\\', ['\\'])
        assert_equal('C:\\Users', var_1)
    end

    def test_character_multiple_split_2()
        var_1 = Helpers.removeMultipleLastCharacterIf('C:\\Users\\', ['\\', '/'])
        assert_equal('C:\\Users', var_1)
    end

    def test_character_multiple_split_3()
        var_1 = Helpers.removeMultipleLastCharacterIf('C:\\Users\\', ['/', '\\',])
        assert_equal('C:\\Users', var_1)
    end

    def test_character_multiple_split_4()
        assert_raise TypeError do
            Helpers.removeMultipleLastCharacterIf('C:\\Users', '\\')
        end
    end

    def test_replace_all_character_1()
        var_1 = Helpers.replaceAllCharacter('C:\\Users', '\\', '/')
        assert_equal('C:/Users', var_1)
    end

    def test_replace_all_character_2()
        assert_raise TypeError do
            Helpers.replaceAllCharacter(['C:\\Users'], '\\', '/')
        end
    end

    def test_replace_all_character_3()
        assert_raise TypeError do
            Helpers.replaceAllCharacter('C:\\Users', ['\\'], '/')
        end
    end

    def test_replace_all_character_4()
        assert_raise TypeError do
            Helpers.replaceAllCharacter('C:\\Users', '\\', ['/'])
        end
    end

    def test_get_last_character_1()
        assert_equal(Helpers.getLastCharacter('hello'), 'o')
    end

    def test_get_last_character_2()
        assert_raise TypeError do
            Helpers.getLastCharacter(['hello'])
        end
    end
end