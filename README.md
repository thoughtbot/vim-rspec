# rspec.vim

This is a lightweight Rspec runner for Vim.

## Installation

Recommended installation with [vundle](https://github.com/gmarik/vundle):

```vim
Bundle 'thoughtbot/vim-rspec'
```

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

To use [zeus](https://github.com/burke/zeus) or
[spring](https://github.com/jonleighton/spring), set g:use_rails_preloader variable:

```vim
let g:use_rails_preloader = 'zeus'
```

If you use janus, you have to set this variable in the .vimrc.before
file.

## License

rspec.vim is copyright © 2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
