require 'rubygems'
require 'test/unit'
require 'json'
require 'swagger_hash'
require 'swagger_reader'

$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

Dir[File.dirname(__FILE__) + '/test_helpers/**/*.rb'].each { |file| require file }


