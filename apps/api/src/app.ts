import express, { type NextFunction, type Request, type Response } from "express";
import { authRouter } from "./routes/auth.routes.js";

export const app = express();

app.use(express.json());

app.get("/health", (_request, response) => {
  response.status(200).json({ message: "Mini ERP CRM API is running" });
});

app.use("/auth", authRouter);

app.use((_request: Request, response: Response) => {
  response.status(404).json({ message: "Route not found." });
});

app.use((error: unknown, _request: Request, response: Response, _next: NextFunction) => {
  console.error(error);
  response.status(500).json({ message: "An unexpected server error occurred." });
});
