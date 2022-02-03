Describe 'askUser'
  It 'prints usage if no argument is given'
    When call askUser
    The output should eq ''
    The error should match pattern 'error:*Usage:*askUser*'
    The status should eq 64
  End
End

Describe 'askUser confirm'
  QUESTION='Is this a question?'
  It 'asks user for confirmation'
    Data 'y'
    When call askUser confirm "${QUESTION}"
    The output should eq "${QUESTION} [y/n] "
    The error should eq ''
    The variable REPLY should eq 'y'
  End

  It 'asks user again if no input is made'
    Data
      #|
      #|y
    End
    When call askUser confirm "${QUESTION}"
    The output should eq "${QUESTION} [y/n] ${QUESTION} [y/n] "
    The error should eq 'error: No input made. Please confirm with y or n.'
    The variable REPLY should eq 'y'
    The status should eq 0
  End

  It 'shows big Y at question end with y option'
    Data
      #|y
    End
    When call askUser confirm -y "${QUESTION}"
    The output should eq "${QUESTION} [Y/n] "
    The variable REPLY should eq 'y'
    The status should eq 0
  End

  It 'shows big N at question end with n option'
    Data
      #|y
    End
    When call askUser confirm -n "${QUESTION}"
    The output should eq "${QUESTION} [y/N] "
    The variable REPLY should eq 'y'
    The status should eq 0
  End

  It 'prints usage if both y and n options are given'
    When call askUser confirm -y -n "${QUESTION}"
    The output should eq ''
    The error should match pattern 'error:*Usage:*askUser*'
    The status should eq 64
  End

  It 'chooses yes with y option but no input is made'
    Data
      #|
    End
    When call askUser confirm -y "${QUESTION}"
    The output should eq "${QUESTION} [Y/n] "
    The variable REPLY should eq ''
    The status should eq 0
  End

  It 'chooses no with n option but no input is made'
    Data
      #|
    End
    When call askUser confirm -n "${QUESTION}"
    The output should eq "${QUESTION} [y/N] "
    The variable REPLY should eq ''
    The status should eq 1
  End

  It 'asks user again if wrong input is made'
    Data
      #|sy
    End
    When call askUser confirm "${QUESTION}"
    The output should eq "${QUESTION} [y/n] ${QUESTION} [y/n] "
    The error should eq 'error: Unrecognized input. Please confirm with y or n.'
    The variable REPLY should eq 'y'
    The status should eq 0
  End

  It 'returns 1 if user inputs n'
    Data
      #|n
    End
    When call askUser confirm "${QUESTION}"
    The output should eq "${QUESTION} [y/n] "
    The error should eq ''
    The variable REPLY should eq 'n'
    The status should eq 1
  End
End

Describe 'askUser choose'
  QUESTION='Please select a color:'
  It 'returns 64 if choices array does not exist'
    When call askUser choose "${QUESTION}"
    The output should eq ''
    The error should eq 'error: choices must be an array defined outside.'
    The variable REPLY should eq ''
    The status should eq 64
  End

  It 'does nothing if choices is empty'
    choices=()
    When call askUser choose "${QUESTION}"
    The output should eq ''
    The error should eq ''
    The variable REPLY should eq ''
    The status should eq 0
  End

  It 'asks again if input is empty'
    choices=('blue' 'red')
    Data
      #|
      #|1
    End
    When call askUser choose "${QUESTION}"
    The output should eq "${QUESTION}"
    The error should match pattern '1)*1)*' 
    The variable REPLY should eq 'blue'
    The status should eq 0
  End

  It 'asks again if input is wrong'
    choices=('blue' 'red')
    Data
      #|a
      #|40ia
      #|1
    End
    When call askUser choose "${QUESTION}"
    The output should eq "${QUESTION}"
    The error should match pattern '*?# ?# ?# ' 
    The variable REPLY should eq 'blue'
    The status should eq 0
  End

  It 'accepts value if it passes validation'
    choices=('blue' 'red' 'green')
    isYellow() { test "${1}" = yellow; }
    DEFAULT_VALUE=green
    Data
      #|yellow
    End
    When call askUser choose -v isYellow "${QUESTION}"
    The output should eq "${QUESTION}" 
    The error should match pattern '1)*?# ' 
    The variable REPLY should eq 'yellow'
    The status should eq 0
  End

  It 'sets REPLY to the chosen value'
    choices=('blue' 'red')
    Data
      #|2
    End
    When call askUser choose "${QUESTION}"
    The output should eq "${QUESTION}"
    The error should match pattern '1)*?# ' 
    The variable REPLY should eq 'red'
    The status should eq 0
  End
End

Describe 'askUser info'
  QUESTION='What shall the username be?'

  It 'prints usage if no prompt is given'
    When call askUser info
    The output should eq ''
    The error should match pattern 'error:*Usage:*askUser*'
    The status should eq 64
  End

  It 'asks user for info'
    Data
      #|answer
    End
    When call askUser info "${QUESTION}"
    The output should eq "${QUESTION} "
    The error should eq ''
    The variable REPLY should eq 'answer'
    The status should eq 0
  End

  It 'asks again if no input is made'
    Data
      #|
      #|answer
    End
    When call askUser info "${QUESTION}"
    The output should eq "${QUESTION} ${QUESTION} "
    The error should eq ''
    The variable REPLY should eq 'answer'
    The status should eq 0
  End

  It 'shows default value in prompt line if one is given'
    Data 'myanswer'
    When call askUser info -d myvalue "${QUESTION}"
    The output should eq "${QUESTION} debug: [default: myvalue] "
    The error should eq ''
    The variable REPLY should eq 'myanswer'
    The status should eq 0
  End

  It 'uses default value if one is given and no input is made'
    Data
      #|
    End
    When call askUser info -d myvalue "${QUESTION}"
    The output should eq "${QUESTION} debug: [default: myvalue] "
    The error should eq ''
    The variable REPLY should eq 'myvalue'
    The status should eq 0
  End

  It 'validates input if validator is given and asks again if validation fails'
    smallNumber() { 
      test "${1}" -eq "${1}" -a "${1}" -lt 10  2> /dev/null
    }
    Data
      #|answer
      #|9
    End
    When call askUser info -v smallNumber "${QUESTION}"
    The output should eq "${QUESTION} ${QUESTION} "
    The error should eq ''
    The variable REPLY should eq '9'
    The status should eq 0
  End
End
