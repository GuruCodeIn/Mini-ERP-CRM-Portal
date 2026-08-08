import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./styles/index.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <main className="min-h-screen bg-slate-50 p-8 text-slate-900">
      <h1 className="text-2xl font-semibold">Mini ERP + CRM</h1>
      <p className="mt-2 text-slate-600">Project scaffold ready. Application features begin in Phase 2.</p>
    </main>
  </StrictMode>
);
