# Xboard 管理员后台 API 文档

## 基础信息

**Base URL**: `/api/v2/admin/{secure_path}/`
**认证方式**: Bearer Token (管理员权限)
**Content-Type**: `application/json`

## 🔐 管理员认证

### 管理员登录
**POST** `/api/v1/passport/auth/login`

**说明**: 管理员通过邮箱和密码登录获取Bearer Token。登录成功后，使用返回的`auth_data`作为Bearer Token访问管理员API。

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "your_password"
}
```

**Response (成功):**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "token": "user_token_for_subscription",
    "auth_data": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "is_admin": true
  }
}
```

**Response (失败):**
```json
{
  "status": "fail",
  "message": "邮箱或密码错误",
  "data": null
}
```

**使用说明:**
1. 管理员账户需要在数据库中`v2_user`表的`is_admin`字段设置为`1`
2. 登录成功后，将`auth_data`字段的值作为Authorization头部使用
3. 所有管理员API请求都需要在请求头中包含: `Authorization: Bearer {auth_data}`
4. Token有效期为1年，过期后需要重新登录

**安全特性:**
- 支持密码错误次数限制（默认5次）
- 超过限制后会被锁定一段时间（默认60分钟）
- 被封禁的用户无法登录

### 通过邮件链接登录
**POST** `/api/v1/passport/auth/loginWithMailLink`

**说明**: 发送登录链接到管理员邮箱，通过邮件链接快速登录。

**Request Body:**
```json
{
  "email": "admin@example.com",
  "redirect": "dashboard"
}
```

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": "https://your-domain.com/#/login?verify=temp_token&redirect=dashboard"
}
```

### Token验证登录
**GET** `/api/v1/passport/auth/token2Login`

**说明**: 通过临时验证码登录，通常用于邮件链接登录的第二步。

**Query Parameters:**
- `verify` (required): 临时验证码

**Response:**
```json
{
  "data": {
    "token": "user_token_for_subscription",
    "auth_data": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "is_admin": true
  }
}
```

### 获取管理员路径
**说明**: 管理员后台的访问路径是动态的，通过`secure_path`配置项设置。

**默认路径计算方式:**
```
secure_path = hash('crc32b', APP_KEY)
```

**完整管理员API路径:**
```
/api/v2/admin/{secure_path}/
```

**示例:**
如果您的`secure_path`是`admin`，则完整的API基础路径为：
```
/api/v2/admin/admin/
```

## 通用响应格式

### 成功响应
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {}
}
```

### 失败响应
```json
{
  "status": "fail", 
  "message": "错误信息",
  "data": null,
  "error": null
}
```

### 分页响应
```json
{
  "total": 100,
  "current_page": 1,
  "per_page": 10,
  "last_page": 10,
  "data": []
}
```

---

## 🔧 系统配置 (Config)

### 获取系统配置
**GET** `/config/fetch`

**Query Parameters:**
- `key` (optional): 配置分组名称

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "site": {
      "logo": "",
      "force_https": 0,
      "stop_register": 0,
      "app_name": "XBoard",
      "app_description": "XBoard is best!",
      "app_url": "",
      "subscribe_url": "",
      "try_out_plan_id": 0,
      "try_out_hour": 1,
      "tos_url": "",
      "currency": "CNY",
      "currency_symbol": "¥"
    },
    "safe": {
      "email_verify": false,
      "safe_mode_enable": false,
      "secure_path": "admin",
      "email_whitelist_enable": false,
      "captcha_enable": false
    }
  }
}
```

### 保存系统配置
**POST** `/config/save`

**Request Body:**
```json
{
  "app_name": "XBoard",
  "app_description": "XBoard is best!",
  "force_https": 1
}
```

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": true
}
```

### 获取邮件模板列表
**GET** `/config/getEmailTemplate`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    "verify.blade.php",
    "reset.blade.php",
    "invite.blade.php"
  ]
}
```

### 获取主题模板列表
**GET** `/config/getThemeTemplate`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    "Xboard",
    "v2board"
  ]
}
```

### 设置Telegram Webhook
**POST** `/config/setTelegramWebhook`

**Request Body:**
```json
{
  "telegram_bot_token": "your_bot_token",
  "telegram_webhook_url": "https://your-domain.com/webhook"
}
```

### 测试邮件发送
**POST** `/config/testSendMail`

**Request Body:**
```json
{
  "email": "test@example.com",
  "subject": "测试邮件",
  "content": "这是一封测试邮件"
}
```

---

## 📋 套餐管理 (Plan)

### 获取套餐列表
**GET** `/plan/fetch`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "name": "基础套餐",
      "content": "套餐描述",
      "month_price": 1000,
      "quarter_price": 2700,
      "half_year_price": 5000,
      "year_price": 9000,
      "transfer_enable": 107374182400,
      "speed_limit": null,
      "device_limit": 3,
      "show": 1,
      "sort": 1,
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 保存套餐
**POST** `/plan/save`

**Request Body:**
```json
{
  "name": "高级套餐",
  "content": "套餐详细描述",
  "month_price": 2000,
  "quarter_price": 5400,
  "half_year_price": 10000,
  "year_price": 18000,
  "transfer_enable": 214748364800,
  "speed_limit": null,
  "device_limit": 5,
  "show": 1
}
```

### 删除套餐
**POST** `/plan/drop`

**Request Body:**
```json
{
  "id": 1
}
```

### 更新套餐
**POST** `/plan/update`

**Request Body:**
```json
{
  "id": 1,
  "name": "更新后的套餐名称",
  "show": 0
}
```

### 套餐排序
**POST** `/plan/sort`

**Request Body:**
```json
{
  "ids": [3, 1, 2]
}
```

---

## 🖥️ 服务器管理 (Server)

### 获取节点列表
**GET** `/server/manage/getNodes`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "name": "香港节点01",
      "type": "shadowsocks",
      "host": "hk01.example.com",
      "port": 443,
      "server_port": 8080,
      "cipher": "aes-256-gcm",
      "obfs": "tls",
      "obfs_settings": {},
      "rate": 1.0,
      "network": ["tcp"],
      "rules": [],
      "networkSettings": {},
      "tlsSettings": {},
      "ruleSettings": {},
      "dnsSettings": {},
      "show": 1,
      "sort": 1,
      "tags": ["香港", "高速"],
      "group_ids": [1, 2],
      "groups": [
        {
          "id": 1,
          "name": "基础组"
        }
      ],
      "parent": null,
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 保存节点
**POST** `/server/manage/save`

**Request Body:**
```json
{
  "name": "新加坡节点01",
  "type": "shadowsocks",
  "host": "sg01.example.com",
  "port": 443,
  "server_port": 8080,
  "cipher": "aes-256-gcm",
  "rate": 1.0,
  "show": 1,
  "group_ids": [1]
}
```

### 获取服务器组
**GET** `/server/group/fetch`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "name": "基础组",
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

---

## 👥 用户管理 (User)

### 获取用户列表
**GET/POST** `/user/fetch`

**Query/Body Parameters:**
- `current` (int): 当前页码，默认1
- `pageSize` (int): 每页数量，默认10
- `email` (string): 邮箱筛选
- `id` (int): 用户ID筛选

**Response:**
```json
{
  "total": 100,
  "current_page": 1,
  "per_page": 10,
  "last_page": 10,
  "data": [
    {
      "id": 1,
      "email": "user@example.com",
      "email_verified_at": 1640995200,
      "balance": 10.50,
      "commission_balance": 5.25,
      "discount": null,
      "commission_rate": null,
      "commission_type": 1,
      "d": 0,
      "u": 0,
      "total_used": 0,
      "transfer_enable": 107374182400,
      "banned": 0,
      "remind_expire": 1,
      "remind_traffic": 1,
      "expired_at": 1672531200,
      "plan_id": 1,
      "subscribe_url": "https://example.com/api/v1/client/subscribe?token=xxx",
      "plan": {
        "id": 1,
        "name": "基础套餐"
      },
      "invite_user": {
        "id": 2,
        "email": "inviter@example.com"
      },
      "group": {
        "id": 1,
        "name": "普通用户"
      },
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 根据ID获取用户信息
**GET** `/user/getUserInfoById`

**Query Parameters:**
- `id` (required): 用户ID

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "balance": 1050,
    "commission_balance": 525,
    "transfer_enable": 107374182400,
    "expired_at": 1672531200,
    "plan_id": 1,
    "invite_user": {
      "id": 2,
      "email": "inviter@example.com"
    }
  }
}
```

### 更新用户信息
**POST** `/user/update`

**Request Body:**
```json
{
  "id": 1,
  "email": "newemail@example.com",
  "balance": 2000,
  "transfer_enable": 214748364800,
  "expired_at": 1704067200,
  "plan_id": 2,
  "banned": 0
}
```

### 生成用户
**POST** `/user/generate`

**Request Body:**
```json
{
  "email_prefix": "testuser",
  "email_suffix": "example.com",
  "password": "password123",
  "plan_id": 1,
  "expired_at": 1704067200
}
```

### 重置用户密钥
**POST** `/user/resetSecret`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": true
}
```

---

## 📊 统计数据 (Stat)

### 获取概览数据
**GET** `/stat/getOverride`

**Response:**
```json
{
  "data": {
    "month_income": 50000,
    "month_register_total": 150,
    "ticket_pending_total": 5,
    "commission_pending_total": 10,
    "day_income": 2000,
    "last_month_income": 45000,
    "commission_rate": 0.1,
    "pending_commission": 1500,
    "today_register_total": 8,
    "last_month_register_total": 120
  }
}
```

### 获取详细统计
**GET** `/stat/getStats`

**Response:**
```json
{
  "data": {
    "todayIncome": 2000,
    "dayIncomeGrowth": 15.5,
    "currentMonthIncome": 50000,
    "lastMonthIncome": 45000,
    "monthIncomeGrowth": 11.1,
    "currentMonthNewUsers": 150,
    "totalUsers": 1500,
    "activeUsers": 800,
    "userGrowth": 25.0,
    "onlineUsers": 120,
    "onlineDevices": 180,
    "commissionPendingTotal": 10
  }
}
```

---

## 🛒 订单管理 (Order)

### 获取订单列表
**GET/POST** `/order/fetch`

**Query/Body Parameters:**
- `current` (int): 当前页码
- `pageSize` (int): 每页数量
- `is_commission` (boolean): 是否为佣金订单

**Response:**
```json
{
  "total": 50,
  "current_page": 1,
  "per_page": 10,
  "last_page": 5,
  "data": [
    {
      "id": 1,
      "trade_no": "202301010001",
      "user_id": 1,
      "plan_id": 1,
      "period": "month",
      "total_amount": 1000,
      "status": 1,
      "commission_status": 1,
      "commission_balance": 100,
      "plan": {
        "id": 1,
        "name": "基础套餐"
      },
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 获取订单详情
**GET** `/order/detail`

**Query Parameters:**
- `id` (required): 订单ID

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "id": 1,
    "trade_no": "202301010001",
    "user_id": 1,
    "plan_id": 1,
    "period": "month",
    "total_amount": 1000,
    "status": 1,
    "user": {
      "id": 1,
      "email": "user@example.com"
    },
    "plan": {
      "id": 1,
      "name": "基础套餐"
    },
    "commission_log": [],
    "invite_user": null,
    "surplus_orders": []
  }
}
```

---

## 📢 公告管理 (Notice)

### 获取公告列表
**GET** `/notice/fetch`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "title": "系统维护通知",
      "content": "系统将于今晚进行维护",
      "img_url": "",
      "tags": ["系统", "维护"],
      "show": 1,
      "popup": 0,
      "sort": 1,
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 保存公告
**POST** `/notice/save`

**Request Body:**
```json
{
  "title": "新公告标题",
  "content": "公告内容详情",
  "img_url": "https://example.com/image.jpg",
  "tags": ["重要", "通知"],
  "show": 1,
  "popup": 1
}
```

### 显示/隐藏公告
**POST** `/notice/show`

**Request Body:**
```json
{
  "id": 1
}
```

### 删除公告
**POST** `/notice/drop`

**Request Body:**
```json
{
  "id": 1
}
```

---

## 🎫 工单管理 (Ticket)

### 获取工单列表
**GET/POST** `/ticket/fetch`

**Query/Body Parameters:**
- `current` (int): 当前页码
- `pageSize` (int): 每页数量
- `id` (int): 工单ID（获取单个工单详情）

**Response:**
```json
{
  "total": 20,
  "current_page": 1,
  "per_page": 10,
  "last_page": 2,
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "subject": "无法连接服务器",
      "level": 1,
      "status": 0,
      "reply_status": 1,
      "user": {
        "id": 1,
        "email": "user@example.com"
      },
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 回复工单
**POST** `/ticket/reply`

**Request Body:**
```json
{
  "id": 1,
  "message": "我们正在处理您的问题，请稍等。"
}
```

### 关闭工单
**POST** `/ticket/close`

**Request Body:**
```json
{
  "id": 1
}
```

---

## 🎟️ 优惠券管理 (Coupon)

### 获取优惠券列表
**GET/POST** `/coupon/fetch`

**Response:**
```json
{
  "total": 10,
  "current_page": 1,
  "per_page": 10,
  "last_page": 1,
  "data": [
    {
      "id": 1,
      "code": "WELCOME2023",
      "name": "新用户优惠券",
      "type": 1,
      "value": 500,
      "limit_use": 100,
      "used": 25,
      "limit_use_with_user": 1,
      "limit_plan_ids": [1, 2],
      "started_at": 1640995200,
      "ended_at": 1672531200,
      "show": 1,
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 生成优惠券
**POST** `/coupon/generate`

**Request Body:**
```json
{
  "name": "春节优惠券",
  "type": 1,
  "value": 1000,
  "limit_use": 50,
  "limit_use_with_user": 1,
  "started_at": 1640995200,
  "ended_at": 1672531200,
  "show": 1
}
```

---

## 📚 知识库管理 (Knowledge)

### 获取知识库列表
**GET** `/knowledge/fetch`

**Query Parameters:**
- `id` (optional): 知识库文章ID（获取单篇文章）

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "title": "如何使用客户端",
      "category": "使用教程",
      "show": 1,
      "updated_at": 1640995200
    }
  ]
}
```

### 获取分类列表
**GET** `/knowledge/getCategory`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    "使用教程",
    "常见问题",
    "故障排除"
  ]
}
```

### 保存知识库文章
**POST** `/knowledge/save`

**Request Body:**
```json
{
  "title": "新手入门指南",
  "category": "使用教程",
  "body": "详细的使用说明...",
  "sort": 1,
  "show": 1
}
```

---

## 💳 支付管理 (Payment)

### 获取支付方式列表
**GET** `/payment/fetch`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": 1,
      "uuid": "payment-uuid-123",
      "payment": "Alipay",
      "name": "支付宝",
      "icon": "alipay.png",
      "handling_fee_fixed": 0,
      "handling_fee_percent": 0,
      "enable": 1,
      "sort": 1,
      "notify_url": "https://example.com/api/v1/guest/payment/notify/Alipay/payment-uuid-123",
      "config": {},
      "created_at": 1640995200,
      "updated_at": 1640995200
    }
  ]
}
```

### 获取可用支付方法
**GET** `/payment/getPaymentMethods`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    "Alipay",
    "WechatPay",
    "Stripe",
    "PayPal"
  ]
}
```

---

## ⚙️ 系统管理 (System)

### 获取系统状态
**GET** `/system/getSystemStatus`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "schedule": true,
    "horizon": true,
    "schedule_last_runtime": 1640995200,
    "logs": {
      "total": 1000,
      "error": 5,
      "warning": 20,
      "info": 975
    }
  }
}
```

### 获取队列统计
**GET** `/system/getQueueStats`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "failedJobs": 2,
    "jobsPerMinute": 150,
    "pausedMasters": 0,
    "processes": 4,
    "recentJobs": 1500,
    "status": true,
    "wait": []
  }
}
```

### 获取系统日志
**GET** `/system/getSystemLog`

**Query Parameters:**
- `current` (int): 当前页码
- `page_size` (int): 每页数量
- `level` (string): 日志级别
- `keyword` (string): 搜索关键词

**Response:**
```json
{
  "total": 100,
  "current_page": 1,
  "per_page": 10,
  "last_page": 10,
  "data": [
    {
      "id": 1,
      "level": "INFO",
      "title": "用户登录",
      "data": "用户 user@example.com 登录成功",
      "context": "{}",
      "uri": "/api/v1/passport/auth/login",
      "created_at": 1640995200
    }
  ]
}
```

---

## 🎨 主题管理 (Theme)

### 获取主题列表
**GET** `/theme/getThemes`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "themes": [
      {
        "name": "Xboard",
        "description": "默认主题",
        "version": "1.0.0",
        "author": "XBoard Team"
      }
    ],
    "active": "Xboard"
  }
}
```

### 上传主题
**POST** `/theme/upload`

**Request Body:** (multipart/form-data)
- `file`: 主题ZIP文件

### 删除主题
**POST** `/theme/delete`

**Request Body:**
```json
{
  "name": "theme-name"
}
```

### 获取主题配置
**POST** `/theme/getThemeConfig`

**Request Body:**
```json
{
  "name": "Xboard"
}
```

### 保存主题配置
**POST** `/theme/saveThemeConfig`

**Request Body:**
```json
{
  "name": "Xboard",
  "config": {
    "primary_color": "#1890ff",
    "logo_url": "https://example.com/logo.png"
  }
}
```

---

## 🔌 插件管理 (Plugin)

### 获取插件列表
**GET** `/plugin/getPlugins`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "code": "daily_checkin",
      "name": "每日签到",
      "description": "用户每日签到获取奖励",
      "version": "1.0.0",
      "author": "XBoard Team",
      "installed": true,
      "enabled": true,
      "config": {
        "balance_reward_min": 1,
        "balance_reward_max": 10,
        "traffic_reward_mb": 100
      },
      "readme": "# 每日签到插件\n\n用户可以通过每日签到获取余额和流量奖励。"
    }
  ]
}
```

### 上传插件
**POST** `/plugin/upload`

**Request Body:** (multipart/form-data)
- `file`: 插件ZIP文件

**Response:**
```json
{
  "message": "插件上传成功"
}
```

### 删除插件
**POST** `/plugin/delete`

**Request Body:**
```json
{
  "code": "plugin_code"
}
```

### 安装插件
**POST** `/plugin/install`

**Request Body:**
```json
{
  "code": "daily_checkin"
}
```

**Response:**
```json
{
  "message": "插件安装成功"
}
```

### 卸载插件
**POST** `/plugin/uninstall`

**Request Body:**
```json
{
  "code": "daily_checkin"
}
```

### 启用插件
**POST** `/plugin/enable`

**Request Body:**
```json
{
  "code": "daily_checkin"
}
```

**Response:**
```json
{
  "message": "插件启用成功"
}
```

### 禁用插件
**POST** `/plugin/disable`

**Request Body:**
```json
{
  "code": "daily_checkin"
}
```

**Response:**
```json
{
  "message": "插件禁用成功"
}
```

### 获取插件配置
**GET** `/plugin/config`

**Query Parameters:**
- `code` (required): 插件代码

**Response:**
```json
{
  "data": {
    "balance_reward_min": 1,
    "balance_reward_max": 10,
    "traffic_reward_mb": 100,
    "continuous_bonus_enabled": true
  }
}
```

### 更新插件配置
**POST** `/plugin/config`

**Request Body:**
```json
{
  "code": "daily_checkin",
  "config": {
    "balance_reward_min": 2,
    "balance_reward_max": 20,
    "traffic_reward_mb": 200
  }
}
```

---

## 📊 流量重置管理 (Traffic Reset)

### 获取重置日志
**GET** `/traffic-reset/logs`

**Query Parameters:**
- `page` (int): 页码
- `limit` (int): 每页数量
- `user_id` (int): 用户ID筛选
- `reset_type` (string): 重置类型筛选
- `start_date` (string): 开始日期
- `end_date` (string): 结束日期

**Response:**
```json
{
  "total": 100,
  "current_page": 1,
  "per_page": 20,
  "last_page": 5,
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "user": {
        "id": 1,
        "email": "user@example.com"
      },
      "reset_type": "monthly",
      "reset_type_name": "月度重置",
      "reset_time": "2023-01-01T00:00:00Z",
      "old_traffic": {
        "upload": 1073741824,
        "download": 2147483648,
        "total": 3221225472,
        "formatted": "3.00 GB"
      },
      "trigger_source": "cron",
      "trigger_source_name": "定时任务",
      "metadata": {}
    }
  ]
}
```

### 获取重置统计
**GET** `/traffic-reset/stats`

**Query Parameters:**
- `days` (int): 统计天数，默认30天

**Response:**
```json
{
  "data": {
    "total_resets": 150,
    "auto_resets": 120,
    "manual_resets": 20,
    "cron_resets": 10
  }
}
```

### 获取用户重置历史
**GET** `/traffic-reset/user/{userId}/history`

**Query Parameters:**
- `limit` (int): 记录数量限制，默认10

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "reset_type": "monthly",
      "reset_type_name": "月度重置",
      "reset_time": "2023-01-01T00:00:00Z",
      "old_traffic": {
        "upload": 1073741824,
        "download": 2147483648,
        "total": 3221225472,
        "formatted": "3.00 GB"
      },
      "trigger_source": "manual",
      "trigger_source_name": "手动重置",
      "metadata": {
        "reason": "用户申请重置",
        "admin_id": 1
      }
    }
  ]
}
```

### 手动重置用户流量
**POST** `/traffic-reset/reset-user`

**Request Body:**
```json
{
  "user_id": 1,
  "reason": "用户申请重置流量"
}
```

**Response:**
```json
{
  "message": "流量重置成功",
  "data": {
    "user_id": 1,
    "email": "user@example.com",
    "reset_time": "2023-01-01T12:00:00Z",
    "next_reset_at": "2023-02-01T00:00:00Z"
  }
}
```

---

## 🎁 礼品卡模板管理 (Gift Card Templates)

### 获取礼品卡模板列表
**GET/POST** `/gift-card/templates`

**Query/Body Parameters:**
- `type` (int): 模板类型筛选
- `status` (int): 状态筛选 (0=禁用, 1=启用)
- `page` (int): 页码
- `per_page` (int): 每页数量

**Response:**
```json
{
  "total": 10,
  "current_page": 1,
  "per_page": 15,
  "last_page": 1,
  "data": [
    {
      "id": 1,
      "name": "新用户礼品卡",
      "type": 1,
      "type_name": "余额卡",
      "value": 1000,
      "description": "新用户专享礼品卡",
      "status": 1,
      "sort": 1,
      "created_at": "2023-01-01T00:00:00Z",
      "updated_at": "2023-01-01T00:00:00Z"
    }
  ]
}
```

### 创建礼品卡模板
**POST** `/gift-card/create-template`

**Request Body:**
```json
{
  "name": "VIP礼品卡",
  "type": 1,
  "value": 5000,
  "description": "VIP用户专享",
  "status": 1,
  "sort": 1
}
```

### 更新礼品卡模板
**POST** `/gift-card/update-template`

**Request Body:**
```json
{
  "id": 1,
  "name": "更新后的礼品卡",
  "value": 2000,
  "status": 0
}
```

### 删除礼品卡模板
**POST** `/gift-card/delete-template`

**Request Body:**
```json
{
  "id": 1
}
```

---

## � 认证使用示例

### 完整登录流程示例

**步骤1: 管理员登录**
```bash
curl -X POST "https://your-domain.com/api/v1/passport/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@example.com",
    "password": "your_password"
  }'
```

**步骤2: 获取Bearer Token**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "token": "abc123def456",
    "auth_data": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "is_admin": true
  }
}
```

**步骤3: 使用Token访问管理员API**
```bash
curl -X GET "https://your-domain.com/api/v2/admin/admin/config/fetch" \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..." \
  -H "Content-Type: application/json"
```

### JavaScript示例

```javascript
// 登录获取Token
async function adminLogin(email, password) {
  const response = await fetch('/api/v1/passport/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ email, password })
  });

  const result = await response.json();
  if (result.status === 'success') {
    // 保存Token到localStorage
    localStorage.setItem('admin_token', result.data.auth_data);
    return result.data;
  }
  throw new Error(result.message);
}

// 使用Token调用管理员API
async function callAdminAPI(endpoint, options = {}) {
  const token = localStorage.getItem('admin_token');
  if (!token) {
    throw new Error('未登录');
  }

  const response = await fetch(`/api/v2/admin/admin/${endpoint}`, {
    ...options,
    headers: {
      'Authorization': token,
      'Content-Type': 'application/json',
      ...options.headers
    }
  });

  return response.json();
}

// 使用示例
try {
  // 登录
  const authData = await adminLogin('admin@example.com', 'password');
  console.log('登录成功:', authData);

  // 获取系统配置
  const config = await callAdminAPI('config/fetch');
  console.log('系统配置:', config);

  // 获取用户列表
  const users = await callAdminAPI('user/fetch', {
    method: 'POST',
    body: JSON.stringify({
      current: 1,
      pageSize: 10
    })
  });
  console.log('用户列表:', users);
} catch (error) {
  console.error('操作失败:', error.message);
}
```

### Python示例

```python
import requests
import json

class XboardAdminAPI:
    def __init__(self, base_url, secure_path='admin'):
        self.base_url = base_url.rstrip('/')
        self.secure_path = secure_path
        self.token = None

    def login(self, email, password):
        """管理员登录"""
        url = f"{self.base_url}/api/v1/passport/auth/login"
        data = {
            "email": email,
            "password": password
        }

        response = requests.post(url, json=data)
        result = response.json()

        if result.get('status') == 'success':
            self.token = result['data']['auth_data']
            return result['data']
        else:
            raise Exception(result.get('message', '登录失败'))

    def call_api(self, endpoint, method='GET', data=None):
        """调用管理员API"""
        if not self.token:
            raise Exception('未登录，请先调用login方法')

        url = f"{self.base_url}/api/v2/admin/{self.secure_path}/{endpoint}"
        headers = {
            'Authorization': self.token,
            'Content-Type': 'application/json'
        }

        if method.upper() == 'GET':
            response = requests.get(url, headers=headers, params=data)
        else:
            response = requests.request(method, url, headers=headers, json=data)

        return response.json()

# 使用示例
if __name__ == "__main__":
    # 初始化API客户端
    api = XboardAdminAPI('https://your-domain.com')

    try:
        # 登录
        auth_data = api.login('admin@example.com', 'your_password')
        print(f"登录成功: {auth_data}")

        # 获取系统配置
        config = api.call_api('config/fetch')
        print(f"系统配置: {config}")

        # 获取用户列表
        users = api.call_api('user/fetch', 'POST', {
            'current': 1,
            'pageSize': 10
        })
        print(f"用户列表: {users}")

    except Exception as e:
        print(f"操作失败: {e}")
```

---

## �📝 订单补充API

### 订单分配
**POST** `/order/assign`

**Request Body:**
```json
{
  "trade_no": "202301010001",
  "plan_id": 2
}
```

### 订单支付确认
**POST** `/order/paid`

**Request Body:**
```json
{
  "trade_no": "202301010001"
}
```

### 订单详情 (POST方式)
**POST** `/order/detail`

**Request Body:**
```json
{
  "id": 1
}
```

---

## 🔧 系统补充API

### 获取队列工作负载
**GET** `/system/getQueueWorkload`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "default": {
      "length": 0,
      "wait": 0,
      "processes": 1
    }
  }
}
```

### 获取失败任务
**GET** `/system/getHorizonFailedJobs`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": [
    {
      "id": "1",
      "job": "App\\Jobs\\SendEmail",
      "failed_at": "2023-01-01T12:00:00Z",
      "exception": "Connection timeout"
    }
  ]
}
```

### 获取日志清理统计
**GET** `/system/getLogClearStats`

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": {
    "total_logs": 10000,
    "logs_to_clear": 5000,
    "estimated_space_saved": "50MB"
  }
}
```

---

## 🎯 服务器管理补充API

### 复制节点
**POST** `/server/manage/copy`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "status": "success",
  "message": "操作成功",
  "data": true
}
```

---

## 📧 用户管理补充API

### 导出用户CSV
**POST** `/user/dumpCSV`

**Request Body:**
```json
{
  "user_ids": [1, 2, 3]
}
```

### 发送邮件给用户
**POST** `/user/sendMail`

**Request Body:**
```json
{
  "user_id": 1,
  "subject": "重要通知",
  "content": "邮件内容"
}
```

### 封禁用户
**POST** `/user/ban`

**Request Body:**
```json
{
  "id": 1,
  "banned": 1
}
```

### 设置邀请用户
**POST** `/user/setInviteUser`

**Request Body:**
```json
{
  "id": 1,
  "invite_user_id": 2
}
```

### 删除用户
**POST** `/user/destroy`

**Request Body:**
```json
{
  "id": 1
}
```
