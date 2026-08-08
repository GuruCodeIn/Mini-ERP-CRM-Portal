-- Initial schema for the Mini ERP + CRM MVP.
CREATE SCHEMA IF NOT EXISTS "public";

CREATE TYPE "UserRole" AS ENUM ('ADMIN', 'SALES', 'WAREHOUSE', 'ACCOUNTS');
CREATE TYPE "CustomerType" AS ENUM ('RETAIL', 'WHOLESALE', 'DISTRIBUTOR');
CREATE TYPE "CustomerStatus" AS ENUM ('LEAD', 'ACTIVE', 'INACTIVE');
CREATE TYPE "StockMovementType" AS ENUM ('IN', 'OUT');
CREATE TYPE "ChallanStatus" AS ENUM ('DRAFT', 'CONFIRMED', 'CANCELLED');

CREATE TABLE "User" (
  "id" UUID NOT NULL, "name" TEXT NOT NULL, "email" TEXT NOT NULL,
  "passwordHash" TEXT NOT NULL, "role" "UserRole" NOT NULL,
  "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Customer" (
  "id" UUID NOT NULL, "customerName" TEXT NOT NULL, "mobile" TEXT NOT NULL,
  "email" TEXT NOT NULL, "businessName" TEXT NOT NULL, "gstNumber" TEXT,
  "type" "CustomerType" NOT NULL, "address" TEXT NOT NULL,
  "status" "CustomerStatus" NOT NULL DEFAULT 'LEAD', "followUpDate" TIMESTAMP(3),
  "notes" TEXT, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "FollowUp" (
  "id" UUID NOT NULL, "customerId" UUID NOT NULL, "note" TEXT NOT NULL,
  "followUpDate" TIMESTAMP(3), "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "FollowUp_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Product" (
  "id" UUID NOT NULL, "name" TEXT NOT NULL, "sku" TEXT NOT NULL,
  "category" TEXT NOT NULL, "unitPrice" DECIMAL(12,2) NOT NULL,
  "currentStock" INTEGER NOT NULL DEFAULT 0, "minimumStockAlertQty" INTEGER NOT NULL DEFAULT 0,
  "warehouseLocation" TEXT NOT NULL, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL,
  CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "StockMovement" (
  "id" UUID NOT NULL, "productId" UUID NOT NULL, "quantity" INTEGER NOT NULL,
  "movementType" "StockMovementType" NOT NULL, "reason" TEXT NOT NULL,
  "createdById" UUID NOT NULL, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "StockMovement_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Challan" (
  "id" UUID NOT NULL, "challanNumber" TEXT NOT NULL, "customerId" UUID NOT NULL,
  "totalQuantity" INTEGER NOT NULL DEFAULT 0, "status" "ChallanStatus" NOT NULL DEFAULT 'DRAFT',
  "createdById" UUID NOT NULL, "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" TIMESTAMP(3) NOT NULL, "confirmedAt" TIMESTAMP(3),
  CONSTRAINT "Challan_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "ChallanItem" (
  "id" UUID NOT NULL, "challanId" UUID NOT NULL, "productId" UUID NOT NULL,
  "productNameSnapshot" TEXT NOT NULL, "skuSnapshot" TEXT NOT NULL,
  "unitPriceSnapshot" DECIMAL(12,2) NOT NULL, "quantity" INTEGER NOT NULL,
  CONSTRAINT "ChallanItem_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE INDEX "Customer_customerName_idx" ON "Customer"("customerName");
CREATE INDEX "Customer_mobile_idx" ON "Customer"("mobile");
CREATE INDEX "Customer_status_idx" ON "Customer"("status");
CREATE INDEX "FollowUp_customerId_createdAt_idx" ON "FollowUp"("customerId", "createdAt");
CREATE UNIQUE INDEX "Product_sku_key" ON "Product"("sku");
CREATE INDEX "Product_name_idx" ON "Product"("name");
CREATE INDEX "Product_category_idx" ON "Product"("category");
CREATE INDEX "StockMovement_productId_createdAt_idx" ON "StockMovement"("productId", "createdAt");
CREATE INDEX "StockMovement_createdById_idx" ON "StockMovement"("createdById");
CREATE UNIQUE INDEX "Challan_challanNumber_key" ON "Challan"("challanNumber");
CREATE INDEX "Challan_customerId_idx" ON "Challan"("customerId");
CREATE INDEX "Challan_status_idx" ON "Challan"("status");
CREATE INDEX "Challan_createdAt_idx" ON "Challan"("createdAt");
CREATE INDEX "ChallanItem_productId_idx" ON "ChallanItem"("productId");
CREATE UNIQUE INDEX "ChallanItem_challanId_productId_key" ON "ChallanItem"("challanId", "productId");

ALTER TABLE "FollowUp" ADD CONSTRAINT "FollowUp_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "StockMovement" ADD CONSTRAINT "StockMovement_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "StockMovement" ADD CONSTRAINT "StockMovement_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "Challan" ADD CONSTRAINT "Challan_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "Challan" ADD CONSTRAINT "Challan_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "ChallanItem" ADD CONSTRAINT "ChallanItem_challanId_fkey" FOREIGN KEY ("challanId") REFERENCES "Challan"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "ChallanItem" ADD CONSTRAINT "ChallanItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
