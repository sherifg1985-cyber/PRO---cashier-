export interface Branch {
  id: number;
  name: string;
  name_ar: string;
  code: string;
  address: string;
  city: string;
  phone: string;
  email: string;
  manager_id: number;
  is_active: boolean;
  created_at: Date;
  updated_at: Date;
}

export interface BranchConfig {
  id: number;
  branch_id: number;
  currency: string;
  tax_rate: number;
  discount_allowed: boolean;
  max_discount_percentage: number;
  receipt_header: string;
  receipt_footer: string;
  created_at: Date;
  updated_at: Date;
}
