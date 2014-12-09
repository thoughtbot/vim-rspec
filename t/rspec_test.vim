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
          let expected = "^silent !\.\*/bin/iterm 'rspec " . s:filename . "'$"

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
          let expected = "^silent !\.\*/bin/os_x_terminal 'rspec " . s:filename . "'$"

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
        let expected = "^silent !\.\*/bin/os_x_terminal '!Dispatch rspec " . s:filename . "'$"
        call Call("s:RunSpecs", s:filename)

        Expect Ref("s:rspec_command") =~ expected
      end
    end
  end
end
