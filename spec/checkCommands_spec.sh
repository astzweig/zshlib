Describe 'checkCommands'
  It 'does nothing if no c2c is provided'
    When call checkCommands
    The error should eq ''
    The status should be success
  End

  It 'fails silently if command does not exist'
    When call checkCommands nonexistentcmd
    The error should eq ''
    The status should be failure
  End

  It 'fails with message if command does not exist and message is provided'
    When call checkCommands -m 'Error message' nonexistentcmd
    The error should match pattern '*] ☠ Error message'
    The status should be failure
  End

  It 'inserts command name in message'
    When call checkCommands -m 'Pre %s' nonexistentcmd
    The error should match pattern '*] ☠ Pre nonexistentcmd'
    The status should be failure
  End

  It 'inserts comment in message'
    local -A cmds=(nonexistentcmd 'Some comment')
    When call checkCommands -m 'Pre %2$s %1$s' nonexistentcmd
    The error should match pattern '*] ☠ Pre Some comment nonexistentcmd'
    The status should be failure
  End
End
