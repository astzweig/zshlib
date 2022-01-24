% APPNAME: 'com.example.zshlib'

Describe 'getPrefDir'
  It 'prints usage when called without arguments'
    When call getPrefDir
    The output should eq ''
    The error should match pattern 'error:*Usage:*getPrefDir*'
    The status should be failure
  End

  It 'prints default user config when called with app as only argument'
    When call getPrefDir "${APPNAME}"
    The output should eq "${HOME}/Library/Preferences"
    The status should be success
  End

  It 'prints app support when called with appdata'
    When call getPrefDir "${APPNAME}" appdata
    The output should eq "${HOME}/Library/Application Support/${APPNAME}"
    The status should be success
  End

  It 'prints home folder when linux is given as os'
    When run getPrefDir -o linux "${APPNAME}"
    The output should eq "${HOME}"
    The status should be success
  End

  It 'prints sub home folder when called with appdata and linux as os'
    When run getPrefDir -o linux "${APPNAME}" appdata
    The output should eq "${HOME}/.${APPNAME}"
    The status should be success
  End
End
