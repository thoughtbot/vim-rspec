source plugin/rspec.vim

call vspec#hint({"scope": "rspec#scope()", "sid": "rspec#sid()"})

let s:filename = "model_spec.rb"

describe "RunSpecs"
  context "when g:rspec_command is not defined"
    it "sets the default command"
      call Call("s:RunSpecs", s:filename)

      Expect Ref("s:rspec_command") == "!clear && echo rspec model_spec.rb && rspec model_spec.rb"
    end

    context "when in GUI"
      context "when g:rspec_runner is defined"
        before
          call Set("s:force_gui", 1)
          let s:original_runner = g:rspec_runner
          let g:rspec_runner = "iterm"
        end

        after
          let g:rspec_runner = s:original_runner
          call Set("s:force_gui", 0)
        end

        it "sets the command with provided runner"
          let expected = "^silent ! '\.\*/bin/iterm' 'rspec " . s:filename . "'$"

          call Call("s:RunSpecs", s:filename)

          Expect Ref("s:rspec_command") =~ expected
        end
      end

      context "when rspec_runner is not defined"
        before
          call Set("s:force_gui", 1)
        end

        after
          call Set("s:force_gui", 0)
        end

        it "sets the command with default runner"
          let expected = "^silent ! '\.\*/bin/os_x_terminal' 'rspec " . s:filename . "'$"

          call Call("s:RunSpecs", s:filename)

          Expect Ref("s:rspec_command") =~ expected
        end
      end
    end
  end

  context "when g:rspec_command is defined"
    before
      call Set("s:force_gui", 0)
      let g:rspec_command = "!Dispatch rspec {spec}"
    end

    after
      unlet g:rspec_command
    end

    context "when not in GUI"
      it "sets the provided command"
        let expected = "!Dispatch rspec " . s:filename

        call Call("s:RunSpecs", s:filename)

        Expect Ref("s:rspec_command") == expected
      end
    end

    context "when in GUI"
      before
        call Set("s:force_gui", 1)
      end

      after
        call Set("s:force_gui", 0)
      end

      it "sets the provided GUI command"
        let expected = "^silent ! '\.\*/bin/os_x_terminal' '!Dispatch rspec " . s:filename . "'$"
        call Call("s:RunSpecs", s:filename)

        Expect Ref("s:rspec_command") =~ expected
      end
    end
  end
end

describe "RunCurrentSpecFile"
  before
    let g:rspec_command = "!rspec {spec}"
  end

  after
    unlet g:rspec_command
  end

  context "when in a spec file"
    before
      new
      file controller_spec.rb
    end

    after
      bdelete!
    end

    it "runs the current spec file"
      call Set("s:last_spec_file", "model_spec.rb")

      call Call("RunCurrentSpecFile")

      Expect Ref("s:rspec_command") == "!rspec controller_spec.rb"
    end

    it "sets last_spec_file to the current file"
      call Set("s:last_spec_file", "model_spec.rb")

      call Call("RunCurrentSpecFile")

      Expect Ref("s:last_spec_file") ==  "controller_spec.rb"
    end
  end

  context "when not in a spec file"
    it "runs the last spec file"
      call Set("s:last_spec_file", "model_spec.rb")

      call Call("RunCurrentSpecFile")

      Expect Ref("s:rspec_command") == "!rspec model_spec.rb"
    end
  end
end

describe "RunNearestSpec"
  before
    let g:rspec_command = "!rspec {spec}"
  end

  after
    unlet g:rspec_command
  end

  context "when in a spec file"
    before
      new
      file controller_spec.rb
      put =[
          \   'it \"is tautological\" do',
          \   '  expect(true).to eq',
          \   'end',
          \   '',
          \   'it \"is optimistic\" do',
          \   '  expect(1 + 1).to eq 3',
          \   'end',
          \ ]
      5 " jump to the start of the second spec
    end

    after
      bdelete!
    end

    it "runs the current spec file at the current line"
      call Set("s:last_spec_file_with_line", "model_spec.rb:42")
      call Set("s:last_spec_file", "model_spec.rb")

      call Call("RunNearestSpec")

      Expect Ref("s:rspec_command") == "!rspec controller_spec.rb:5"
    end

    it "sets last_spec_file to the current file"
      call Set("s:last_spec_file", "model_spec.rb")

      call Call("RunNearestSpec")

      Expect Ref("s:last_spec_file") ==  "controller_spec.rb"
    end
  end

  context "not in a spec file"
    it "runs the last spec file with line"
      call Set("s:last_spec_file_with_line", "model_spec.rb:42")

      call Call("RunNearestSpec")

      Expect Ref("s:rspec_command") == "!rspec model_spec.rb:42"
    end
  end
end

describe "RunLastSpec"
  before
    let g:rspec_command = "!rspec {spec}"
  end

  after
    unlet g:rspec_command
  end

  context "when s:last_spec is set"
    it "executes the last spec"
      call Set("s:last_spec", "model_spec.rb:42")

      call Call("RunLastSpec")

      Expect Ref("s:rspec_command") == "!rspec model_spec.rb:42"
    end
  end
end

describe "RunAllSpecs"
  before
    let g:rspec_command = "!rspec {spec}"
  end

  after
    unlet g:rspec_command
  end

  it "runs all specs"
    call Set("s:last_spec", "model_spec.rb:42")
    call Set("s:last_spec_file", "model_spec.rb")
    call Set("s:last_spec_file_with_line", "model_spec.rb:42")

    call Call("RunAllSpecs")

    Expect Ref("s:rspec_command") == "!rspec spec"
  end

  it "sets s:last_spec to 'spec'"
    call Call("RunAllSpecs")

    Expect Ref("s:last_spec") == ""
  end
end
