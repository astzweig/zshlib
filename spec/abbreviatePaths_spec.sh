Describe 'abbreviatePaths'
 It 'prints usage if help option is given'
  When call abbreviatePaths --help
  The output should match pattern 'Usage: abbreviatePaths*'
  The status should be success
 End

 It 'prints filename if a single filepath is given'
  When call abbreviatePaths ./myfile.path.txt
  The output should eq 'myfile.path.txt'
  The status should be success
 End

 It 'prints filename if multiple distinct filepaths are given'
  When call abbreviatePaths /firstDir/first.file.txt /secondDir/second.file.txt
  The line 1 of output should eq 'first.file.txt'
  The line 2 of output should eq 'second.file.txt'
  The status should be success
 End

 It 'prints filename and dir name if filenames alone are not distinct'
  When call abbreviatePaths /some/long/firstDir/file.txt /some/long/secondDir/file.txt "dir with spaces/file.txt"
  The line 1 of output should eq 'firstDir/file.txt'
  The line 2 of output should eq 'secondDir/file.txt'
  The line 3 of output should eq 'dir with spaces/file.txt'
  The status should be success
 End

 It 'reads filenames from stdin if no argument is given.'
  Data
    #|/firstDir/file.txt
    #|/secondDir/file.txt
    #|dir with spaces/file.txt
  End
  When call abbreviatePaths
  The line 1 of output should eq 'firstDir/file.txt'
  The line 2 of output should eq 'secondDir/file.txt'
  The line 3 of output should eq 'dir with spaces/file.txt'
  The status should be success
 End
End
