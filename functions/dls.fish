#!/usr/bin/env fish
function dangerload --description "dangerously sources whatever's in ./scripts/dangerload.fish"
    # echo "dangerloading"
    set include_file ./scripts/dangerload.fish
    dangerunload    

    set -e _dls_new_functions    
    set -g _dls_old_functions (functions)
   
    test -f $include_file; or begin
        echo "I can't find $include_file!"
        return 1
    end       
    source $include_file

    for i in (functions)
        contains $i $_dls_old_functions; or set -ag _dls_new_functions $i
    end

    for n in $_dls_new_functions
        
        set -l old_func (functions $n)

        set -l  old_func_header $old_func[2]
        set -l old_func_footer $old_func[-1]    
        set random_id "_dls_temporary_function_"(random 0 (math '4 * 1024 * 1024 * 1024'))"_$n"
        echo $random_id

        set -l -e new_func        
        set -l -a new_func "
$old_func_header
    functions --erase $random_id
    functions -c $n $random_id
    source $include_file
    $n \$argv
    functions --erase $n
    functions -c $random_id $n
$old_func_footer
        "
        eval $new_func
    end
end

function dangerunload
    for f in $_dls_new_functions
        echo "erasing $f"
        functions --erase $f
    end
end