#!/bin/sh

max_ver=0;

git fetch --prune

branch_key='release/';

branches=`git branch -r | grep $branch_key`;

branches=`awk -F / '{print $2" "$3}' <<< $branches`;

vers=`awk '{print $2}' <<< $branches`;

branches=`awk '{print $1"/"$2}' <<< $branches`;

for ver in `awk -F . '{print $1"."$2}' <<< $vers`;
do
    if [[ $ver > $max_ver ]]
    then
        max_ver=$ver;
    fi
done

delete_branches=`grep -v $max_ver <<< $branches`;

echo 'Start deleting remote branches...';
for branch in $delete_branches
do
    echo 'Deleting origin'$branch'...';
    git push -d origin $branch;
done
echo 'Fin';

echo '';
echo '';

local_branches=`git branch | grep $branch_key`;

delete_local_branches=`grep -v $max_ver <<< $local_branches`;

echo 'Start deleting local branches...';
for branch in $delete_local_branches
do
    echo 'Deleting '$branch'...';
    git branch -D $branch;
done
echo 'Fin';

