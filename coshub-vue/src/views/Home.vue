<template>
  <div class="home">
    <div class="card">
      <h1>CosHub 美妆产品论坛</h1>
      <p class="subtitle">项目框架已就绪，功能开发中</p>

      <el-divider />

      <div class="stack">
        <el-tag type="danger" effect="dark">Spring Boot 3</el-tag>
        <el-tag type="warning" effect="dark">MyBatis-Plus</el-tag>
        <el-tag type="success" effect="dark">Vue 3</el-tag>
        <el-tag effect="dark">Element Plus</el-tag>
        <el-tag type="info" effect="dark">MySQL 8</el-tag>
      </div>

      <el-divider />

      <el-button type="primary" :loading="loading" @click="checkHealth">
        检查后端连通性
      </el-button>

      <el-alert
        v-if="health"
        class="health-result"
        :title="`后端连接成功：${health.status} @ ${health.time}`"
        type="success"
        :closable="false"
        show-icon
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import request from '@/api/request'

const loading = ref(false)
const health = ref(null)

async function checkHealth() {
  loading.value = true
  try {
    health.value = await request.get('/health')
  } catch (e) {
    health.value = null
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.home {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #fdf6f0 0%, #fce4ec 100%);
}

.card {
  background: #fff;
  border-radius: 16px;
  padding: 48px 56px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
  text-align: center;
  max-width: 520px;
}

h1 {
  font-size: 28px;
  color: #333;
  margin-bottom: 8px;
}

.subtitle {
  color: #999;
  margin-bottom: 8px;
}

.stack {
  display: flex;
  gap: 8px;
  justify-content: center;
  flex-wrap: wrap;
}

.health-result {
  margin-top: 16px;
  text-align: left;
}
</style>
