package com.coshub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class UserVO {

    private Long id;

    private String username;

    private String nickname;

    private String avatar;

    private String email;

    private Integer gender;

    private String skinType;

    private String signature;

    private String role;

    private LocalDateTime createTime;
}
