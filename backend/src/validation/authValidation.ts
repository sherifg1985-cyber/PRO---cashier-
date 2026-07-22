import Joi from 'joi';

export const validateLogin = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().required(),
  branch_id: Joi.number().optional(),
});

export const validateFingerprintLogin = Joi.object({
  fingerprint_data: Joi.string().required(),
  device_id: Joi.string().required(),
  branch_id: Joi.number().optional(),
});
