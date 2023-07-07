通常情况, 代码在被执行前, 会被映射到进程虚拟内存的固定位置

程序在被执行时, 按地址直接取指令执行就行, 但是动态库在被执行前, 会通过`mmap`系统调用映射到改进程的虚拟内存中, 并且位置是不定的, 因此需要一种机制保证动态库能被正常执行

# PIC - position-independent code

位置无关代码, 其无论被加载到哪个地址, 都可以正常执行, gcc 中通过指定`-fPIC`生成 pic

# PIE - position-independent executable

位置无关可执行文件

# ASLR

地址空间布局随机化

# PLT - procedure linkage table

过程链接表

# GOT = global offset table

全局偏移表

# dynamic symbol table

动态链接器使用, 用于动态链接时重定位符号

# RTLD

运行时加载器
