import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import api from '../utils/api';

function AdminDashboard() {
  const [selectedUserId, setSelectedUserId] = useState(null);

  const { data: usersData, isLoading: usersLoading } = useQuery({
    queryKey: ['adminUsers'],
    queryFn: () => api.get('/admin/users').then(res => res.data)
  });

  const { data: userRedemptions, isLoading: redemptionsLoading } = useQuery({
    queryKey: ['adminUserRedemptions', selectedUserId],
    queryFn: () => api.get(`/redemptions?user_id=${selectedUserId}`).then(res => res.data),
    enabled: !!selectedUserId
  });

  if (usersLoading) return <div>Loading users...</div>;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <h1 className="text-3xl font-bold mb-8">Admin Dashboard</h1>
      
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div>
          <h2 className="text-xl font-semibold mb-4">Users</h2>
          <div className="bg-white shadow overflow-hidden sm:rounded-md">
            <ul className="divide-y divide-gray-200">
              {usersData?.users?.map((user) => (
                <li key={user.id}>
                  <button
                    onClick={() => setSelectedUserId(user.id)}
                    className="block hover:bg-gray-50 px-4 py-4 w-full text-left"
                  >
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="text-sm font-medium text-gray-900">{user.name}</p>
                        <p className="text-sm text-gray-500">{user.email}</p>
                      </div>
                      <div className="text-right">
                        <p className="text-sm font-medium text-gray-900">
                          {user.points_balance.toLocaleString()} points
                        </p>
                        {user.admin && (
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            Admin
                          </span>
                        )}
                      </div>
                    </div>
                  </button>
                </li>
              ))}
            </ul>
          </div>
        </div>

        <div>
          <h2 className="text-xl font-semibold mb-4">
            {selectedUserId ? 'User Redemption History' : 'Select a user to view history'}
          </h2>
          {selectedUserId && (
            <div className="bg-white shadow overflow-hidden sm:rounded-md">
              {redemptionsLoading ? (
                <div className="p-4">Loading redemptions...</div>
              ) : (
                <ul className="divide-y divide-gray-200">
                  {userRedemptions?.data?.length === 0 ? (
                    <li className="px-4 py-4 text-gray-500">No redemptions yet</li>
                  ) : (
                    userRedemptions?.data?.map((redemption) => (
                      <li key={redemption.id} className="px-4 py-4">
                        <div className="flex justify-between">
                          <div>
                            <p className="text-sm font-medium text-gray-900">
                              {redemption.attributes.reward_name}
                            </p>
                            <p className="text-sm text-gray-500">
                              {new Date(redemption.attributes.created_at).toLocaleDateString()}
                            </p>
                          </div>
                          <p className="text-sm text-gray-900">
                            {redemption.attributes.points_cost?.toLocaleString()} points
                          </p>
                        </div>
                      </li>
                    ))
                  )}
                </ul>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default AdminDashboard;