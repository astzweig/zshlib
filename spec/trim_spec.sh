Describe 'trim'
  Parameters
    space ' '
    tab $'\t'
    nonbreakable-space ' '
  End

  It 'does nothing if the string does not contain leading or trailing whitespace'
    When call trim 'mystr'
    The output should eq 'mystr'
    The status should be success
  End

  It "removes leading $1"
    When call trim "${2}mystr"
    The output should eq 'mystr'
    The status should be success
  End

  It "removes trailing $1"
    When call trim "mystr${2}"
    The output should eq 'mystr'
    The status should be success
  End
End
