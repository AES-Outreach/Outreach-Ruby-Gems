class Helpers

    # Used to retrieve the last character of a string
    # @param string [String] The string that is used to retrieve the last character
    # @return [String] The last character of the string
    # @raise [TypeError] if the string is of the wrong type
    def self.getLastCharacter(string)
        raise TypeError unless string.is_a? String
        return string[-1]
    end

    # Remove the last character of a string if the character is a given definition
    # @param string [String] The string to remove a character from
    # @param character [String] The character to remove from the string
    # @return [String] The newly edited string with the removed character
    # @raise [TypeError] if the character is of the wrong type
    def self.removeLastCharacterIf(string, character)
        raise TypeError unless character.is_a? String

        string = string.chomp(character)
        return string
    end

    # Remove the multiple last character of a string if the character is a given definition
    # @param string [String] The string to remove a character from
    # @param characters [String] The character to remove from the string
    # @return [String] The newly edited string with the removed character
    # @raise [TypeError] if the character is of the wrong type
    def self.removeMultipleLastCharacterIf(string, characters)
        raise TypeError unless characters.is_a? Array

        characters.each { |i|
            string = removeLastCharacterIf(string, i)
        }

        return string
    end

    # Replace all characters in a string given a pattern and a replacement string
    # @param string [String] The string to remove a character from
    # @param pattern [String] The pattern to be taken into account when analyzing the string
    # @param replacement [String] The replacement string to use when the pattern is found
    # @return [String] The newly edited string with the replacement and pattern applied to it
    # @raise [TypeError] if the string, pattern or the replacement is of the wrong type
    def self.replaceAllCharacter(string, pattern, replacement)
        raise TypeError unless string.is_a? String
        raise TypeError unless pattern.is_a? String
        raise TypeError unless replacement.is_a? String

        string = string.gsub(pattern, replacement)
        
        return string
    end
end