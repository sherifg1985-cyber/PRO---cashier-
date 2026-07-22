import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthRequest extends Request {
  userId?: number;
  username?: string;
  role?: string;
  branchId?: number;
}

export const authMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET!) as any;
    req.userId = decoded.userId;
    req.username = decoded.username;
    req.role = decoded.role;
    req.branchId = decoded.branchId;

    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};
