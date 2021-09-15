#!/usr/bin/env fish
function dangerload -a include_file --description "does the opposite of .gitignore; only source the files referenced in the .dangerload-include file"
    string length -q "$include_file"; or set include_file ./scripts/dangerload.fish
    dangerunload
    set -e _dls_new_functions    
    set -g _dls_old_functions (functions)


    # for i in $_dls_old_functions
    #     echo $i
    # end
    source $include_file
    for i in (functions)
        contains $i $_dls_old_functions; or set -ag _dls_new_functions $i
    end
    echo $_dls_new_functions
end

function dangerunload
    for f in $_dls_new_functions
        functions --erase $f
    end
end