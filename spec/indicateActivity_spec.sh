Describe 'indicateActivity misuse'
  Parameters
    'no msg argument is given' ''
    'no work option is given' 'Some message'
  End

  It "shows help if $1"
    When call indicateActivity ${(s.,.)2}
    The error should match pattern 'error:*Usage: indicateActivity*'
    The status should be failure
  End
End

Describe 'indicateActivity'
    output="`tput setaf 255`➔ `tput sgr0; tput setaf 8; tput setaf 255`Some message`tput sgr0;tput civis; tput cnorm``tput setaf 8`done"$'\n'`tput sgr0`
    fileoutput='*] ➔ Some message...*] failed'

  task() {}
  failing_task() { return 1 }

  It 'returns return code of func'
    When call indicateActivity -- failing_task 'Some message'
    The output should match pattern "$fileoutput"
    The status should eq 1
  End

  It 'does not print anything if lop filters everything'
    lop() { return 1 }
    When call indicateActivity -- task 'Some message'
    The output should eq ''
  End

  It 'does not print anything if lop output is to file'
    lop() { [[ $1 = getoutput ]] && echo /dev/null }
    When call indicateActivity -- task 'Some message'
    The output should eq ''
  End

  It 'does not print anything if lop output is to syslog'
    lop() { [[ $1 = getoutput ]] && echo syslog }
    When call indicateActivity -- task 'Some message'
    The output should eq ''
  End

  It 'does print something'
    lop() { [[ $1 = getoutput ]] && echo stdout || print -n -- "${@[-1]}" }
    When call indicateActivity -- task 'Some message'
    The output should eq 'Some message...done'
  End
End
