#!/usr/bin/env ruby


require 'rubygems'
require './analyzer.rb'
require 'json'
require 'sinatra'

class SentimentApi < Sinatra::Base
  disable :logging
  disable :raise_errors
  disable :show_exceptions
  
  configure :production do
    disable :dump_errors
  end
  
  set :server, 'thin'

  @@the_logic = Analyzer.new

  ##~ sapi = source2swagger.namespace("sentiment")
  ##~ sapi.basePath = "http://helloworld.3scale.net"
  ##~ sapi.swaggerVersion = "0.1a"
  ##~ sapi.apiVersion = "1.0"

  ##~ sapi = source2swagger.namespace("sentiment")
  ##~ a = sapi.apis.add
  ## 
  ##~ a.set :path => "/word/{word}", :format => "json"
  ##~ a.description = "Access to the sentiment of a given word"
  ##
  ##  declaring errors
  ##
  ##~ err = a.errorResponses.add 
  ##~ err.set :reason => "failure to sanitize: \"input\"", :code => 422
  ##~ a.errorResponses.add :reason => "failure to sanitize: \"input\", returns empty set", :code => 422
  ##~ a.errorResponses.add :reason => "access denied, either your access credentials are incorrect or you are about the limits of your quota", :code => 403
  ##~ a.errorResponses.add :reason => "API down", :code => 500
  ##~ 
  ##~ op = a.operations.add   
  ##~ op.set :httpMethod => "GET", :tags => ["production"], :nickname => "get_word", :deprecated => false
  ##~ op.summary = "Returns the sentiment values of a given word"  
  ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "app_id", :description => "Your access application id", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "app_key", :description => "Your access application key", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ## 
  
  
  get '/word/:word' do
    res = @@the_logic.word(params[:word])
    body res.to_json
    ##sleep(1)
    status 200
  end

  ##~ s = source2swagger.namespace("sentiment")
  ##~ a = s.apis.add
  ##~ 
  ##~ a.set :path => "/sentence/{sentence}", :format => "json"
  ##~ a.description = "Returns the aggregated sentiment of a sentence"
  ##
  ##  declaring errors
  ##
  ##~ err = a.errorResponses.add 
  ##~ err.set :reason => "sentence is too long", :code => 422
  ##~ a.errorResponses.add :reason => "failure to sanitize: \"input\"", :code => 422
  ##~ a.errorResponses.add :reason => "failure to sanitize: \"input\", returns empty set", :code => 422
  ##~ a.errorResponses.add :reason => "access denied, either your access credentials are incorrect or you are about the limits of your quota", :code => 403
  ##~ a.errorResponses.add :reason => "API down", :code => 500
  ## 
  ##~ op = a.operations.add   
  ##~ op.set :httpMethod => "GET", :tags => ["production"], :nickname => "get_sentence", :deprecated => false
  ##~ op.summary = "Returns the aggregated sentiment of a sentence"  
  ##~ op.parameters.add :name => "sentence", :description => "The sentence to be analyzed", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "app_id", :description => "Your access application id", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "app_key", :description => "Your access application key", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~
  
  get '/sentence/:sentence' do
    res = @@the_logic.sentence(params[:sentence])   
    body res.to_json
    status 200
  end


  ##~ s = source2swagger.namespace("sentiment")
  ##~ a = s.apis.add
  ##~ 
  ##~ a.path = "/word/{word}/{value}"
  ##~ a.format = "json"
  ##~ a.description = "Set the sentiment of a given word"
  ##
  ##  declaring errors
  ##
  ##~ a.errorResponses.add :reason => "\"word\" is not a single word", :code => 422
  ##~ a.errorResponses.add :reason => "incorrect \"value\", must be -5 to -1 for negative or to +1 to +5 for positive connotations", :code => 422
  ##~ a.errorResponses.add :reason => "failure to sanitize: \"input\"", :code => 422
  ##~ a.errorResponses.add :reason => "failure to sanitize: \"input\", returns empty set", :code => 422
  ##~ a.errorResponses.add :reason => "access denied, either your access credentials are incorrect or you are about the limits of your quota", :code => 403
  ##~ a.errorResponses.add :reason => "API down", :code => 500
  ##~ 
  ##~ op = a.operations.add   
  ##~ op.set :httpMethod => "POST", :tags => ["production"], :nickname => "set_word", :deprecated => false
  ##~ op.summary = "Returns the sentiment values of a given word"  
  ##~ op.parameters.add :name => "word", :description => "The word whose sentiment is to be set", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "value", :description => "The sentiment value, -5 to -1 for negative connotations, 0 neutral, +1 to +5 for positive connotations", :dataType => "int", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "app_id", :description => "Your access application id", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "app_key", :description => "Your access application key", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~

  post '/word/:word/:value' do
    res = @@the_logic.add_word(params[:word],params[:value])
    body res.to_json
    status 200
  end


  ##~ sapi = source2swagger.namespace("sentiment")
  ##~ a = sapi.apis.add
  ## 
  ##~ a.set :path => "/ping", :format => "text"
  ##~ a.description = "Check the status to see if it's up and running"
  ##
  ##  declaring errors
  ##
  ##~ a.errorResponses.add :reason => "API down", :code => 500
  ## 
  ##~ op = a.operations.add   
  ##~ op.set :httpMethod => "GET", :tags => ["test"], :nickname => "ping", :deprecated => true
  ##~ op.summary = "This operation is DEPRECATED. It returns the string \"that's getting old... pong \" if the API is up and running"  
  ##
  
  get '/ping' do
    body "that's getting old... pong"
    status 200
  end

  not_found do
    ""
  end
  
  error InvalidParameters do
    error_code = 422
    error error_code, env['sinatra.error'].to_s 
  end 
  
  error do
    error_code = 500
    error error_code, env['sinatra.error'].to_s 
  end
   
end


SentimentApi.run! :port => ARGV[0]
