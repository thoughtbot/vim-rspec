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
map <Leader>rf :call RunCurrentSpecFile()<CR>
map <Leader>rn :call RunNearestSpec()<CR>
map <Leader>rl :call RunLastSpec()<CR>
map <Leader>ra :call RunAllSpecs()<CR>
map <Leader>rt :call RunAllSpecsFilteredByTags()<CR>
```

See [Filtering Specs](#filter) for more details of `RunAllSpecsFilteredByTags`.

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

### Custom runners

Overwrite the `g:rspec_runner` variable to set a custom launch script. At the
moment there are two MacVim-specific runners, i.e. `os_x_terminal` and
`os_x_iterm`. The default is `os_x_terminal`, but you can set this to anything
you want, provided you include the appropriate script inside the plugin's
`bin/` directory.

#### iTerm instead of Terminal

If you use iTerm, you can set `g:rspec_runner` to use the included iterm
launching script. This will run the specs in the last session of the current
terminal.

```vim
let g:rspec_runner = "os_x_iterm"
```

## <a name='filter'></a> Filtering Specs

After running `RunAllSpecsFilteredByTags` either by directly calling it or using
its key mapping, Vim will prompt `tags: ` and wait for your input. If you don't
want to filter anything, hit enter and all specs will be run. If you want to
only run some specs with certain tag(s), for example: `fast`, type `fast` and
hit enter. Or if you don't want to run some specs with certain tag(s), for
example: `slow`, type `~slow` and hit enter. And you can combine these together.
For example, `XXX ~slow` means 'run specs being tagged with XXX but not those
slow ones'. Basically it takes the tags you feed to it, and pass that to RSpecs
`--tag` option.

For more info on RSpec's `--tag` option, have a look at here [--tag
option](http://www.relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option)

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

