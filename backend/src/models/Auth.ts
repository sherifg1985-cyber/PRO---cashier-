export interface LoginRequest {
  username: string;
  password: string;
  branch_id?: number;
}

export interface FingerprintLoginRequest {
  fingerprint_data: string;
  device_id: string;
  branch_id?: number;
}

export interface AuthResponse {
  token: string;
  refresh_token: string;
  user: {
    id: number;
    username: string;
    email: string;
    first_name: string;
    last_name: string;
    role: string;
    branch_id: number;
    branch_name: string;
    is_fingerprint_enabled: boolean;
  };
}

export interface JWTPayload {
  userId: number;
  username: string;
  role: string;
  branchId: number;
  iat: number;
  exp: number;
}
