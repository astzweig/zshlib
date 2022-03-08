Describe 'askUserModuleQuestions parseQuestionLine'
  Include ./askUserModuleQuestions

  It 'does nothing if the line is empty' 
    line=''
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should be success
  End

  It 'does nothing if the line does not have a question type' 
    line='some value here'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should eq 10
  End

  It 'does nothing if the line does not have a valid question type' 
    line='z: some value here'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should eq 11
  End

  It 'does nothing if the line does not have a parameter name' 
    line='i: '
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should eq 12
  End

  It 'does nothing if the parameter name starts with a dash'
    line='i: -parameter-name=Is this my question?'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should eq 13
  End

  It 'does nothing if the line does not have a question' 
    line='i: parameter-name='
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The status should eq 14
  End

  It 'extends outer questions associative array with question'
    declare -A questions
    line='i: parameter-name=What parameter do you like? #'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The line 1 of variable 'questions[parameter-name]' should eq 'What parameter do you like?'
    The line 2 of variable 'questions[parameter-name]' should eq info
    The status should be success
  End

  It 'ignores empty arguments'
    declare -A questions
    line='i: parameter-name=What parameter do you like? # some arg: some value;;'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The line 1 of variable 'questions[parameter-name]' should eq 'What parameter do you like?'
    The status should eq 0
  End

  It 'does nothing if an argument does not contain a name'
    declare -A questions
    line='i: parameter-name=What parameter do you like? # some arg: some value;:some value;'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The output should eq ''
    The variable 'questions' should eq ''
    The status should eq 15
  End

  It 'writes question type to outer questions associative array'
    declare -A questions
    line='s: parameter-name=What parameter do you like? # choose from: blue,red,light green; default: blue'
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The line 2 of variable 'questions[parameter-name]' should eq 'select;choose from:blue,red,light green;default:blue'
  End
End

Describe "askUserModuleQuestions parseQuestionLine type renaming"
  Include ./askUserModuleQuestions
  Parameters
    i info
    p password
    c confirm
    s select
  End

  It "converts $1 to $2"
    declare -A questions
    line="${1}: parameter-name=What parameter do you like? #"
    When call _zshlib_askUserModuleQuestions_parseQuestionLine
    The line 2 of variable 'questions[parameter-name]' should eq "$2"
  End
End
