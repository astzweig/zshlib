Describe 'indicateActivity misuse'
  Parameters
    'no msg argument is given' ''
    'no work option is given' 'Some message'
  End

  It "shows help if $1"
    When call indicateActivity ${2}
    The error should match pattern 'error:*Usage: indicateActivity*'
    The status should be failure
  End
End

Describe 'indicateActivity'
    output="`tput setaf 255`➔ `tput sgr0; tput setaf 8; tput setaf 255`Some message`tput sgr0;tput civis; tput cnorm``tput setaf 8`done"$'\n'`tput sgr0`
    fileoutput='*] ➔ Some message'

  task() {}
  failing_task() { return 1 }

  It 'returns return code of func'
    When call indicateActivity -- 'Some message' failing_task
    The output should match pattern "$fileoutput"
    The status should eq 1
  End

  It 'does not print anything if lop filters everything'
    lop() { return 1 }
    When call indicateActivity -- 'Some message' task
    The output should eq ''
  End

  It 'does not print anything if lop output is to file'
    lop() { [[ $1 = getoutput ]] && echo /dev/null }
    When call indicateActivity -- 'Some message' task
    The output should eq ''
  End

  It 'does not print anything if lop output is to syslog'
    lop() { [[ $1 = getoutput ]] && echo syslog }
    When call indicateActivity -- 'Some message' task
    The output should eq ''
  End

  It 'does print something if output is to stdout but not to terminal'
    lop() { [[ $1 = getoutput ]] && echo stdout || print -n -- "${@[-1]}" }
    When call indicateActivity -- 'Some message' task
    The output should eq 'Some message'
  End
End

Describe 'indicateActivity'
  task() {}
  showSpinner() { }
  formattedOutput="Some message`tput cr; tput el`Some message"
  message='Some message'
  Parameters
    filtered stdout terminal ''
    filtered other terminal ''
    filtered stdout other ''
    filtered other other ''

    unfiltered stdout terminal "${formattedOutput}"
    unfiltered other terminal ''
    unfiltered stdout other "${message}"
    unfiltered other other ''
  End

  It "${${4:+does}:-does not} print message if lop output is $1, lop output is to ${2} and stdout goes to $3"
    local FILTERED=$1 OUTPUT=$2 STDOUTTO=$3
    test [() {
      [[ $1 = -t && $2 = 1 ]] && { [[ $STDOUTTO = terminal ]]; return };
      builtin $0 "$@"
    }
    lop () {
      [[ $1 = getoutput ]] && { echo $OUTPUT; return };
      local args=("$@")
      [[ $FILTERED != filtered && $OUTPUT = stdout && $OUTPUT = stdout ]] && print -n -- "${@[-1]}"
    }
    When call indicateActivity -- "${message}" task
    The output should eq "${4}"
  End
End
