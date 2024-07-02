Describe 'askUserModuleQuestions convertQuestionArgsToAskUserArgs'
  Include ./functions/askUserModuleQuestions

  It 'converts info to info'
    args=()
    choices=()
    questionArgs='info'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The output should eq ''
    The variable args should eq 'info'
    The variable choices should eq ''
    The status should be success
  End

  It 'converts info with default arg to info with default arg'
    args=()
    choices=()
    questionArgs='info;default:Mario Kart'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The output should eq ''
    The variable args should eq '-d Mario Kart info'
    The variable choices should eq ''
    The status should be success
  End

  It 'converts password to -p info'
    args=() choices=() questionArgs='password'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq '-p info'
    The variable choices should eq ''
  End

  It 'converts confirm to confirm'
    args=() choices=() questionArgs='confirm'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq 'confirm'
    The variable choices should eq ''
  End

  It 'returns if type is select but no choose from arg is provided'
    args=() choices=() questionArgs='select'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq ''
    The variable choices should eq ''
    The status should eq 10
  End

  It 'converts select to choose'
    args=() choices=() questionArgs='select;choose from:blue,light green,red'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq 'choose'
    The variable choices should eq 'blue light green red'
    The variable '#choices' should eq 3
  End

  It 'converts validator to -v option for choose'
    args=() choices=() questionArgs='select;validator:is_file;choose from:blue,light green,red'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq 'choose -v is_file'
    The variable choices should eq 'blue light green red'
    The variable '#choices' should eq 3
  End

  It 'finds choose from arg even if many args are provided'
    args=() choices=() questionArgs='select;first arg:red;choose from:blue,light green,red;after arg:nine;after arg:nine;'
    When call _zshlib_askUserModuleQuestions_convertQuestionArgsToAskUserArgs
    The variable args should eq 'choose'
    The variable choices should eq 'blue light green red'
    The variable '#choices' should eq 3
  End
End
