# Outreach-Ruby-Gems
A repository for our Gems.

This repository runs the unit tests associated to the Ruby scripts in order to validate that the scripts are working as planned.

# How to install dependencies

To install dependencies for the project perform the following steps

1. Install bundler `gem install bundler`
2. Navgigate to `outreach_gem/` folder
3. Run `bundle install`
    * You should see the following output:
    ```
    Fetching gem metadata from https://rubygems.org/.
    Resolving dependencies...
    Using bundler 2.0.1
    Fetching json 2.2.0
    Installing json 2.2.0 with native extensions
    Bundle complete! 1 Gemfile dependency, 2 gems now installed.
    Use `bundle info [gemname]` to see where a bundled gem is installed.
    ```
    * Now you have all the depencies that your project requires in order to start developing

If you use a new dependency then simply add it to the `Gemfile` in order for others to be able to use.

# How to Build

1. Navigate to the `outreach_gem` folder
2. Run `gem build outreach_gem.gemspec`
    * Note that this will fail on your PC since the `#{ENV['TRAVIS_BUILD_NUMBER']}` is not defined locally make the correct adjustments to allow the build to go through
    * Once this runs successfully you should see the following output
    ```
    $ gem build outreach_gem.gemspec
    Successfully built RubyGem
    Name: outreach_gem
    Version: 1.0.1
    File: outreach_gem-1.0.1.gem
    ```
3. Run `gem install outreach_gem-#{VERSION}.gem`
    * Here `${VERSION}` is whatever version the gem was built in
    * You should see the following once the build ran successfully
    ```
    $ gem install outreach_gem-1.0.1.gem
    Successfully installed outreach_gem-1.0.1
    Parsing documentation for outreach_gem-1.0.1
    Installing ri documentation for outreach_gem-1.0.1
    Done installing documentation for outreach_gem after 0 seconds
    1 gem installed
    ```
4. Run `gem signin`
    * The result should be
    ```
    $ gem signin
    Enter your RubyGems.org credentials.
    Don't have an account yet? Create one at https://rubygems.org/sign_up
    Email:   patrique.legault@uottawa.ca
    Password:

    Signed in.
    ```
    * To locate where the gems are installed on your PC run the following command:
    `gem env` and look the `GEM PATHS`
    ```
      - GEM PATHS:
        - C:/Ruby25-x64/lib/ruby/gems/2.5.0 <- This is the one that you are looking for
        - C:/Users/Pat/.gem/ruby/2.5.0
    ```
5. Run `gem push outreach_gem-#{VERSION}.gem`
     * The result will be 
     ```
     $ gem push outreach_gem-1.0.1.gem
    Pushing gem to https://rubygems.org...
    Successfully registered gem: outreach_gem (1.0.1)
     ```
6. Now you can use `require outreach-gem` in your code in order to retrieve our helper functions.

The Ruby Gem is located [here](https://rubygems.org/gems/outreach_gem)

# How to Test

The lib folder is what contains the source code and the testing code for the project.

## lib 

The lib folder is organized with folders that represent the folder structure. Each folder contains an object that offers a certain set of tasks

## tests

The tests folder is what tests the functionality of the lib folder objects. Currently we are using the `test/unit` library that Ruby offers to validate the sanity of our library.

# How to document

All the functions that are added must be documented. In order to properly document them make sure to follow the Ruby standard which is documented [here](https://www.rubydoc.info/gems/yard/file/docs/Tags.md)

When documenting please refer to the official Ruby types in order to properly typeout the function definition. The Ruby types documentation can be found [here](http://zetcode.com/lang/rubytutorial/datatypes/)

# Contributors

[Patrique Legault](mailto:patrique.legault@uottawa.ca)