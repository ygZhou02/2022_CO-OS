### Thinking 0.1 

我认为这是因为第一次未执行过git add README.txt命令，导致git根本就无法追踪到README.txt这个文件，无论是暂存区还是工作区都是查无此人，因此显示的是Untracked files；而第三次的输出结果是因为README.txt这个文件已经在git暂存区中有所记录，已经生成了一个.git/objects目录中的具有hashID的文件。然而现在这个文件又添加了新的修改，导致工作区记录的内容与暂存区目录指向.git/objects中的文件内容不一致，因此显示的是Changes not staged for commit。

### Thinking 0.2

add the file对应

stage the file对应git add命令

commit对应git commit命令

### Thinking 0.3

1、应当使用命令 git checkout printf.c 命令恢复文件。

2、应当使用命令 git reset --hard HEAD 命令恢复文件。

3、执行命令touch .gitigore，然后使用vim在其中写入/mtk/Tucao.txt

### Thinking 0.3

1、应当使用命令 git checkout printf.c 命令恢复文件。

2、应当使用命令 git reset --hard HEAD 命令恢复文件。

3、执行命令touch .gitigore，然后使用vim在其中写入/mtk/Tucao.txt

### Thinking 0.4

1、有三次提交，提交说明为3的哈希值为ee791368195c141f49265a66990e219a449e1c09

2、第三次提交的信息没了

3、我猜测原因是git对于每一次commit生成的目录树都会产生一个哈希值，这个哈希值其实就对应着该次commit的版本信息。而文件内容存储在.git/object中，所以二者其实都在，使用哈希值就可以恢复该次commit的信息了。

### Thinking 0.5

1、**克隆时所有分支均被克隆，但只有HEAD指向的分支被检出。** 正确。

2、**克隆出的工作区中执行 git log、git status、git checkout、git commit等操作不会去访问远程版本库。** 正确。

3、**克隆时只有远程版本库HEAD指向的分支被克隆。** 错误。

4、**克隆后工作区的默认分支处于master分支。** 错误。

### Thinking 0.6

1、在命令行输出first

2、将output.txt文件的内容变成了second

3、将output.txt文件的内容变成了third

4、在output.txt原文件内容的基础上，添加了一行forth

### Thinking 0.7

command文件内容：

```shell
echo 'echo Shell Start...
echo set a = 1
a=1
echo set b = 2
b=2
echo set c = a+b
c=$[$a+$b]
echo c = $c
echo save c to ./file1
echo $c>file1
echo save b to ./file2
echo $b>file2
echo save a to ./file3
echo $a>file3
echo save file1 file2 file3 to file4
cat file1>file4
cat file2>>file4
cat file3>>file4
echo save file4 to ./result
cat file4>>result' > test
```

result文件内容：

```
3
2
1
```

通过command文件写出的test文件内容为：

```shell
echo Shell Start...
echo set a = 1
a=1
echo set b = 2
b=2
echo set c = a+b
c=$[$a+$b]
echo c = $c
echo save c to ./file1
echo $c>file1
echo save b to ./file2
echo $b>file2
echo save a to ./file3
echo $a>file3
echo save file1 file2 file3 to file4
cat file1>file4
cat file2>>file4
cat file3>>file4
echo save file4 to ./result
cat file4>>result
```

其中，每行的作用为：

```shell
echo Shell Start...      # 在命令行输出一行字符：Shell Start...
echo set a = 1			# 在命令行输出一行字符：set a = 1
a=1					   # 创建shell变量a并赋值a=1
echo set b = 2			# 在命令行输出一行字符：set b = 2
b=2					   # 创建shell变量b并赋值b=2
echo set c = a+b		# 在命令行输出一行字符：set c = a+b
c=$[$a+$b]			    # 创建shell变量c，并将其赋值为(a的值+b的值)的值
echo c = $c			    # 在命令行输出一行字符：c = (shell变量c的值)
echo save c to ./file1	 # 在命令行输出一行字符：save c to ./file1
echo $c>file1            # 输出shell变量c的值，输出结果(3)重定向到file1中
echo save b to ./file2   # 在命令行输出一行字符：save b to ./file2
echo $b>file2            # 输出shell变量b的值，输出结果(2)重定向到file2中
echo save a to ./file3   # 在命令行输出一行字符：save a to ./file3
echo $a>file3            # 输出shell变量a的值，输出结果(1)重定向到file3中
echo save file1 file2 file3 to file4   # 在命令行输出一行字符：save file1 file2 file3 to file4
cat file1>file4          # 输出文件file1的内容，输出结果(3)重定向到file4中
cat file2>>file4         # 输出文件file2的内容，输出结果(2)追加到file4中
cat file3>>file4         # 输出文件file3的内容，输出结果(1)追加到file4中
echo save file4 to ./result   # 在命令行输出一行字符：save file4 to ./result
cat file4>>result        # 输出文件file4的内容，并追加到文件result中
```

echo echo Shell Start 与 echo 'echo Shell Start'效果无区别；

echo echo \$c>file1 与 echo 'echo \$c>file1'效果有区别，原因是$c是对变量的取值操作。