Describe 'askUserModuleQuestions answerQuestionsFromCacheOrAskUser'
  Include ./functions/askUserModuleQuestions
  mod="testmod"

  It 'does nothing if module has no questions'
    declare -A questions=()
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq ''
    The variable 'questions' should eq ''
    The status should be success
  End

  It 'asks the user if the question is not in the config'
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    Data 'blue'
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your favorite color? "
    The status should be success
  End

  It 'does not ask the user if the question is stored in the config'
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    config() { [ "${1}" = read ] && echo red; }
    cache=config
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq ''
    The status should be success
  End

  It 'stores the answer in the answers array if asking user'
    declare -A answers
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    Data 'blue'
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your favorite color? "
    The variable "answers[${mod}_question-one]" should eq 'blue'
    The status should be success
  End

  It 'stores the answer in the answers array if retrieving from cache'
    declare -A answers
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    config() { [ "${1}" = read ] && echo red; }
    cache=config
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq ''
    The variable "answers[${mod}_question-one]" should eq 'red'
    The status should be success
  End

  It 'does store the user answer in cache if cache is given'
    declare -A answers
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    writtenValue=""
    Data 'red'
    config() { [ "${1}" = read ] && return; [ "${1}" = write ] && writtenValue="${2}" }
    cache=config
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your favorite color? "
    The variable "answers[${mod}_question-one]" should eq 'red'
    The variable writtenValue should eq 'red'
    The status should be success
  End

  It 'does not store the user answer in cache if no-update options is given'
    declare -A answers
    declare -A questions=([question-one]=$'What is your favorite color?\ninfo')
    writtenValue=""
    Data 'red'
    config() { [ "${1}" = read ] && return; [ "${1}" = write ] && writtenValue="${2}" }
    cache=config
    no_update=true
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your favorite color? "
    The variable "answers[${mod}_question-one]" should eq 'red'
    The variable writtenValue should eq ''
    The status should be success
  End

  It 'does not store the user answer in cache if question for password'
    declare -A answers
    declare -A questions=([some-password]=$'What is your login password?\ninfo')
    writtenValue=""
    Data 'red'
    config() { [ "${1}" = read ] && return; [ "${1}" = write ] && writtenValue="${2}" }
    cache=config
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your login password? "
    The variable "answers[${mod}_some-password]" should eq 'red'
    The variable writtenValue should eq ''
    The status should be success
  End

  It 'does store the user answer in cache if question for password and -p option given'
    declare -A answers
    declare -A questions=([some-password]=$'What is your login password?\ninfo')
    writtenValue=""
    Data 'red'
    config() { [ "${1}" = read ] && return; [ "${1}" = write ] && writtenValue="${2}" }
    cache=config
    save_password=true
    When call _zshlib_askUserModuleQuestions_answerQuestionsFromCacheOrAskUser
    The output should eq "➔ What is your login password? "
    The variable "answers[${mod}_some-password]" should eq 'red'
    The variable writtenValue should eq 'red'
    The status should be success
  End
End
