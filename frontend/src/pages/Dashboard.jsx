import { useBalances } from '../hooks/useRewards'

function Dashboard() {
  const { data: balances, isLoading } = useBalances()

  if (isLoading) {
    return <div>Loading balances...</div>
  }

  return (
    <div className="bg-white overflow-hidden shadow rounded-lg">
      <div className="px-4 py-5 sm:p-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Your Balances</h2>
        <dl className="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-1">
          <div className="px-4 py-5 bg-white shadow rounded-lg overflow-hidden sm:p-6">
            <dt className="text-sm font-medium text-gray-500 truncate">Points Balance</dt>
            <dd className="mt-1 text-3xl font-semibold text-gray-900">
              {balances?.points_balance?.toLocaleString() || 0}
            </dd>
          </div>
        </dl>
      </div>
    </div>
  )
}

export default Dashboard