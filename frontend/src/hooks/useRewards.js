import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import api from '../utils/api'

export const useRewards = () => {
  return useQuery({
    queryKey: ['rewards'],
    queryFn: async () => {
      const response = await api.get('/rewards')
      return response.data.data
    },
  })
}

export const useBalances = () => {
  return useQuery({
    queryKey: ['balances'],
    queryFn: async () => {
      const response = await api.get('/user/balances')
      return response.data
    },
  })
}

export const useRedemptions = () => {
  return useQuery({
    queryKey: ['redemptions'],
    queryFn: async () => {
      const response = await api.get('/redemptions')
      return response.data.data
    },
  })
}

export const useRedeemReward = () => {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: async (rewardId) => {
      const response = await api.post('/redemptions', { reward_id: rewardId })
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['balances'] })
      queryClient.invalidateQueries({ queryKey: ['redemptions'] })
    },
  })
}