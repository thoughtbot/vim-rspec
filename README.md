# rspec.vim

This is a lightweight RSpec runner for Vim and MacVim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Plugin 'thoughtbot/vim-rspec'
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

### MacVim command runners

If you are running your specs from MacVim,
you must set `g:rspec_runner` or `g:rspec_command`, or both.

The `g:rspec_runner` variable specifies which launch script will be used:

```vim
let g:rspec_runner = "os_x_iterm"
```

At the moment the following MacVim-specific runners are supported:

* `os_x_terminal` for OSX Terminal.app
* `os_x_iterm` for iTerm2 stable release
  * If you use the iTerm2 nightlies,
  this runner will not work due to AppleScript incompatibilities
  between the old and new versions of iTerm2
* `os_x_iterm2` for iTerm2 nightly builds

If `g:rspec_runner` isn't set,
the `g:rspec_command` will be executed from MacVim without a runner.
This enables commands like `Dispatch rspec {spec}` to work in GUI mode.

You can set `g:rspec_runner` to anything you want,
provided you include the appropriate script
inside the plugin's `bin/` directory.

## Running tests

Tests are written using [`vim-vspec`](https://github.com/kana/vim-vspec)
and run with [`vim-flavor`](https://github.com/kana/vim-flavor).

Install the `vim-flavor` gem, install the dependencies and run the tests:

```
gem install vim-flavor
vim-flavor install
rake
```

Credits
-------

![thoughtbot](https://thoughtbot.com/logo.png)

rspec.vim is maintained by [thoughtbot's Vim enthusiasts](https://thoughtbot.com/upcase/vim)
and [contributors](https://github.com/thoughtbot/vim-rspec/graphs/contributors)
like you. Thank you!

It was strongly influenced by Gary Bernhardt's [Destroy All
Software](https://www.destroyallsoftware.com/screencasts) screencasts.

## License

rspec.vim is copyright © 2016 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
