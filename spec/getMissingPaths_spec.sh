Describe 'getMissingPaths'
  It 'prints help if no pathitem is provided'
    When call getMissingPaths
    The output should eq ''
    The error should match pattern 'error:*Usage*'
    The status should be failure
  End

  It 'prints nothing if all segments exist'
    test [() { builtin test "$1" = -d && return; builtin $0 "$@" }
    When call getMissingPaths /existing/directory
    The output should eq ''
    The status should be success
  End

  It 'prints all segments if nothing exists'
    When call getMissingPaths /nonexistent/path
    The line 1 of output should eq '/nonexistent/path'
    The line 2 of output should eq '/nonexistent'
    The status should be success
  End

  It 'prints only non existent segments'
    test [() { builtin test "$1" = -d && builtin test "$2" = /existent && return; builtin $0 "$@" }
    When call getMissingPaths /existent/nonexistent/path
    The line 1 of output should eq '/existent/nonexistent/path'
    The line 2 of output should eq '/existent/nonexistent'
    The status should be success
  End

  It 'does not check last element if -f option is given'
    test [() { builtin test "$1" = -d && builtin test "$2" = /existent && return; builtin $0 "$@" }
    When call getMissingPaths -f /existent/nonexistent/path
    The output should eq '/existent/nonexistent'
    The status should be success
  End
End
