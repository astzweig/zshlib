Describe 'lop'
 syslogmsg=
 logger() { [ $# -gt 4 ] && syslogmsg=$5 || syslogmsg=$3 }

 It 'does do nothing if called without any argument'
  When call lop
  The output should eq ''
  The status should be success
 End

 It 'does do nothing if called with only --no-newline option'
  When call lop --no-newline
  The output should eq ''
  The status should be success
 End

 It 'does do nothing if called with only -s option'
  When call lop -s
  The output should eq ''
  The status should be success
 End

 It 'does do nothing if called with only -f option'
  When call lop -f /dev/stdout
  The output should eq ''
  The status should be success
 End

 It 'does do nothing if called with only -l option'
  When call lop -l info
  The output should eq ''
  The status should be success
 End

 It 'prints debug message'
  msg='some message'
  When call lop -d "${msg}"
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'prints debug message if both debug and info message are given'
  msg='some message'
  When call lop -d "${msg}" -i 'some other message here'
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'does not print debug if loglevel is set to info'
  When call lop -l info -d 'some message'
  The output should eq ''
  The status should be success
 End

 It 'can configure loglevel in advance'
  lop setoutput -l info tostdout
  When call lop -d 'some message'
  The output should eq ''
  The status should be success
 End

 It 'does print info if loglevel is set to info'
  msg='some other message'
  When call lop -l info -d 'some message' -i "${msg}"
  The output should match pattern "*] ${msg}"
  The status should be success
 End

 It 'prints tagline if one is given'
  msg='some message'
  tag='some tag'
  When call lop -t "${tag}" -d "${msg}"
  The output should match pattern "*${tag}] ${msg}"
  The status should be success
 End

 It 'prints to file if told so'
  msg='some other message'
  tmpfile="`mktemp`"
  When call lop -f "${tmpfile}" -d "${msg}" -i 'some other message'
  The contents of file "${tmpfile}" should match pattern "*] ${msg}"
  The status should be success
 End

 It 'can configure output to file in advance'
  msg='some other message'
  tmpfile="`mktemp`"
  run() { lop setoutput "${tmpfile}"; lop -d "${msg}" -i 'some other message'; }
  When call run
  The contents of file "${tmpfile}" should match pattern "*] ${msg}"
  The status should be success
 End

 It 'pushes message to syslog if asked for'
  msg='some other message'
  When call lop -s -d "${msg}" -i 'some other message'
  The variable syslogmsg should eq "${msg}"
  The status should be success
 End

 It 'can configure output to syslog in advance'
  msg='some other message'
  run() { lop setoutput tosyslog; lop -d "${msg}" -i 'some other message'; }
  When call run
  The variable syslogmsg should eq "${msg}"
  The status should be success
 End

 It 'returns the default output form'
  When call lop getoutput
  The output should eq 'stdout'
  The status should be success
 End

 It 'returns syslog output if configured'
  run() { lop setoutput tosyslog; lop getoutput }
  When call run
  The output should eq 'syslog'
  The status should be success
 End

 It 'returns filepath output if configured'
  run() { lop setoutput /some/path; lop getoutput }
  When call run
  The output should eq '/some/path'
  The status should be success
 End
End
