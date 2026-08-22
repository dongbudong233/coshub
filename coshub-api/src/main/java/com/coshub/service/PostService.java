package com.coshub.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.coshub.common.BusinessException;
import com.coshub.common.ResultCode;
import com.coshub.dto.PostCreateRequest;
import com.coshub.entity.Post;
import com.coshub.entity.SysUser;
import com.coshub.mapper.PostMapper;
import com.coshub.mapper.SysUserMapper;
import com.coshub.vo.PostVO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PostService {

    private final PostMapper postMapper;
    private final SysUserMapper userMapper;

    public Page<PostVO> listPosts(int page, int size, Long categoryId) {
        LambdaQueryWrapper<Post> wrapper = new LambdaQueryWrapper<Post>()
                .eq(Post::getStatus, 1)
                .orderByDesc(Post::getIsTop)
                .orderByDesc(Post::getCreateTime);
        if (categoryId != null) {
            wrapper.eq(Post::getCategoryId, categoryId);
        }

        Page<Post> postPage = postMapper.selectPage(new Page<>(page, size), wrapper);
        return toVOPage(postPage);
    }

    @Transactional
    public PostVO getPostDetail(Long id) {
        Post post = postMapper.selectById(id);
        if (post == null || post.getStatus() != 1) {
            throw new BusinessException(ResultCode.NOT_FOUND, "帖子不存在");
        }

        post.setViewCount(post.getViewCount() + 1);
        postMapper.updateById(post);

        return toPostVO(post, loadUserMap(Set.of(post.getUserId())));
    }

    @Transactional
    public PostVO createPost(Long userId, PostCreateRequest request) {
        Post post = new Post();
        post.setUserId(userId);
        post.setTitle(request.getTitle());
        post.setContent(request.getContent());
        post.setCategoryId(request.getCategoryId());
        post.setViewCount(0L);
        post.setLikeCount(0L);
        post.setCommentCount(0L);
        post.setIsTop(0);
        post.setIsEssence(0);
        post.setStatus(1);
        postMapper.insert(post);

        return toPostVO(post, loadUserMap(Set.of(userId)));
    }

    private Page<PostVO> toVOPage(Page<Post> postPage) {
        Set<Long> userIds = postPage.getRecords().stream()
                .map(Post::getUserId)
                .collect(Collectors.toSet());
        Map<Long, SysUser> userMap = loadUserMap(userIds);

        Page<PostVO> voPage = new Page<>(postPage.getCurrent(), postPage.getSize(), postPage.getTotal());
        List<PostVO> records = postPage.getRecords().stream()
                .map(post -> toPostVO(post, userMap))
                .collect(Collectors.toList());
        voPage.setRecords(records);
        return voPage;
    }

    private Map<Long, SysUser> loadUserMap(Set<Long> userIds) {
        if (userIds.isEmpty()) {
            return Map.of();
        }
        return userMapper.selectBatchIds(userIds).stream()
                .collect(Collectors.toMap(SysUser::getId, u -> u));
    }

    private PostVO toPostVO(Post post, Map<Long, SysUser> userMap) {
        PostVO vo = new PostVO();
        BeanUtils.copyProperties(post, vo);
        SysUser author = userMap.get(post.getUserId());
        if (author != null) {
            vo.setAuthorName(author.getNickname() != null ? author.getNickname() : author.getUsername());
            vo.setAuthorAvatar(author.getAvatar());
        }
        return vo;
    }
}
