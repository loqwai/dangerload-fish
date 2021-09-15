#!/usr/bin/env fish
function dangerload --description "dangerously sources whatever's in ./scripts/dangerload.fish"
    echo "dangerloading"
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
        set old_func (functions $n)
        set old_func_header $old_func[2]
        set old_func_footer $old_func[-1]
        set old_func_body $old_func[3..-1]
        

        set old_func_header_pieces (string split " " $old_func_header)

        set  -la hidden_func_header $old_func_header_pieces[1]

        set -la hidden_func_header "_$old_func_header_pieces[2]"
        set -la hidden_func_header $old_func_header_pieces[3..-2]
        
        set hidden_func_header (string join ' ' $hidden_func_header)

        set -e new_func
        set -a new_func "$old_func_header"

        set -a new_func $hidden_func_header        
        set -a new_func (string join \n $old_func_body)
        set -a new_func "dangerload"
        set -a new_func "_$n \$argv "
        set -a new_func "$old_func_footer"
        echo (count $new_func)
        functions --erase $old_func_header
        string join \n $new_func
        # echo -e $new_body


    end
end

function dangerunload
    for f in $_dls_new_functions
        functions --erase $f
    end
end