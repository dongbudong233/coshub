package com.coshub;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 美妆产品论坛 - 后端启动类
 */
@SpringBootApplication
@MapperScan("com.coshub.mapper")
public class CoshubApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(CoshubApiApplication.class, args);
    }
}
