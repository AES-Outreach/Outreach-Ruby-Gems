require 'json'

class Release

    # This function is used to increase the Maven project version
    # @param version [String] the version of project
    # @param releaseType [String] this function accepts either 'minor' or 'major' as its param values
    # @return The newly versioned project value
    def self.increaseVersion(version, releasetype)
        nums = version.split(".")
        if releasetype.eql? 'major'
            nums[1] = nums[1].to_i + 1
        elsif releasetype.eql? 'minor'
            nums[nums.length - 1] = nums[nums.length - 1].to_i + 1
        else
            raise 'major or minor was not passed into the function please the appropriate value'
        end
        return nums.join('.').to_s
    end

    # This fuction takes in the location of the Maven project and returns its version
    # Must be running Maven 3.6.x in order for this to work properly
    # @param [String] projectLocation this is the location as to where the Maven project resides on disk
    # @return [String] currentVersion_1 this is the version of the maven project
    def self.getProjectVersion(projectLocation)
        Dir.chdir(projectLocation){
            # Get current project version
            currentVersion_1 = `mvn org.apache.maven.plugins:maven-help-plugin:3.1.0:evaluate -Dexpression=project.version -q -DforceStdout`
            return currentVersion_1
        }
    end

    def self.removeSnapshot(version)
        return version.sub('-SNAPSHOT', '')
    end

    def self.mavenVersion(projectLocation, newVersion)
        Dir.chdir(projectLocation){
            `mvn versions:set -DnewVersion=#{newVersion} -DgenerateBackupPoms=false`
        }
    end

    def self.gitMerge(projectLocation, branch)
        Dir.chdir(projectLocation) {
            `git merge #{branch}`
        }
    end

    def self.gitCheckout(projectLocation, branch)
        Dir.chdir(projectLocation) {
            `git checkout #{branch}`
        }
    end

    def self.gitAddAll(projectLocation)
        Dir.chdir(projectLocation) {
            `git add .`
        }
    end

    def self.gitCommit(projectLocation, commitMessage)
        Dir.chdir(projectLocation) {
            `git commit -m "#{commitMessage}"`
        }
    end

    def self.gitPush(projectLocation)
        Dir.chdir(projectLocation) {
            `git push origin`
        }
    end

    def self.gitTag(projectLocation, tagName)
        Dir.chdir(projectLocation) {
            `git tag #{tagName}`
            `git push origin --tags`
        }
    end

    # This function will change the contents of a file.
    # The function takes the text `from` and converts it `to`
    # It then returns the file as a response
    # @param file [File] A file to be changed
    # @param from [String] The original String value
    # @param to [String] The String value to change the from value too
    # @result new_contents [File] The changed file
    def self.changeVersionNumber(file, from, to)
        new_contents = file.sub(from, to)
        return new_contents
    end
end