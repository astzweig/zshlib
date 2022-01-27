% DEBUGMSG: 'This is a debug message'
% INFOMSG: 'This is an info message'
% WARNMSG: 'This is a warning message'

Describe 'hio'
  It 'prints nothing when no argument is given'
    When call hio
    The output should eq ''
    The status should be success
  End

  It 'prints help message when only type is given'
    When call hio info
    The error should match pattern 'error:*Usage: hio*'
    The status should eq 64
  End

  It 'prints the info message when given one'
    When call hio info "${INFOMSG}"
    The output should match pattern "${INFOMSG}"
    The status should be success
  End

  It 'prints different info messages when given'
    When call hio info "${INFOMSG}." info "${INFOMSG}"
    The output should match pattern "${INFOMSG}. ${INFOMSG}"
    The status should be success
  End

  It 'Prefixes anything but info when output is not to terminal'
    When call hio warn "${WARNMSG}" debug "${DEBUGMSG}" info "${INFOMSG}"
    The output should match pattern "warn: ${WARNMSG} debug: ${DEBUGMSG} ${INFOMSG}"
  End

  It 'prints help messagen when asked for'
    When call hio --help
    The line 1 of output should match pattern 'Usage: hio*'
    The status should be success
  End
End
