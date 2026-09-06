import "package:cv_app/domain/showcase/showcase_models.dart";

/// Featured POS / operations platform case study.
const kisbeyCaseStudy = CaseStudy(
  slug: "kisbey-pos",
  title: "Kisbey Technologies",
  subtitle: "Offline-first point-of-sale infrastructure for hospitality and retail.",
  year: "2026",
  role: "Software Engineer",
  platform: "Desktop / Mobile / Cloud",
  sourceVisibility: SourceVisibility.private,
  stack: [
    "Flutter",
    "Dart",
    "NestJS",
    "TypeScript",
    "GraphQL",
    "REST",
    "Prisma",
    "PostgreSQL",
    "SQLite",
    "AWS CDK",
    "Docker",
  ],
  problem: "Retail and hospitality terminals need to keep selling when connectivity drops, while still converging on a consistent cloud state across multiple tills, back-office apps, and tenants.",
  solution:
      "Designed an offline-first Flutter client with a local SQLite runtime and sync engine, backed by a NestJS command/query API: REST for money-changing writes, GraphQL for reads, Prisma on PostgreSQL, and AWS CDK stages for the intended cloud path.",
  product:
      "Kisbey Central hosts the register and office shells. Till (Today, Checkout), Admin, Inventory, Accounting, and Restaurant packages share one Flutter codebase. Local development seeds Kisbey Demo Café — about 55 products with recipes and modifiers — so a teller can open a shift and complete a sale without production data.",
  result:
      "A modular monorepo that separates till, office, and hospitality concerns while sharing types, branding, and a command/query contract. Flutter web is intentionally out of scope; the portfolio demonstrates the system through architecture, a simulated API, and a schema excerpt rather than a hosted till.",
  decisions: [
    EngineeringDecision(
      title: "Commands on REST, queries on GraphQL",
      detail:
          "Writes that change money or stock are idempotent REST commands (`sales.complete`, `inventory.adjust`). GraphQL is reserved for reads so a financial mutation cannot land through a loosely typed query surface.",
    ),
    EngineeringDecision(
      title: "Offline-first local runtime",
      detail:
          "The register keeps a SQLite store and sync engine on device. Branding falls back to a bundled JSON if `GET /branding` is unreachable, so splash and theme still load when the API is down.",
    ),
    EngineeringDecision(
      title: "Tenant isolation in the data model",
      detail: "Every operational table is scoped by `tenantId`. Seed users include a second tenant so isolation is exercised locally, not only described.",
    ),
    EngineeringDecision(
      title: "IaC designed, Docker locally",
      detail: "CDK stages `kisbey-dev` and `kisbey-prod` exist and synth. VPC, RDS, Cognito, and ECS are the target topology; day-to-day development uses Docker Postgres and a local Nest process.",
    ),
  ],
  relatedRepos: [
    RelatedRepo(
      name: "kisbey-technologies",
      description: "Private Flutter + NestJS + CDK monorepo. Walkthrough on request.",
    ),
  ],
  endpoints: [
    ShowcaseEndpoint(
      id: "kisbey-signin",
      method: "POST",
      path: "/auth/sign-in",
      group: "AUTH",
      summary: "Issue a JWT for a seeded café user.",
      requestJson: '''
{
  "email": "teller@kisbey.local",
  "password": "kisbey-dev"
}''',
      responseMs: 118,
      responseJson: '''
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…",
  "user": {
    "email": "teller@kisbey.local",
    "tenantId": "tenant_a",
    "permissions": ["sell", "shift", "stock.read"],
    "registerId": "till_1"
  }
}''',
    ),
    ShowcaseEndpoint(
      id: "kisbey-products",
      method: "GET",
      path: "/catalogue/products",
      group: "CATALOGUE",
      summary: "List Demo Café products for the current tenant.",
      requestJson: "{}",
      responseMs: 96,
      responseJson: '''
{
  "items": [
    {
      "id": "prd_flat_white",
      "name": "Flat White",
      "priceCents": 4200,
      "category": "Coffee"
    },
    {
      "id": "prd_almond_croissant",
      "name": "Almond Croissant",
      "priceCents": 3800,
      "category": "Bakery"
    }
  ]
}''',
    ),
    ShowcaseEndpoint(
      id: "kisbey-sale",
      method: "POST",
      path: "/commands/sales.complete",
      group: "SALES",
      summary: "Idempotent sale completion. Requires an open shift.",
      requestJson: '''
{
  "commandId": "cmd_7f21",
  "registerId": "till_1",
  "items": [
    {
      "productId": "prd_flat_white",
      "quantity": 2,
      "modifiers": ["oat_milk"]
    }
  ]
}''',
      responseStatus: 201,
      responseMs: 164,
      responseJson: '''
{
  "id": "sale_7281",
  "status": "COMPLETED",
  "totalCents": 8400,
  "currency": "ZAR",
  "createdAt": "2026-09-06T07:14:22Z"
}''',
    ),
    ShowcaseEndpoint(
      id: "kisbey-today",
      method: "QUERY",
      path: "todaySummary",
      group: "GRAPHQL",
      summary: "Read-only till summary. Not a financial mutation.",
      requestJson: """
{
  todaySummary {
    saleCount
    totalCents
  }
}""",
      responseMs: 72,
      responseJson: '''
{
  "data": {
    "todaySummary": {
      "saleCount": 18,
      "totalCents": 76400
    }
  }
}''',
      note: "GraphQL is query-only. Completing or voiding a sale is a REST command.",
    ),
  ],
  schema: SchemaGraph(
    caption: "Excerpt only — tenant scoping, registers, catalogue, and sales. Not the full commercial schema.",
    entities: [
      SchemaEntity(
        name: "Tenant",
        fields: ["id", "name", "currencyCode", "entitledProducts"],
      ),
      SchemaEntity(
        name: "Register",
        fields: ["id", "tenantId", "locationId", "name"],
      ),
      SchemaEntity(
        name: "Product",
        fields: ["id", "tenantId", "name", "priceCents"],
      ),
      SchemaEntity(
        name: "Sale",
        fields: ["id", "tenantId", "registerId", "status", "totalCents"],
      ),
    ],
    relations: [
      SchemaRelation(from: "Register", to: "Tenant", label: "tenantId"),
      SchemaRelation(from: "Product", to: "Tenant", label: "tenantId"),
      SchemaRelation(from: "Sale", to: "Tenant", label: "tenantId"),
      SchemaRelation(from: "Sale", to: "Register", label: "registerId"),
    ],
  ),
  architecture: ArchitectureGraph(
    caption: "Flutter desktop/mobile clients keep a local store. The API splits writes and reads.",
    layers: [
      ["Flutter Desktop", "Flutter Mobile"],
      ["Local SQLite", "Sync Engine"],
      ["REST Commands", "GraphQL Queries"],
      ["NestJS"],
      ["Prisma", "PostgreSQL"],
    ],
  ),
  infrastructure: [
    InfraNote(label: "Local today", detail: "Docker Compose Postgres + NestJS on localhost. Seeded Demo Café users and catalogue."),
    InfraNote(label: "Infrastructure as Code", detail: "AWS CDK stages kisbey-dev and kisbey-prod. Synth works; VPC/RDS/Cognito/ECS are designed, not deployed."),
    InfraNote(label: "Authentication", detail: "Local JWT sign-in. Cognito is the intended cloud identity."),
    InfraNote(label: "API", detail: "REST command ingest + Apollo GraphQL reads. No financial mutations on GraphQL."),
    InfraNote(label: "Compute (target)", detail: "ECS Fargate behind an ALB, provisioned in a later CDK phase."),
    InfraNote(label: "Database", detail: "PostgreSQL locally; Aurora PostgreSQL is the cloud target."),
    InfraNote(label: "Storage", detail: "Seeded catalogue media locally; S3 is the designed object store."),
  ],
);
