Describe 'showSpinner'
  func_called=false
  emptyfunc() {}
  tput() {}
  stty() {}
  print() {}
  setVar() { func_called=true }
  test [() { builtin test "$1" = '-t' && return; builtin $0 "$@" }
  setVarSleep() { sleep 0.1; func_called=true }
  setup() { func_called=false }
  BeforeEach 'setup'

  It 'prints usage if no argument is given'
    When call showSpinner
    The error should match pattern 'error:*Usage:*showSpinner*'
    The status should eq 64
  End

  It 'hides the cursor before calling the func'
    cursor_hidden=false
    tput() { [ "$1" = civis -a "$func_called" = false ] && cursor_hidden=true; return 0 }
    When call showSpinner setVar
    The variable cursor_hidden should eq true
    The status should eq 0
  End

  It 'hides input echoing before calling the func'
    input_echoing_hidden=false
    stty() {
      while [ -n "$1" ]; do
        [ "$1" = '-echo' -a "$func_called" = false ] && input_echoing_hidden=true
        shift
      done
      return 0
    }
    When call showSpinner setVar
    The variable input_echoing_hidden should eq true 
    The status should eq 0
  End

  It 'allows argument passing to func'
    args=
    myfunc() { args=("$@") }
    When call showSpinner -- myfunc -c hallo
    The variable args should eq '-c hallo'
    The variable 'args[1]' should eq '-c'
  End

  It 'shows the cursor after calling the func'
    cursor_hidden=true
    tput() { [ "$1" = cnorm -a "$func_called" = true ] && cursor_hidden=false; return 0 }
    When call showSpinner setVar
    The variable cursor_hidden should eq false
    The status should eq 0
  End

  It 'does not show the cursor after calling the func if TERMINAL_CURSOR_HIDDEN env is set'
    cursor_hidden=true
    tput() { [ "$1" = cnorm -a "$func_called" = true ] && cursor_hidden=false; return 0 }
    run() { TERMINAL_CURSOR_HIDDEN="true" showSpinner setVar }
    When call run
    The variable cursor_hidden should eq true
    The status should eq 0
  End

  It 'reset input echoing after calling the func'
    previousSettings=$(stty -g 2> /dev/null)
    input_echoing_hidden=true
    stty() {
      [ "$*" = "${previousSettings}" ] && input_echoing_hidden=false
      return 0
    }
    When call showSpinner setVar
    The variable input_echoing_hidden should eq false
    The status should eq 0
  End

  It 'shows first spinner sequence before calling func'
    print() { [ -z "$first" ] || return 0; first=1; builtin print "$@"; }
    When call showSpinner setVarSleep
    The output should eq '.  '
    The status should eq 0
  End

  It 'can set sequence duration'
    print() { builtin print "$@"; }
    When call showSpinner -d 1 setVarSleep
    The output should eq '.  '
    The status should eq 0
  End

  It 'returns failure if duration is set to less than 0.1'
    When call showSpinner -d 0.05 setVar
    The output should eq ''
    The status should be failure
  End

  It 'can set spinner sequences'
    print() { builtin print "$@"; }
    When call showSpinner -s '-  -- ---   ' setVarSleep
    The output should eq '-  '
    The status should eq 0
  End

  It 'can set sequence width'
    print() { builtin print "$@"; }
    When call showSpinner -w 1 setVarSleep
    The output should eq '.'
    The status should eq 0
  End

  It 'returns failure if width is set to less than 1'
    When call showSpinner -w 0.9 setVar
    The output should eq ''
    The status should be failure
  End

  It 'executes func without spinner, if output is not to terminal'
    test() { builtin test "$@" }
    When call showSpinner setVar
    The output should eq ''
    The variable func_called should eq true
    The status should be success
  End

  It 'catches any output of func if output is to terminal'
    outfunc() { echo "hallo" }
    When call showSpinner outfunc
    The output should eq ''
    The status should be success
  End

  It 'does not catch any output of func if output is not to terminal'
    outfunc() { echo "hallo" }
    test() { builtin $0 "$@" }
    When call showSpinner outfunc
    The output should eq 'hallo'
    The status should be success
  End

  It 'catches and stores any output of func if output is to terminal'
    outfunc() { echo "hallo" }
    out=
    When call showSpinner -o out outfunc
    The output should eq ''
    The variable out should eq 'hallo'
    The status should be success
  End
End
