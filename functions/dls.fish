#!/usr/bin/env fish
function dangerload --description "dangerously sources whatever's in ./scripts/dangerload.fish"
    # echo "dangerloading"
    set include_file ./scripts/dangerload.fish
    dangerunload    

    set -e _dls_new_functions    
    set -g _dls_old_functions (functions)
   
    test -f $include_file; or return        
    source $include_file

    for i in (functions)
        contains $i $_dls_old_functions; or set -ag _dls_new_functions $i
    end

    for n in $_dls_new_functions
        
        set -l old_func (functions $n)

        set -l  old_func_header $old_func[2]
        set -l  old_func_body $old_func[3..-1]
        set  -l old_func_footer $old_func[-1]    


        set -l -e new_func        
        set -l -a new_func "$old_func_header"
        set -l -a new_func "functions --erase _$n"
        set -l -a new_func "functions -c $n _$n"
        set -l -a new_func \t"source $include_file"

        set -l -a new_func \t"$n \$argv"
        set -l -a new_func "echo hey there"
        set -l -a new_func "functions --erase $n"
        set -l -a new_func "functions -c _$n $n"
        set -l -a new_func $old_func_footer

        # set -l -a new_func (string join \n $old_func_body)
        # set -l -a new_func "dangerload"
        # set -l -a new_func "_$n \$argv "
        # set -l -a new_func "$old_func_footer"
  
        set finished_new_func (string join ';' $new_func)
        echo $finished_new_func
        echo $finished_new_func | source -
        functions $n
    
    end
end

function dangerunload
    for f in $_dls_new_functions
        echo "erasing $f"
        functions --erase $f
    end
end


function main
    dangerload
end

status is-interactive; or main