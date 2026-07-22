import express, { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { pool } from '../database/connection';
import { authMiddleware } from '../middleware/auth';
import { validateLogin, validateFingerprintLogin } from '../validation/authValidation';

const router = express.Router();

// Standard Password Login
router.post('/login', async (req: Request, res: Response) => {
  try {
    const { error, value } = validateLogin.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const { username, password, branch_id } = value;
    const client = await pool.connect();

    try {
      // Get user
      const userResult = await client.query(
        `SELECT id, password_hash, first_name, last_name, role, branch_id, is_active, is_fingerprint_enabled, login_attempts, locked_until 
         FROM users_extended 
         WHERE username = $1`,
        [username]
      );

      if (userResult.rows.length === 0) {
        // Log failed attempt
        await client.query(
          `INSERT INTO login_attempts (username, branch_id, attempt_type, ip_address, device_id, user_agent, success, reason) 
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
          [username, branch_id, 'password', req.ip, req.headers['user-agent'], req.headers['user-agent'], false, 'User not found']
        );
        return res.status(401).json({ error: 'Invalid credentials' });
      }

      const user = userResult.rows[0];

      // Check if account is locked
      if (user.locked_until && new Date(user.locked_until) > new Date()) {
        return res.status(403).json({ error: 'Account is locked. Try again later.' });
      }

      // Check if user is active
      if (!user.is_active) {
        return res.status(403).json({ error: 'Account is inactive' });
      }

      // Verify password
      const passwordMatch = await bcrypt.compare(password, user.password_hash);

      if (!passwordMatch) {
        // Increment login attempts
        const newAttempts = user.login_attempts + 1;
        const isLocked = newAttempts >= user.max_login_attempts || user.max_login_attempts;
        let lockedUntil = null;

        if (isLocked) {
          const lockTime = new Date();
          lockTime.setMinutes(lockTime.getMinutes() + 30); // Lock for 30 minutes
          lockedUntil = lockTime;
        }

        await client.query(
          `UPDATE users_extended SET login_attempts = $1, locked_until = $2 WHERE id = $3`,
          [newAttempts, lockedUntil, user.id]
        );

        // Log failed attempt
        await client.query(
          `INSERT INTO login_attempts (user_id, branch_id, attempt_type, ip_address, device_id, user_agent, success, reason) 
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
          [user.id, branch_id, 'password', req.ip, req.headers['user-agent'], req.headers['user-agent'], false, 'Invalid password']
        );

        return res.status(401).json({ error: 'Invalid credentials' });
      }

      // Reset login attempts
      await client.query(
        `UPDATE users_extended SET login_attempts = 0, locked_until = NULL, last_login = NOW(), last_login_ip = $1 WHERE id = $2`,
        [req.ip, user.id]
      );

      // Get branch info
      const branchResult = await client.query(
        `SELECT name FROM branches WHERE id = $1`,
        [user.branch_id]
      );

      // Generate tokens
      const token = jwt.sign(
        { userId: user.id, username: user.username, role: user.role, branchId: user.branch_id },
        process.env.JWT_SECRET!,
        { expiresIn: process.env.JWT_EXPIRATION || '24h' }
      );

      const refreshToken = jwt.sign(
        { userId: user.id },
        process.env.JWT_SECRET! + '_refresh',
        { expiresIn: '7d' }
      );

      // Create session
      await client.query(
        `INSERT INTO user_sessions (user_id, branch_id, token_hash, ip_address, login_type, last_activity, expires_at) 
         VALUES ($1, $2, $3, $4, $5, NOW(), NOW() + INTERVAL '24 hours')`,
        [user.id, user.branch_id, token, req.ip, 'password']
      );

      // Log successful login
      await client.query(
        `INSERT INTO user_activity_logs (user_id, branch_id, action, status, ip_address, device_info) 
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [user.id, user.branch_id, 'login', 'success', req.ip, req.headers['user-agent']]
      );

      res.json({
        token,
        refresh_token: refreshToken,
        user: {
          id: user.id,
          username: user.username,
          first_name: user.first_name,
          last_name: user.last_name,
          role: user.role,
          branch_id: user.branch_id,
          branch_name: branchResult.rows[0]?.name,
          is_fingerprint_enabled: user.is_fingerprint_enabled,
        },
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Fingerprint Login
router.post('/fingerprint-login', async (req: Request, res: Response) => {
  try {
    const { error, value } = validateFingerprintLogin.validate(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    const { fingerprint_data, device_id, branch_id } = value;
    const client = await pool.connect();

    try {
      // Find user by fingerprint
      const userResult = await client.query(
        `SELECT u.id, u.username, u.first_name, u.last_name, u.role, u.branch_id, u.is_active, u.fingerprint_template, u.locked_until 
         FROM users_extended u 
         WHERE u.is_fingerprint_enabled = true AND u.is_active = true`,
      );

      // Simple fingerprint matching (in production, use proper biometric library)
      let matchedUser = null;
      for (const user of userResult.rows) {
        // This is a placeholder - implement proper fingerprint matching
        if (user.fingerprint_template) {
          matchedUser = user;
          break;
        }
      }

      if (!matchedUser) {
        await client.query(
          `INSERT INTO login_attempts (branch_id, attempt_type, ip_address, device_id, user_agent, success, reason) 
           VALUES ($1, $2, $3, $4, $5, $6, $7)`,
          [branch_id, 'fingerprint', req.ip, device_id, req.headers['user-agent'], false, 'No matching fingerprint']
        );
        return res.status(401).json({ error: 'Fingerprint not recognized' });
      }

      // Reset login attempts
      await client.query(
        `UPDATE users_extended SET login_attempts = 0, locked_until = NULL, last_login = NOW() WHERE id = $1`,
        [matchedUser.id]
      );

      // Get branch info
      const branchResult = await client.query(
        `SELECT name FROM branches WHERE id = $1`,
        [matchedUser.branch_id]
      );

      // Generate tokens
      const token = jwt.sign(
        { userId: matchedUser.id, username: matchedUser.username, role: matchedUser.role, branchId: matchedUser.branch_id },
        process.env.JWT_SECRET!,
        { expiresIn: process.env.JWT_EXPIRATION || '24h' }
      );

      const refreshToken = jwt.sign(
        { userId: matchedUser.id },
        process.env.JWT_SECRET! + '_refresh',
        { expiresIn: '7d' }
      );

      // Create session
      await client.query(
        `INSERT INTO user_sessions (user_id, branch_id, token_hash, ip_address, device_id, login_type, last_activity, expires_at) 
         VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW() + INTERVAL '24 hours')`,
        [matchedUser.id, matchedUser.branch_id, token, req.ip, device_id, 'fingerprint']
      );

      // Log successful fingerprint login
      await client.query(
        `INSERT INTO user_activity_logs (user_id, branch_id, action, status, ip_address, device_info) 
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [matchedUser.id, matchedUser.branch_id, 'fingerprint_login', 'success', req.ip, device_id]
      );

      res.json({
        token,
        refresh_token: refreshToken,
        user: {
          id: matchedUser.id,
          username: matchedUser.username,
          first_name: matchedUser.first_name,
          last_name: matchedUser.last_name,
          role: matchedUser.role,
          branch_id: matchedUser.branch_id,
          branch_name: branchResult.rows[0]?.name,
          is_fingerprint_enabled: true,
        },
      });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Fingerprint login error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Logout
router.post('/logout', authMiddleware, async (req: Request, res: Response) => {
  try {
    const userId = (req as any).userId;
    const client = await pool.connect();

    try {
      await client.query(
        `UPDATE user_sessions SET is_active = false WHERE user_id = $1 AND is_active = true`,
        [userId]
      );

      await client.query(
        `INSERT INTO user_activity_logs (user_id, action, status) VALUES ($1, $2, $3)`,
        [userId, 'logout', 'success']
      );

      res.json({ message: 'Logged out successfully' });
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Refresh Token
router.post('/refresh-token', async (req: Request, res: Response) => {
  try {
    const { refresh_token } = req.body;
    if (!refresh_token) {
      return res.status(401).json({ error: 'Refresh token required' });
    }

    const decoded = jwt.verify(refresh_token, process.env.JWT_SECRET! + '_refresh') as any;
    const token = jwt.sign(
      { userId: decoded.userId },
      process.env.JWT_SECRET!,
      { expiresIn: process.env.JWT_EXPIRATION || '24h' }
    );

    res.json({ token });
  } catch (error) {
    res.status(401).json({ error: 'Invalid refresh token' });
  }
});

export default router;
