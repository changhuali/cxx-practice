# transaction memory

transaction memory 试图让一组 load/store 指令以一种原子性的方式执行, 以此简化并发编程。

它是为一种为了在进行并行计算时对共享内存的访问进行控制的机制, 类似数据库的事务。

它提供了一种上层抽象, 其可以作为底层线程同步技术的替代。
 