Gem::Specification.new do |s|
  s.name         = "bosh_docker_cpi"
  s.version      = '0.0.1.pre.1'
  s.platform     = Gem::Platform::RUBY
  s.summary      = "BOSH Docker CPI"
  s.description  = s.summary
  s.author       = "Alex Jackson"
  s.homepage     = 'https://github.com/ajackson/bosh-lite'
  s.license      = 'Apache 2.0'
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")

  s.files        = `git ls-files -- lib/* `.split("\n")
  s.require_path = "lib"

  s.add_dependency "docker-client"
  s.add_dependency "bosh_common", "~>1.5.0.pre.3"
  s.add_dependency "bosh_cpi", "~>1.5.0.pre.3"
  s.add_dependency "bosh_registry", "~>1.5.0.pre.3"
  s.add_dependency "httpclient", "=2.2.4"
  s.add_dependency "yajl-ruby", ">=0.8.2"
end
