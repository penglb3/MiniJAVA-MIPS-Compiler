# 编译原理 项目4 说明

## 环境说明

- 操作系统：WSL2-Ubuntu 18.04.5 LTS
- 编译环境：
  - GNU Make 4.1 Built for x86_64-pc-linux-gnu
  - gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)
  - flex 2.6.4
  - bison (GNU Bison) 3.0.4
  - SPIM Version 8.0 of January 8, 2010（通过apt install安装）

## 编译和运行方法



### 编译

`Makefile`已经写好，只需要进入`src`文件夹然后`make`即可。

### 编译和运行测试

**注意：由于proj4提供的spim.linux笔者无法使用，故笔者用的是apt安装的spim。如果你想要使用这个脚本，可以自己apt install spim，也可以把脚本里的`spim`换成`./spim.linux`（如果你的机子上跑得起来的话）**

笔者提供了一个脚本`buildAndTest.sh`，可以自动完成编译并将`tests/`中提供的输入文件一一输入测试并将结果保存于`results/`里面，如果读者需要可以运行它：

```bash
chmod +x buildAndTest.sh
./buildAndTest.sh
```

## 目录结构

```
.
├── README.md
├── buildAndTest.sh
├── results
│   ├── src0.prog.out
│   ├── src0.prog.std.out
│   ├── src0.s
│   ├── src1.prog.out
│   ├── src1.prog.std.out
│   ├── src1.s
│   ├── src10.prog.out
│   ├── src10.prog.std.out
│   ├── src10.s
│   ├── src2.prog.out
│   ├── src2.prog.std.out
│   ├── src2.s
│   ├── src3.prog.out
│   ├── src3.prog.std.out
│   ├── src3.s
│   ├── src4.prog.out
│   ├── src4.prog.std.out
│   ├── src4.s
│   ├── src5.prog.out
│   ├── src5.prog.std.out
│   ├── src5.s
│   ├── src6.prog.out
│   ├── src6.prog.std.out
│   ├── src6.s
│   ├── src7.prog.out
│   ├── src7.prog.std.out
│   ├── src7.s
│   ├── src8.prog.out
│   ├── src8.prog.std.out
│   ├── src8.s
│   ├── src9.prog.out
│   ├── src9.prog.std.out
│   └── src9.s
├── spim.linux
├── src
│   ├── Makefile
│   ├── grammar.y
│   ├── lexer.l
│   ├── proj2.c
│   ├── proj2.h
│   ├── proj3.c
│   ├── proj3.h
│   ├── proj4.c
│   ├── proj4.h
│   ├── semantic.c
│   └── y.output
├── tests
│   ├── src0
│   ├── src0.out
│   ├── src0.s
│   ├── src1
│   ├── src1.out
│   ├── src1.s
│   ├── src10
│   ├── src10.in
│   ├── src10.out
│   ├── src10.s
│   ├── src2
│   ├── src2.out
│   ├── src2.s
│   ├── src3
│   ├── src3.in
│   ├── src3.out
│   ├── src3.s
│   ├── src4
│   ├── src4.out
│   ├── src4.s
│   ├── src5
│   ├── src5.out
│   ├── src5.s
│   ├── src6
│   ├── src6.out
│   ├── src6.s
│   ├── src7
│   ├── src7.out
│   ├── src7.s
│   ├── src8
│   ├── src8.out
│   ├── src8.s
│   ├── src9
│   ├── src9.out
│   └── src9.s
└── trap.handler

3 directories, 83 files
```