import type { NextFunction, Request, Response } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";
import { UserRole } from "@prisma/client";

type AccessTokenPayload = JwtPayload & {
  sub: string;
  email: string;
  role: UserRole;
};

function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret) {
    throw new Error("JWT_SECRET must be configured.");
  }

  return secret;
}

function isAccessTokenPayload(payload: string | JwtPayload): payload is AccessTokenPayload {
  return (
    typeof payload !== "string" &&
    typeof payload.sub === "string" &&
    typeof payload.email === "string" &&
    Object.values(UserRole).includes(payload.role as UserRole)
  );
}

export function authenticateToken(request: Request, response: Response, next: NextFunction): void {
  const authorization = request.header("authorization");
  const token = authorization?.startsWith("Bearer ") ? authorization.slice(7) : undefined;

  if (!token) {
    response.status(401).json({ message: "Authentication token is required." });
    return;
  }

  try {
    const payload = jwt.verify(token, getJwtSecret());
    if (!isAccessTokenPayload(payload)) {
      response.status(401).json({ message: "Authentication token is invalid." });
      return;
    }

    request.authUser = { id: payload.sub, email: payload.email, role: payload.role };
    next();
  } catch {
    response.status(401).json({ message: "Authentication token is invalid or expired." });
  }
}

export function authorizeRoles(...roles: UserRole[]) {
  return (request: Request, response: Response, next: NextFunction): void => {
    if (!request.authUser) {
      response.status(401).json({ message: "Authentication token is required." });
      return;
    }

    if (!roles.includes(request.authUser.role)) {
      response.status(403).json({ message: "You do not have permission to access this resource." });
      return;
    }

    next();
  };
}
