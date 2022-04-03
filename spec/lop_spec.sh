Describe 'lop misuse'
 Parameters
  'called without any argument' ''
  'called with only --no-newline option' --no-newline
  'called with only -s option' -s
  'called with only -f option' -f,/dev/stdout
  'called with only -l option' -l,info
 End

 It "prints help if $1"
  When call lop ${(s.,.)2}
  The output should eq ''
  The error should match pattern 'error:*Usage*lop*'
  The status should be failure
 End
End

Describe 'lop'
 syslogmsg=
 logger() { [ $# -gt 4 ] && syslogmsg=$5 || syslogmsg=$3 }

 It 'prints help if called with --help option'
  When call lop --help
  The output should match pattern 'Usage*lop*'
  The status should be success
 End

 It 'prints debug message'
  msg='some message'
  When call lop -- -d "${msg}"
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'prints debug message if both debug and info message are given'
  msg='some message'
  When call lop -- -d "${msg}" -i 'some other message here'
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'does not print debug if loglevel is set to info'
  When call lop -l info -- -d 'some message'
  The output should eq ''
  The status should eq 1
 End

 It 'can configure loglevel in advance'
  lop setoutput -l info tostdout
  When call lop -- -d 'some message'
  The output should eq ''
  The status should eq 1
 End

 It 'does print info if loglevel is set to info'
  msg='some other message'
  When call lop -l info -- -d 'some message' -i "${msg}"
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'prints tagline if one is given'
  msg='some message'
  tag='some tag'
  When call lop -t "${tag}" -- -d "${msg}"
  The output should match pattern "*${tag}] ${msg}"
  The status should be success
 End

 It 'prints to file if told so'
  msg='some other message'
  tmpfile="`mktemp`"
  When call lop -f "${tmpfile}" -- -d "${msg}" -i 'some other message'
  The contents of file "${tmpfile}" should match pattern "*] ${msg}"
  The status should be success
 End

 It 'can configure output to file in advance'
  msg='some other message'
  tmpfile="`mktemp`"
  run() { lop setoutput "${tmpfile}"; lop -- -d "${msg}" -i 'some other message'; }
  When call run
  The contents of file "${tmpfile}" should match pattern "*] ${msg}"
  The status should be success
 End

 It 'pushes message to syslog if asked for'
  msg='some other message'
  When call lop -s -- -d "${msg}" -i 'some other message'
  The variable syslogmsg should eq "${msg}"
  The status should be success
 End

 It 'can configure output to syslog in advance'
  msg='some other message'
  run() { lop setoutput tosyslog; lop -- -d "${msg}" -i 'some other message'; }
  When call run
  The variable syslogmsg should eq "${msg}"
  The status should be success
 End

 It 'returns the default output form'
  When call lop getoutput
  The output should eq 'stdout'
  The status should be success
 End

 It 'accepts multiple types'
  When call lop -y body:add -y body:warn -- -i 'some message'
  The output should match pattern '*] some message'
  The status should be success
 End

 It 'returns syslog output if preconfigured'
  run() { lop setoutput tosyslog; lop getoutput }
  When call run
  The output should eq 'syslog'
  The status should be success
 End

 It 'returns syslog output if configured'
  When call lop getoutput -s
  The output should eq 'syslog'
  The status should be success
 End

 It 'returns filepath output if preconfigured'
  run() { lop setoutput /some/path; lop getoutput }
  When call run
  The output should eq '/some/path'
  The status should be success
 End

 It 'returns filepath output if configured'
  When call lop getoutput -f /some/path
  The output should eq '/some/path'
  The status should be success
 End

 It 'returns output regardless of other arguments if called with getoutput'
  When call lop getoutput -f /some/path -- -i 'Some message'
  The output should eq '/some/path'
  The status should be success
 End

 It 'returns one if all messages are filtered'
  When call lop -l error -- -i 'Some info message' -n 'Some notice message'
  The output should eq ''
  The status should eq 1
 End

 It 'returns ten if wrong level is supplied'
  When call lop -- -z 'Some message'
  The output should eq ''
  The status should eq 10
 End
End

Describe 'lop'
 Parameters
  output debug
  output info
  output notice
  output warning
  error error
  error critical
  error alert
  error panic
 End

 It "prints $2 to $1"
  When call lop -- -${2[1]} 'Some message'
  The $1 should match pattern '* Some message'
  The status should be success
 End
End
