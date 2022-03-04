Describe 'isTerminalBackgroundDark'
  test() { [ "$1" = '-t' ] && return; builtin test "$@" }

  It 'returns code 10 if output is not connected to terminal'
    test() { builtin test "$@" }
    When call isTerminalBackgroundDark
    The status should eq 10
  End

  It 'returns failure if color is white'
    print() {}
    Data '1;rgb:ffff/ffff/ffff'
    When call isTerminalBackgroundDark
    The status should be failure
  End

  It 'returns success if color is black'
    print() {}
    Data '1;rgb:0000/0000/0000'
    When call isTerminalBackgroundDark
    The status should be success
  End

  It 'returns success if color is dark blue'
    print() {}
    Data '11;rgb:2b5f/66a6/c977'
    When call isTerminalBackgroundDark
    The status should be success
  End
End
