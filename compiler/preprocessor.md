## 预处理器

### 预处理指令

预处理指令格式`#name`

- #和 name 之间可以有空格，name 称为指令名
- name 不会进行宏展开

  ```c
  #define foo define
  #foo // 这里的foo不会展开, 导致#foo不是一个有效预处理指令
  ```

- 用户不能自定义新的预处理指令
- 不能跨行, 但是可以用`\`对多行进行连接

### 头文件

头文件包括了公用的接口声明和宏定义

- 系统头文件, 声明了部分操作系统的接口和宏定义
  ```C
  #include <file> // 在一组系统目录中查找该文件, 这组系统目录的值取决于系统, GCC配置以及GCC的安装目录
  ```
- 用户头文件, 声明了用户共享代码的接口和宏定义
  ```C
  #include "file" // 首先在当前文件所在目录下查找该文件, 最后按系统头文件进行查找
  ```

可以通过下列脚本查看系统头文件查找目录

```sh
echo | cpp -v
// or
gcc/clang -Xpreprocessor -dM -E -</dev/null
```

- -I 指定户头/系统头文件查找目录, 其优先级高于系统目录, 并按照从左到右依次查找
- -iquote 指定用户头文件查找目录
- -isystem 指定系统头文件查找目录, 这些目录中查找到的头文件算作系统头文件
- -nostdinc 指定忽略默认的系统查找目录

> `#include_next`是 GCC 的一种扩展, 表示从当前文件的查找目录之后的目录开始查找, 可以有效防止循环引用

#### 通过哨兵宏保证头文件只被处理一次

```C
/* File foo.  */
#ifndef FILE_FOO_SEEN
#define FILE_FOO_SEEN

the entire file

#endif /* !FILE_FOO_SEEN */
```

CPP 提供了两种另外的方法保证头文件只会被处理一次, 但是可移植性都很差, 并不推荐使用

```c
#import <xxx.h> // Objective-C标准
#pragma once // 放到头文件中
```

#### 系统头文件

GCC 对系统头文件会有部分特殊处理, 所有警告(`#warning`产生除外)都会被抑制

哪些头文件算作系统头文件:

- 部分特殊目录中查找到的头文件
- 在`-isystem`和`-idirafter`指定的目录中查找到的头文件
- `pragma GCC system_header`指令后面引入的头文件

### 宏

- 宏的名字可以是任何标识符, 但是`defined`不能作为宏的名字
- 宏的名字甚至可以是语言关键字, 但是 c++具名操作符不能用作宏的名称
  https://gcc.gnu.org/onlinedocs/cpp/C_002b_002b-Named-Operators.html
- 按照惯例, 宏的名字应该用大写, 方便阅读代码

#### 对象宏

```c
#define BUFFER_SIZE 1024
```

宏展开前

```c
char *foo = (char *) malloc (BUFFER_SIZE);
```

宏展开后

```c
char *foo = (char *) malloc (1024);
```

> 宏在定义的时候不会检查对应的值是否是另外一个宏定义, 但是在展开宏的时候会, 因此宏展开会递归进行, 如果发生循环引用, 则会中断这个过程

```C
#define TABLESIZE BUFSIZE // 这里不会检查BUFSIZE
#define BUFSIZE 1024
TABLESIZE
    → BUFSIZE // 这里会
    → 1024
```

#### 函数宏

```C
#define lang_init()  c_init()
lang_init()
     → c_init()
```

> 括号和名字之间不能有空格, 否则会变成对象宏

##### 参数

```C
#define min(X, Y)  ((X) < (Y) ? (X) : (Y))
  x = min(a, b);          →  x = ((a) < (b) ? (a) : (b));
  y = min(1, 2);          →  y = ((1) < (2) ? (1) : (2));
  z = min(a + 28, *p);    →  z = ((a + 28) < (*p) ? (a + 28) : (*p));
```

- 会先对参数进行展开, 最后对结果再次进行展开
  ```C
  min(min(a, b), c)
  // 第一次展开
  min(((a) < (b) ? (a) : (b)), (c))
  // 第二次展开
  ((((a) < (b) ? (a) : (b))) < (c)
  ? (((a) < (b) ? (a) : (b)))
  : (c))
  ```
- 参数数量必须同宏定义保持一致, 但是可以为空
  ```C
  min(, b) → (( ) < (b) ? ( ) : (b))
  ```

#### Stringizing(字符串化)

`#`将字符串中的宏进行展开, 默认字符串中的宏是不会进行展开的

```C
#define WARN_IF(EXP) \
do { if (EXP) \
        fprintf (stderr, "Warning: " #EXP "\n"); } \
while (0)
WARN_IF (x == 0);
     → do { if (x == 0)
           fprintf (stderr, "Warning: " "x == 0" "\n"); } while (0);
```

#### Concatenation(连接)

`##`将两个 token 连接起来组成新的 token, 新 token 会继续进行展开(如果是一个宏)

```C
#define COMMAND(prefix) prefix ## _command

COMMAND(help);
// generate help_command
```

#### 可变参数

```C
#define eprintf(...) fprintf(stderr, __VA_ARGS__)
// or
#define eprintf(args...) fprintf(stderr, args) // CPP的扩展功能, 并且不能使用__VA_ARGS__和__VA_OPT__
```

##### 具名参数

```C
#define eprintf(format, ...) fprintf(stderr, format, __VA_ARGS__)
```

注意最后一个具名参数(format)后面的逗号, 如果可变参数为空, 则这里会产生语法错误

- c++20 修复了上述问题
- c++20 和 CPP/clang 引入了`__VA_OPT__`函数宏修复上述问题, 该函数宏只能出现在具有可变参数的函数宏中
  ```C
  // __VA_OPT__根据可变参数内容判断是否需要插入参数
  #define eprintf(format, ...) fprintf(stderr, format __VA_OPT__(, ) __VA_ARGS__)
  ```
- CPP 通过`##__VA_ARGS__`修复上述问题
  ```C
  #define eprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
  ```

#### 预定义宏

##### 标准预定义宏

- \_\_FILE\_\_ 文件名
- \_\_LINE\_\_ 出现的代码行
- \_\_DATE\_\_ 预处理日期, 格式"Feb 12 1996", 如果 GCC 获取日期失败, 则报警告并且展开为"??? ?? ????"
- \_\_TIME\_\_ 预处理时间, 格式"23:59:01", 如果 GCC 获取时间失败, 则报警告并且展开为"??:??:??"
- \_\_STDC\_\_ 值为 1, 表示编译器遵循 ISO Standard C

  > -traditional-cpp 被指定时, 不会定义该宏

  > CPP 在处理用户头文件时, 该宏始终被定义为 1, 而系统头文件中, 该宏通常定义为 0

- \_\_STDC_VERSION\_\_ 扩展为 c 标准版本号, 格式为 yyyymmL, 如 199409L, 199901L, 201112L, 201710L
- \_\_STDC_HOSTED\_\_ 当编译器目标为`hosted environment`时会被定义, 值为 1
  > hosted environment 是指有完整标准 c 库的环境
- \_\_cplusplus 使用 C++编译器时会被定义, 值为 c++标准版本号, 格式为 yyyymmL, 如 199711L, 201103L, 201402L, 201703L, 202002L, 202302L
- \_\_OBJC\_\_ 使用 Objective-C 编译器会被定义, 值为 1
- \_\_ASSEMBLER\_\_ 预处理汇编语言时会被定义为 1

> C99 引入了\_\_func\_\_, GCC 提供了\_\_FUNCTION\_\_, 它们会被展开为包含它们的函数名, 但是注意, 它们都不是宏

##### 通用预定义宏

GNU C 扩展

- \_\_COUNTER\_\_ 顺序自增, 从 0 开始, 可以配合宏连接技术(##)生成唯一标识
- \_\_GNUC\_\_ GCC 主版本号, 也可以用它来判断编译器是否为 GNU 系列
- \_\_GNUC_MINOR\_\_ GCC 次版本号
- \_\_GNUC_PATCHLEVEL\_\_ GCC 补丁版本号
  ```c
  /* Test for GCC > 3.2.0 */
  #if __GNUC__ > 3 || \
    (__GNUC__ == 3 && (__GNUC_MINOR__ > 2 || \
                       (__GNUC_MINOR__ == 2 && \
                        __GNUC_PATCHLEVEL__ > 0))
  ```
- \_\_GNUG\_\_ GNU C++编译器, 相当于`(__GNUC__ && __cplusplus)`
- \_\_STRICT_ANSI\_\_ 当启用了-ansi 或者-std 严格遵循 ISO C/C++标准时被定义, 值为 1, 用于指导 GNU libc 的头文件只能使用标准 C 中的定义
- \_\_BASE_FILE\_\_ 入口文件的绝对路径
- \_\_FILE_NAME\_\_ 当前文件的文件名(文件路径的最后一部分) `"/usr/local/include/myheader.h" -> "myheader.h"`
- \_\_INCLUDE_LEVEL\_\_ 当前文件所在层级, 从 0 开始
- \_\_ELF\_\_ 如果目标文件是 ELF 格式, 则会被定义, 值为 1
- \_\_VERSION\_\_ 描述编译器版本(`13.1.0` or `Apple LLVM 14.0.0 (clang-1400.0.29.202)`), 注意: 不要依赖它做任何判断
- \_\_OPTIMIZE\_\_ 如果启用了优化(-On, n>0), 则会被定义, 值为 1
- \_\_OPTIMIZE_SIZE\_\_ 如果开启了优化, 且优化是针对代码尺寸而非运行速度, 则会被定义, 值为 1
- \_\_NO_INLINE\_\_ 如果未启用优化(-O0), 则会被定义, 值为 1, 表示函数不应该被内联(可以通过-fno-inline 禁用)
- \_\_GNUC_GNU_INLINE\_\_ 指定-std=gnu/c90 时, 则会被定义, 值为 1, 目标文件不会包含`extern inline`声明的函数, 而是包含没有`extern`和`static`修饰的`inline`函数
- \_\_GNUC_STDC_INLINE\_\_ 指定-std=gnu/c99 或后续标准, 则会被定义, 值为 1, 目标文件不会包含任何未被`extern`修饰的`inline`函数
- \_\_CHAR_UNSIGNED\_\_ 当目标环境的`char类型`是无符号类型时, 则会被定义, 值为 1, 用于标准头文件`limits.h`中能正确定义`CHAR_MIN/CHAR_MAX`的值
- \_\_WCHAR_UNSIGNED\_\_ 和\_\_CHAR_UNSIGNED\_\_类似, 不过是为了处理 C++中的`wchar_t类型`
- \_\_REGISTER_PREFIX\_\_ 展开为单个符号或空字符, 用于汇编中的寄存器名前缀, 以此增加汇编程序可移植性
- \_\_USER_LABEL_PREFIX\_\_ 展开为单个符号或空字符, 用于汇编中的 label 前缀
- \_\_\*\_TYPE\_\_系列 用于正确定义一些底层类型, 如`size_t`, `ptrdiff_t`, `wchar_t`, `intn_t`, `intn_fast_t`, `intn_least_t`等
  > 小知识: `*_fast_t`用于提升时间效率, 但是可能损失部分空间效率, `*_least_t`用于提升空间效率, 但是可能损失部分时间效率
- \_\_CHAR_BIT\_\_ 用于定义`char类型`的位宽, 标准头文件内部使用, 开发者不应该直接使用, 而是应该引入相应的头文件
- \_\_\*\_MAX\_\_系列 用于定义数值类类型的最大值, 标准头文件内部使用, 开发者不应该直接使用, 而是应该引入相应的头文件
- \_\_\*\_WIDTH\_\_系列 用于定义对应类型的位宽, 标准头文件内部使用, 开发者不应该直接使用, 而是应该引入相应的头文件
- \_\_SIZEOF\_\_系列 用于定义相应类型占用的字节数
- \_\_BYTE_ORDER\_\_ 用于描述内存中的字节序
- \_\_ORDER_LITTLE_ENDIAN\_\_ 小端字节序
- \_\_ORDER_BIG_ENDIAN\_\_ 大端字节序
- \_\_ORDER_PDP_ENDIAN\_\_ 一半小端一半大端
- \_\_FLOAT_WORD_ORDER\_\_ 浮点数在内存中的字节序, 只有大小端两种

##### 系统特定的预定义宏

C 预处理器通常会定义一些宏, 用来表示系统和机器的类型

```sh
// 可以通过`cpp -dM`查看这些宏定义名
echo | cpp -dM
```

- \_\_APPLE\_\_ Mac 系统
- \_\_linux\_\_ Linux 系统
- \_\_WIN64\_\_ Windows 系统
- \_\_x86_64\_\_ x86_64 架构
- \_\_aarch64\_\_ arm64 架构

#### 取消宏定义

`#undef name`

```c
#define FOO 4
int x = FOO;
#undef FOO
```

- 如果`name`并不是一个宏, `#undef`则不会产生效果
- 取消函数宏也只需要`name`, 而不需要括号

#### 函数宏参数中的指令

C C++标准声明参数中的指令会产生为定义行为, GNU CPP 会按正常的方式处理这些指令

#### 函数宏参数中的副作用

参数最好不要含有副作用, 因为参数可能会被替换到多个地方

#### 自引用宏

```c
#define foo (4 + foo)
```

因为宏会递归展开, 所以理论上这里会进入死循环, 因此预处理器有一条规则, 那就是第一次展开后, foo 不会继续展开

#### 函数宏参数预扫描

宏定义中的参数会被提前展开, 然后替换到定义体中, 最后再对替换后的结果进行展开

预扫描解决了几个问题:

- 函数宏的嵌套调用

  ```c
  #define f(x) x + 1
  f(f(1))
  ```

  上述例子中, 如果没有预扫描机制, 则 f(1)被直接替换到定义体中, 结果为`f(1) + 1`, 此处产生了自引用, 所以 f(1)不会再被展开, 导致最终结果并不是我们想要的

- 如果宏定义中使用了`stringizing`或`concatenation`, 则参数不会被提前展开, 但是你有时候又想参数被展开, 那么你可以利用预扫描机制, 将这个宏包裹一层, 从而达到目的
  ```c
  #define AFTERX(x) X_ ## x
  #define XAFTERX(x) AFTERX(x)
  #define TABLESIZE 1024
  #define BUFSIZE TABLESIZE
  ```
  AFTERX(BUFSIZE) 展开为 X_BUFSIZE  
  XAFTERX(BUFSIZE) 展开为 X_1024, 因为这里的 BUFSIZE 被提前展开

### 条件编译

#### 条件编译指令

- #ifdef
  ```c
  #ifdef MACRO
  controlled text
  #endif /* MACRO */
  ```
- #ifndef
  ```c
  #ifndef MACRO
  controlled text
  #endif /* MACRO */
  ```
- #if

  ```c
  #if expression // expression是一个返回整型的C表达式
  controlled text
  #endif /* expression */
  ```

  表达式可以包含:

  - 整型常量
  - 字符常量
  - +-\*/ &|~^ >><< ><>=<= &&||, 逻辑运算遵循短路规则
  - 宏, 并且会在计算之前展开
  - defined 运算符, 可以检查宏是否被定义
  - 标识符, 非宏名或者不带括号的函数宏名会被替换为 0 值
    -Wundef 会让 GCC 报标识符不是宏的警告

  预处理器会计算出表达式结果

- #defined(name) 在#if #elif 中判断 name 是否是宏, #if defined(name) 等价于 #ifdef name
  ```c
  #if defined(BUFSIZE) && BUFSIZE >= 1024
  // 可以简化为
  #if BUFSIZE >= 1024 // 如果BUFSIZE不是宏, 则会被替换为0
  ```
- #else 搭配#if #ifdef #ifndef #elif 使用
- #elif 搭配#if

### 诊断

- #error

预处理时发送至命错误, 预处理会中断处理流程

```c
#ifdef __vax__
#error "Won't work on VAXen.  See comments at get_last_object."
#endif
```

- #warning

预处理器只会给出警告, 不会中断处理流程

```c
#warning "this header has been deprecated."
```

### 预处理器执行

执行`cpp` or `gcc -E`是等效的, gcc 中, 预处理器和编译器是集成在一起的, 其并不是一个独立的程序, 所以这两个命令最终都是执行 gcc, 并告诉它在预处理完成后停止。

预处理器接受两个文件名作为参数, `infile`和`outfile`, 合并`infile`及其中所有被 include 的头文件, 最终生成 outfile

infile 和 outfile 均可以为`-`, 表示标准输入和输出

选项和选项参数之间可以用空格分隔, 也可以连接在一起, `-Ifoo`和`-I foo`等价, 以`=`结尾的参数项例外

#### options

- -D name
  预定义宏, 值为 1
- -D name=definition
  预定义宏, 值为 definition, definition 会被 token 化, 并且会被换行符截断, 注意如有特殊字符, 需要用引号包住
  函数宏格式: `-D'name(args...)=definition'`
- -U name
  取消宏定义, 可以取消非用户定义的宏或-D 定义的宏
- -include file
  将 file.h 以#include "file.h"的方式放到入口文件首行, 不过会优先在当前工作目录查找该头文件
- -imacros file
  类似-include, 不过只会提取宏定义, 其余内容都会被丢弃, 会先于-include 被处理
- -undef
  取消所有系统和 GCC 特定的预定义宏
- -pthread
  定义 POSIX threads 库需要的宏, GNU/Linux 大多数 Unix MinGW 等平台支持该选项
- -M
  生成 make rule, 格式为`target: deps`, 依赖会包括-include -imacros 指定的文件
  如果使用了该选项, 则默认会应用-E 和-W
- -MM
  类似-M, 但是依赖项中不会包含系统头文件
- -MF file
  配合-M -MM 使用, 会将依赖项写入到 file 中
- -MG
  配合-M -MM 使用, 找不到的头文件依然会被加入到依赖项中, 其不会抛错
- -Mno-modules
  不会为 CMI(compiled module interface: c++20 模块特性) 生成依赖
- -MP
  会为每个依赖(主文件除外)定义一个 target, 以此解决一些错误: 当你删除一个依赖文件后, 倘若你没更新 makefile, 则 make 会报错
- -MT target
  为 make rule 指定 target 名称, 默认的 target 名称是和主文件的名称, 且不带拓展名, 可以多次指定, 也可以一次指定多个
- -MQ target
  和-MT 类似, 不过会为 target 中对 make 来说有特殊含义的字符加上引号
- -MD
  等同于`-M -MF file`, 但是-E 不会被隐式指定, file 会根据-o 推断, 后缀会被替换为.d
- -MMD
  等同于`-MD`, 但是依赖项不会包含系统头文件
- -fpreprocessed
  告诉预处理器, 当前输入文件已经被预处理过, 从而不会再进行宏展开和处理一些预处理指令等操作, 在这种模式下, 预处理器仅是一个编译器的分词器
  当输入文件扩展名是.i, .ii, .mi 时, 该选项被隐式指定
- -fdirectives-only
  搭配-E 时, 只会处理预处理指令, 而不会进行宏展开等操作
  搭配-fpreprocessed 时, 命令行和系统/编译器内置的宏被禁用, 标准预定义宏会正常被处理
- -fdollars-in-identifiers
  标识符接受$, GCC 默认支持, 可以通过-fno-dollars-in-identifiers 关闭
- -fextended-identifiers
  标识符接受 UCS 和一些拓展字符, C99 及其之后/C++默认开启
- -fno-canonical-system-headers
  不要规范化头文件路径
  ```sh
  /opt/homebrew/Cellar/gcc/13.1.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin22/13/include-fixed/stdio.h // 未规范化
  /opt/homebrew/Cellar/gcc/13.1.0/lib/gcc/current/gcc/aarch64-apple-darwin22/13/include-fixed/stdio.h // 已规范化
  ```
- -fmax-include-depth=depth
  设置 include 的最大嵌套深度, 默认 200
- -ftabstop=width
  制表位(tab)长度, 默认为 8, <2 或>100 则会被重置为默认值
- -ftrack-macro-expansion[=level]
  指定宏展开错误的栈信息级别, 0 表示不生成栈信息, 1 比较省内存, 但是函数宏参数中的每个 token 都会用同样的位置信息, 2 会占用更多内存, 但是会为每个 token 都生成完整的位置信息, 默认为 2
- -fmacro-prefix-map=old=new
  对于`__FILE__` `__BASE_FILE__`宏, 如果其展开结果是 old 目录中的文件, 则将其 old 部分前缀映射到 new 目录, new 目录可以是相对路径, 以此可以使结果位置与环境无关(多环境移植性提高)
- -fexec-charset=charset
  指定可执行文件的字符集, 默认 UTF-8, charset 为系统 iconv 库支持的所有编码
- -fwide-exec-charset=charset
  指定可执行文件的宽字符集, 用于宽字符串和宽字符常量, 默认是 UTF-32BE, UTF-32LE, UTF-16BE, UTF-16LE 中的一个, charset 为系统 iconv 库支持的所有编码
- -finput-charset=charset
  指定源代码文件的字符集, 如果没有指定 locale, 则默认为 UTF-8, 此选项比 locale 优先级高, charset 为系统 iconv 库支持的所有编码
- -fworking-directory
  会在当前行标后加上以//开头的新行标, 内容是 CPP 预处理时所在的工作目录, 主要提供给一些调试工具使用
- -A predicate=answer
  声明一个断言, 断言是一个用来在不同计算机或系统间做测试的功能, 已经被宏替代, 该功能不属于标准
  ```c
  // machine是predicate, vax和ns16000是answer
  #if #machine (vax) || #machine (ns16000)
  ```
- -A -predicate=answer
  取消一个断言, 注意这里的-
- -C
  保留注释
- -CC
  和-C 类似, 但是会在宏展开时保留宏原有的注释
- -P
  禁止输出行标
  ```c
  // 预处理结果中的行标格式
  # 35 "/usr/local/Cellar/gcc/13.1.0/lib/gcc/current/gcc/x86_64-apple-darwin22/13/include/limits.h" 2 3 4
  ```
- -traditional
- -traditional-cpp
  模拟标准 C 预处理器之前的的行为 [https://gcc.gnu.org/onlinedocs/cpp/Traditional-Mode.html](111), 只会影响预处理器
- -trigraphs
  转换 ISO C trigraphs [https://gcc.gnu.org/onlinedocs/cpp/Initial-processing.html](trigraphs), GCC 默认会忽略这些字符, 但是在标准模式(-std/-ansi)下会转换他们
- -remap
  允许部分文件系统使用一些特殊字符, 比如 MS-DOS
- -H
  打印出每个被用到的头文件, 用相应数量(层级数量)的`.`作缩进
- -dM
  只会输出 CPP 执行期间所有的宏定义, 包括预定义宏
- -dD
  和-dM 类似, 不过不会包含预定义宏, 并且会输出预处理结果
- -dN
  和-dDl 类似, 但是不包含宏展开的值
- -dI
  预处理结果会包含#include 指令
- -dU
  和-dD 类似, 不过只会输出使用到的宏(运行时决定), 有的宏虽然被源码使用到, 但是可能被条件编译排除, 那这些宏也不会包含到结果中
- -fdebug-cpp
  仅用于调试 GCC, 生成 location maps 相关的调试信息
  ```c
  {P:main.c;F:<NULL>;L:5;C:1;S:0;M:0x110a67048;E:0,LOC:16962,R:16962}int {P:main.c;F:<NULL>;L:5;C:5;S:0;M:0x110a67048;E:0,LOC:17091,R:17091}main{P:main.c;F:<NULL>;L:5;C:9;S:0;M:0x110a67048;E:0,LOC:17216,R:17216}({P:main.c;F:<NULL>;L:5;C:10;S:0;M:0x110a67048;E:0,LOC:17248,R:17248}){P:main.c;F:<NULL>;L:6;C:1;S:0;M:0x110a67048;E:0,LOC:21056,R:21056}
  ```
- -I dir
- -iquote dir
- -isystem dir
- -idirafter dir
  将 dir 加入头文件查找目录, 如果 dir 以=或$SYSROOT 开头, 那这两个符号会被替换为 sysroot
  头文件查找顺序如下

  1. 查找当前文件所在目录(用户头文件)
  2. 从左到右查找-iquote 指定的目录(用户头文件)
  3. 从左到右查找-I 指定的目录
  4. 从左到右查找-isystem 指定的目录(头文件会被标识为系统文件)
  5. 查找标准系统目录(头文件会被标识为系统文件)
  6. 从左到右查找-idirafter 指定的目录(头文件会被标识为系统文件)

- -I-
  已被废弃, 用于分隔用户头文件查找目录和系统目录, -I-之前的-I 指定的目录用于用户头文件, -I-之后的-I 用于系统头文件, 并且使用户头文件查找目录不包含当前文件所在目录
- -iprefix prefix
  配合-iwithprefix 使用, 用于指定一个前缀, 如果是一个目录, 则应该以/结尾
- -iwithprefix dir
  prefix + dir 等同 -idirafter
- -iwithprefixbefore dir
  prefix + dir 等同 -I
- -isysroot dir
  同--sysroot 一样, 但是只用于头文件查找(若目标环境是 Darwin, 则也会应用于库查找)
- -imultilib dir
  用 dir 作为目标特定的 C++头文件查找目录的子目录
- -nostdinc
  查找头文件的时候忽略查找标准系统目录
- -nostdinc++
  同上, 不过是针对 C++
- -Wcomment
- -Wcomments
  块注释内包含/\*, 行注释内包含//时会发出警告
- -Wtrigraphs
  程序内(注释除外)遇到 trigraph 时, 会警告, 该项默认启用, 可以通过-Wno-trigraphs 关闭
- -Wundef
  如果在#if 遇到不是宏的标识符, 则会警告
- -Wexpansion-to-define
  宏展开中包含 defined 时会发出警告
- -Wunused-macros
  用户在代码中定义的宏如果未使用, 则会发出警告, 在被跳过的条件编译中使用不算被使用(可以通过将宏放到条件编译内)
- -Wno-endif-labels
  在 else 和 endif 指令后如果有文本, 不要发出警告
  ```c
  #if FOO
  …
  #else FOO
  …
  #endif FOO
  ```
