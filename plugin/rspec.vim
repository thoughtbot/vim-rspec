let s:plugin_path = expand("<sfile>:p:h:h")
let s:default_command = "rspec {spec}"
let s:force_gui = 0

if !exists("g:rspec_runner")
  let g:rspec_runner = "os_x_terminal"
endif

function! RunAllSpecs()
  let s:last_spec = ""
  call s:RunSpecs(s:last_spec)
endfunction

function! RunCurrentSpecFile()
  if s:InSpecFile()
    let s:last_spec_file = s:CurrentFilePath()
    let s:last_spec = s:last_spec_file
    call s:RunSpecs(s:last_spec_file)
  elseif exists("s:last_spec_file")
    call s:RunSpecs(s:last_spec_file)
  endif
endfunction

function! RunNearestSpec()
  if s:InSpecFile()
    let s:last_spec_file = s:CurrentFilePath()
    let s:last_spec_file_with_line = s:last_spec_file . ":" . line(".")
    let s:last_spec = s:last_spec_file_with_line
    call s:RunSpecs(s:last_spec_file_with_line)
  elseif exists("s:last_spec_file_with_line")
    call s:RunSpecs(s:last_spec_file_with_line)
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec")
    call s:RunSpecs(s:last_spec)
  endif
endfunction

" === local functions ===

function! s:RunSpecs(spec_location)
  let s:rspec_command = substitute(s:RspecCommand(), "{spec}", a:spec_location, "g")

  execute s:rspec_command
endfunction

function! s:InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! s:RspecCommand()
  if s:RspecCommandProvided() && s:IsMacGui()
    let l:command = s:GuiCommand(g:rspec_command)
  elseif s:RspecCommandProvided()
    let l:command = g:rspec_command
  elseif s:IsMacGui()
    let l:command = s:GuiCommand(s:default_command)
  else
    let l:command = s:DefaultTerminalCommand()
  endif

  return l:command
endfunction

function! s:RspecCommandProvided()
  return exists("g:rspec_command")
endfunction

function! s:DefaultTerminalCommand()
  return "!" . s:ClearCommand() . " && echo " . s:default_command . " && " . s:default_command
endfunction

function! s:CurrentFilePath()
  return @%
endfunction

function! s:GuiCommand(command)
  return "silent ! '" . s:plugin_path . "/bin/" . g:rspec_runner . "' '" . a:command . "'"
endfunction

function! s:ClearCommand()
  if s:IsWindows()
    return "cls"
  else
    return "clear"
  endif
endfunction

function! s:IsMacGui()
  return s:force_gui || (has("gui_running") && has("gui_macvim"))
endfunction

function! s:IsWindows()
  return has("win32") && fnamemodify(&shell, ':t') ==? "cmd.exe"
endfunction

" begin vspec config
function! rspec#scope()
  return s:
endfunction

function! rspec#sid()
    return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>
" end vspec config
