import "dotenv/config";
import { PrismaClient, UserRole } from "@prisma/client";

const prisma = new PrismaClient();

const users = [
  { name: "Aarav Admin", email: "admin@minierp.local", role: UserRole.ADMIN },
  { name: "Siya Sales", email: "sales@minierp.local", role: UserRole.SALES },
  { name: "Wren Warehouse", email: "warehouse@minierp.local", role: UserRole.WAREHOUSE },
  { name: "Asha Accounts", email: "accounts@minierp.local", role: UserRole.ACCOUNTS }
];

async function main() {
  for (const user of users) {
    await prisma.user.upsert({
      where: { email: user.email },
      update: { name: user.name, role: user.role },
      create: {
        ...user,
        // Replaced with bcrypt hashes when Phase 2 authentication is implemented.
        passwordHash: "PHASE_1_PASSWORD_NOT_ENABLED"
      }
    });
  }

  await prisma.product.upsert({
    where: { sku: "DEMO-WIDGET-001" },
    update: {},
    create: {
      name: "Demo Distribution Widget",
      sku: "DEMO-WIDGET-001",
      category: "Demo",
      unitPrice: "250.00",
      currentStock: 100,
      minimumStockAlertQty: 10,
      warehouseLocation: "Main Warehouse / A-01"
    }
  });

  await prisma.customer.upsert({
    where: { id: "00000000-0000-0000-0000-000000000001" },
    update: {},
    create: {
      id: "00000000-0000-0000-0000-000000000001",
      customerName: "Priya Shah",
      mobile: "+91-90000-00000",
      email: "priya@example.com",
      businessName: "Shah Retail Stores",
      type: "RETAIL",
      address: "Bengaluru, Karnataka",
      status: "LEAD",
      notes: "Seed customer for local development."
    }
  });
}

main()
  .then(() => console.log("Seed data created."))
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(() => prisma.$disconnect());
