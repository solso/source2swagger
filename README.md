## Description

Coming soon...

## Usage

#### Dependencies

* Ruby (1.8x or 1.9x)
* Gem 
* JSON gem (gem install json)

#### Parameters

     $ bin/source2swagger

     Usage: source2swagger [options]
     -i, --input PATH                 Directory of the input source code
     -e, --ext ("rb"|"c"|"js"|"py")   File extension of the source code
     -f, --file FILENAME              Overwrites options: -i and -e. Takes a single annotated source code file
     -c, --comment ("##~"|"//~")      Comment tag used to write docs
     -o, --output PATH                Directory where the json output will be saved (optional)

#### Example

      $ bin/source2swagger -i ~/project/lib -e "rb" -c "##~"_

This will output the Swagger compatible JSON specs on the terminal. 

For this example the file annotated with the swagger spec are ruby files (*-e "rb"*). The annotations
started with *##~* to distinguish them from normal ruby comments that start *#*. 

The source code is on the directory *~/project/lib* , note that the path is handled recursively, it will analyze all ruby
file under the declared path.

You can also target a single file setting the option *-f* 

      $ bin/source2swagger -f ~/data/test/sample3.rb -c "##~"_


Add *-o /tmp* and it will write the JSON file(s) to */tmp*

#### Contributions

Feel free to extend the code and issue a pull request,

The test suite can be invoked as

      $ rake test

Requires *rake* and the *gem test/unit*


## How to

Check [test/data/sample3.rb](https://github.com/solso/source2swagger/blob/master/test/data/sample3.rb) for a comprehensive real example of the *source2swagger* inline docs for Ruby.

The names of the attributes can be seen on the section Grammar (partially) or better yet in the original [Swagger Specification](http://swagger.wordnik.com/spec). 

#### API names declaration

First you need to declare the API

      ##~ a = source2swagger.namespace("your_api_spec_name")

This will generate the file your_api_spec_name.json. The name can be declared in multiple files and several times in the same file. Each time *namespace* is invoked it returns the reference to the root element of the API named "your_api_spec_name".

#### Setting attributes elements

One by one,

      ##~ a.basePath = "http://helloworld.3scale.net"
      ##~ a.swagrVersion = "0.1a"
      ##~ a.apiVersion = "1.0"

or all at the same time,

      ##~ a.set "basePath" => "http://helloworld.3scale.net", "swagrVersion" => "0.1a", "apiVersion" => "1.0"


You can always combine

      ##~ a.set "basePath" => "http://helloworld.3scale.net", "swagrVersion" => "0.1a"
      ##~ a.apiVersion = "1.0"

#### Adding and element to a list attribute

      ##~ op = a.operations.add   
      ##~ op.httpMethod = "GET"
      ##~ op.tags = ["production"] 
      ##~ op.nickname = "get_word"
      ##~ deprecated => false
      ##~
      ##~ op = a.operations.add
      ##~ op.set :httpMethod => "POST", :tags => ["production"], :nickname => "set_word", :deprecated => false
  
Two elements (*operations*) were added to *a.operations*, you can also add directly if you do not need to have a reference to the variable *op*

      ##~ a.operations.add :httpMethod => "GET", :tags => ["production"], :nickname => "get_word", :deprecated => false
      ##~ a.operations.add :httpMethod => "POST", :tags => ["production"], :nickname => "set_word", :deprecated => false

#### Using variables for common structures

The source2swagger notation also allows you to define variables that can be defined anywhere on the source code files as *@name = value*, the value is typically a hash structure in ruby notation (*{"key_1" => "value_1", ... , "key_n" => "value_n"}*) 

*Note:* all variable declarations are evaluated before the non-variable statements so vars will always available no matter where they are defined. For instance,

    ... 
    ##  in foo.rb
    ##~ op.parameters.add @parameter_app_id
    ...
    ## in bar.rb
    ##~ @parameter_app_id = {"name" => "word", "description" => "The word whose sentiment is to be set", "dataType" => "string", "required" => true, "paramType" => "path"}
    ...
  

#### Adding comments

You can add comments on the inline docs specification, just use the normal comment tags of your language

    ##~ op = a.operations.add   
    ##
    ##  HERE IS MY COMMENT (do not use the comment tag, e.g. ##~ but the comment tag specific of your language, in ruby #)
    ##
    ##~ op.httpMethod = "GET"

    

Check [test/data/sample3.rb](https://github.com/solso/source2swagger/blob/master/test/data/sample3.rb) for a comprehensive real example of the *source2swagger* inline docs for Ruby.


### Grammar

(partial)

For a more comprehensive specification of the fields needed to declare your API on the Swagger format you can always go to the [source](http://swagger.wordnik.com/spec) 

      $ROOT

      a = source2swagger.namespace(STRING)

      a.basepath = STRING             [required, ]
      a.swagrVersion = STRING         []
      a.apiVersion = STRING           []
      a.apis = LIST[$ENDPOINTS]       [required, ]

      a.models = LIST[$MODELS]        []

      $ENDPOINTS

      e = a.apis.add

      e.path = STRING                 [required, ]
      e.format = LIST[STRING]         [required, ]
      e.description = STRING          [required, ]
      e.errorResponses = LIST[$ERRORS][]
      e.operations = LIST[$OPERATIONS][]

      $OPERATIONS

      o = e.operations.add

      o.httpMethod = STRING           [required, ]
      o.tags = LIST[STRING]           []
      o.nickname = STRING             []
      o.deprecated = BOOLEAN          []
      o.summary = STRING              []
      o.parameters = LIST[$PARAMETERS][]

      PARAMETERS

      p = o.parameters.add

      p.name = STRING                 [required]
      p.description = STRING          []
      p.dataType = STRING             [required]
      p.allowMultiple = BOOLEAN       []
      p.required = BOOLEAN            []
      p.paramType = STRING

      ERRORS

      err = e.operations.add

      err.reason = STRING             []
      err.code = INT                  []

## Extra Resources

You can edit and view the generated Swagger JSON specs online here: [JSON Editor](http://jsoneditor.appspot.com/)

It's pretty basic but it works great for a quick manual inspection and edition
of the json generated by *source2swagger*. If you know of another online editor 
please let us know. 

## License

MIT License


