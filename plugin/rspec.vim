let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:rspec_command")
  if has("gui_running") && has("gui_macvim")
    let g:rspec_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal 'rspec {spec}'"
  else
    let s:cmd = "rspec {spec}"
    if exists(":Dispatch")
      let g:rspec_command = "Dispatch " . s:cmd
    else
      let g:rspec_command = "!echo " . s:cmd . " && " . s:cmd
    endif
  endif
endif

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    RunLastSpec()
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec)
    call RunSpecs(l:spec)
  else
    RunLastSpec()
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_command")
    call RunSpecs(s:last_spec_command)
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1 || match(expand("%"), ".feature$") != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! RunSpecs(spec)
  write
  execute substitute(g:rspec_command, "{spec}", a:spec, "g")
endfunction
