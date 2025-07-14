import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import { useCurrentUser } from './hooks/useAuth'
import Layout from './components/Layout'
import Login from './pages/Login'
import Dashboard from './pages/Dashboard'
import AdminDashboard from './pages/AdminDashboard'
import Rewards from './pages/Rewards'
import History from './pages/History'

function App() {
  const { data: user, isLoading } = useCurrentUser()

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">Loading...</div>
      </div>
    )
  }

  return (
    <Router>
      <Routes>
        <Route path="/login" element={!user ? <Login /> : <Navigate to="/" />} />
        <Route path="/" element={user ? <Layout /> : <Navigate to="/login" />}>
          <Route index element={user?.admin ? <AdminDashboard /> : <Dashboard />} />
          <Route path="rewards" element={<Rewards />} />
          <Route path="history" element={<History />} />
        </Route>
      </Routes>
    </Router>
  )
}

export default App