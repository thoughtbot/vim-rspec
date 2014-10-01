let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:rspec_runner")
  let g:rspec_runner = "os_x_terminal"
endif

if exists("g:rspec_command")
  if has("gui_running") && has("gui_macvim")
    let s:rspec_command = "silent !" . s:plugin_path . "/bin/" . g:rspec_runner . " '" . g:rspec_command . "'"
  else
    let s:rspec_command = g:rspec_command
  endif
else
  let s:cmd = "rspec {spec}"

  if has("gui_running") && has("gui_macvim")
    let s:rspec_command = "silent !" . s:plugin_path . "/bin/" . g:rspec_runner . " '" . s:cmd . "'"
  elseif has("win32") && fnamemodify(&shell, ':t') ==? "cmd.exe"
    let s:rspec_command = "!cls && echo " . s:cmd . " && " . s:cmd
  else
    let s:rspec_command = "!clear && echo " . s:cmd . " && " . s:cmd
  endif
endif

function! SetSpecCommand(new_command)
  let s:rspec_command = a:new_command
endfunction

function! GetSpecCommand()
  return s:rspec_command
endfunction

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
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
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
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! RunSpecs(spec)
  execute substitute(s:rspec_command, "{spec}", a:spec, "g")
endfunction
