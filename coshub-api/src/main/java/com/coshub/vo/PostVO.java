package com.coshub.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PostVO {

    private Long id;

    private Long userId;

    private String authorName;

    private String authorAvatar;

    private Long categoryId;

    private String title;

    private String content;

    private Long viewCount;

    private Long likeCount;

    private Long commentCount;

    private Integer isTop;

    private Integer isEssence;

    private LocalDateTime createTime;
}
