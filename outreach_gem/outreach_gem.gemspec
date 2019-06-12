Gem::Specification.new do |s|
    s.name          = %q{outreach_gem}
    s.version       = "1.0.#{ENV['TRAVIS_BUILD_NUMBER']}"
    s.date          = Time.now.strftime('%Y-%m-%d')
    s.licenses      = ['MIT']
    s.summary       = %q{outreach_gem is a utility used at Outreach in order to manage deployments and builds}
    s.authors       = ["Patrique Legault"]
    s.email         = 'patrique.legault@uottawa.ca'
    s.homepage      = "https://github.com/AES-Outreach/Outreach-Ruby-Gems"
    s.metadata      = {
        "allowed_push_host" => 'https://rubygems.org'
    }
    s.files         = Dir.glob("lib/**/*.rb")
    s.require_paths = ["lib"]
    s.required_ruby_version = Gem::Requirement.new(">= 1.9".freeze)
  end