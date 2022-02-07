% TAG: 'mytag'
% MSG: 'mymessage'

Describe 'lop'
 It 'does do nothing if called without any argument'
  When call lop
  The output should eq ''
  The status should be success
 End

 It 'does do nothing if called with only n option'
  When call lop -n
  The output should eq ''
  The status should be success
 End

 It 'does print the tagline'
  When call lop -t "${TAG}" info "${MSG}"
  The output should match pattern "*${TAG}] ${MSG}"
  The status should be success
 End

 It 'does print the tagline only at line start'
  When call lop -t "${TAG}" info "${MSG}" info "${MSG}"
  The output should match pattern "*${TAG}] ${MSG} ${MSG}"
  The status should be success
 End

 It 'does print to file when one is given'
  TMPFILE="`mktemp`"
  When call lop -f "${TMPFILE}" info "${MSG}"
  The path "${TMPFILE}" should be file
  The path "${TMPFILE}" should not be empty file
  The output should eq ''
  The status should be success
 End

 It 'does print to syslog when asked to'
  When call lop -s info "${MSG}"
  The output should eq ''
  The status should be success
 End

 It 'does map log level for syslog'
  When call lop -s success "${MSG}"
  The output should eq ''
  The status should be success
 End

 It 'can configure output in advance'
  TMPFILE="`mktemp`"
  lop setoutput "${TMPFILE}"
  When call lop info "${MSG}"
  The path "${TMPFILE}" should be file
  The path "${TMPFILE}" should not be empty file
  The output should eq ''
  The status should be success
 End

 It 'can configure loglevel in advance'
  lop setoutput -l warn tostdout
  When call lop info "${MSG}"
  The output should eq ''
  The status should be success
 End

 It 'prints nothing if everything is filtered and n option is given'
  lop setoutput -l warn tostdout
  When call lop -n debug "${MSG}"
  The output should eq ''
  The status should be success
 End

 It 'can reset output in advance'
  TMPFILE="`mktemp`"
  lop setoutput "${TMPFILE}"
  lop setoutput tostdout
  When call lop info "${MSG}"
  The path "${TMPFILE}" should be file
  The path "${TMPFILE}" should be empty file
  The output should match pattern "*${MSG}"
  The status should be success
 End

 It 'does log message if level is less than filter'
  When call lop -l info warning "${MSG}"
  The output should match pattern "*${MSG}"
  The status should be success
 End

 It 'does not log message if level is greater than or equal to filter'
  When call lop -l info debug "${MSG}"
  The output should eq ''
  The status should be success
 End

 It 'does prioritize syslog to file'
  TMPFILE="`mktemp`"
  When call lop -s -f "${TMPFILE}" info "${MSG}"
  The path "${TMPFILE}" should be file
  The path "${TMPFILE}" should be empty file
  The output should eq ''
  The status should be success
 End
End
