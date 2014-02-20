let s:plugin_path = expand("<sfile>:p:h:h")

if !exists("g:rspec_command")
  let s:cmd = "rspec {spec}"

  if has("gui_running") && has("gui_macvim")
    let g:rspec_command = "silent !" . s:plugin_path . "/bin/run_in_os_x_terminal '" . s:cmd . "'"
  else
    let g:rspec_command = "!clear && echo " . s:cmd . " && " . s:cmd
  endif
endif

if !exists("g:rspec_patterns")
  let g:rspec_patterns = []
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
  elseif InAlternateFile()
    let l:spec = AlternateFile()
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
  return match(expand("%"), "_spec.rb$") != -1 || match(expand("%"), ".feature$") != -1
endfunction

function! SetLastSpecCommand(spec)
  let s:last_spec_command = a:spec
endfunction

function! RunSpecs(spec)
  execute substitute(g:rspec_command, "{spec}", a:spec, "g")
endfunction

function! InAlternateFile()
  return AlternateFile() != -1
endfunction

function! AlternateFile()
  for l:pattern in g:rspec_patterns
    let l:matches = filter(matchlist(expand("%"), l:pattern[0] ), 'v:val != ""')

    if len(l:matches) == 0
      continue
    endif

    let l:alternate = l:pattern[1]

    let l:i = 1
    while l:i < len(l:matches)
      let l:alternate = substitute(l:alternate, "{MATCH".i."}", l:matches[i], "")
      let l:i += 1
    endwhile

    return l:alternate
  endfor

  return -1
endfunction
