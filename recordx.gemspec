Gem::Specification.new do |s|
  s.name = 'recordx'
  s.version = '0.2.2'
  s.summary = 'A kind of Hash which can also use accessor methods to store or retrieve values.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/recordx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/recordx'
  s.required_ruby_version = '>= 2.1.2'
end
