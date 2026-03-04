---
title: User Authentication
created: 2025-01-15
updated: 2025-02-03
related_prd: user-authentication.md
related_plan: auth-implementation-plan.md
---

## Overview

Token-based authentication system using JWT for API access and session cookies for the web UI. Built to replace the previous basic-auth system which couldn't support role-based access control or token expiration.

## Key Files

| File | Purpose |
|------|---------|
| `src/auth/middleware.ts` | Express middleware that validates JWT tokens on protected routes |
| `src/auth/jwt.ts` | Token generation and verification utilities |
| `src/auth/routes.ts` | Login, logout, refresh, and registration endpoints |
| `src/auth/roles.ts` | Role definitions and permission checking logic |
| `src/db/migrations/003-add-users-table.sql` | Database schema for users and sessions |
| `tests/auth/auth.test.ts` | Integration tests for all auth endpoints |

## Architecture Decisions

### JWT with refresh tokens over session-only auth

**Context:** Needed stateless auth for API clients while maintaining secure web sessions
**Decision:** Use short-lived JWTs (15min) with long-lived refresh tokens (7 days) stored in httpOnly cookies
**Rationale:** Balances security (short token lifetime) with UX (users don't re-login constantly). API clients use Bearer tokens, web UI uses cookies automatically.
**Alternatives considered:** Session-only auth (simpler but requires server-side session store), OAuth2 (overkill for single-app use case)

### bcrypt over argon2 for password hashing

**Context:** Needed a password hashing algorithm
**Decision:** Use bcrypt with cost factor 12
**Rationale:** bcrypt is widely supported across our deployment targets. argon2 would require a native addon that complicated our Docker builds. The security difference is negligible for our threat model.
**Alternatives considered:** argon2id (better but native dependency issues), scrypt (less ecosystem support)

## How It Works

1. **Registration**: `POST /auth/register` validates input, hashes password with bcrypt, creates user record and initial session
2. **Login**: `POST /auth/login` verifies credentials, generates JWT access token + refresh token, sets httpOnly cookie for web clients
3. **Request authentication**: `authMiddleware` in `src/auth/middleware.ts` extracts token from Authorization header or cookie, verifies with `jwt.verify()`, attaches `req.user`
4. **Token refresh**: `POST /auth/refresh` accepts a valid refresh token, issues new access token without re-authentication
5. **Role checking**: `requireRole('admin')` middleware in `src/auth/roles.ts` checks `req.user.role` against required role

Entry point: `src/auth/routes.ts:registerAuthRoutes`
Core logic: `src/auth/middleware.ts:authMiddleware`

## Related Docs

- PRD: [docs/prds/user-authentication.md](../prds/user-authentication.md)
- Plan: [docs/plans/auth-implementation-plan.md](../plans/auth-implementation-plan.md)
- Roadmap: See "Phase 2: Security" in [docs/ROADMAP.md](../ROADMAP.md)
