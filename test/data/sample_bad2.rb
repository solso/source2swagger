##~ sapi = source2swagger.namespace("sentiment")
##~ sapi.basePath = "http://helloworld.3scale.net"
##~ sapi.swagrVersion = "0.1a"
##~ sapi.apiVersion = "1.0"
##
##~ a = sapi.apis.add
## 
##~ a.set :path => "/ping", :format => "text"
##~ a.description = Check the status to see if it's up and running
## 
##  THE STRING ABOVE IS NOT WITHIN QUOTES
##  declaring errors
##
##~ a.errorResponses.add :reason => "API down", :code => 500
## 

