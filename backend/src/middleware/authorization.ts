import { Response, NextFunction } from 'express';
import { pool } from '../database/connection';
import { AuthRequest } from './auth';

export const checkPermission = (permissionName: string) => {
  return async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const userId = req.userId;
      if (!userId) {
        return res.status(401).json({ error: 'Unauthorized' });
      }

      const client = await pool.connect();
      try {
        // Get user role
        const userResult = await client.query(
          `SELECT role FROM users_extended WHERE id = $1`,
          [userId]
        );

        if (userResult.rows.length === 0) {
          return res.status(401).json({ error: 'User not found' });
        }

        const userRole = userResult.rows[0].role;

        // Check role permissions
        const permissionResult = await client.query(
          `SELECT rp.id FROM role_permissions rp
           JOIN roles r ON rp.role_id = r.id
           JOIN permissions p ON rp.permission_id = p.id
           WHERE r.name = $1 AND p.name = $2`,
          [userRole, permissionName]
        );

        if (permissionResult.rows.length === 0) {
          return res.status(403).json({ error: 'Insufficient permissions' });
        }

        next();
      } finally {
        client.release();
      }
    } catch (error) {
      console.error('Authorization error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
};

export const checkRole = (allowedRoles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.role || !allowedRoles.includes(req.role)) {
      return res.status(403).json({ error: 'Access denied' });
    }
    next();
  };
};
