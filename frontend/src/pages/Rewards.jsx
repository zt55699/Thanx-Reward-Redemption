import { useRewards, useBalances, useRedeemReward } from '../hooks/useRewards'

function Rewards() {
  const { data: rewards, isLoading } = useRewards()
  const { data: balances } = useBalances()
  const redeemReward = useRedeemReward()

  const handleRedeem = (rewardId) => {
    if (confirm('Are you sure you want to redeem this reward?')) {
      redeemReward.mutate(rewardId)
    }
  }

  if (isLoading) {
    return <div>Loading rewards...</div>
  }

  const pointsBalance = balances?.points_balance || 0

  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-md">
      <div className="px-4 py-5 sm:px-6">
        <h2 className="text-lg font-medium text-gray-900">Available Rewards</h2>
        <p className="mt-1 text-sm text-gray-600">
          Your current points balance: {pointsBalance.toLocaleString()}
        </p>
      </div>
      <ul className="divide-y divide-gray-200">
        {rewards?.map((reward) => {
          const canAfford = pointsBalance >= reward.attributes.cost
          return (
            <li key={reward.id}>
              <div className="px-4 py-4 sm:px-6">
                <div className="flex items-center justify-between">
                  <div className="flex-1">
                    <h3 className="text-lg font-medium text-gray-900">{reward.attributes.name}</h3>
                    <p className="mt-1 text-sm text-gray-500">{reward.attributes.description}</p>
                    <p className="mt-2 text-sm font-medium text-gray-900">
                      Cost: {reward.attributes.cost.toLocaleString()} points
                    </p>
                  </div>
                  <div className="ml-4">
                    <button
                      onClick={() => handleRedeem(reward.id)}
                      disabled={!canAfford || redeemReward.isPending}
                      className={`px-4 py-2 font-medium rounded-md ${
                        canAfford
                          ? 'bg-indigo-600 text-white hover:bg-indigo-700'
                          : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                      } disabled:opacity-50`}
                    >
                      {redeemReward.isPending ? 'Redeeming...' : 'Redeem'}
                    </button>
                  </div>
                </div>
              </div>
            </li>
          )
        })}
      </ul>
      {redeemReward.isError && (
        <div className="px-4 py-3 bg-red-50 text-red-800">
          Failed to redeem reward
        </div>
      )}
      {redeemReward.isSuccess && (
        <div className="px-4 py-3 bg-green-50 text-green-800">
          Reward redeemed successfully!
        </div>
      )}
    </div>
  )
}

export default Rewards