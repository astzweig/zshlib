Describe 'hio'
  It 'prints nothing when no argument is given'
    When call hio
    The output should eq ''
    The status should be success
  End

  It 'prints nothing when no message is given'
    When call hio -n
    The output should eq ''
    The status should be success
  End

  It 'prints help message when only type is given'
    When call hio body
    The line 1 of error should eq 'error: '
    The status should eq 64
  End

  It 'prints help messagen when asked for'
    When call hio --help
    The line 1 of output should eq 'Usage:'
    The status should be success
  End

  It 'prints unstyled if output is not to console'
    When call hio body:li 'Some string'
    The output should eq '· Some string'
  End

  It 'prints addon if one is given'
    When call hio -a Y/n body:li 'Some string'
    The output should eq '· Some string Y/n'
  End

  It 'prints explanation if one is given'
    When call hio -e 'This is some text' body:li 'Some string'
    The line 1 of output should eq '· Some string'
    The line 2 of output should eq '↳ This is some text'
  End

  It 'prints all explanations if multiple are given'
    When call hio -e 'This is some text' -e 'This is another text' body:li 'Some string'
    The line 1 of output should eq '· Some string'
    The line 2 of output should eq '↳ This is some text'
    The line 3 of output should eq '↳ This is another text'
  End

  It 'prints explanation and addon if they are given'
    When call hio -e 'This is some text' -a 'Yes/no' body:li 'Some string'
    The line 1 of output should eq '· Some string Yes/no'
    The line 2 of output should eq '↳ This is some text'
  End
End


Describe '_zshlib_hio_getModifier'
  Include ./functions/hio
  modifier=
  setup() { modifier= }
  BeforeEach 'setup'

  It 'sets empty modifier if no type given'
    type=
    When call _zshlib_hio_getModifier
    The variable modifier should equal ''
  End

  It 'sets empty modifier if type with no modifier given'
    type=title
    When call _zshlib_hio_getModifier
    The variable modifier should equal ''
  End

  It 'sets modifier if type has modifier'
    type=title:sub
    When call _zshlib_hio_getModifier
    The variable modifier should equal 'sub'
    The variable type should equal 'title'
  End
End

Describe '_zshlib_hio_printPrefixSymbol'
  Include ./functions/hio
  It 'does nothing if no modifier given'
    modifier=
    When call _zshlib_hio_printPrefixSymbol
    The output should eq ''
  End

  It 'does nothing if -p option is given'
    modifier=li
    no_prefix=true
    When call _zshlib_hio_printPrefixSymbol
    The output should eq ''
  End
End

Describe '_zshlib_hio_printPrefixSymbol symbols'
  Include ./functions/hio
  declare -A modifierStyles=()
  Parameters
   li '· '
   warn "⚠ "
   quest '➔ '
   error '☠ '
   add ''
   success '✓ '
   failure '✗ '
   done '✓ '
   note '! '
   active '➔ '
  End

  It "prints $2 when modifier is $1"
    modifier=$1
    When call _zshlib_hio_printPrefixSymbol
    The output should eq "$2"
  End
End

Describe '_zshlib_hio_modifyStyle'
  Include ./functions/hio
  It 'does nothing if modifier is not set'
    style='bold'
    When call _zshlib_hio_modifyStyle
    The variable style should eq 'bold'
  End

  It 'does nothing if modifier has no color'
    modifier=note
    style='bold'
    When call _zshlib_hio_modifyStyle
    The variable style should eq 'bold'
  End

  It 'does nothing if modifier is not in colorOverwriting'
    modifier=note
    declare -A modifierStyles=(note 8)
    colorOverwriting=()
    style='bold'
    When call _zshlib_hio_modifyStyle
    The variable style should eq 'bold'
  End

  It 'appends color if modifier is in colorOverwriting'
    modifier=note
    declare -A modifierStyles=(note 8)
    colorOverwriting=(note)
    style='bold,9'
    When call _zshlib_hio_modifyStyle
    The variable style should eq "bold,9,8"
  End
End
