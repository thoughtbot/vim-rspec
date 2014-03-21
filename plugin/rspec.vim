let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:rspec_runner")
  let g:rspec_runner = "os_x_terminal"
endif

function! RunAllSpecs()
  let l:spec = "spec"
  call SetLastSpecCommand(l:spec)
  call RunSpecs(l:spec)
endfunction

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    call RunLastSpec()
  endif
endfunction

function! RunNearestSpec()
  if InRSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  elseif InJavascriptSpecFile()
    call RunCurrentSpecFile()
  else
    call RunLastSpec()
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_command")
    call RunSpecs(s:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return InRSpecFile() || InJavascriptSpecFile()
endfunction

function! InRSpecFile()
  return match(expand("%"), "_spec.rb$") != -1 || match(expand("%"), ".feature$") != -1
endfunction

function! InJavascriptSpecFile()
  return match(expand('%'), 'spec/javascripts/[a-z0-9].*\.\(coffee\|js\)$') != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! SetDefaultCommand(variable, command)
  if !exists(a:variable)
    if has("gui_running") && has("gui_macvim")
      execute "let " . a:variable . " = \"silent !" . s:plugin_path . "/bin/" . g:rspec_runner . " '" . a:command . "'\""
    else
      execute "let " . a:variable . " = \"!clear && echo " . a:command . " && " . a:command . "\""
    endif
  endif
endfunction

function! RunSpecs(spec)
  if InRSpecFile()
    execute substitute(g:rspec_command, "{spec}", a:spec, "g")
  elseif InJavascriptSpecFile()
    execute substitute(g:javascript_command, "{spec}", a:spec, "g")
  endif
endfunction

call SetDefaultCommand('g:rspec_command', 'rspec {spec}')
call SetDefaultCommand('g:javascript_command', 'teaspoon {spec}')
