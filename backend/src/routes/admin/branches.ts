import express, { Request, Response } from 'express';
import { pool } from '../../database/connection';
import { authMiddleware } from '../../middleware/auth';
import { checkPermission } from '../../middleware/authorization';

const router = express.Router();

// Get all branches (Admin only)
router.get('/', authMiddleware, checkPermission('manage_branches'), async (req: Request, res: Response) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = ((Number(page) - 1) * Number(limit));

    const client = await pool.connect();
    try {
      const result = await client.query(
        `SELECT b.*, u.username as manager_name FROM branches b 
         LEFT JOIN users_extended u ON b.manager_id = u.id 
         ORDER BY b.created_at DESC LIMIT $1 OFFSET $2`,
        [limit, offset]
      );

      const countResult = await client.query(`SELECT COUNT(*) FROM branches`);

      res.json({
        branches: result.rows,
        total: parseInt(countResult.rows[0].count),
        page: Number(page),
        limit: Number(limit),
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching branches:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Create new branch (Admin only)
router.post('/', authMiddleware, checkPermission('manage_branches'), async (req: Request, res: Response) => {
  try {
    const { name, name_ar, code, address, city, phone, email, manager_id } = req.body;
    const createdBy = (req as any).userId;

    if (!name || !name_ar || !code) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const client = await pool.connect();
    try {
      // Create branch
      const branchResult = await client.query(
        `INSERT INTO branches (name, name_ar, code, address, city, phone, email, manager_id) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8) 
         RETURNING *`,
        [name, name_ar, code, address, city, phone, email, manager_id]
      );

      const branchId = branchResult.rows[0].id;

      // Create default branch configuration
      await client.query(
        `INSERT INTO branch_configurations (branch_id, currency, tax_rate) 
         VALUES ($1, $2, $3)`,
        [branchId, 'SAR', 0]
      );

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, status) 
         VALUES ($1, $2, $3, $4, $5)`,
        [createdBy, 'branch', branchId, 'create_branch', 'success']
      );

      res.status(201).json(branchResult.rows[0]);
    } finally {
      client.release();
    }
  } catch (error: any) {
    console.error('Error creating branch:', error);
    if (error.code === '23505') {
      return res.status(400).json({ error: 'Branch code already exists' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update branch (Admin only)
router.put('/:branchId', authMiddleware, checkPermission('manage_branches'), async (req: Request, res: Response) => {
  try {
    const { branchId } = req.params;
    const { name, name_ar, address, city, phone, email, manager_id, is_active } = req.body;
    const updatedBy = (req as any).userId;

    const client = await pool.connect();
    try {
      let updateQuery = `UPDATE branches SET updated_at = NOW()`;
      const params: any[] = [];

      if (name) {
        updateQuery += `, name = $${params.length + 1}`;
        params.push(name);
      }
      if (name_ar) {
        updateQuery += `, name_ar = $${params.length + 1}`;
        params.push(name_ar);
      }
      if (address) {
        updateQuery += `, address = $${params.length + 1}`;
        params.push(address);
      }
      if (city) {
        updateQuery += `, city = $${params.length + 1}`;
        params.push(city);
      }
      if (phone) {
        updateQuery += `, phone = $${params.length + 1}`;
        params.push(phone);
      }
      if (email) {
        updateQuery += `, email = $${params.length + 1}`;
        params.push(email);
      }
      if (manager_id) {
        updateQuery += `, manager_id = $${params.length + 1}`;
        params.push(manager_id);
      }
      if (is_active !== undefined) {
        updateQuery += `, is_active = $${params.length + 1}`;
        params.push(is_active);
      }

      updateQuery += ` WHERE id = $${params.length + 1} RETURNING *`;
      params.push(branchId);

      const result = await client.query(updateQuery, params);

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Branch not found' });
      }

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, status) 
         VALUES ($1, $2, $3, $4, $5)`,
        [updatedBy, 'branch', branchId, 'update_branch', 'success']
      );

      res.json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error updating branch:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get branch configuration
router.get('/:branchId/config', authMiddleware, async (req: Request, res: Response) => {
  try {
    const { branchId } = req.params;

    const client = await pool.connect();
    try {
      const result = await client.query(
        `SELECT * FROM branch_configurations WHERE branch_id = $1`,
        [branchId]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Branch configuration not found' });
      }

      res.json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error fetching branch config:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update branch configuration
router.put('/:branchId/config', authMiddleware, checkPermission('manage_branches'), async (req: Request, res: Response) => {
  try {
    const { branchId } = req.params;
    const { currency, tax_rate, discount_allowed, max_discount_percentage, receipt_header, receipt_footer } = req.body;
    const updatedBy = (req as any).userId;

    const client = await pool.connect();
    try {
      const result = await client.query(
        `UPDATE branch_configurations 
         SET currency = COALESCE($1, currency), 
             tax_rate = COALESCE($2, tax_rate), 
             discount_allowed = COALESCE($3, discount_allowed), 
             max_discount_percentage = COALESCE($4, max_discount_percentage), 
             receipt_header = COALESCE($5, receipt_header), 
             receipt_footer = COALESCE($6, receipt_footer),
             updated_at = NOW() 
         WHERE branch_id = $7 
         RETURNING *`,
        [currency, tax_rate, discount_allowed, max_discount_percentage, receipt_header, receipt_footer, branchId]
      );

      if (result.rows.length === 0) {
        return res.status(404).json({ error: 'Branch configuration not found' });
      }

      // Log activity
      await client.query(
        `INSERT INTO user_activity_logs (user_id, resource_type, resource_id, action, status) 
         VALUES ($1, $2, $3, $4, $5)`,
        [updatedBy, 'branch_config', branchId, 'update_config', 'success']
      );

      res.json(result.rows[0]);
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error updating branch config:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
