#!/usr/bin/env bash

# Metrics Dashboard Installation Script
set -e

echo "🚀 Claude Code Metrics Dashboard - Installation Script"
echo "========================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check prerequisites
echo "Checking prerequisites..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi
print_success "Node.js $(node --version) found"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi
print_success "npm $(npm --version) found"

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    print_warning "PostgreSQL client not found. Make sure PostgreSQL 14+ is installed and accessible."
else
    print_success "PostgreSQL found"
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    print_warning "Git is not installed. Git hooks won't be available."
else
    print_success "Git $(git --version | awk '{print $3}') found"
fi

echo ""
echo "Step 1: Database Setup"
echo "----------------------"

# Prompt for database configuration
read -p "Database host (default: localhost): " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Database port (default: 5432): " DB_PORT
DB_PORT=${DB_PORT:-5432}

read -p "Database name (default: metrics_dashboard): " DB_NAME
DB_NAME=${DB_NAME:-metrics_dashboard}

read -p "Database user (default: postgres): " DB_USER
DB_USER=${DB_USER:-postgres}

read -s -p "Database password: " DB_PASSWORD
echo ""

# Test database connection
export PGPASSWORD="$DB_PASSWORD"
if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -c "SELECT 1" &> /dev/null; then
    print_success "Database connection successful"
else
    print_error "Failed to connect to database. Please check your credentials."
    exit 1
fi

# Create database if it doesn't exist
if psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME"; then
    print_info "Database '$DB_NAME' already exists"
else
    print_info "Creating database '$DB_NAME'..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -c "CREATE DATABASE $DB_NAME"
    print_success "Database created"
fi

# Run schema migration
print_info "Applying database schema..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f database/schema.sql
print_success "Database schema applied"

echo ""
echo "Step 2: Backend Setup"
echo "---------------------"

cd backend

# Create .env file
cat > .env <<EOF
# Server Configuration
NODE_ENV=production
PORT=3001
LOG_LEVEL=info

# Database Configuration
DB_HOST=$DB_HOST
DB_PORT=$DB_PORT
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
DB_POOL_MAX=20

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# JWT Configuration (generate a random secret)
JWT_SECRET=$(openssl rand -base64 32)
JWT_EXPIRES_IN=7d

# Slack Integration (optional)
# SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
# SLACK_CHANNEL=#claude-code-alerts

# Email Configuration (optional)
# SMTP_HOST=smtp.gmail.com
# SMTP_PORT=587
# SMTP_USER=your_email@company.com
# SMTP_PASSWORD=your_password_here
# EMAIL_FROM=metrics-dashboard@company.com
EOF

print_success ".env file created"

# Install backend dependencies
print_info "Installing backend dependencies..."
npm install --silent
print_success "Backend dependencies installed"

# Build backend
print_info "Building backend..."
npm run build
print_success "Backend built successfully"

cd ..

echo ""
echo "Step 3: Frontend Setup"
echo "----------------------"

cd frontend

# Create .env file
cat > .env <<EOF
VITE_API_BASE_URL=http://localhost:3001/api
EOF

print_success ".env file created"

# Install frontend dependencies
print_info "Installing frontend dependencies..."
npm install --silent
print_success "Frontend dependencies installed"

# Build frontend
print_info "Building frontend..."
npm run build
print_success "Frontend built successfully"

cd ..

echo ""
echo "Step 4: Data Collection Setup"
echo "------------------------------"

# Make Git hooks executable
chmod +x data-collection/git-hooks/*
print_success "Git hooks made executable"

# Make Claude Code logger executable
chmod +x data-collection/claude-code-logger.ts
print_success "Claude Code logger made executable"

# Create logs directory
mkdir -p ~/.claude/logs
print_success "Logs directory created"

echo ""
echo "Step 5: Create Systemd Services (Optional)"
echo "-------------------------------------------"

read -p "Do you want to create systemd services for auto-start? (y/N) " CREATE_SERVICES

if [[ $CREATE_SERVICES =~ ^[Yy]$ ]]; then
    DASHBOARD_DIR=$(pwd)

    # Backend service
    sudo tee /etc/systemd/system/metrics-dashboard-backend.service > /dev/null <<EOF
[Unit]
Description=Metrics Dashboard Backend
After=network.target postgresql.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$DASHBOARD_DIR/backend
ExecStart=$(which node) dist/index.js
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=metrics-dashboard-backend

[Install]
WantedBy=multi-user.target
EOF

    # Frontend service (using Vite preview)
    sudo tee /etc/systemd/system/metrics-dashboard-frontend.service > /dev/null <<EOF
[Unit]
Description=Metrics Dashboard Frontend
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$DASHBOARD_DIR/frontend
ExecStart=$(which npm) run preview
Restart=on-failure
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=metrics-dashboard-frontend

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd
    sudo systemctl daemon-reload
    print_success "Systemd services created"

    # Enable services
    sudo systemctl enable metrics-dashboard-backend
    sudo systemctl enable metrics-dashboard-frontend
    print_success "Services enabled for auto-start"
fi

echo ""
echo "Installation Complete! 🎉"
echo "========================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Start the backend:"
echo "   cd backend && npm start"
echo ""
echo "2. Start the frontend (in another terminal):"
echo "   cd frontend && npm run dev"
echo ""
echo "3. Access the dashboard:"
echo "   http://localhost:3000"
echo ""
echo "4. (Optional) Install Git hooks in your projects:"
echo "   cp data-collection/git-hooks/* /path/to/your/project/.git/hooks/"
echo ""
echo "5. (Optional) Configure Slack/Email notifications:"
echo "   Edit backend/.env and add SLACK_WEBHOOK_URL and SMTP settings"
echo ""
echo "For documentation, see: README.md"
echo ""
