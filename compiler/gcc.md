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

- _hosted environment_ 必要的, 该环境可能缺失一些超出*freestanding implementation*要求之外的的标准库设施, 因此程序的启动和终止相关代码实现是由用户定义的
  例: 操作系统内核的运行环境
- _freestanding environment_ 可选的, 该环境提供了所有的标准库设施, 程序的启动代码是通过`int main(void)`或`int main(int, char *[])`实现的
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

### options controlling the kind of output

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

## C 实现定义的行为

## C++实现定义的行为

## C 语言扩展

## C++语言扩展

## Objective-C 功能

## 二进制兼容性
