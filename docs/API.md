# API Documentation

## Authentication Endpoints

### POST /api/auth/login
User login

**Request:**
```json
{
  "username": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "username": "user@example.com",
    "role": "cashier"
  }
}
```

### POST /api/auth/logout
User logout

## Products Endpoints

### GET /api/products
List all products

### POST /api/products
Create new product

### GET /api/products/:id
Get product details

### PUT /api/products/:id
Update product

### DELETE /api/products/:id
Delete product

## Sales Endpoints

### POST /api/sales
Create new sale

**Request:**
```json
{
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "price": 100.00
    }
  ],
  "payment_method": "cash",
  "total": 200.00
}
```

### GET /api/sales
List all sales

### GET /api/sales/:id
Get sale details

## Inventory Endpoints

### GET /api/inventory
Get inventory status

### POST /api/inventory/update
Update inventory

## Reports Endpoints

### GET /api/reports/daily
Daily sales report

### GET /api/reports/monthly
Monthly sales report

### GET /api/reports/inventory
Inventory report
