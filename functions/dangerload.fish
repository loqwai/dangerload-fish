#!/usr/bin/env fish
function dangerload -v PWD --description "dangerously sources whatever's in ./scripts/dangerload.fish"
    set include_file ./scripts/dangerload.fish
    dangerunload    

    set -e _dls_new_functions    
    set -g _dls_old_functions (functions)
   
    test -f $include_file; or begin
        # echo "I can't find $include_file!"
        return 1
    end    

    source $include_file

    for i in (functions)
        contains $i $_dls_old_functions; or set -ag _dls_new_functions $i
    end

    for function_name in $_dls_new_functions        
         echo -n " +$function_name"
        set -l old_func (functions $function_name)

        set -l  old_func_header $old_func[2]
        set -l old_func_footer $old_func[-1]    
        set random_id "_dls_temporary_function_"(random 0 (math '4 * 1024 * 1024 * 1024'))"_$function_name"

        set -l -e new_func        
        set -l -a new_func "
$old_func_header
    functions --erase $random_id
    functions -c $function_name $random_id
    source $include_file 2>/dev/null; or begin
        echo \"$function_name can't find $include_file to reload itself. Aborting.\"
        functions --erase $random_id
        return 1
    end
    $function_name \$argv
    functions --erase $function_name
    functions -c $random_id $function_name
    functions --erase $random_id
$old_func_footer
        "
        eval $new_func
    end
end

function dangerunload
    echo -n "dangerload: "
    for f in $_dls_new_functions
        echo -n " -$f"
        functions --erase $f
    end
end

function dls
    echo $_dls_new_functions
end