-- BRANCHES TABLE
CREATE TABLE IF NOT EXISTS branches (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    name_ar VARCHAR(255) NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    manager_id INT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BRANCH CONFIGURATION
CREATE TABLE IF NOT EXISTS branch_configurations (
    id SERIAL PRIMARY KEY,
    branch_id INT NOT NULL UNIQUE REFERENCES branches(id) ON DELETE CASCADE,
    currency VARCHAR(10) DEFAULT 'SAR',
    tax_rate DECIMAL(5, 2) DEFAULT 0,
    discount_allowed BOOLEAN DEFAULT true,
    max_discount_percentage DECIMAL(5, 2) DEFAULT 10,
    receipt_header TEXT,
    receipt_footer TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EXTENDED USERS TABLE
CREATE TABLE IF NOT EXISTS users_extended (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    avatar_url TEXT,
    role VARCHAR(50) DEFAULT 'cashier', -- admin, manager, cashier, supervisor
    branch_id INT NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    is_active BOOLEAN DEFAULT true,
    is_fingerprint_enabled BOOLEAN DEFAULT false,
    fingerprint_hash VARCHAR(255),
    fingerprint_template TEXT, -- Binary fingerprint template
    max_login_attempts INT DEFAULT 5,
    login_attempts INT DEFAULT 0,
    locked_until TIMESTAMP,
    password_last_changed TIMESTAMP,
    last_login TIMESTAMP,
    last_login_ip VARCHAR(45),
    last_login_device VARCHAR(255),
    created_by INT REFERENCES users_extended(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ROLES TABLE
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    name_ar VARCHAR(100),
    description TEXT,
    is_system BOOLEAN DEFAULT false, -- System roles cannot be deleted
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PERMISSIONS TABLE
CREATE TABLE IF NOT EXISTS permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    module VARCHAR(50), -- sales, inventory, reports, admin, etc
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ROLE PERMISSIONS JUNCTION TABLE
CREATE TABLE IF NOT EXISTS role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(role_id, permission_id)
);

-- USER PERMISSIONS (FOR CUSTOM OVERRIDES)
CREATE TABLE IF NOT EXISTS user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE CASCADE,
    permission_id INT NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    is_granted BOOLEAN DEFAULT true, -- true=grant, false=deny
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, permission_id)
);

-- USER ACTIVITY LOG
CREATE TABLE IF NOT EXISTS user_activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE SET NULL,
    branch_id INT NOT NULL REFERENCES branches(id) ON DELETE SET NULL,
    action VARCHAR(100), -- login, logout, create, edit, delete, etc
    resource_type VARCHAR(50), -- user, product, sale, etc
    resource_id INT,
    description TEXT,
    ip_address VARCHAR(45),
    device_info VARCHAR(255),
    user_agent TEXT,
    status VARCHAR(20) DEFAULT 'success', -- success, failed, warning
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- LOGIN ATTEMPTS LOG (FOR SECURITY)
CREATE TABLE IF NOT EXISTS login_attempts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users_extended(id) ON DELETE SET NULL,
    username VARCHAR(100),
    branch_id INT REFERENCES branches(id) ON DELETE SET NULL,
    attempt_type VARCHAR(20), -- password, fingerprint
    ip_address VARCHAR(45),
    device_id VARCHAR(255),
    user_agent TEXT,
    success BOOLEAN DEFAULT false,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- FINGERPRINT DEVICES
CREATE TABLE IF NOT EXISTS fingerprint_devices (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE CASCADE,
    device_id VARCHAR(255) NOT NULL,
    device_name VARCHAR(255),
    device_type VARCHAR(50), -- android, ios, windows
    fingerprint_enrolled_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    last_used TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- USER SESSIONS
CREATE TABLE IF NOT EXISTS user_sessions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE CASCADE,
    branch_id INT NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    token_hash VARCHAR(255),
    ip_address VARCHAR(45),
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    login_type VARCHAR(20), -- password, fingerprint
    last_activity TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ADMIN CONTROLS / USER RESTRICTIONS
CREATE TABLE IF NOT EXISTS user_restrictions (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE CASCADE,
    restriction_type VARCHAR(50), -- time_based, ip_based, device_based, action_based
    restriction_value TEXT, -- JSON for storing restriction details
    is_active BOOLEAN DEFAULT true,
    notes TEXT,
    created_by INT REFERENCES users_extended(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- BRANCH MANAGERS ASSIGNMENT
CREATE TABLE IF NOT EXISTS branch_managers (
    id SERIAL PRIMARY KEY,
    branch_id INT NOT NULL REFERENCES branches(id) ON DELETE CASCADE,
    user_id INT NOT NULL REFERENCES users_extended(id) ON DELETE CASCADE,
    assigned_by INT REFERENCES users_extended(id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(branch_id, user_id)
);

-- INDEXES FOR PERFORMANCE
CREATE INDEX idx_users_branch ON users_extended(branch_id);
CREATE INDEX idx_users_role ON users_extended(role);
CREATE INDEX idx_users_active ON users_extended(is_active);
CREATE INDEX idx_users_username ON users_extended(username);
CREATE INDEX idx_branches_active ON branches(is_active);
CREATE INDEX idx_activity_user ON user_activity_logs(user_id);
CREATE INDEX idx_activity_branch ON user_activity_logs(branch_id);
CREATE INDEX idx_activity_date ON user_activity_logs(created_at);
CREATE INDEX idx_login_attempts_user ON login_attempts(user_id);
CREATE INDEX idx_login_attempts_date ON login_attempts(created_at);
CREATE INDEX idx_sessions_user ON user_sessions(user_id);
CREATE INDEX idx_sessions_branch ON user_sessions(branch_id);
CREATE INDEX idx_fingerprint_user ON fingerprint_devices(user_id);
CREATE INDEX idx_restrictions_user ON user_restrictions(user_id);

-- INSERT DEFAULT SYSTEM ROLES
INSERT INTO roles (name, name_ar, description, is_system) VALUES
('admin', 'مسؤول', 'System Administrator with full access', true),
('manager', 'مدير', 'Branch Manager with management capabilities', true),
('supervisor', 'مشرف', 'Supervisor with monitoring capabilities', true),
('cashier', 'صراف', 'Cashier with basic sales capabilities', true)
ON CONFLICT (name) DO NOTHING;

-- INSERT DEFAULT PERMISSIONS
INSERT INTO permissions (name, description, module) VALUES
('view_sales', 'View sales transactions', 'sales'),
('create_sale', 'Create new sale', 'sales'),
('edit_sale', 'Edit sale transaction', 'sales'),
('delete_sale', 'Delete sale transaction', 'sales'),
('view_inventory', 'View inventory', 'inventory'),
('edit_inventory', 'Edit inventory', 'inventory'),
('view_reports', 'View reports', 'reports'),
('export_reports', 'Export reports', 'reports'),
('manage_users', 'Manage users', 'admin'),
('manage_branches', 'Manage branches', 'admin'),
('manage_roles', 'Manage roles and permissions', 'admin'),
('view_audit_logs', 'View audit logs', 'admin'),
('system_settings', 'System settings', 'admin')
ON CONFLICT (name) DO NOTHING;
