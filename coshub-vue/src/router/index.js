import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue'),
    meta: { title: '首页' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 全局路由守卫（框架已就绪，鉴权逻辑后续接入）
router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - CosHub` : 'CosHub'
  next()
})

export default router
