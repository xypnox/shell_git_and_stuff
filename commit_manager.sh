#!/bin/bash

branch=`date +%F`
prev_branch=`date -d "yesterday" +%F`
exists=`git show-ref refs/heads/${branch}`
num_changes=`git status --porcelain=v1 2>/dev/null | wc -l`

yesterday_branch_merged=``

git-is-merged () {
  # I am using the following bash function like: 
  # git-is-merged develop feature/new-feature
  # https://stackoverflow.com/a/49434212/
  
  merge_destination_branch=$1
  merge_source_branch=$2

  merge_base=$(git merge-base $merge_destination_branch $merge_source_branch)
  merge_source_current_commit=$(git rev-parse $merge_source_branch)
  if [[ $merge_base = $merge_source_current_commit ]]
  then
    echo $merge_source_branch is merged into $merge_destination_branch
    return 0
  else
    echo $merge_source_branch is not merged into $merge_destination_branch
    return 1
  fi
}


create_normal_commit() {
  git checkout $1
  
  local gstatus=`git status --porcelain`

  if [ ${#gstatus} -ne 0 ]
  then
    echo "Committing and pushing changes!"
    git add --all
    git commit -m "Auto Commit" -m "Porecellain: $gstatus"
  fi
}

# create_squash_commit() {
# # Create squash commit
# }



main() {
  is_megrged=`git-is-merged main $branch`
  if [ -z is_megrged ]; then
    echo "Daily merged"
  else
    echo "Daily not merged"
  fi

  # if [ -n "$exists" ]; then
  #   echo 'Daily Branch exists!'
  #   git checkout $branch
  #   # Commit all stuff here
  #   create_normal_commit $branch
  #   # push branch
  # else
  #   echo "Daily Branch doesn't exist!"
  #   git checkout -b $branch
  # fi
}

main

