#!/usr/bin/env fish
function dangerload-include -a include_file --description "does the opposite of .gitignore; only source the files referenced in the .dangerload-include file"
    string length -q "$include_file"; or set include_file .dangerload-include
    echo $include_file

end