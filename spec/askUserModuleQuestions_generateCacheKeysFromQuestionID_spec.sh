Describe 'askUserModuleQuestions generateCacheKeysFromQuestionID'
  Include ./askUserModuleQuestions

  It 'does nothing if given no arguments' 
    declare -A cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID ''
    The output should eq ''
    The variable 'cachekeys' should eq ''
    The status should be success
  End

  It 'does nothing if question id is empty' 
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID 'somemod' ''
    The output should eq ''
    The variable 'cachekeys' should eq ''
    The status should be success
  End

  It 'generates key when given module name and question id'
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID 'somemod' 'somekey'
    The output should eq ''
    The variable 'cachekeys' should eq 'somemod questions somekey'
    The status should be success
  End

  It 'replaces minus with underscore'
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID 'some-mod' 'somekey'
    The output should eq ''
    The variable 'cachekeys' should eq 'some_mod questions somekey'
    The status should be success
  End

  It 'replaces multiple minus with single underscore'
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID 'some---mod' 'so--mekey'
    The output should eq ''
    The variable 'cachekeys' should eq 'some_mod questions so_mekey'
    The status should be success
  End

  It 'replaces underscores at the begin and end of string'
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID '--some-mod' '--somekey-'
    The output should eq ''
    The variable 'cachekeys' should eq 'some_mod questions somekey'
    The status should be success
  End

  It 'removes all chars but [A-Za-z_]'
    declare cachekeys=()
    When call _zshlib_askUserModuleQuestions_generateCacheKeysFromQuestionID '*some≠{mod' '?`somekey'
    The output should eq ''
    The variable 'cachekeys' should eq 'somemod questions somekey'
    The status should be success
  End
End
