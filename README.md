# rspec.vim

This is a lightweight RSpec runner for Vim and MacVim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'thoughtbot/vim-rspec'
```

If using zsh on OS X it may be necessary to move `/etc/zshenv` to `/etc/zshrc`.

## Configuration

### Key mappings

Add your preferred key mappings to your `.vimrc` file.

```vim
" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
```

### Custom command

Overwrite the `g:rspec_command` variable to execute a custom command.

Example:

```vim
let g:rspec_command = "!rspec --drb {spec}"
```

This `g:rspec_command` variable can be used to support any number of test
runners or pre-loaders. For example, to use
[Dispatch](https://github.com/tpope/vim-dispatch):

```vim
let g:rspec_command = "Dispatch rspec {spec}"
```
Or, [Dispatch](https://github.com/tpope/vim-dispatch) and
[Zeus](https://github.com/burke/zeus) together:

```vim
let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"
```

### Filename Pattern Matching

The `g:rspec_patterns` variable can be passed a list of lists, which contain
mappings of file names to spec names.  The first list element is a regex for
matching the current file's name, and the second element is the spec file
or directory to run.

In this example, we're any time we run `RunCurrentSpecFile()` for a controller
or javascript file, we run the `spec/features` directory.  Any time we run the
command in a model file, we run that model's spec.

Notice that the regex group matches from the first parameter can be
interpolated into the second parameter with the syntax `{MATCH#}`, i.e.,
`{MATCH1}` or `{MATCH3}`.

```vim
let g:rspec_patterns = [ 
                       \ [ '\v^app/.+_controller\.rb$', "spec/features" ],
                       \ [ '\v^app/.+(\.js|\.coffee)$', "spec/features" ],
                       \ [ '\v^app/(.+)\.rb$', "spec/{MATCH1}_spec.rb" ]
                     \ ]
```

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

rspec.vim is maintained by [thoughtbot, inc](http://thoughtbot.com/community)
and [contributors](https://github.com/thoughtbot/vim-rspec/graphs/contributors)
like you. Thank you!

It was strongly influenced by Gary Bernhardt's [Destroy All
Software](https://www.destroyallsoftware.com/screencasts) screencasts.

## License

rspec.vim is copyright © 2014 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
