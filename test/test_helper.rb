require 'test/unit'
require 'swagger_hash'
require 'swagger_reader'
require 'json'

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

Dir[File.dirname(__FILE__) + '/test_helpers/**/*.rb'].each { |file| require file }


