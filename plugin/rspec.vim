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
  let s:cmd = "rspec {options} {spec}"

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
  call SetLastSpecCommand(l:spec, '')
  call RunSpecs(l:spec, '')
endfunction

function! RunAllSpecsWithOptions(options)
  let l:spec = "spec"
  call SetLastSpecCommand(l:spec, a:options)
  call RunSpecs(l:spec, a:options)
endfunction

function! RunCurrentSpecFile()
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec, '')
    call RunSpecs(l:spec, '')
  else
    call RunLastSpec()
  endif
endfunction

function! RunCurrentSpecFileWithOptions(options)
  if InSpecFile()
    let l:spec = @%
    call SetLastSpecCommand(l:spec, a:options)
    call RunSpecs(l:spec, a:options)
  else
    call RunLastSpec()
  endif
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec, '')
    call RunSpecs(l:spec, '')
  else
    call RunLastSpec()
  endif
endfunction

function! RunNearestSpecWithOptions(options)
  if InSpecFile()
    let l:spec = @% . ":" . line(".")
    call SetLastSpecCommand(l:spec, a:options)
    call RunSpecs(l:spec, a:options)
  else
    call RunLastSpec()
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_command")
    if exists("s:last_spec_options")
      call RunSpecs(s:last_spec_command, s:last_spec_options)
    else
      call RunSpecs(s:last_spec_command, '')
    endif
  endif
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! SetLastSpecCommand(spec, options)
  let s:last_spec_command = a:spec
  let s:last_spec_options = a:options
endfunction

function! RunSpecs(spec, options)
  let l:with_options = substitute(s:rspec_command, "{options}", a:options, "g")
  execute substitute(l:with_options, "{spec}", a:spec, "g")
endfunction
