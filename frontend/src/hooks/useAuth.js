import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import api from '../utils/api'

export const useLogin = () => {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: async ({ email, password }) => {
      const response = await api.post('/auth/login', { email, password })
      return response.data
    },
    onSuccess: (data) => {
      localStorage.setItem('jwt', data.token)
      queryClient.setQueryData(['currentUser'], data.user)
    },
  })
}

export const useCurrentUser = () => {
  return useQuery({
    queryKey: ['currentUser'],
    queryFn: async () => {
      const response = await api.get('/user')
      return response.data.user
    },
    enabled: !!localStorage.getItem('jwt'),
  })
}

export const useLogout = () => {
  const queryClient = useQueryClient()
  
  return () => {
    localStorage.removeItem('jwt')
    queryClient.clear()
    window.location.href = '/login'
  }
}