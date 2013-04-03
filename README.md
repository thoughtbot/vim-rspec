# rspec.vim

This is a lightweight Rspec runner for Vim.

## Installation

Recommended installation with [vundle]('https://github.com/gmarik/vundle'):

    Bundle 'thoughtbot/vim-rspec'

## Default mappings

    <leader>t - run the full spec file
    <leader>s - run the spec file under the cursor
    <leader>l - rerun the previous spec command

## Configuration

Overwrite `g:rspec_command` variable to execute a custom command.

Example:

    let g:rspec_command = "!rspec --drb {spec}"

## Licence

rspec.vim is copyright © 2013 thoughtbot. It is free software, and may be
redistributed under the terms specified in the `LICENSE` file.

The names and logos for thoughtbot are trademarks of thoughtbot, inc.
