
### Usage

_bin/source2swagger_

Usage: source2swagger [options]
    -i, --input PATH                 Directory of the input source code
    -e, --ext ("rb"|"c"|"js"|"py")   File extension of the source code
    -c, --comment ("##~"|"//~")      Comment tag used to write docs
    -o, --output PATH                Directory where the json output will be saved (optional)

### Example

_bin/souce2swagger -i ~/project/lib -e "rb" -c "##~"_

This will output the Swagger compatible JSON specs on the terminal. 

Add _-o /tmp_ and it will write the JSON file(s) to _/tmp_
