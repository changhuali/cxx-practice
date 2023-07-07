# GCC 使用手册

GNU Compiler Collection
本手册只讨论 C, C++, Objective-C/Objective-C++ 相关内容

## 支持的编程语言

- C
- C++
- Objective-C
- Objective-C++

## 支持的语言标准

### C 语言

| 标准名             | 使用方式                               | 说明                   |
| ------------------ | -------------------------------------- | ---------------------- | --- |
| C89<br>C90         | -ansi<br>-std=c90<br>-std=iso9899:1990 | 最初版                 |
| AMD1<br>C94<br>C95 | -std=iso9899:199409                    |                        |
| C99                | -std=c99<br>-std=iso9899:1999          | GCC 支持该标准所有内容 |
| C11                | -std=c11<br>-std=iso9899:2011          |                        |
| C17                | -std=c17<br>-std=iso9899:2017          |                        |
| C2X                | -std=c2x                               |                        |     |

> 默认使用-std=gnu17, GCC 为 C 语言提供了很多扩展功能, 可以通过-std=gnu\*使用

ISO C 标准定义了两种符合标准的实现

- _hosted implementation_ 要求支持所有标准并提供所有的标准库设施
- _freestanding implementation_ 仅要求提供部分标准库设施
  - float.h
  - limits.h
  - stdarg.h
  - stddef.h
  - iso646.h
  - stdbool.h
  - stdint.h
  - stdalign.h
  - stdnoreturn.h

ISO C 标准还为程序定义了两种运行环境

- _freestanding environment_ 必要的, 该环境可能缺失一些超出*freestanding implementation*要求之外的的标准库设施, 程序入口也并不一定是`main`函数
  例: 操作系统内核的运行环境
- \__hosted environment_ 可选的, 该环境提供了所有的标准库设施, 程序的启动代码是通过`int main(void)`或`int main(int, char *[])`实现的
  例: 运行在操作系统之上的应用程序的运行环境

> 默认是 hosted environment, 通过`-ffreestanding`命令行选项切换到 freestanding environment 模式

GCC 并不提供 hosted environment 独有的标准库设施, 如果需要完整的标准库设施, 你需要自行提供

### C++

| 标准名 | 使用方式            | 说明                 |
| ------ | ------------------- | -------------------- |
| C++98  | -ansi<br>-std=c++98 | 最初版               |
| C++03  | -std=c++03          |                      |
| C++11  | -std=c++11          | GCC 支持所有新增特性 |
| C++14  | -std=c++14          | GCC 支持所有新增特性 |
| C++17  | -std=c++17          | GCC 支持所有修改     |
| C++20  | -std=c++20          | GCC 支持大部分特性   |

> 默认使用-std=gnu++17, GCC 为 C++语言提供了很多扩展功能, 可以通过-std=gnu++\*使用

### Objective-C/Objective-C++

支持 Objective-C 1.0, 还有 `exception` 和 `synchronization` 语法

支持一些 Objective-C 2.0 语言扩展, 包括 `properties`, `fast enumeration`(OC++不支持), `method attributes`, `@optional`/`@required` 关键字

GCC 默认使用 GNU Objective-C runtime 库, 它跟苹果系统的 Apple/NeXT Objective-C runtime 库有些不同

可以通过`-fgnu-runtime` 和`-fnext-runtime` 切换

Objective-C 和 Objective-C++没有正式的标准
[OC by NeXTstep](https://gnustep.github.io/resources/documentation/ObjectivCBook.pdf)

Objective-C 2.0 相关扩展和功能默认就被支持, 可以通过`-fobjcstd=objc1`关闭
[OC 2.0 by APPLE](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)

## 命令行选项

因为部分选项包含了多个字符, 因此, 多个单字符的选项不能组合在一起进行传递, `-dv`和`-d -v`是不同的

一些选项的名字很长, 比如以` -f` `-W `开头的选项` -fmoveloop-invariants` `-Wformat `等, 这些选项大多数都会有肯定/否定两种形式, ` -ffoo` `-fno-foo `

一个选项可以接受多个参数, 这些参数通常用`空格`分开

参数可以是字符串或者数字, 数字通常是无符号整数或 16 进制整数, 16 进制整数必须以`0x`开头

通常和文件大小相关的参数值可以以`KB` `MB` `GB`结尾

`gcc` 编译 C++文件时不会添加 C++库, 因此需要使用 `g++`, 它会自动链接 C++库, 同时 `g++`会将 C 代码当作 C++代码进行处理, 除非显示指定了`-x` 选项

### 用于控制输出的命令行选项

#### -x language

显示指定输入文件的语言

- `c c-header cpp-output`
- `c++ c++-header c++-system-header c++user-header c++-cpp-output`
- `objective-c objective-c-header objective-c-cpp-output`
- `objective-c++ objective-c++-header objective-c++-cpp-output`
- `none` 取消显示指定, 输入文件的语言将从其后缀名推倒

#### -c

编译源文件, 并将编译结果进行汇编处理, 但不链接, 生成目标文件(.o), 无法识别的文件会被忽略

#### -S

编译源文件, 但不进行汇编处理, 生成汇编文件(.s), 无法识别的文件会被忽略

#### -E

预处理源文件, 生成预处理结果文件(.i .ii .mi)

```sh
cc -E xxx.c -o xxx.i
```

_预处理_

- 展开所有宏定义
- 处理预处理指令
- 删除注释(会保留删除注释后留下的空行)

_结果格式_

- 遇到的头文件会以`# linenum filename flags`的形式出现在`.i`文件中

  - linenum 文件行号
  - flags 可能的值为 1, 2, 3, 4
    - 1 标志进入一个文件
    - 2 标志回到一个文件
    - 3 表示后续内容来自系统头文件
    - 4 表示后续的内容应该被当做包含在`extern "C"`块中

  > 由 flags 可以得出, 头文件采用 DFS 的方式进行展开, 通过行号可以判断后续代码是在源码中的哪一行

#### -o file

指定将结果输出到 file, 如果不指定则默认如下规则

- 预处理结果会输出到 stdout
- 预编译头文件会输出为 source.suffix.gch
- 编译结果会输出为 source.s
- 汇编结果会输出为 source.o
- 可执行文件会输出为 a.out

#### -dumpbase dumpbase

指定中间文件输出/辅助信息文件输出的文件名

#### -dumpbase-ext auxdropsuf

指定中间文件输出/辅助信息文件输出的后缀名

#### -dumpdir dumppfx

指定中间文件输出/辅助信息文件输出的目录

#### -pass-exit-codes

返回程序退出状态码, 默认出错了都会返回 1, 指定此选项后会返回具体的状态码, 如编译器内部错误会返回 4

#### -pipe

指定编译不同阶段直接的通信方式使用管道, 而不是生成临时文件(部分操作系统无法使用管道)

#### -specs=file

通过该文件中的内容覆盖传递给编译工具的默认选项值

#### -wrapper

将所有子命令将在包裹程序之下执行

```sh
gcc -c t.c -wrapper gdb,--args
// 等同于
gdb --args cc1 ...
```

#### -ffile-prefix-map=old=new

将 old 目录下的文件映射到 new 目录下

#### @file

从 file 中读取命令行选项(如果 file 内部嵌套有@file, 则会被递归处理)

### 用于控制 C(C++ OBJC OBJC++) 的命令行选项

#### -ansi

对 C 语言来说, 等同于-std=c90, 对 C++来说, 等同于-std=c98

#### -std=

指定语言标准, 标准分 base standard(c*/c++*) 和 GNU standard(gnu*/gnu++*)
指定为 base standard 时, 会同时包含 GNU 扩展中未和标准发生冲突的部分
指定为 GNU standard 时, GNU standard 中定义的行为会具有较高优先级

#### -aux-info filename

向名为 filename 的文件输出函数原型

#### -fno-asm

指定-ansi 时, 此选项会隐式开启, 开启后 `asm` `inline` `typeof`不会被识别为关键字
C++和 c99 及后续版本中的 inline 是关键字, 不受此选项控制
c2x 及后续版本, typeof 也成为了关键字, 不受此选项控制

#### -fno-builtin

不以\_\_builtin\_\_为前缀的函数不会被识别为内置函数
编译器可能会对内置函数做很多处理, 比如内联, 生成更高效的代码

#### -fcond-mismatch

允许条件表达式的第二/第三个参数类型不一致(试了下, 没啥作用, 都会报警告)

#### -ffreestanding

指定目标环境为`freestanding environment`, 会隐式开启`-fno-builtin`
等同于`-fno-hosted`

#### -fgimple

允许为函数定义解析\_\_GIMPLE 标记, 该标记用于`GIMPLE`为该函数执行单元测试

#### -fgnu-tm

为 Intel 处理器下的 Linux 相关系统生成 Transactional Memory ABI 代码

#### -fgnu89-inline

告诉 GCC 使用 traditional 语义处理内联函数(不带`extern`关键字的内联函数会存在最终目标文件中)
`__GNUC_GNU_INLINE__`

#### -fno-gnu89-inline

告诉 GCC 使用 C99 标准语义处理内联函数(带有`extern`关键字的内联函数会存在最终目标文件中)
`__GNUC_STDC_INLINE__`

#### -fhosted

指定目标环境时`hosted environment`, 会隐式开启`-fbuiltin`

#### -flax-vector-conversions

允许具有不同元素数量和/或元素类型的向量间的转换(新代码已不建议使用)

#### -fms-extensions

允许接受一些微软头文件中的非标准的结构
C++中, 允许结构体成员名是类型定义

```c++
typedef int UOW;
struct ABC {
  UOW UOW;
};
```

默认只在 x86 下的 ms-abi 目标环境启用

### 用于控制链接器的命令行选项

#### -flinker-output=type

- type=exec 生成静态二进制可执行文件 `-fpic -fpie`会被禁用
- type=dyn 生成共享库
- type=pie 生成二进制可执行文件, `-fpie`不会被禁用
- type=rel 编译器确保增量链接已完成, 目标文件会包含用于链接时优化相关的中间代码区(增量链接开启时的默认选项)
  增量编译会为每个函数预留部分空间, 防止某函数代码修改后需要重新链接所有符号, 从而加快链接速度
- type=nolto-rel 目标文件不会包含用于链接时优化的中间代码区

#### -fuse-ld=ld

默认是 GNU 链接器

- ld=bfd 使用 bfd 链接器
- ld=gold 使用 gold 链接器
- ld=lld 使用 llvm lld 链接器
- ld=mold 使用 Modern 链接器

#### -llibrary/-l library(只适用于 POSIX 系)

链接时查找名称为 library 的库, 库的顺序会影响符号查找结果, 因此需要注意依赖关系

库查找目录

1. -L 指定的目录
2. 环境变量 LIBRARY_PATH 指定的目录, 多目录用冒号分隔
3. 一些标准系统目录

动态库比静态库的优先级要高, 除非指定了-static 选项

#### -lobjc

链接 OBCJ/OBJC++程序时需要指定此选项

#### -nostartfiles

链接时不使用标准的系统启动文件

#### -nodefaultlibs

链接时不使用标准的系统库, `-static-libgcc -shared-libgcc`也会被忽略

#### -nolibc

比`-nodefaultlibs`宽松一点, 链接时只是不使用标准 C 库和跟系统强关联的系统库, 比如-lc 会被移除, 一些系统库也会被移除, 比如-lpthread -lm

#### -nostdlib

链接时不使用标准的系统启动文件和系统库, `-static-libgcc -shared-libgcc`也会被忽略

`gcc library`相当于一个垫片库, 大多数时候如果你指定了`-nostdlib -nodefaultlibs`, 你应该指定`-lgcc`

#### -nostdlib++

链接时不会隐式使用标准的 C++库

#### -e entry

指定程序入口, 可以是一个符号名或者具体的地址

#### -pie

为目标环境生成一个位置无关的可动态链接的可执行文件
可通过`-no-pie`关闭

#### -static-pie

为目标环境生成一个静态的位置无关的可执行文件

#### -pthread

链接 POSIX 线程库, GNU/Linux/类 Unix MinGW 目标环境支持

#### -r

生成可重定位输出, 其部分符号不需要实现, 但是需要声明, 需要和其他文件经过链接后才能执行

#### -rdynamic

指示链接器将所有的符号都加到动态符号表中

#### -s

从可执行文件中移除所有的符号表以及重定位信息

#### -static

对于支持动态链接的系统, `-static`会覆盖`-pie`并且防止链接到同名的动态库

#### -shared

生产共享目标文件(编译时需要指定`-fpic/-fPIC`)

#### -shared-libgcc/-static-libgcc

将 libgcc 当作共享/静态库, 如果找不到该库, 则没有任何效果

#### -static-libstdc++

为 C++程序静态链接 libstdc++(默认是走动态链接)

#### -symbolic

在构建共享库的时候, 将引用绑定到全局符号

#### -T script

使用 script 替换默认的链接脚本(链接器作为解释器)

#### -Xlinker option

将 option 作为选项传递给链接器, 选项名和参数需要分别指定, 如`-assert definitions`需要写成`-Xlinker -assert -Xlinker definitions`
GNU 链接器可以用`-Xlinker -assert=definitions`这种格式

#### -Wl, option

将 option 作为选项传递给链接器, 选项名和参数可以用逗号分隔, 如`-assert definitions`需要写成`-Wl,-assert,definitions`
GNU 链接器可以用`-Wl,-assert=definitions`这种格式

#### -u symbol

会假设符号 symbol 为定义, 以此强制让链接的库提供该符号定义

#### -z keyword

此选项会被原样传递给链接器, 请查看链接器文档来获取 keyword 可能的值

### 用于控制查找路径的命令行选项

#### -I dir

#### -iquote dir

#### -isystem dir

#### -idirafter dir

#### -I-

#### -iprefix prefix

#### -iwithprefix dir

#### -iwithprefixbefore dir

#### -isysroot dir

#### -imultilib dir

> 以上选项见预处理器章节

#### -nostdinc

头文件查找不会查找标准系统目录, 仅查找用户指定目录/当前目录

#### -nostdinc++

对于 C++头文件查找, 不会查找 C++特定的标准目录

#### -Ldir

将 dir 添加到-l 指定的库查找目录中

#### -Bprefix

等同于环境变量`GCC_EXEC_PREFIX`
gcc 会使用 prefix 目录下对应的子程序可执行文件(cpp cc1 as ld), 如果找不到, 会尝试/usr/lib/gcc /usr/loca/lib/gcc 两个目录, 如果都没找到, 则会直接使用子程序名(因此会在 PATH 下查找)

会将该目录添加到-L
会将该目录加上 include 再添加到-isystem
libgcc.a 也会在该目录下查找, 如果找不到, 会尝试/usr/lib/gcc /usr/loca/lib/gcc 两个目录, 如果都没找到, 则不会链接该库

#### -no-canonical-prefixes

不会对路径进行符号链接展开, 相对路径转为绝对路径等处理

#### --sysroot=dir

将 dir 作为头文件/库文件查找的逻辑根目录, 比如: 如果编译器通常会在/usr/include 中查找头文件, 在/usr/lib 中查找库文件, 则会变为 dir/usr/include 和 dir/usr/lib

和`-isysroot`同时使用时, `--sysroot`作用于库查找, `-isysroot`作用于头文件查找

#### --no-sysroot-suffix

一些目标环境, 会将一个后缀自动添加到通过`--sysroot`指定的根目录后面, 则结果会变为 dir/suffix/usr/include, 此选项用于禁止此行为

## C 实现定义的行为

## C++实现定义的行为

## C 语言扩展

## C++语言扩展

## Objective-C 功能

## 二进制兼容性
