import { compare } from "bcryptjs";
import { Router } from "express";
import jwt from "jsonwebtoken";
import { prisma } from "../lib/prisma.js";
import { authenticateToken } from "../middlewares/auth.middleware.js";

export const authRouter = Router();

function getJwtSecret(): string {
  const secret = process.env.JWT_SECRET;
  if (!secret) {
    throw new Error("JWT_SECRET must be configured.");
  }

  return secret;
}

authRouter.post("/login", async (request, response, next) => {
  try {
    const { email, password } = request.body as { email?: unknown; password?: unknown };

    if (typeof email !== "string" || typeof password !== "string" || !email.trim() || !password) {
      response.status(400).json({ message: "Email and password are required." });
      return;
    }

    const user = await prisma.user.findUnique({
      where: { email: email.trim().toLowerCase() }
    });

    if (!user || !(await compare(password, user.passwordHash))) {
      response.status(401).json({ message: "Invalid email or password." });
      return;
    }

    const token = jwt.sign(
      { email: user.email, role: user.role },
      getJwtSecret(),
      { subject: user.id, expiresIn: "8h" }
    );

    response.status(200).json({
      token,
      user: { id: user.id, name: user.name, email: user.email, role: user.role }
    });
  } catch (error) {
    next(error);
  }
});

authRouter.get("/me", authenticateToken, (request, response) => {
  response.status(200).json({ user: request.authUser });
});
