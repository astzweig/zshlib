Describe 'pf'
  It 'prints nothing when no argument is given'
    When call pf
    The output should eq ''
    The status should be success
  End

  It 'prints help message when unknown option is given'
    When call pf -l goes on and on
    The line 1 of error should eq 'error: '
    The status should be failure
  End

  It 'prints a given string to stdout'
    When call pf somestr
    The output should eq 'somestr'
    The status should be success
  End

  It 'passes all args to print'
    When call pf -- -l that goes on
    The line 1 of output should eq 'that'
    The status should be success
  End

  It 'passes command to tput'
    test [() { builtin test "$1 $2" = '-t 1' && return; builtin $0 "$@"; }
    When call pf -c bold that goes on
    The line 1 of output should eq "`tput bold`that goes on"
    The status should be success
  End

  It 'converts integer command to tput setaf command'
    test [() { builtin test "$1 $2" = '-t 1' && return; builtin $0 "$@"; }
    When call pf -c 240 that goes on
    The line 1 of output should eq "`tput setaf 240`that goes on"
    The status should be success
  End

  It 'passes multiple commands to tput in order'
    test [() { builtin test "$1 $2" = '-t 1' && return; builtin $0 "$@"; }
    When call pf -c bold,240 that goes on
    The line 1 of output should eq "`tput bold; tput setaf 240`that goes on"
    The status should be success
  End

  It 'resets output if -r option is given'
    test [() { builtin test "$1 $2" = '-t 1' && return; builtin $0 "$@"; }
    When call pf -r that goes on
    The of output should eq 'that goes on'$'\n'`tput sgr0`
    The status should be success
  End
End
