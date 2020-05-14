#!/usr/bin/env bash
export LANG="zh_CN.GB18030"
printf "Calculate the total number of times to visit the source host TOP100 and corresponding to each" >> web_calculate.txt
# awk -F  -F相当于内置变量FS, 指定分割字符
# '{print $1}'输出文本中的第1项，行匹配语句 awk '' 只能用单引号
# sort默认是从小到大，uniq -c表示显示该主机重复出现的次数
# -n 按照数值大小排序 -r表示逆序
# head -n指定显示头部内容的行数
cat web_log.tsv | awk -F'\t' '{print $1}' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt
printf "统计访问来源主机TOP100 IP和分别对应出现的总次数" >> web_calculate.txt
# grep使用正则表达式搜索文本，^表示以后面开头的元素，[]表示范围
cat web_log.tsv | awk -F'\t' '{print $1}' | grep -E "^[0-9]" | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt

printf "统计最频繁被访问的URL TOP 100" >> web_calculate.txt
cat web_log.tsv | awk -F'\t' '{print $5}' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt

printf "统计不同响应状态码的出现次数和对应百分比" >> web_calculate.txt
# END后的语句是每行数据处理完后执行
cat web_log.tsv | awk '{a[$6]++;s+=1}END{for (i in a) printf "%s %d %6.6f%%\n", i, a[i], a[i]/s*100}' | sort >> web_calculate.txt

printf "分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数" >> web_calculate.txt
printf "403:" >> web_calculate.txt
cat web_log.tsv | awk -F'\t' '{if($6=="403")print $5,$6}' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt
printf "404:">> web_calculate.txt
cat web_log.tsv | awk -F'\t' '{if($6=="404")print $5,$6}' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt
printf "给定URL输出TOP 100访问来源主机">> web_calculate.txt
# url参数
url=$1
if [[ $url == "-h" || $url == "-help" ]];then
	echo '-------------------------------------------'
        echo '-h/-help Input hte help file'
	echo "Calculate the total number of times to visit the source host TOP100 and corresponding to each"
# awk -F  -F当于内置变量FS, 指定分割字符
        echo '统计访问来源主机TOP 100 IP和分别对应出现的总次数'
	echo '统计最频繁被访问的URL TOP 100'
	echo '统计不同响应状态码的出现次数和对应百分比'
	echo '分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数'
	echo '给定url 指定url,给定URL输出TOP 100访问来源主机 '
else
	#cat web_log.tsv | awk -F'\t' '{if($5=="'$url'")print $1,$5)' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt
       cat web_log.tsv | awk -F'\t' '{if($5=="'$url'")print $1,$5}' | sort | uniq -c | sort -nr | head -n 100 >> web_calculate.txt
fi
echo "Finished!"
