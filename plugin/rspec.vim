let s:plugin_path = expand("<sfile>:p:h:h")
let s:default_command = "rspec {spec}"
let s:force_gui = 0
let s:spec_tags = ""

if !exists("g:rspec_runner")
  let g:rspec_runner = "os_x_terminal"
endif

function! RunAllSpecs()
  let s:last_spec_location = "spec"
  call s:RunSpecs(s:last_spec_location)
endfunction

function! RunCurrentSpecFile()
  if s:InSpecFile()
    let s:last_spec_location = s:CurrentFilePath()
    call s:RunSpecs(s:last_spec_location)
  else
    call RunLastSpec()
  endif
endfunction

function! RunNearestSpec()
  if s:InSpecFile()
    let s:last_spec_location = s:CurrentFilePath() . ":" . line(".")
    call s:RunSpecs(s:last_spec_location)
  else
    call RunLastSpec()
  endif
endfunction

function! RunLastSpec()
  if exists("s:last_spec_location")
    call s:RunSpecs(s:last_spec_location)
  endif
endfunction

function! RunAllSpecsFilteredByTags()
  call s:GetTags()
  call RunAllSpecs()
endfunction

" === local functions ===

function! s:RunSpecs(spec_location)
  call s:ComposeRspecCommand(a:spec_location)
  call s:ResetTags()
  execute s:rspec_command
endfunction

function! s:ComposeRspecCommand(spec_location)
  call s:RspecCommandWithLocation(a:spec_location)
  call s:AddTagsToRspecCommand()
endfunction

function! s:RspecCommandWithLocation(spec_location)
  let s:rspec_command = substitute(s:RspecCommand(), "{spec}", a:spec_location, "g")
endfunction

function! s:AddTagsToRspecCommand()
  let s:rspec_command = s:rspec_command.s:RspecTags()
endfunction

function! s:RspecTags()
  if strlen(s:spec_tags) > 0
    return " --tag ".s:spec_tags
  else
    return ""
  endif
endfunction

function! s:ResetTags()
  let s:spec_tags = ""
endfunction

function! s:GetTags()
  call inputsave()
  let s:spec_tags = input("tags: ")
  call inputrestore()
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
  return "silent !" . s:plugin_path . "/bin/" . g:rspec_runner . " '" . a:command . "'"
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
