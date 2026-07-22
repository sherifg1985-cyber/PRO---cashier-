export interface User {
  id: number;
  username: string;
  email: string;
  password_hash: string;
  first_name: string;
  last_name: string;
  role: 'admin' | 'manager' | 'cashier' | 'supervisor';
  branch_id: number;
  is_active: boolean;
  is_fingerprint_enabled: boolean;
  fingerprint_data?: string;
  last_login: Date;
  created_at: Date;
  updated_at: Date;
}

export interface UserPermission {
  id: number;
  role: string;
  permission: string;
  created_at: Date;
}

export interface UserActivity {
  id: number;
  user_id: number;
  action: string;
  description: string;
  ip_address: string;
  device_info: string;
  status: 'success' | 'failed';
  created_at: Date;
}
