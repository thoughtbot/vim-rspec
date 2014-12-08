source plugin/rspec.vim

call vspec#hint({"scope": "rspec#testScope()", "sid": "rspec#sid()"})

describe "SetupCommand"
  it "sets the default command"
    Expect Ref("s:rspec_command") == "!clear && echo rspec {spec} && rspec {spec}"
  end

  context "when g:rspec_command is not defined"
    context "when in GUI"
      context "when g:rspec_runner is defined"
        before
          call Set("s:forceGUI", 1)
          let s:original_runner = g:rspec_runner
          let g:rspec_runner = "iterm"
        end

        after
          let g:rspec_runner = s:original_runner
          call Set("s:forceGUI", 0)
        end

        it "sets the command with provided runner"
          call Call("s:SetupCommand")

          Expect Ref("s:rspec_command") =~ "^silent !\.\*/bin/iterm 'rspec {spec}'$"
        end
      end

      context "when rspec_runner is not defined"
        before
          call Set("s:forceGUI", 1)
        end

        after
          call Set("s:forceGUI", 0)
        end

        it "sets the command with default runner"
          call Call("s:SetupCommand")

          Expect Ref("s:rspec_command") =~ "^silent !\.\*/bin/os_x_terminal 'rspec {spec}'$"
        end
      end
    end
  end

  context "when g:rspec_command is defined"
    before
      call Set("s:forceGUI", 0)
      let g:rspec_command = "Dispatch rspec {spec}"
    end

    after
      unlet g:rspec_command
    end

    context "when not in GUI"
      it "sets the provided command"
        call Call("s:SetupCommand")

        Expect Ref("s:rspec_command") == "Dispatch rspec {spec}"
      end
    end

    context "when in GUI"
      before
        call Set("s:forceGUI", 1)
      end

      after
        call Set("s:forceGUI", 0)
      end

      it "sets the provided GUI command"
        call Call("s:SetupCommand")

        Expect Ref("s:rspec_command") =~ "^silent !\.\*/bin/os_x_terminal 'Dispatch rspec {spec}'$"
      end
    end
  end
end
