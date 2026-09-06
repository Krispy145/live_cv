import "package:cv_app/domain/showcase/showcase_models.dart";

/// Featured safety-first Flutter + NestJS case study.
const helpingHandCaseStudy = CaseStudy(
  slug: "helping-hand",
  title: "Helping Hand",
  subtitle: "Adults-only help requests that stay hidden until they are vetted.",
  year: "2026",
  role: "Software Engineer",
  platform: "Mobile / Web / API",
  index: 3,
  githubUrl: "https://github.com/Krispy145/helping_hand",
  stack: [
    "Flutter",
    "Dart",
    "NestJS",
    "TypeScript",
    "Prisma",
    "PostgreSQL",
    "Redis",
    "REST",
    "Docker",
    "Firebase",
  ],
  problem:
      "People who need help should be able to ask nearby adults — without exposing a raw request to the public feed, leaking chat text in push notifications, or trusting the client to mark someone 18+.",
  solution:
      "A Flutter mobile app and Pulse web surface talk to a NestJS API. Requests stay in draft until keyword/PII/crisis filters pass. Discovery uses approximate location. Chat is session-locked. Age eligibility is decided on the server (Yoti in staging/prod, in-process stub when keys are unset).",
  product:
      "Mobile: sign in, verify age, post a request, browse a vetted map/feed, offer help, chat in-session. Pulse: anonymous public totals plus a staff login for appeals. Shared Dart DTOs and a design-system package keep the two Flutter apps aligned.",
  result:
      "A public monorepo with explicit safety constraints: Flutter never marks an account verified, FCM payloads never include chat text, and the local stack (Postgres + Redis + Nest on :3000) can be run without Yoti credentials. This portfolio simulates the contract instead of hosting the API.",
  decisions: [
    EngineeringDecision(
      title: "Server owns eligibility",
      detail: "Yoti keys live only on the API. When they are unset, a stub completes verification for local development. The Flutter app never writes `verified: true`.",
    ),
    EngineeringDecision(
      title: "Vetting before discovery",
      detail: "Nearby helpers only see requests that have passed filters. Toxicity/LLM checks are still stubbed; keyword, PII, and crisis rules already gate the feed.",
    ),
    EngineeringDecision(
      title: "Session-locked chat",
      detail: "Messages exist only inside an accepted session. Either party can end or report. Push alerts are generic — no message body in the payload.",
    ),
    EngineeringDecision(
      title: "Approximate location on the feed",
      detail: "Discovery uses a coarse geo query. Precise coordinates are posted only after a session starts, and only for that session.",
    ),
  ],
  relatedRepos: [
    RelatedRepo(
      name: "helping_hand",
      description: "Flutter mobile, Pulse web, NestJS API, Prisma, Redis.",
      url: "https://github.com/Krispy145/helping_hand",
    ),
  ],
  endpoints: [
    ShowcaseEndpoint(
      id: "hh-login",
      method: "POST",
      path: "/auth/login",
      group: "AUTH",
      summary: "Email + password. JWT, not Firebase Auth.",
      requestJson: '''
{
  "email": "helper@example.com",
  "password": "local-dev"
}''',
      responseMs: 104,
      responseJson: '''
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…",
  "user": {
    "id": "usr_hel_01",
    "ageStatus": "verified",
    "role": "helper"
  }
}''',
    ),
    ShowcaseEndpoint(
      id: "hh-submit",
      method: "POST",
      path: "/requests/draft/{id}/submit",
      group: "REQUESTS",
      summary: "Move a draft into pending vetting. It is not on the feed yet.",
      requestJson: '''
{
  "id": "req_1042"
}''',
      responseStatus: 201,
      responseMs: 142,
      responseJson: '''
{
  "id": "req_1042",
  "status": "PENDING_VETTING",
  "category": "errand",
  "visibleToHelpers": false
}''',
    ),
    ShowcaseEndpoint(
      id: "hh-nearby",
      method: "GET",
      path: "/requests/nearby",
      group: "REQUESTS",
      summary: "Vetted requests only. Approximate geo.",
      requestJson: '''
{
  "category": "errand",
  "radiusKm": 3
}''',
      responseMs: 88,
      responseJson: '''
{
  "items": [
    {
      "id": "req_981",
      "category": "errand",
      "approxDistanceKm": 1.2,
      "status": "VETTED"
    }
  ]
}''',
    ),
    ShowcaseEndpoint(
      id: "hh-accept",
      method: "POST",
      path: "/requests/{id}/accept",
      group: "SESSIONS",
      summary: "Helper accepts. Creates a session-locked chat.",
      requestJson: '''
{
  "id": "req_981"
}''',
      responseStatus: 201,
      responseMs: 131,
      responseJson: '''
{
  "sessionId": "ses_441",
  "requestId": "req_981",
  "status": "OPEN",
  "chatLockedToSession": true
}''',
    ),
  ],
  schema: SchemaGraph(
    caption: "Request visibility is a status, not a client flag. Sessions own chat.",
    entities: [
      SchemaEntity(
        name: "User",
        fields: ["id", "email", "ageStatus", "role"],
      ),
      SchemaEntity(
        name: "HelpRequest",
        fields: ["id", "authorId", "status", "category", "approxGeo"],
      ),
      SchemaEntity(
        name: "Session",
        fields: ["id", "requestId", "helperId", "status"],
      ),
      SchemaEntity(
        name: "Message",
        fields: ["id", "sessionId", "body", "createdAt"],
      ),
    ],
    relations: [
      SchemaRelation(from: "HelpRequest", to: "User", label: "authorId"),
      SchemaRelation(from: "Session", to: "HelpRequest", label: "requestId"),
      SchemaRelation(from: "Message", to: "Session", label: "sessionId"),
    ],
  ),
  architecture: ArchitectureGraph(
    caption: "Pulse and mobile share models. Redis backs presence and rate limits.",
    layers: [
      ["Flutter Mobile", "Pulse Web"],
      ["NestJS API"],
      ["Prisma", "PostgreSQL", "Redis"],
      ["FCM", "Yoti (or local stub)"],
    ],
  ),
  infrastructure: [
    InfraNote(label: "Local today", detail: "Docker Postgres + Redis, API on :3000, Pulse on :8081."),
    InfraNote(label: "Authentication", detail: "JWT from Nest. Not Firebase Auth. FCM is used only for generic push."),
    InfraNote(label: "Age verification", detail: "Yoti on staging/prod. Empty YOTI_* keys activate an in-process stub. Do not treat the stub as a live identity service."),
    InfraNote(label: "Documentation", detail: "Nest Swagger at /api. This site uses an exported excerpt plus the published API contracts."),
    InfraNote(label: "Hosting", detail: "No paid public API. The portfolio playground is deterministic."),
  ],
);
