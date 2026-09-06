import "package:cv_app/domain/showcase/showcase_models.dart";

/// Featured FastAPI + RAG + phishing inference case study.
const secureAiCaseStudy = CaseStudy(
  slug: "secure-ai-api",
  title: "Secure AI Platform",
  subtitle: "FastAPI service for phishing inference and RAG, consumed by Flutter and React Native clients.",
  year: "2026",
  role: "Software Engineer",
  platform: "API / Docker / Clients",
  index: 2,
  githubUrl: "https://github.com/Krispy145/secure-ai-api",
  stack: [
    "FastAPI",
    "Python",
    "REST",
    "JWT",
    "OAuth2",
    "Docker",
    "GitHub Actions",
    "scikit-learn",
    "Flutter",
    "React Native",
  ],
  problem:
      "A phishing classifier and a small RAG knowledge base needed a single authenticated HTTP surface that Flutter, React, and React Native clients could share — without standing up a paid cloud API for a portfolio.",
  solution:
      "Built a FastAPI service with OAuth2/JWT, rate limiting, CORS for localhost clients, Docker Compose, and auto-generated OpenAPI. The phishing model is trained in a sibling repo and loaded at process start; RAG retrieves from a sample knowledge base.",
  product:
      "Clients authenticate, classify a URL, list labelled samples, and ask a RAG question. Flutter and React Native chat apps stream against `/v1/rag/query`. This portfolio hosts the OpenAPI excerpt and a deterministic playground instead of keeping uvicorn running in production.",
  result:
      "A documented, tested API with CI, Docker, and reusable IAM clients. Honest constraint: the service is local (Docker / uvicorn on :8000). The showcase simulates the contract so a recruiter can exercise it without a deploy bill.",
  decisions: [
    EngineeringDecision(
      title: "One API, many clients",
      detail: "Auth, phishing, and RAG share JWT middleware. Flutter IAM and React Native IAM packages implement login/refresh against the same token endpoints.",
    ),
    EngineeringDecision(
      title: "Classifier as a library, not a second service",
      detail: "phishing-classifier trains and exports the model. secure-ai-api loads it at startup and falls back to a stub if the artifact is missing — useful for CI and first-run Docker.",
    ),
    EngineeringDecision(
      title: "OpenAPI as the contract",
      detail: "FastAPI emits `/docs`. The portfolio copies that spec rather than screenshotting Swagger. The playground uses fixtures so the public site never depends on localhost.",
    ),
    EngineeringDecision(
      title: "Rate limits on inference paths",
      detail: "Phishing and RAG routes are rate-limited. Health and ping stay exempt so clients can probe connectivity cheaply.",
    ),
  ],
  relatedRepos: [
    RelatedRepo(
      name: "secure-ai-api",
      description: "FastAPI service — JWT, RAG, phishing, Docker, CI.",
      url: "https://github.com/Krispy145/secure-ai-api",
    ),
    RelatedRepo(
      name: "phishing-classifier",
      description: "Feature-engineered scikit-learn pipeline served by the API.",
      url: "https://github.com/Krispy145/phishing-classifier",
    ),
    RelatedRepo(
      name: "flutter-ai-chat-rag",
      description: "Flutter RAG chat client with streaming UI.",
      url: "https://github.com/Krispy145/flutter-ai-chat-rag",
    ),
    RelatedRepo(
      name: "react-native-chat-rag",
      description: "Expo RAG chat client against the same API.",
      url: "https://github.com/Krispy145/react-native-chat-rag",
    ),
  ],
  endpoints: [
    ShowcaseEndpoint(
      id: "secure-login",
      method: "POST",
      path: "/auth/login",
      group: "AUTH",
      summary: "Password login. Also exposed as OAuth2 `/v1/auth/token`.",
      requestJson: '''
{
  "username": "demo",
  "password": "demo-password"
}''',
      responseMs: 110,
      responseJson: '''
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…",
  "refresh_token": "rt_9c21…",
  "token_type": "bearer",
  "expires_in": 1800
}''',
    ),
    ShowcaseEndpoint(
      id: "secure-predict",
      method: "POST",
      path: "/v1/predict/phishing",
      group: "PHISHING",
      summary: "Classify a URL. Requires a bearer token.",
      requestJson: '''
{
  "url": "https://bit.ly/suspicious-link"
}''',
      responseMs: 187,
      responseJson: '''
{
  "input_url": "https://bit.ly/suspicious-link",
  "prediction": "phishing",
  "confidence": 0.88,
  "score": 0.88
}''',
    ),
    ShowcaseEndpoint(
      id: "secure-rag",
      method: "POST",
      path: "/v1/rag/query",
      group: "RAG",
      summary: "Retrieve context and generate an answer from the sample knowledge base.",
      requestJson: '''
{
  "query": "How does the phishing classifier score a URL?",
  "n_results": 3,
  "max_tokens": 400
}''',
      responseMs: 240,
      responseJson: '''
{
  "query": "How does the phishing classifier score a URL?",
  "response": "The service extracts engineered features from the URL and runs the exported scikit-learn model. A score closer to 1.0 indicates phishing.",
  "sources": ["kb/phishing-features.md", "kb/api-contract.md"],
  "confidence": 0.81,
  "retrieved_docs": 3
}''',
    ),
  ],
  schema: SchemaGraph(
    caption: "The API is mostly stateless. Auth tokens and a sample knowledge base are the durable pieces shown here.",
    entities: [
      SchemaEntity(
        name: "User",
        fields: ["id", "username", "passwordHash"],
      ),
      SchemaEntity(
        name: "RefreshToken",
        fields: ["id", "userId", "expiresAt", "revoked"],
      ),
      SchemaEntity(
        name: "KnowledgeChunk",
        fields: ["id", "source", "embedding", "text"],
      ),
      SchemaEntity(
        name: "PhishingSample",
        fields: ["id", "url", "label", "score"],
      ),
    ],
    relations: [
      SchemaRelation(from: "RefreshToken", to: "User", label: "userId"),
      SchemaRelation(from: "PhishingSample", to: "User", label: "requested by"),
    ],
  ),
  architecture: ArchitectureGraph(
    caption: "Clients share one FastAPI process. The classifier and RAG services initialize at startup.",
    layers: [
      ["Flutter", "React Native", "React"],
      ["JWT / OAuth2"],
      ["FastAPI"],
      ["Phishing Classifier", "RAG + Vector Store"],
    ],
  ),
  infrastructure: [
    InfraNote(label: "Runtime", detail: "uvicorn locally, or `docker-compose up --build`. No public cloud deploy."),
    InfraNote(label: "Documentation", detail: "OpenAPI at /docs and /redoc. This site embeds an exported excerpt."),
    InfraNote(label: "Authentication", detail: "OAuth2 password flow + JWT access/refresh. Rate-limited inference routes."),
    InfraNote(label: "CI/CD", detail: "GitHub Actions run pytest and image build. Deploy to a host is intentionally omitted."),
    InfraNote(label: "CORS", detail: "Configured for localhost Expo and Flutter web during development."),
  ],
);
