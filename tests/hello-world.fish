#!/usr/bin/env fish
function hello-world --description "testing out dls -a"
    echo "bye, world!"
end

function goodbye-world --description "yeah, yeah. very original. I know."
    hello-world
    echo "jk. goodbye, world"
end