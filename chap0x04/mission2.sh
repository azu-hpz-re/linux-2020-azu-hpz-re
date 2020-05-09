#!usr/bin/env bash

# count the number and percentage of players in different age ranges
function count_age {
  count_20=0
  count_20to30=0
  count_30=0
  i=0
  for i in ${age[@]};do
    if [ $i -lt 20 ]
    then
    ((count_20++))
    elif [ $i -gt 30 ]
    then
    ((count_30++))
    elif [ $i -ge 20 ] || [ $i -le 30 ]
    then 
    ((count_20to30++))
    fi
  done
  
  printf "The number of players under 20 is %-5d,accounting for %-10.6f%% \n" $count_20 $(echo "scale=10;$count_20/$count*100" | bc -l | awk '{printf "%f",$0}')
  printf "The number of players between 20 to 30 is %-5d,accounting for %-10.6f%% \n" $count_20to30 $(echo "scale=10;$count_20to30/$count*100" | bc -l | awk '{printf "%f",$0}')
  printf "The number of players over 30 is %-5d,accounting for %-10.6f%% \n" $count_30 $(echo "scale=10;$count_30/$count*100" | bc -l | awk '{printf "%f",$0}')
}

# count the number and the percentage of players in different positions on the field
function count_positions {
#vRs:Array assignment,remove the unnecessary spaces
    array=($(awk -vRS=' ' '!a[$1]++' <<< "${position[@]}"))
    i=0
    #声明关联数组，索引为球员位置
    declare -A member
    for((i=0;i<${#array[@]};i++))
    {
        m=${array[$i]}
        member["$m"]=0
    }
    for some in "${position[@]}";do
       case $some in
               ${array[0]})
                    ((member["${array[0]}"]++));;
               ${array[1]})
                    ((member["${array[1]}"]++));;
               ${array[2]})
                    ((member["${array[2]}"]++));;
               ${array[3]})
                    ((member["${array[3]}"]++));;
               ${array[4]})
                    ((member["${array[4]}"]++));;
               esac
    done
    printf "%-10s : %10s %15s  \n" "Position" "Number" "Percent"
    for((i=0;i<${#array[@]};i++))
    {
        t=${member[${array[$i]}]}
        printf "%-10s : %10d %15.8f %% \n" ${array[$i]} $t $(echo "scale=10; $t/$count*100" | bc -l | awk '{printf "%f", $0}')
    }
}

#统计名字最长和最短的球员
function name_by_length {
    i=0
    max_name=0;
    min_name=0;
    while [[ i -lt $count ]]
    do
      #去掉字符串中的*
      name=${player[$i]//\*/}
      l=${#name}
      if [[ l -gt max_name ]];then
              max_name=$l
              max_num=$i
      elif [[ n -lt min_name ]];then
              min_name=$n
              min_num=$i
      fi
      ((i++))
    done
    echo "The longest name is ${player[max_num]//\*/ }"
    echo "The shortest name is ${player[min_num]}"
}

#统计年龄最大和最小的球员
function count_by_age {
    oldest=0;
    youngest=100;
    i=0
    while [[ i -lt $count ]];
    do
             a=age[$i]
             if [[ a -gt $oldest ]];then
                   oldest=$a
                   max_num=$i
             elif [[ a -lt $youngest ]];then
                   youngest=$a
                   min_num=$i
             fi
             ((i++))
    done
    echo "The oldest player is ${player[max_num]//\*/ }"
    echo "The youngest player is ${player[min_num]//\*/ }"
}

# main function
count=0
#按行读取数据
while read line
do ((count++))
if [[ $count -gt 1 ]];then
        str=(${line// /*})
        position[$(($count-2))]=${str[4]}
        age[$(($count-2))]=${str[5]}
        player[$(($count-2))]=${str[8]}
fi
done < worldcupplayerinfo.tsv
count=$(($count-1))
echo "The number of array is :$count"
echo "--------------------------------"
count_age 
echo "--------------------------------"
count_positions
echo "--------------------------------"
name_by_length
echo "--------------------------------"
count_by_age
echo "--------------------------------"


