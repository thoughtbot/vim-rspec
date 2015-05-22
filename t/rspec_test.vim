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
      before
        call Set("s:force_gui", 1)
      end

      after
        call Set("s:force_gui", 0)
      end

      context "when rspec_runner is defined"
        before
          let g:rspec_runner = "iterm"
        end

        after
          unlet g:rspec_runner
        end

        it "sets the command with provided runner"
          let expected = "^silent ! '\.\*/bin/iterm' 'rspec " . s:filename . "'$"

          call Call("s:RunSpecs", s:filename)

          Expect Ref("s:rspec_command") =~ expected
        end
      end

      context "when rspec_runner is not defined"
        it "sets the default command"
          let expected = "rspec " . s:filename

          try
            call Call("s:RunSpecs", s:filename)
          catch
          finally
            Expect Ref("s:rspec_command") =~ expected
          endtry
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

      context "and rspec_runner is defined"
        before
          let g:rspec_runner = "fake_runner"
        end

        after
          unlet g:rspec_runner
        end

        it "sets the provided GUI command"
          let expected = "^silent ! '\.\*/bin/fake_runner' '!Dispatch rspec " . s:filename . "'$"
          call Call("s:RunSpecs", s:filename)

          Expect Ref("s:rspec_command") =~ expected
        end
      end

      context "and rspec_runner is not defined"
        it "sets the provided rspec command"
          let expected = "Dispatch rspec " . s:filename
          call Call("s:RunSpecs", s:filename)

          Expect Ref("s:rspec_command") =~ expected
        end
      end
    end
  end
end

describe "RunCurrentSpecFile"
  context "when not in a spec file"
    before
      let g:rspec_command = "!rspec {spec}"
    end

    after
      unlet g:rspec_command
    end

    context "when line number is not set"
      it "runs the last spec file"
        call Set("s:last_spec_file", "model_spec.rb")

        call Call("RunCurrentSpecFile")

        Expect Ref("s:rspec_command") == "!rspec model_spec.rb"
      end
    end

    context "when line number is set"
      it "runs the last spec file"
        call Set("s:last_spec_file", "model_spec.rb")
        call Set("s:last_spec_line", 42)

        call Call("RunCurrentSpecFile")

        Expect Ref("s:rspec_command") == "!rspec model_spec.rb"
      end
    end
  end
end

describe "RunNearestSpec"
  context "not in a spec file"
    before
      let g:rspec_command = "!rspec {spec}"
    end

    after
      unlet g:rspec_command
    end

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
  it "sets s:last_spec to 'spec'"
    call Call("RunAllSpecs")

    Expect Ref("s:last_spec") == "spec"
  end
end
