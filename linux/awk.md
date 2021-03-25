#### awk学习
------
在linux系统下，awk是必不可少的一个文本处理，文本分析工具，下面来根据模拟几个excel不好处理的情况下来用awk去解决的问题：

- 1.简单查看文档筛选  
    （类似excel的筛选功能，但是excel打开文件行数有限，且耗费cpu和内存）  
    - 命令:查看第一列大于100的有多少，并筛选出来  
      >   awk -F ","  '{if ($1>100) {print $0} }'  list.txt 
    - 保留个别列  
      >   awk -F ","  '{ print $1\t$4 }'  list.txt  
     
- 2.中级用法
    （类似excel两个文件进行vlookup数据） 
    - 命令：给出一个大文件detail_list.txt和一个小文件id.txt
      >   [wangfuyu@localhost ~/awk/data]$ wc -l detail_list.txt  
      >   5000000  
      >   [wangfuyu@localhost ~/awk/data]$ wc -l id.txt  
      >   200000  
      >   [wangfuyu@localhost ~/awk/data]$ head -n4 detail_list.txt    
      >   id      user_name  
      >   1        我  
      >   2        你  
      >   3        他  
      >   [wangfuyu@localhost ~/awk/data]$ head -n4 id.txt   
      >   id  
      >   1  
      >   150  
      >   1000   
      >   [wangfuyu@localhost ~/awk/data]$ awk 'NR==FNR{a[$1]=$1;next}NR!=FNR{if($1 in a)print $0}' id.txt detail.txt |head -n4  
      >   id      user_name  
      >   1        我  
      >   150        姜子牙  
      >   1000          李太白  
      >   
    
    
