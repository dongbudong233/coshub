import { defineStore } from 'pinia'
import { ref } from 'vue'

/**
 * 用户状态（框架已就绪，登录逻辑后续接入）
 */
export const useUserStore = defineStore('user', () => {
  const token = ref(localStorage.getItem('coshub_token') || '')
  const userInfo = ref(null)

  function setToken(val) {
    token.value = val
    localStorage.setItem('coshub_token', val)
  }

  function setUserInfo(info) {
    userInfo.value = info
  }

  function logout() {
    token.value = ''
    userInfo.value = null
    localStorage.removeItem('coshub_token')
  }

  return { token, userInfo, setToken, setUserInfo, logout }
})
