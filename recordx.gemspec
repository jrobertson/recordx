Gem::Specification.new do |s|
  s.name = 'recordx'
  s.version = '0.6.0'
  s.summary = 'A kind of Hash which can also use accessor methods to store or retrieve values.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/recordx.rb']
  s.add_runtime_dependency('kvx', '~> 1.1', '>=1.1.0')
  s.signing_key = '../privatekeys/recordx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'digital.robertson@gmail.com'
  s.homepage = 'https://github.com/jrobertson/recordx'
  s.required_ruby_version = '>= 2.1.2'
end
