import { useRedemptions } from '../hooks/useRewards'

function History() {
  const { data: redemptions, isLoading } = useRedemptions()

  if (isLoading) {
    return <div>Loading redemption history...</div>
  }

  if (!redemptions || redemptions.length === 0) {
    return (
      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <div className="px-4 py-5 sm:px-6">
          <h2 className="text-lg font-medium text-gray-900">Redemption History</h2>
          <p className="mt-1 text-sm text-gray-600">You haven't redeemed any rewards yet.</p>
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white shadow overflow-hidden sm:rounded-md">
      <div className="px-4 py-5 sm:px-6">
        <h2 className="text-lg font-medium text-gray-900">Redemption History</h2>
      </div>
      <ul className="divide-y divide-gray-200">
        {redemptions.map((redemption) => (
          <li key={redemption.id} className="px-4 py-4 sm:px-6">
            <div className="flex items-center justify-between">
              <div>
                <h3 className="text-base font-medium text-gray-900">
                  {redemption.attributes.reward_name}
                </h3>
                <p className="text-sm text-gray-500">
                  {redemption.attributes.reward_description}
                </p>
                <p className="text-sm text-gray-500">
                  Cost: {redemption.attributes.points_cost?.toLocaleString() || 0} points
                </p>
              </div>
              <div className="text-sm text-gray-500">
                {new Date(redemption.attributes.created_at).toLocaleDateString()}
              </div>
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}

export default History