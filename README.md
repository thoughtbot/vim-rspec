# rspec.vim

This is a lightweight Rspec runner for Vim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'thoughtbot/vim-rspec'
```

If using zsh on OS X it may be necessary to run move `/etc/zshenv` to `/etc/zshrc`.

## Recommended mappings

```vim
" Rspec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>

```

## Configuration

Overwrite `g:rspec_command` variable to execute a custom command.

Example:

```vim
let g:rspec_command = "!rspec --drb {spec}"
```

This `g:rspec_command` variable can be used to support any number of test
runners or pre-loaders. For example, you can use
[Dispatch](https://github.com/tpope/dispatch) and
[Zeus](https://github.com/burke/zeus) together with the following:

```vim
let g:rspec_command = "Dispatch zeus rspec {spec}"
```

## License

rspec.vim is copyright © 2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
