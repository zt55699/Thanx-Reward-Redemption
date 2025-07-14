# Thanx Rewards Redemption App MVP

A rewards redemption application focused on backend implementation, built with Ruby on Rails API and a basic React frontend for demonstration.

## Tech Stack

- **Backend**: Ruby 3.4.3, Rails 8.0.2 (API-only), SQLite
- **Frontend**: React 18, Vite, TailwindCSS  
- **Authentication**: JWT with bcrypt
- **Authorization**: Pundit policies
- **Data Fetching**: @tanstack/react-query
- **Testing**: RSpec with FactoryBot

## Features

### Authentication & Authorization
- JWT-based authentication
- User registration and login
- Admin and regular user roles
- Pundit policies for authorization

### User Features
- View account balance (points)
- Browse available rewards
- Redeem rewards with points (admin users cannot redeem)
- View redemption history
- Race-safe redemption with database locks

### Admin Features
- Admin dashboard with all users list
- View user points balances
- Click on any user to view their redemption history
- Full user management (CRUD operations via API)
- Admin users cannot redeem rewards (business rule)

## Quick Start

### Prerequisites
- Ruby 3.4.3
- Node.js 18+
- bundler gem

If you don't have the required dependencies, run:
```bash
./install_deps.sh
```

### One-Click Setup
```bash
./setup.sh
```

This script will:
1. Install Ruby gems
2. Create and migrate the database
3. Seed test data
4. Install npm packages
5. Create a start script

### Manual Setup

#### Backend Setup
```bash
cd backend
bundle install
rails db:create db:migrate db:seed
rails server -p 3000
```

#### Frontend Setup
```bash
cd frontend
npm install
npm run dev
```

## API Endpoints

### Public Endpoints
- `POST /auth/login` - User login
- `POST /users` - User registration
- `GET /rewards` - List all rewards

### Authenticated User Endpoints
- `GET /user` - Current user profile
- `PATCH /user` - Update user profile
- `GET /user/balances` - User balances
- `GET /redemptions` - User redemption history
- `POST /redemptions` - Redeem a reward

### Admin Endpoints
- `GET /admin/users` - List all users
- `POST /admin/users` - Create user
- `GET /admin/users/:id` - Show user
- `PATCH /admin/users/:id` - Update user
- `DELETE /admin/users/:id` - Delete user
- `GET /admin/users/:id/balances` - User balances
- `POST /admin/users/:id/balances` - Adjust user balances

## Test Credentials

### Regular User
- **Email**: tong@gmail.com
- **Password**: user123
- **Points Balance**: 10,000

### Admin User
- **Email**: admin@thanx.com
- **Password**: admin123
- **Points Balance**: 0

## Sample Data

### Rewards
1. **Starbucks Gift Card** - 500 points
2. **Walmart Gift Card** - 1,000 points
3. **iPhone 17 Pro** - 50,000 points

## Database Schema

### Users Table
- `id` (primary key)
- `email` (unique, not null)
- `name` (not null)
- `password_digest` (not null)
- `admin` (boolean, default: false)
- `points_balance` (integer, default: 0, non-negative)
- `created_at`, `updated_at`

### Rewards Table
- `id` (primary key)
- `name` (not null)
- `description` (not null)
- `cost` (integer, not null)
- `created_at`, `updated_at`

### Redemptions Table
- `id` (primary key)
- `user_id` (foreign key to users)
- `reward_id` (foreign key to rewards)
- `created_at`, `updated_at`

## Security Features

- Password hashing with bcrypt
- JWT tokens with expiration
- Admin flag verified from database (not JWT)
- CORS configured for localhost:5173
- Race-safe redemption using database locks

## Development

### Running Tests

Backend tests (92 examples, all passing):
```bash
cd backend
bundle exec rspec
```

Frontend tests:
```bash
cd frontend
npm test
```

### Test Coverage
- **Models**: User, Reward, Redemption validations and associations
- **Policies**: Authentication and authorization with Pundit
- **Services**: Race-safe redemption logic with database locks
- **Controllers**: API endpoints with proper error handling
- **Request Specs**: End-to-end API testing with JWT auth

### API Testing
Use tools like Postman or curl to test the API endpoints. All authenticated endpoints require the `Authorization: Bearer <token>` header.

#### Getting a JWT Token
To obtain a JWT token for API testing:

```bash
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "tong@gmail.com", "password": "user123"}'
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {...}
}
```

Use the token in subsequent API calls:
```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..." \
  http://localhost:3000/redemptions
```

### Frontend Development
The React app uses React Query for state management and API calls. All API interactions are handled through custom hooks in the `hooks` directory.

## Project Structure

```
├── backend/                 # Rails API
│   ├── app/
│   │   ├── controllers/     # API controllers
│   │   ├── models/          # ActiveRecord models
│   │   ├── policies/        # Pundit authorization policies
│   │   ├── serializers/     # JSON API serializers
│   │   └── services/        # Business logic services
│   ├── config/              # Rails configuration
│   ├── db/                  # Database migrations and seeds
│   └── Gemfile
├── frontend/                # React app
│   ├── src/
│   │   ├── components/      # Reusable React components
│   │   ├── hooks/           # Custom React hooks for API calls
│   │   ├── pages/           # Page components
│   │   └── utils/           # Utility functions (API client)
│   ├── package.json
│   └── vite.config.js
├── demo_screenshots/        # Application screenshots
├── setup.sh                # One-click setup script
├── start.sh                # Start both servers
└── README.md
```

## Demo Screenshots

Application screenshots are available in the `demo_screenshots/` folder showing:
- Login interface
- User balance view
- Rewards catalog
- Redemption history
- Admin panel

## Author

**Tong Zhang**  
Email: zt55699@gmail.com