Describe 'config'
  setup() {
    TMPDIR="`mktemp -d`"
    TMPFILE="${TMPDIR}/file.txt"
  }
  cleanup() {
    setopt localoptions nonomatch
    rm -fr "${TMPDIR}"
  }
  getPrefDir() { echo "${TMPDIR}" }
  BeforeEach setup
  AfterEach cleanup

  It 'prints usage when no argument is given'
    When call config
    The output should eq ''
    The error should match pattern 'error:*Usage:*config*'
    The status should eq 64
  End

  It 'exits cleanly when setting the app name'
    When call config setappname my.app.name
    The output should eq ''
    The status should be success
  End

  It 'fails to read when no appname or configfile is set'
    When call config write myval mykey
    The output should eq ''
    The status should eq 10
  End

  It 'fails to read when no appname or configfile is set'
    When call config read mykey
    The output should eq ''
    The status should eq 10
  End

  It 'handles non existent files for reading'
    When call config -c "${TMPFILE}" read mykey
    The path "${TMPFILE}" should not be file
    The output should eq ''
    The status should be success
  End

  It 'handles non existent files for writing'
    When call config -c "${TMPFILE}" write myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'handles empty files for reading'
    : > "${TMPFILE}"
    When call config -c "${TMPFILE}" read mykey
    The path "${TMPFILE}" should be empty file
    The output should eq ''
    The status should be success
  End

  It 'handles empty files for writing'
    : > "${TMPFILE}"
    When call config -c "${TMPFILE}" write myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'handles malformed files for writing'
    echo 'some temporary string' > "${TMPFILE}"
    When call config -c "${TMPFILE}" write myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'handles malformed files for reading'
    echo 'some temporary string' > "${TMPFILE}"
    When call config -c "${TMPFILE}" read myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be failure
  End

  It 'creates config on first write'
    APPNAME=my.app.name
    config setappname "${APPNAME}"
    When call config write myval mykey
    The path "${TMPDIR}/${APPNAME}.plist" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'takes app name from options -a for writing'
    APPNAME=my.app.name
    When call config -a "${APPNAME}" write myval mykey
    The path "${TMPDIR}/${APPNAME}.plist" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'takes app name from options -a for reading'
    APPNAME=my.app.name
    config -a "${APPNAME}" write myval mykey
    When call config -a "${APPNAME}" read mykey
    The path "${TMPDIR}/${APPNAME}.plist" should not be empty file
    The output should eq 'myval'
    The status should be success
  End

  It 'takes config path from option -c for writing'
    When call config -c "${TMPFILE}" write myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'can set configfile in advance for writing'
    config setconfigfile "${TMPFILE}"
    When call config write myval mykey
    The path "${TMPFILE}" should not be empty file
    The output should eq ''
    The status should be success
  End

  It 'can set configfile in advance for reading'
    config setconfigfile "${TMPFILE}"
    When call config read mykey
    The path "${TMPFILE}" should not be file
    The output should eq ''
    The status should be success
  End

  It 'returns nothing for nonexistent key'
    config write -c "${TMPFILE}" write myval somekey
    When call config -c "${TMPFILE}" read mykey
    The output should eq ''
    The status should be failure
  End

  It 'returns something for existent key'
    config -c "${TMPFILE}" write myval someexistentkey
    When call config -c "${TMPFILE}" read someexistentkey
    The output should eq myval
    The status should be success
  End

  It 'creates string key when first key is integer'
    no_array_in_config() { grep 'array' "${TMPFILE}" >&! /dev/null || return 0; return 1 }
    When call config -c "${TMPFILE}" write myval 0
    The result of function no_array_in_config should be successful
    The output should eq ''
    The status should be success
  End

  It 'creates array when key is integer'
    no_array_in_config() { grep 'array' "${TMPFILE}" >&! /dev/null }
    When call config -c "${TMPFILE}" write myval mykey 0
    The result of function no_array_in_config should be successful
    The output should eq ''
    The status should be success
  End

  It 'reads nested keys'
    VALUE=myval
    config -c "${TMPFILE}" write "${VALUE}" some existent key
    When call config -c "${TMPFILE}" read some existent key
    The output should eq "${VALUE}"
    The status should be success
  End

  It 'can read after multiple writes'
    config -c "${TMPFILE}" write 'value one' my first key
    config -c "${TMPFILE}" write 'value two' my second key
    When call config -c "${TMPFILE}" read my first key
    The output should eq 'value one'
    The status should be success
  End
End
