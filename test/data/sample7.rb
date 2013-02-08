##~ sapi = source2swagger.namespace("helloWorld")
##~ sapi.basePath = "http://helloworld.3scale.net"
##~ sapi.swaggerVersion = "0.1a"
##~ sapi.apiVersion = "1.0"
##
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
##~ op.summary = "This operation is nice, it returns an object"
##~ op.responseClass = "HelloMessage"
##
##
##  declaring models
##
##~ m = {:id => "HelloMessage", :properties => {:id => {:type => "long"}, :name => {:type => "string"}}}
##~ sapi.models = {"HelloMessage" => m}


