# Yoinked from https://github.com/jez/dotfiles/blob/master/util/bazel.zsh

_fzf_complete_bazel_test() {
  _fzf_complete '-m' "$@" < <(command bazel query "kind('(test|test_suite) rule', //...)" 2> /dev/null)
}

_fzf_complete_bazel() {
  local tokens
  tokens=(${(z)LBUFFER})

  if [ ${#tokens[@]} -ge 3 ] && [ "${tokens[2]}" = "test" ]; then
    _fzf_complete_bazel_test "$@"
  else
    # Might be able to make this better someday, by listing all repositories
    # that have been configured in a WORKSPACE.
    # See https://stackoverflow.com/questions/46229831/ or just run
    #     bazel query //external:all
    # This is the reason why things like @ruby_2_6//:ruby.tar.gz don't show up
    # in the output: they're not a dep of anything in //..., but they are deps
    # of @ruby_2_6//...
    _fzf_complete '-m' "$@" < <(command bazel query --keep_going --noshow_progress "kind('(binary rule)|(generated file)', deps(//...))" 2> /dev/null)
  fi
}
