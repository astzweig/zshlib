% APPNAME: 'com.example.zshlib'
% KEYVALUE: 'myvalue'

config_does_not_exist() {
  config_does_exist && return 12 || return 0
}

config_does_exist() {
  test -f "${HOME}/Library/Preferences/${1:-${APPNAME}}.plist"
}

no_array_in_config() {
  grep 'array' "${HOME}/Library/Preferences/${APPNAME}.plist" || return 0
}

array_in_config() {
  grep 'array' "${HOME}/Library/Preferences/${APPNAME}.plist" > /dev/null
}

rmfiles() {
  for file; do
    [ -f "${file}" ] && rm "${file}";
  done
}

Describe 'config'
  setup() { 
    config_does_not_exist
    config setappname "${APPNAME}"
    config write "${KEYVALUE}" someexistentkey
    config write "${KEYVALUE}" some existent key
  }
  cleanup() {
    setopt nonomatch
    rmfiles "${HOME}/Library/Preferences/${APPNAME}"*.plist || return 0
  }
  BeforeEach 'setup'
  AfterEach 'cleanup'

  It 'prints usage when no argument is given'
    When call config
    The output should eq ''
    The error should match pattern 'error:*Usage:*config*'
    The status should eq 64
  End

  It 'exits cleanly when setting the app name'
    When call config setappname "${APPNAME}"
    The output should eq ''
    The status should be success
  End

  It 'creates config on first write'
    When call config write myval mykey
    Assert config_does_exist
    The output should eq ''
    The status should be success
  End

  It 'takes app name from options -a for writing'
    When call config -a "${APPNAME}.second" write myval mykey
    Assert config_does_exist "${APPNAME}.second"
    The output should eq ''
    The status should be success
  End

  It 'takes app name from options -a for reading'
    config -a "${APPNAME}.second" write myval mykey
    When call config -a "${APPNAME}.second" read mykey
    Assert config_does_exist "${APPNAME}.second"
    The output should eq 'myval'
    The status should be success
  End

  It 'returns nothing for nonexistent key'
    When call config read mykey
    The output should eq ''
    The status should be failure
  End

  It 'returns something for existent key'
    When call config read someexistentkey
    The output should eq "${KEYVALUE}"
    The status should be success
  End

  It 'creates string key when first key is integer'
    When call config write myval 0
    Assert no_array_in_config
    The output should eq ''
    The status should be success
  End

  It 'creates array when key is integer'
    When call config write myval mykey 0
    Assert array_in_config
    The output should eq ''
    The status should be success
  End

  It 'reads nested keys'
    When call config read some existent key
    The output should eq "${KEYVALUE}"
    The status should be success
  End
End
