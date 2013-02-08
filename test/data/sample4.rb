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
##~ @error_sanitize = {:reason => "failure to sanitize: \"input\"", :code => 422}
##~ @error_api_down = {:reason => "API down", :code => 500}

##
##~ a.errorResponses.add @error_sanitize
##~ a.errorResponses.add @error_api_down
##~ a.errorResponses.add :reason => "failure to sanitize: \"input\", returns empty set", :code => 422
##~ a.errorResponses.add :reason => "access denied, either your access credentials are incorrect or you are about the limits of your quota", :code => 403
##~ 
##~ op = a.operations.add   
##~ op.set :httpMethod => "GET", :tags => ["production"], :nickname => "get_word", :deprecated => false
##~ op.summary = "Returns the sentiment values of a given word"  
##~ op.parameters.add :name => "word", :description => "The word whose sentiment is returned", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
##~ op.parameters.add :name => "app_id", :description => "Your access application id", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
##~ op.parameters.add :name => "app_key", :description => "Your access application key", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
## 
##~ sapi = source2swagger.namespace("sentiment")
##
##~ a = sapi.apis.add
## 
##~ a.set :path => "/ping", :format => "text"
##~ a.description = "Check the status to see if it's up and running"
##
##  declaring errors
##
##~ a.errorResponses.add @error_api_down
## 
##~ op = a.operations.add   
##~ op.set :httpMethod => "GET", :tags => ["test"], :nickname => "ping", :deprecated => true
##~ op.summary = "This operation is DEPRECATED. It returns the string \"that's getting old... pong \" if the API is up and running"  
##

