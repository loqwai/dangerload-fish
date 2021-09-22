# dangerload

`dangerload` is a very dangerous extension for your fish shell. It adds a feature to fish that can load and unload fish functions depending on the current directory.

These functions will auto-reload once the files that defined them have changed. Once you leave a directory with functions loaded in this way, `dangerload` will remove them from your shell. 

Unlike fish's native lazy-loading of functions, it is directory-specific, and more than one function can be defined in a file.

It's like [direnv](https://direnv.net/), but for functions instead of environment variables.

When you enable dangerload, changing directories into a folder that has a `./scripts/dangerload.fish` file will load functions defined in the file into your shell.
(I usually just use that file to source functions from other files in my projects.)

When you change out of that directory, it removes the functions from your shell.

You can install it via [fisher](https://github.com/jorgebucaran/fisher):

```fisher install loqwai/dangerload-fish ```

Once it's installed, if you run `dangerload` in a shell, dangerload will start monitoring what directory you are in _for that shell session_ and do it's magic function autoreloading thing.


Here's a quick demo:

```
dangerload
mkdir -p ~/dangerload-demo/scripts
echo "
    function hi-world
        echo 'this is a very exciting function'
    end
    function bye-world
        echo 'an even more interesting function'
    end
    " 
> ./dangerload-demo/scripts/dangerload.fish 

cd ~/dangerload-demo
# shell will print "dangerload:  +bye-world +hi-world"

hi-world
#this should print  "this is a very exciting function"
cd ..
#  shell will print "dangerload:  -bye-world -hi-world"

hi-world
# shell will print "hi-world: command not found"
```

In the above example. dangerload will make sure that the `hi-world` function is up to date with the `hi-world` function defiled in `dangerload.fish` by dangerously sourcing the file again before executing.


