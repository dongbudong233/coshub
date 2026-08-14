-- =============================================================
-- CosHub 美妆产品论坛 - 数据库初始化脚本
-- 数据库: MySQL 8.0+  字符集: utf8mb4
-- =============================================================

CREATE DATABASE IF NOT EXISTS `coshub`
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE `coshub`;

-- -------------------------------------------------------------
-- 1. 用户表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
    `id`              BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `username`        VARCHAR(50)  NOT NULL COMMENT '用户名',
    `password`        VARCHAR(100) NOT NULL COMMENT '密码（BCrypt 加密）',
    `nickname`        VARCHAR(50)  DEFAULT NULL COMMENT '昵称',
    `avatar`          VARCHAR(255) DEFAULT NULL COMMENT '头像 URL',
    `email`           VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `gender`          TINYINT      DEFAULT 0 COMMENT '性别 0-未知 1-男 2-女',
    `skin_type`       VARCHAR(20)  DEFAULT NULL COMMENT '肤质：dry/oily/mixed/normal/sensitive',
    `age_group`       VARCHAR(20)  DEFAULT NULL COMMENT '年龄段',
    `signature`       VARCHAR(200) DEFAULT NULL COMMENT '个性签名',
    `role`            VARCHAR(20)  NOT NULL DEFAULT 'USER' COMMENT '角色 USER/ADMIN',
    `status`          TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 1-正常 0-禁用',
    `last_login_time` DATETIME     DEFAULT NULL COMMENT '最后登录时间',
    `create_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`         TINYINT      NOT NULL DEFAULT 0 COMMENT '逻辑删除 0-未删 1-已删',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`),
    KEY `idx_deleted` (`deleted`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';

-- -------------------------------------------------------------
-- 2. 美妆分类表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `beauty_category`;
CREATE TABLE `beauty_category` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`        VARCHAR(50)  NOT NULL COMMENT '分类名称',
    `code`        VARCHAR(50)  NOT NULL COMMENT '分类编码',
    `icon`        VARCHAR(255) DEFAULT NULL COMMENT '分类图标',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '分类描述',
    `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序（越小越靠前）',
    `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_code` (`code`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '美妆分类表';

-- -------------------------------------------------------------
-- 3. 美妆产品表（排行榜数据源）
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `beauty_product`;
CREATE TABLE `beauty_product` (
    `id`            BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`          VARCHAR(100)  NOT NULL COMMENT '产品名称',
    `brand`         VARCHAR(50)   DEFAULT NULL COMMENT '品牌',
    `category_id`   BIGINT        NOT NULL COMMENT '所属分类',
    `cover`         VARCHAR(255)  DEFAULT NULL COMMENT '封面图 URL',
    `description`   TEXT          COMMENT '产品描述',
    `price`         DECIMAL(10, 2) DEFAULT NULL COMMENT '参考价格',
    `hot_score`     BIGINT        NOT NULL DEFAULT 0 COMMENT '综合热度分',
    `view_count`    BIGINT        NOT NULL DEFAULT 0 COMMENT '浏览量',
    `like_count`    BIGINT        NOT NULL DEFAULT 0 COMMENT '点赞数',
    `discuss_count` BIGINT        NOT NULL DEFAULT 0 COMMENT '讨论数',
    `status`        TINYINT       NOT NULL DEFAULT 1 COMMENT '状态 1-上架 0-下架',
    `create_time`   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_category` (`category_id`),
    KEY `idx_hot_score` (`hot_score`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '美妆产品表';

-- -------------------------------------------------------------
-- 4. 帖子表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
    `id`           BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`      BIGINT       NOT NULL COMMENT '作者用户 id',
    `category_id`  BIGINT       DEFAULT NULL COMMENT '所属分类',
    `title`        VARCHAR(200) NOT NULL COMMENT '标题',
    `content`      LONGTEXT     NOT NULL COMMENT '正文内容',
    `cover_images` VARCHAR(1000) DEFAULT NULL COMMENT '封面图片 URL（逗号分隔）',
    `view_count`   BIGINT       NOT NULL DEFAULT 0 COMMENT '浏览量',
    `like_count`   BIGINT       NOT NULL DEFAULT 0 COMMENT '点赞数',
    `comment_count` BIGINT      NOT NULL DEFAULT 0 COMMENT '评论数',
    `is_top`       TINYINT      NOT NULL DEFAULT 0 COMMENT '是否置顶 0-否 1-是',
    `is_essence`   TINYINT      NOT NULL DEFAULT 0 COMMENT '是否精华 0-否 1-是',
    `status`       TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 1-正常 0-隐藏',
    `create_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      TINYINT      NOT NULL DEFAULT 0 COMMENT '逻辑删除 0-未删 1-已删',
    PRIMARY KEY (`id`),
    KEY `idx_user` (`user_id`),
    KEY `idx_category` (`category_id`),
    KEY `idx_create_time` (`create_time`),
    KEY `idx_deleted` (`deleted`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '帖子表';

-- -------------------------------------------------------------
-- 5. 评论表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment` (
    `id`            BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `post_id`       BIGINT   NOT NULL COMMENT '帖子 id',
    `user_id`       BIGINT   NOT NULL COMMENT '评论人 id',
    `parent_id`     BIGINT   NOT NULL DEFAULT 0 COMMENT '父评论 id（0 为顶层）',
    `reply_user_id` BIGINT   DEFAULT NULL COMMENT '被回复用户 id',
    `content`       TEXT     NOT NULL COMMENT '评论内容',
    `like_count`    BIGINT   NOT NULL DEFAULT 0 COMMENT '点赞数',
    `status`        TINYINT  NOT NULL DEFAULT 1 COMMENT '状态 1-正常 0-隐藏',
    `create_time`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `deleted`       TINYINT  NOT NULL DEFAULT 0 COMMENT '逻辑删除 0-未删 1-已删',
    PRIMARY KEY (`id`),
    KEY `idx_post` (`post_id`),
    KEY `idx_user` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '评论表';

-- -------------------------------------------------------------
-- 6. 点赞记录表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `like_record`;
CREATE TABLE `like_record` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`     BIGINT   NOT NULL COMMENT '点赞用户 id',
    `target_type` TINYINT  NOT NULL COMMENT '目标类型 1-帖子 2-评论 3-产品',
    `target_id`   BIGINT   NOT NULL COMMENT '目标 id',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_target` (`user_id`, `target_type`, `target_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '点赞记录表';

-- -------------------------------------------------------------
-- 7. 兴趣标签表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `interest_tag`;
CREATE TABLE `interest_tag` (
    `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`        VARCHAR(50)  NOT NULL COMMENT '标签名称',
    `category_id` BIGINT       DEFAULT NULL COMMENT '关联分类 id（可空）',
    `type`        TINYINT      NOT NULL DEFAULT 1 COMMENT '类型 1-系统预设 2-用户自定义',
    `description` VARCHAR(255) DEFAULT NULL COMMENT '标签描述',
    `sort`        INT          NOT NULL DEFAULT 0 COMMENT '排序',
    `status`      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态 1-启用 0-禁用',
    `create_time` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_name` (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '兴趣标签表';

-- -------------------------------------------------------------
-- 8. 用户兴趣关联表
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `user_interest`;
CREATE TABLE `user_interest` (
    `id`          BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`     BIGINT   NOT NULL COMMENT '用户 id',
    `tag_id`      BIGINT   NOT NULL COMMENT '兴趣标签 id',
    `source`      TINYINT  NOT NULL DEFAULT 1 COMMENT '来源 1-用户自定义 2-系统挖掘',
    `weight`      INT      NOT NULL DEFAULT 1 COMMENT '权重（系统挖掘的置信度）',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_tag` (`user_id`, `tag_id`),
    KEY `idx_user` (`user_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户兴趣关联表';

-- -------------------------------------------------------------
-- 9. 用户行为日志表（兴趣自动挖掘数据源）
-- -------------------------------------------------------------
DROP TABLE IF EXISTS `user_behavior`;
CREATE TABLE `user_behavior` (
    `id`            BIGINT   NOT NULL AUTO_INCREMENT COMMENT '主键',
    `user_id`       BIGINT   NOT NULL COMMENT '用户 id',
    `behavior_type` TINYINT  NOT NULL COMMENT '行为类型 1-浏览帖子 2-点赞 3-评论 4-浏览产品 5-搜索',
    `target_type`   TINYINT  NOT NULL COMMENT '目标类型 1-帖子 2-产品 3-分类',
    `target_id`     BIGINT   NOT NULL COMMENT '目标 id',
    `category_id`   BIGINT   DEFAULT NULL COMMENT '关联分类 id',
    `create_time`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_time` (`user_id`, `create_time`),
    KEY `idx_category` (`category_id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户行为日志表';

-- =============================================================
-- 基础数据
-- =============================================================

-- 美妆分类
INSERT INTO `beauty_category` (`name`, `code`, `description`, `sort`) VALUES
('口红',   'lipstick',   '口红、唇釉、唇膏等唇部彩妆', 1),
('粉底',   'foundation', '粉底液、气垫、遮瑕等底妆', 2),
('眼妆',   'eye-makeup', '眼影、眼线、睫毛膏等', 3),
('护肤',   'skincare',   '洁面、水乳、精华、面霜等', 4),
('香水',   'perfume',    '香水、香氛', 5),
('美甲',   'nail',       '指甲油、美甲工具', 6),
('防晒',   'sunscreen',  '防晒霜、防晒喷雾', 7),
('美发',   'haircare',   '洗护、染发、造型', 8);

-- 兴趣标签（系统预设）
INSERT INTO `interest_tag` (`name`, `category_id`, `type`, `description`, `sort`) VALUES
('口红控',      1, 1, '热衷口红、唇釉', 1),
('底妆达人',    2, 1, '粉底、遮瑕心得分享', 2),
('眼妆高手',    3, 1, '眼影、眼线进阶玩法', 3),
('敏感肌护理',  4, 1, '敏感肌友好产品', 4),
('抗老护肤',    4, 1, '抗皱、紧致、抗初老', 5),
('油痘肌护理',  4, 1, '控油、祛痘', 6),
('干皮保湿',    4, 1, '干性皮肤补水保湿', 7),
('香水收藏',    5, 1, '香水品鉴与收藏', 8),
('美甲DIY',     6, 1, '美甲设计 DIY', 9),
('防晒党',      7, 1, '防晒产品推荐', 10),
('染发控',      8, 1, '染发、护色', 11);
