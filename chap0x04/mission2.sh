#!usr/bin/env bash

# count the number and percentage of players in different age ranges
function count_age {
  age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )
  count_20=0
  count_20to30=0
  count_30=0
  total=0
  for i in ${age[@]};do
    if [[ $i -lt 20 ]];
    then
    ((count_20++))
    elif [[ $i -gt 30 ]];
    then
    ((count_30++))
    elif [[ $i -ge 20 ]] || [[ $i -le 30 ]]
    then 
    ((count_20to30++))
    fi
    total=$((total+1))
  done
  
  printf "The number of players under 20 is %-5d,accounting for %-10.6f%% \n" $count_20 $(echo "scale=10;$count_20/$total*100" | bc -l | awk '{printf "%f",$0}')
  printf "The number of players between 20 to 30 is %-5d,accounting for %-10.6f%% \n" $count_20to30 $(echo "scale=10;$count_20to30/$total*100" | bc -l | awk '{printf "%f",$0}')
  printf "The number of players over 30 is %-5d,accounting for %-10.6f%% \n" $count_30 $(echo "scale=10;$count_30/$total*100" | bc -l | awk '{printf "%f",$0}')
}

# count the number and the percentage of players in different positions on the field
function count_positions {
      array=$(awk -F "\t" '{if (NR > 1) {print $5} }' worldcupplayerinfo.tsv )       total=0
    #声明关联数组，索引为球员位置
    declare -A member
    for m in ${array[@]};do
           if [[ ${member[$m]} ]];then
                   member[$m]=$((member[$m]+1))
           else
                   member[$m]=1
           fi
           total=$((total+1))
    done
   
    echo "Position	Num	Ratio"
    for key in "${!member[@]}";do
            echo "$key     ${member[$key]}     $(echo "${member[$key]} $total" | awk '{printf("%0.1f\n",$1/$2*100)}')%"
    done
    printf "\n"
}

#统计名字最长和最短的球员
function name_by_length {
    OLD_IFS="$IFS"
    string=$(awk -F "\t" '{if (NR > 1){print $9","} }' worldcupplayerinfo.tsv )
    IFS=","
    
    player=($string)
    IFS="$OLD_IFS"
    max_name=0;
    min_name=100;
    for i in "${player[@]}";
    do
      #去掉字符串中的*
            if [[ ${#i} -gt $max_name ]];then
                    max_name=${#i}
            fi

            if [[ ${#i} -lt $min_name ]];then
                    min_name=${#i}
            fi
    done

    echo "The longest name:"
    for i in "${player[@]}";do
            if [[ ${#i} -eq $max_name ]];then
                    echo $i
            fi
    done

    printf "\n"

    echo "The shortest name:"
    for i in "${player[@]}";do
            if [[ ${#i} -eq $min_name ]];then
                    echo $i
            fi
    done
    printf "\n"
}
#统计年龄最大和最小的球员
function count_by_age {
    age=$(awk -F "\t" '{if (NR > 1) {print $6} }' worldcupplayerinfo.tsv )
    oldest=0;
    youngest=100;

    for a in ${age[@]};
    do
            if [[ $a -gt $oldest ]];then
                   oldest=$a
            fi

            if [[ $a -lt $youngest ]];then
                   youngest=$a
            fi
    done
    echo "The oldest player is:"
    awk -F "\t" '$6=='$oldest' {print $9}' worldcupplayerinfo.tsv
    printf "\n"
    echo "The youngest player is:"
    awk -F "\t" '$6=='$youngest' {print $9}' worldcupplayerinfo.tsv
    printf "\n"
}

#help
function Help {
	echo "the options:"
        echo "-c:	Count the number and percentage of players in different age ranges (under 20, [20-30], over 30)"
        echo "-p:	Count the number and percentage of players in different positions on the field"
        echo "-n:	Count the players with the longest name and shortest name"
	echo "-a:	Count the oldest and youngest players"
        echo "-h:	get the help of the opetions"
}

if [[ $# -lt 1 ]];then
        echo "Please enter your command."
else
        while [[ $# -ne 0 ]];do
                case $1 in
                        "-a")
                                count_by_age #统计年龄最大和最小的球员
                                shift
                                ;;
                        "-h")
                                Help #获得命令行参数帮助信息
                                shift
                                ;;
                        "-n")
                                name_by_length #统计名字最长和最短的球员
                                shift
                                ;;
                        "-p")
                                count_positions #统计球场不同位置的球员人数、占比
                                shift
                                ;;
                        "-c")
                                count_age #统计不同年龄范围的球员认识、占比
                                shift
                                ;;
                esac
        done
fi
