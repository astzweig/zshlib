Describe 'loadModules'
  TMPDIR=`mktemp -d`
  setup() {
    pushd -q "${TMPDIR}"
    local file key value dirpath
    local -A files=(
      [modules]=fileA,fileB,docA
      [other-dir]=docB,docC
    )
    for key value in ${(kv)files}; do
      dirpath=${TMPDIR}/${key}
      mkdir ${dirpath}
      for file in ${(s.,.)value}; do
        touch ${dirpath}/${file}
        chmod +x ${dirpath}/${file}
      done
    done
  }
  cleanup() { rm -fr ${TMPDIR} }
  BeforeAll setup
  AfterAll cleanup

  It 'returns all modules if no module arg is given'
    When call loadModules
    The line 1 of output should eq './modules/docA'
    The line 2 of output should eq './modules/fileA'
    The line 3 of output should eq './modules/fileB'
    The status should be success
  End

  It 'stores modules in parameter if -v options is given'
    mods=()
    When call loadModules -v mods
    The variable mods should eq './modules/docA ./modules/fileA ./modules/fileB'
    The status should be success
  End

  It 'returns only mentioned modules'
    When call loadModules docA
    The output should eq './modules/docA'
    The status should be success
  End

  It 'matches modules by ending pattern'
    When call loadModules -p 'file*'
    The line 1 of output should eq './modules/fileA'
    The line 2 of output should eq './modules/fileB'
    The status should be success
  End

  It 'returns only not mentioned modules if inversed'
    When call loadModules -i docA
    The line 1 of output should eq './modules/fileA'
    The line 2 of output should eq './modules/fileB'
    The status should be success
  End

  It 'searches given module search paths if given'
    When call loadModules -m "./other-dir"
    The line 1 of output should eq './other-dir/docB'
    The line 2 of output should eq './other-dir/docC'
    The status should be success
  End
End
