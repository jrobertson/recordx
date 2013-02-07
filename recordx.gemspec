Gem::Specification.new do |s|
  s.name = 'recordx'
  s.version = '0.1.5'
  s.summary = 'recordx'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb'] 
  s.signing_key = '../privatekeys/recordx.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
