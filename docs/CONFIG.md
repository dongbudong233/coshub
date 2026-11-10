# CosHub 项目配置文档

> 美妆产品论坛（CosHub）· 前后端分离项目
> 文档更新时间：2026-08-14 · 项目路径：`D:\MyProject\coshub`

---

## 目录

1. [项目总览](#1-项目总览)
2. [目录结构](#2-目录结构)
3. [环境与工具链](#3-环境与工具链)
4. [MySQL 数据库实例](#4-mysql-数据库实例)
5. [coshub 业务数据库](#5-coshub-业务数据库)
6. [后端配置（coshub-api）](#6-后端配置coshub-api)
7. [前端配置（coshub-vue）](#7-前端配置coshub-vue)
8. [连接信息汇总](#8-连接信息汇总)
9. [安全边界与操作约束](#9-安全边界与操作约束)
10. [已知坑与注意事项](#10-已知坑与注意事项)
11. [完整启动步骤](#11-完整启动步骤)

---

## 1. 项目总览

| 项 | 说明 |
|---|---|
| 项目定位 | 美妆产品论坛：产品排行榜、帖子讨论、用户兴趣挖掘 |
| 架构 | 前后端分离（SPA + RESTful API） |
| 后端 | `coshub-api`：Spring Boot 3.3.5 + MyBatis-Plus + Spring Security + JWT |
| 前端 | `coshub-vue`：Vue 3 + Vite 5 + Element Plus + Pinia + Vue Router + Axios |
| 数据库 | MySQL 8.0.29（**项目内独立实例**，端口 3307） |
| Java 包名 | `com.coshub` |
| 后端服务端口 | 8080（context-path `/api`） |
| 前端开发端口 | 5173（Vite dev server） |

请求链路：`浏览器 → Vite(5173) → /api 代理 → Spring Boot(8080) → MySQL(3307)`

---

## 2. 目录结构

```
D:\MyProject\coshub\
├── coshub-api\                      # 后端 Spring Boot 工程
│   ├── pom.xml
│   ├── sql\
│   │   └── init.sql                 # 数据库初始化脚本（建库 + 9 表 + 种子数据）
│   └── src\main\
│       ├── java\com\coshub\
│       │   ├── CoshubApiApplication.java
│       │   ├── common\             # Result / ResultCode / BusinessException / GlobalExceptionHandler
│       │   ├── config\             # SecurityConfig / CorsConfig / MybatisPlusConfig
│       │   ├── controller\         # HealthController 等
│       │   ├── dto\                # 入参对象
│       │   ├── entity\             # 实体类（BaseEntity + 9 张表实体）
│       │   ├── mapper\             # MyBatis-Plus Mapper 接口
│       │   ├── security\           # JwtUtil 等
│       │   ├── service\            # 业务接口
│       │   │   └── impl\
│       │   └── vo\                 # 出参对象
│       └── resources\
│           ├── application.yml     # 主配置（端口/MyBatis-Plus/JWT）
│           └── application-dev.yml # 开发环境（数据源）
├── coshub-vue\                     # 前端 Vue 3 工程
│   ├── package.json
│   ├── vite.config.js              # 开发代理 /api → 8080
│   ├── index.html
│   └── src\
│       ├── main.js / App.vue
│       ├── api\request.js          # Axios 实例（token 附加 + 统一错误处理）
│       ├── router\index.js         # 路由（守卫框架已就绪）
│       ├── store\user.js           # Pinia 用户状态
│       └── views\Home.vue
├── .mysql\                         # 项目自有 MySQL 实例（数据）
│   ├── my.ini                      # MySQL 配置（端口 3307）
│   ├── data\                       # 数据目录（已初始化）
│   └── logs\error.log
├── .tools\                         # 项目内工具链（与全局隔离）
│   ├── apache-maven-3.9.9\         # Maven（conf/settings.xml 已配置阿里云镜像）
│   ├── maven-repo\                 # Maven 本地仓库（项目内隔离）
│   ├── maven-settings.xml          # 备用 Maven settings
│   ├── mysql-8.0.29-winx64\        # MySQL 二进制
│   └── build.log                   # 历史构建日志
├── mvnw                            # Maven 包装脚本（规避中文路径问题）
├── .gitignore
└── .workbuddy\memory\              # 项目记忆（MEMORY.md + 每日日志）
```

---

## 3. 环境与工具链

| 工具 | 位置 / 版本 | 说明 |
|---|---|---|
| JDK | `D:\android\androidStudio\jbr`（JDK 21） | 零安装借用，编译目标 Java 17 |
| Maven | `.tools\apache-maven-3.9.9` | 项目内独立，阿里云镜像 |
| Maven 仓库 | `.tools\maven-repo` | 项目内隔离，不污染全局 `~/.m2` |
| Node.js | 系统安装（22.x） | 用于前端构建 |
| MySQL | `.tools\mysql-8.0.29-winx64`（8.0.29） | 项目内独立实例 |
| Git | 系统安装 | 仓库已在 `D:\MyProject\coshub\.git` 初始化 |

---

## 4. MySQL 数据库实例

### 4.1 概述

- **独立实例**：二进制与数据全部在项目目录内，端口 **3307**（避开系统 3306）
- **绑定地址**：`127.0.0.1`，仅本机可连，不对外暴露
- **与公司/其他项目隔离**：绝不触碰 `192.168.110.162:3306`（公司库）与 `D:\dhtech\apps\mysql`

### 4.2 关键路径

| 项 | 路径 |
|---|---|
| 配置文件 | `D:\MyProject\coshub\.mysql\my.ini` |
| 数据目录 | `D:\MyProject\coshub\.mysql\data` |
| 错误日志 | `D:\MyProject\coshub\.mysql\logs\error.log` |
| 二进制 | `D:\MyProject\coshub\.tools\mysql-8.0.29-winx64\bin\` |

### 4.3 my.ini 全文（当前生效）

```ini
[client]
port=3307
default-character-set=utf8mb4

[mysqld]
port=3307
basedir=D:/MyProject/.tools/mysql-8.0.29-winx64
datadir=D:/MyProject/coshub/.mysql/data
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
lower_case_table_names=1
max_connections=200
max_allowed_packet=64M
innodb_buffer_pool_size=256M
innodb_flush_log_at_trx_commit=1
innodb_file_per_table=1
log-error=D:/MyProject/coshub/.mysql/logs/error.log
skip-log-bin
skip-name-resolve
bind-address=127.0.0.1

[mysql]
default-character-set=utf8mb4
```

**关键参数说明**：

| 参数 | 值 | 说明 |
|---|---|---|
| `port` | 3307 | 实例端口（与全局 3306 错开） |
| `basedir` / `datadir` | 项目内路径 | 必须与项目迁移后的实际路径一致 |
| `character-set-server` | utf8mb4 | 服务端字符集 |
| `lower_case_table_names` | 1 | 表名大小写不敏感（Windows 必需） |
| `skip-name-resolve` | 开 | 禁用 DNS 反向解析，**TCP 连接需匹配 IP 账号**（见 4.4） |
| `bind-address` | 127.0.0.1 | 仅本机监听 |
| `skip-log-bin` | 开 | 关闭 binlog（本地开发实例） |

### 4.4 账号与密码

| 账号 | Host | 密码 | 权限 | 用途 |
|---|---|---|---|---|
| `root` | `localhost` | `123456` | 全部 | 本地维护（已重置） |
| `root` | `127.0.0.1` | `123456` | 全部 + GRANT | **Navicat / JDBC 实际使用的账号** |

> ⚠️ **必须理解**：`skip-name-resolve` 开启时，`root@localhost` 无法匹配 TCP 的 `127.0.0.1` 连接（报 ERROR 1130）。因此必须存在 `root@'127.0.0.1'` 账号，Navicat 和后端 JDBC 才能连接。

### 4.5 启动 / 停止命令

```bash
# 启动（Git Bash）
"D:/MyProject/.tools/mysql-8.0.29-winx64/bin/mysqld.exe" \
  --defaults-file="D:/MyProject/coshub/.mysql/my.ini"

# 停止（PowerShell，PID 为监听 3307 的进程号）
Stop-Process -Id <PID> -Force

# 连接测试
"D:/MyProject/.tools/mysql-8.0.29-winx64/bin/mysql.exe" \
  -h127.0.0.1 -P3307 -uroot -p123456
```

> 注意：目前 MySQL 以命令行前台方式启动，**重启电脑后不会自启**。如需开机自启，需注册为 Windows 服务（尚未执行）。

### 4.6 实例维护常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| `ERROR 1130: Host '127.0.0.1' is not allowed` | `skip-name-resolve` 下无 `root@'127.0.0.1'` 账号 | 用 localhost 进入后创建 IP 账号 |
| `ERROR 1045: Access denied` | 密码错误 | 本项目曾为空密码，现为 `123456` |
| `--skip-grant-tables` 启动报 "TCP/IP... should be configured on NT OS" | MySQL 8.0 的 skip-grant-tables 隐含禁用 TCP | 改用「临时注释 skip-name-resolve + localhost 进入」方案 |
| mysqld 异常中止后 InnoDB assertion failure | 中止连锁反应，非数据损坏 | 正常重启即可 |

---

## 5. coshub 业务数据库

### 5.1 基本信息

| 项 | 值 |
|---|---|
| 库名 | `coshub` |
| 字符集 | `utf8mb4` / `utf8mb4_general_ci` |
| 初始化脚本 | `D:\MyProject\coshub\coshub-api\sql\init.sql` |
| 状态 | ✅ 已创建并导入（2026-08-14） |

### 5.2 表清单（9 张）

| 表名 | 用途 | 关键字段 |
|---|---|---|
| `sys_user` | 用户 | username 唯一、password(BCrypt)、skin_type、age_group、role |
| `beauty_category` | 美妆分类 | name、code 唯一、sort |
| `beauty_product` | 产品（排行榜数据源） | brand、category_id、hot_score、price |
| `post` | 帖子 | title、content、cover_images、is_top、is_essence |
| `comment` | 评论 | parent_id（楼中楼）、reply_user_id |
| `like_record` | 点赞记录 | user_id + target_type + target_id 唯一 |
| `interest_tag` | 兴趣标签 | name 唯一、type（预设/自定义） |
| `user_interest` | 用户兴趣关联 | user_id + tag_id 唯一、weight |
| `user_behavior` | 行为日志（兴趣挖掘数据源） | behavior_type、target_type |

公共约定：主键 `BIGINT AUTO_INCREMENT`；含 `create_time`；业务表含 `deleted` 逻辑删除（与 MyBatis-Plus `logic-delete-field: deleted` 对齐）。

### 5.3 种子数据

- **美妆分类 8 个**：口红、粉底、眼妆、护肤、香水、美甲、防晒、美发
- **兴趣标签 11 个**：口红控、底妆达人、眼妆高手、敏感肌护理、抗老护肤、油痘肌护理、干皮保湿、香水收藏、美甲DIY、防晒党、染发控

### 5.4 重新初始化

```bash
"D:/MyProject/.tools/mysql-8.0.29-winx64/bin/mysql.exe" \
  -h127.0.0.1 -P3307 -uroot -p123456 --default-character-set=utf8mb4 \
  < "D:/MyProject/coshub/coshub-api/sql/init.sql"
```

> ⚠️ 脚本含 `DROP TABLE IF EXISTS`，会清空业务数据，仅开发环境使用。

---

## 6. 后端配置（coshub-api）

### 6.1 依赖版本（pom.xml）

| 依赖 | 版本 | 说明 |
|---|---|---|
| Spring Boot | 3.3.5 | parent，Java 17 |
| MyBatis-Plus | 3.5.7 | `mybatis-plus-spring-boot3-starter` |
| MySQL 驱动 | mysql-connector-j（Boot 管理） | runtime |
| JJWT | 0.11.5 | api / impl / jackson 三件套 |
| Lombok | Boot 管理 | optional |
| Security + Validation | Boot 管理 | starter |

### 6.2 application.yml（主配置）

```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: coshub-api
  profiles:
    active: dev
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
    default-property-inclusion: non_null

mybatis-plus:
  mapper-locations: classpath*:/mapper/**/*.xml
  type-aliases-package: com.coshub.entity
  configuration:
    map-underscore-to-camel-case: true
  global-config:
    banner: false
    db-config:
      id-type: auto
      logic-delete-field: deleted
      logic-delete-value: 1
      logic-not-delete-value: 0

coshub:
  jwt:
    # HS256 签名密钥（生产环境必须更换）
    secret: "coshub-beauty-forum-jwt-secret-key-2026-secure-hash-1234567890-abcdefghijklmnop"
    expire: 86400000        # token 有效期 24 小时
    header: Authorization
    prefix: "Bearer "
```

**要点**：
- 后端统一前缀 `/api`（与前端 baseURL 对齐）
- 逻辑删除字段统一为 `deleted`（0 未删 / 1 已删）
- JWT 配置为业务自定义项，读取 `coshub.jwt.*`

### 6.3 application-dev.yml（开发环境数据源）

```yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3307/coshub?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&rewriteBatchedStatements=true
    username: root
    password: "123456"
    hikari:
      maximum-pool-size: 10
      minimum-idle: 2
      connection-timeout: 30000
      idle-timeout: 600000
      max-lifetime: 1800000

logging:
  level:
    com.coshub: debug
    com.coshub.mapper: debug
```

> 端口已对齐 3307（与项目 MySQL 实例一致）。JDBC URL 中的 `localhost` 会解析为 127.0.0.1 TCP 连接，匹配 `root@'127.0.0.1'`。

### 6.4 构建命令

```bash
# 进入后端目录后，用根目录 mvnw（规避 Git Bash cygpath 中文路径问题）
cd D:/MyProject/coshub/coshub-api
../mvnw clean package -DskipTests
# 产物：coshub-api/target/coshub-api-0.0.1-SNAPSHOT.jar

# 运行
java -jar target/coshub-api-0.0.1-SNAPSHOT.jar
# 或
../mvnw spring-boot:run
```

---

## 7. 前端配置（coshub-vue）

### 7.1 依赖版本（package.json）

| 依赖 | 版本 |
|---|---|
| vue | ^3.4.38 |
| vue-router | ^4.4.5 |
| pinia | ^2.2.4 |
| element-plus | ^2.8.4 |
| @element-plus/icons-vue | ^2.3.1 |
| axios | ^1.7.7 |
| vite | ^5.4.8（dev） |
| @vitejs/plugin-vue | ^5.1.4（dev） |

### 7.2 vite.config.js

```js
server: {
  port: 5173,
  host: true,
  proxy: {
    '/api': {
      target: 'http://localhost:8080',  // 代理到后端
      changeOrigin: true
    }
  }
}
```

- 别名 `@` → `src`
- 开发请求 `/api/xxx` 自动转发至后端 8080

### 7.3 常用命令

```bash
cd D:/MyProject/coshub/coshub-vue
npm install        # 安装依赖
npm run dev        # 开发模式（http://localhost:5173）
npm run build      # 生产构建（dist/）
```

### 7.4 Axios 请求封装（src/api/request.js）

- `baseURL: '/api'`，超时 10s
- **请求拦截器**：从 `localStorage('coshub_token')` 读取 token，附加 `Authorization: Bearer <token>`
- **响应拦截器**：`code === 200` 直接返回 `data`；`code === 401` 清 token 并跳登录页；其他错误弹 ElMessage

### 7.5 路由与状态

- `src/router/index.js`：`createWebHistory`，当前仅 Home 路由；全局守卫已就绪（设置页面 title），鉴权逻辑待接入
- `src/store/user.js`：Pinia store，`token` / `userInfo` / `setToken` / `setUserInfo` / `logout`，token 持久化到 localStorage

---

## 8. 连接信息汇总

### 8.1 Navicat 连接（✅ 当前可用）

```
连接名：coshub-local（自定义）
主机：127.0.0.1
端口：3307
用户名：root
密码：123456
数据库：coshub
```

### 8.2 后端 JDBC

```
jdbc:mysql://localhost:3307/coshub?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true&rewriteBatchedStatements=true
用户名/密码：root / 123456
```

### 8.3 前端代理

```
/api → http://localhost:8080（Vite dev proxy）
```

### 8.4 服务端口一览

| 服务 | 地址 |
|---|---|
| MySQL | 127.0.0.1:3307 |
| 后端 API | http://localhost:8080/api |
| 前端开发 | http://localhost:5173 |

### 8.5 JWT 约定

| 项 | 值 |
|---|---|
| 请求头 | `Authorization: Bearer <token>` |
| 有效期 | 24h（86400000 ms） |
| 算法 | HS256 |
| 前端存储 | `localStorage['coshub_token']` |

---

## 9. 安全边界与操作约束

> ⚠️ **用户明确要求，必须严格遵守**：

1. **所有文件操作仅限 `D:\MyProject\coshub` 内**，不得干扰其他项目
2. **禁止触碰** `D:\dhtech`、`D:\dh_project`（公司项目）
3. **禁止连接公司数据库** `192.168.110.162:3306`
4. **数据库只能操作 `coshub` 库**，绝不碰其他库
5. 本机另有一套 MySQL（`D:\dhtech\apps\mysql`），与项目实例无关，严禁混用

---

## 10. 已知坑与注意事项

| # | 坑 | 状态 |
|---|---|---|
| 1 | MySQL 8.0.29 中文路径启动失败（basedir 被截断为 `D:\`） | ✅ 已解决（迁移至无中文路径 `D:\MyProject\coshub`） |
| 2 | Maven `mvn` 脚本 cygpath 中文路径报错 | ✅ 已解决（使用 `mvnw` 包装脚本） |
| 3 | Maven localRepository 残留旧路径 `D:/个人项目/...` | ✅ 已修正（两处 settings 均改为新路径） |
| 4 | root 密码为空导致 `123456` 连不上 | ✅ 已重置为 `123456` |
| 5 | `skip-name-resolve` 导致 127.0.0.1 无法匹配 localhost 账号 | ✅ 已建 `root@'127.0.0.1'` |
| 6 | MySQL 8.0 `--skip-grant-tables` 隐含禁用 TCP | ⚠️ 记录（勿再用此方式恢复密码） |
| 7 | MySQL 重启后不自启 | ⚠️ 未注册 Windows 服务，待定 |

---

## 11. 完整启动步骤

**一键式顺序**（开发环境）：

```bash
# 1️⃣ 启动 MySQL（如未运行）
"D:/MyProject/.tools/mysql-8.0.29-winx64/bin/mysqld.exe" \
  --defaults-file="D:/MyProject/coshub/.mysql/my.ini"

# 2️⃣ 启动后端（8080）
cd D:/MyProject/coshub/coshub-api
../mvnw spring-boot:run
# 健康检查：curl http://localhost:8080/api/health

# 3️⃣ 启动前端（5173）
cd D:/MyProject/coshub/coshub-vue
npm run dev
# 访问 http://localhost:5173
```

---

*本文档与代码同步维护；任何配置变更后请同步更新本文件。*
