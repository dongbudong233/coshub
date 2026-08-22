package com.coshub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.coshub.entity.Post;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface PostMapper extends BaseMapper<Post> {
}
