import express, { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { pool } from '../../database/connection';
import { authMiddleware } from '../../middleware/auth';
import { checkPermission } from '../../middleware/authorization';

const router = express.Router();

// Get all users (Admin only)
router.get('/', authMiddleware, checkPermission('manage_users'), async (req: Request, res: Response) => {
  try {
    const { branch_id, role, page = 1, limit = 20 } = req.query;
    const offset = ((Number(page) - 1) * Number(limit));

    let query = `SELECT id, username, email, first_name, last_name, role, branch_id, is_active, is_fingerprint_enabled, last_login, created_at 
                 FROM users_extended WHERE 1=1`;
    const params: any[] = [];

    if (branch_id) {
      query += ` AND branch_id = $${params.length + 1}`;
      params.push(branch_id);
    }
    if (role) {
      query += ` AND role = $${params.length + 1}`;
      params.push(role);
    }

    query += ` ORDER BY created_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const client = await pool.connect();
    try {
      const result = await client.query(query, params);
      const countResult = await client.query(`SELECT COUNT(*) FROM users_extended`);
      
      res.json({
        users: result.rows,
        total: parseInt(countResult.rows[0].count),
        page: Number(page),
        limit: Number(limit),
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new user (Admin only)
router.post('/', authMiddleware, checkPermission('manage_users'), async (req: Request, res: Response) => {
  try {
    const { username, email, password, first_name, last_name, role, branch_id } = req.body;
    const createdBy = (req as any).userId;

    // Validate input
    if (!username || !email || !password || !role || !branch_id) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const client = await pool.connect();
    try {
      const result = await client.query(
        `INSERT INTO users_extended (username, email, password_hash, first_name, last_name, role, branch_id, created_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8) 
         RETURNING id, username, email, first_name, last_name, role, branch_id, is_active`,
        [username, email, hashedPassword, first_name, last_name, role, branch_id, createdBy]
      );

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, status) 
         VALUES ($1, $2, $3, $4, $5)`,
        [createdBy, 'user', result.rows[0].id, 'create_user', 'success']
      );

      res.status(201).json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error: any) {
    console.error('Error creating user:', error);
    if (error.code === '23505') {
      return res.status(400).json({ error: 'Username or email already exists' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user (Admin only)
router.put('/:userId', authMiddleware, checkPermission('manage_users'), async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { first_name, last_name, email, role, is_active, is_fingerprint_enabled } = req.body;
    const updatedBy = (req as any).userId;

    const client = await pool.connect();
    try {
      let updateQuery = `UPDATE users_extended SET updated_at = NOW()`;
      const params: any[] = [];

      if (first_name) {
        updateQuery += `, first_name = $${params.length + 1}`;
        params.push(first_name);
      }
      if (last_name) {
        updateQuery += `, last_name = $${params.length + 1}`;
        params.push(last_name);
      }
      if (email) {
        updateQuery += `, email = $${params.length + 1}`;
        params.push(email);
      }
      if (role) {
        updateQuery += `, role = $${params.length + 1}`;
        params.push(role);
      }
      if (is_active !== undefined) {
        updateQuery += `, is_active = $${params.length + 1}`;
        params.push(is_active);
      }
      if (is_fingerprint_enabled !== undefined) {
        updateQuery += `, is_fingerprint_enabled = $${params.length + 1}`;
        params.push(is_fingerprint_enabled);
      }

      updateQuery += ` WHERE id = $${params.length + 1} RETURNING *`;
      params.push(userId);

      const result = await client.query(updateQuery, params);

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'User not found' });
      }

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, status) 
         VALUES ($1, $2, $3, $4, $5)`,
        [updatedBy, 'user', userId, 'update_user', 'success']
      );

      res.json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Disable/Enable user (Admin only)
router.patch('/:userId/toggle-active', authMiddleware, checkPermission('manage_users'), async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { is_active } = req.body;
    const updatedBy = (req as any).userId;

    const client = await pool.connect();
    try {
      const result = await client.query(
        `UPDATE users_extended SET is_active = $1, updated_at = NOW() WHERE id = $2 RETURNING *`,
        [is_active, userId]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'User not found' });
      }

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, description, status) 
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [updatedBy, 'user', userId, 'toggle_active', `User set to ${is_active ? 'active' : 'inactive'}`, 'success']
      );

      res.json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error toggling user active status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Lock/Unlock user account (Admin only)
router.patch('/:userId/lock-account', authMiddleware, checkPermission('manage_users'), async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { lock } = req.body;
    const updatedBy = (req as any).userId;

    const client = await pool.connect();
    try {
      const lockTime = lock ? new Date(Date.now() + 24 * 60 * 60 * 1000) : null; // Lock for 24 hours

      const result = await client.query(
        `UPDATE users_extended SET locked_until = $1, login_attempts = 0, updated_at = NOW() WHERE id = $2 RETURNING *`,
        [lockTime, userId]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'User not found' });
      }

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, description, status) 
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [updatedBy, 'user', userId, 'lock_account', `Account ${lock ? 'locked' : 'unlocked'}`, 'success']
      );

      res.json({ message: lock ? 'User account locked' : 'User account unlocked' });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error locking/unlocking account:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get user activity logs
router.get('/:userId/activity', authMiddleware, checkPermission('view_audit_logs'), async (req: Request, res: Response) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = ((Number(page) - 1) * Number(limit));

    const client = await pool.connect();
    try {
      const result = await client.query(
        `SELECT * FROM user_activity_logs WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
        [userId, limit, offset]
      );

      const countResult = await client.query(
        `SELECT COUNT(*) FROM user_activity_logs WHERE user_id = $1`,
        [userId]
      );

      res.json({
        logs: result.rows,
        total: parseInt(countResult.rows[0].count),
        page: Number(page),
        limit: Number(limit),
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching activity logs:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
