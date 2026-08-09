# Mini ERP + CRM Operations Portal

This repository contains the Phase 1 foundation for the case-study MVP.

## Stack

- API: Node.js, TypeScript, Express.js (added in Phase 2), Prisma ORM, PostgreSQL
- Web: React, Vite, Tailwind CSS
- Authentication: JWT (added in Phase 2)

## Prerequisites

- Node.js 20 or later
- pnpm 10 or later
- PostgreSQL 15 or later

## Local setup

1. Copy `.env.example` to `.env` and adjust `DATABASE_URL` for your PostgreSQL instance.
2. Install dependencies with `pnpm install`.
3. Create the database named `mini_erp_crm`.
4. Run `pnpm db:migrate -- --name init`.
5. Run `pnpm db:seed`.
6. Run `pnpm dev` when subsequent application phases are complete.

## Environment management

Local secrets live only in `.env`, which is gitignored. `.env.example` documents every required key without real credentials. Hosted environments should define the same variables in their platform configuration.

## Phase 1 scope

Phase 1 established the pnpm workspace, React/Vite/Tailwind project, API project, Prisma data model, database migration workflow, and deterministic local seed data. Phase 2 adds the authentication API; business modules remain intentionally unimplemented.

## Authentication

- `POST /auth/login` accepts `email` and `password`, then returns a JWT and user details.
- `GET /auth/me` requires an `Authorization: Bearer <token>` header and returns the verified JWT user.
- The API exposes `authenticateToken` and `authorizeRoles` middleware for protected role-based routes in subsequent modules.

## Seed data

The seed creates the four required role records (`ADMIN`, `SALES`, `WAREHOUSE`, and `ACCOUNTS`), one customer, and one product. Each seeded user has the password `Password@123` for local development only.

## Assumptions

- PostgreSQL is the development and production database.
- UUID primary keys are used across the data model.
- Stock changes will be written in the same transaction as challan confirmation in the sales-challan phase.
- Deployment, Postman collection, screen recording, and final credentials are delivery-phase work.
