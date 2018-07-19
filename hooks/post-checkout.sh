#!/usr/bin/env bash
#
# Install into:
# - .git/hooks/post-merge
# - .git/hooks/post-rewrite
# - .git/hooks/post-checkout
#
# And make sure all are executable.
#
# Then change the $file appropriately. Enjoy.

file="package.json"


if [[ $(git diff HEAD@{1}..HEAD@{0} -- "${file}" | wc -l) -gt 0 ]]; then
  echo
  echo -e "======> The file ${file} changed!"
  echo
  git diff --color HEAD@{1}..HEAD@{0} -- "${file}" | sed 's/^/        /' | tail -n+5
  echo
  echo -e "        Please make sure you install new dependencies by running \033[31mnpm install"
fi