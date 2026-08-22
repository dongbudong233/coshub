# CosHub 项目长期记忆

## 项目定位
美妆产品论坛（CosHub），前后端分离：`coshub-api`（后端）+ `coshub-vue`（前端）。

## 技术栈约定
- 后端：Spring Boot 3.3.5 + MyBatis-Plus 3.5.7 + Spring Security + JWT(jjwt 0.11.5) + Lombok，Java 17，包名 `com.coshub`
- 前端：Vue 3 + Vite 5 + Element Plus + Pinia + Router + Axios
- 数据库：MySQL 8，库名 `coshub`，端口 3307（独立实例）

## 硬性约束（用户明确要求）
- **所有文件必须在 `D:\MyProject\coshub` 内**（项目已从 `D:\个人项目\coshub` 迁移至此），不得干扰其他项目
- **禁止触碰 `D:\dhtech`、`D:\dh_project`**（只读探查后也不再访问）
- 数据库只能操作新建的 `coshub` 库，绝不碰其他库（本机另有 `D:\dhtech\apps\mysql` 与 `192.168.110.162:3306` 为公司数据库，严禁连接）

## 构建方式
- JDK：借用 `D:\android\androidStudio\jbr`（JDK 21）
- 后端编译：`cd coshub-api && ../mvnw clean package -DskipTests`（用根目录 `mvnw` 包装脚本，规避中文路径 + cygpath 问题）
- 前端：`cd coshub-vue && npm install && npm run dev`（vite proxy 已配 `/api` → 8080）

## 数据库运行方式（已修复）
- MySQL 8.0.29 二进制：`D:\MyProject\coshub\.tools\mysql-8.0.29-winx64`
- 启动命令：`mysqld --defaults-file=D:\MyProject\coshub\.mysql\my.ini`（端口 3307，绑定 127.0.0.1）
- root 密码：`123456`（曾为空密码，已重置；另建 `root@'127.0.0.1'` 账号）
- 注意：`skip-name-resolve` 开启时 TCP 连接需匹配 `root@'127.0.0.1'`；数据目录 `.mysql/data`

## 已知坑（务必记住）
- ~~MySQL 8.0.29 在 Windows 中文路径下「启动」失败~~ **已解决**：迁移到 `D:\MyProject\coshub`（无中文路径）后正常
- Maven 的 mvn shell 脚本 cygpath 中文路径问题 → 用 `mvnw` 包装脚本
- 后端 context-path `/api`，前端 axios baseURL `/api`
- MySQL 8.0 `--skip-grant-tables` 会隐含禁用 TCP（报 "TCP/IP... should be configured on NT OS"），需显式 `--skip-networking=OFF`（实测仍无效，密码恢复用官方 init-file 方式更稳）
