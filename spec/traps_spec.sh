Describe 'traps'
  local -A traps=()
  function clearTraps() { traps=() }
  BeforeEach clearTraps

  It 'adds cmd to traps list'
    traps add somename 'print -- somestr'
    When call traps call
    The output should eq 'somestr'
    The status should be success
  End

  It 'does not execute command if signal does not match'
    traps add somename 'print -- somestr' int
    When call traps call exit
    The output should eq ''
    The status should be success
  End

  It 'does execute command if it was added with all signal even if signal does not match on call'
    traps add somename 'print -- somestr'
    When call traps call exit
    The output should eq 'somestr'
    The status should be success
  End

  It 'does execute command if no signal is given for call'
    traps add somename 'print -- somestr' int
    When call traps call
    The output should eq 'somestr'
    The status should be success
  End

  It 'does not execute command if it has been cleared'
    traps add somename 'print -- somestr' int
    traps clear
    When call traps call
    The output should eq ''
    The status should be success
  End

  It 'does not execute command if it has been removed'
    traps add somename 'print -- somestr' int
    traps remove somename
    When call traps call
    The output should eq ''
    The status should be success
  End

  It 'does not remove command if signale does not match'
    traps add somename 'print -- somestr' int
    traps remove somename exit
    When call traps call
    The output should eq 'somestr'
    The status should be success
  End

  It 'does not clear unmatched signals'
    traps add somename 'print -- somestr' int
    traps clear exit
    When call traps call
    The output should eq 'somestr'
    The status should be success
  End
End
