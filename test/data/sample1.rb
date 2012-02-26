##~ sapi = SwaggerHash::namespace("sentiment")
##~ sapi.basePath = "http://helloworld.3scale.net"
##~ sapi.swagrVersion = "0.1a"
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
##~ op.summary = "This operation is DEPRECATED. It returns the string \"that's getting old... pong \" if the API is up and running"  
##
