#!/bin/bash

split_file() {
   target_file=$1
   start=$2
   end=$3

   cat ${target_file} | awk -v start=${start} -v end=${end} 'NR >= start && NR < end { print $0 }' > ${target_file}_${start}
}
export -f split_file

target=$1
sprit_keyword=$2

cat ${target} | grep -n ${sprit_keyword} | awk '{ print $1}' | sed 's/://g' > tmp_lines
target_line=$(( `wc -l ${target} | awk '{ print $1}' ` + 1 ))
echo ${target_line} >> tmp_lines

range=$(( `wc -l tmp_lines | awk '{ print $1}' ` - 1 ))
head -n ${range} tmp_lines > tmp_start
tail -n ${range} tmp_lines > tmp_end

paste tmp_start tmp_end > tmp_split_range
cat tmp_split_range | xargs -n 2 -I % bash -c "split_file ${target} %"

rm -f tmp_*
