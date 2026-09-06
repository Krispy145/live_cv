import "package:cv_app/domain/showcase/showcase_models.dart";

/// Featured reusable IAM + API client case study.
const authClientsCaseStudy = CaseStudy(
  slug: "auth-clients",
  title: "Auth and API Clients",
  subtitle: "The same secured API consumed from Flutter and React Native.",
  year: "2026",
  role: "Software Engineer",
  platform: "Flutter / React Native / Packages",
  index: 4,
  githubUrl: "https://github.com/Krispy145/flutter-iam-package",
  stack: [
    "Flutter",
    "Dart",
    "React Native",
    "TypeScript",
    "JWT",
    "OAuth2",
    "Dio",
    "Axios",
    "BLoC",
    "Zustand",
  ],
  problem: "Secure AI API needed identical login, refresh, and authorised list/predict flows from Flutter and Expo — without copying interceptors into every app.",
  solution:
      "Extracted IAM packages: Flutter (Dio interceptors, session restore, route-guard hooks) and React Native (Axios, SecureStore, Zustand, web localStorage). Showcase apps then demonstrate pagination, caching, and a phishing-samples list against the same token contract.",
  product:
      "flutter-api-showcase: Pexels grid, JWT login, /ping, phishing samples (BLoC + Hive). react-native-api-showcase: the same flows on Expo. The packages are the reusable layer; the showcases are the proof they work.",
  result: "Auth is a dependency, not a feature rewrite. This is the case study that shows client architecture across frameworks — not another Flutter-only screenshot grid.",
  decisions: [
    EngineeringDecision(
      title: "Packages first, apps second",
      detail: "Login, refresh, logout, and attach-bearer live in IAM packages. Showcase apps import them instead of owning token storage.",
    ),
    EngineeringDecision(
      title: "Same HTTP semantics, native storage",
      detail: "Flutter uses secure storage / shared preferences depending on platform. Expo uses SecureStore on device and localStorage on web. The wire format stays JWT.",
    ),
    EngineeringDecision(
      title: "Okta / Azure later, password JWT now",
      detail: "flutter-iam-package is structured for OIDC (Okta, Azure AD) but the working path today is password login against Secure AI API. The roadmap does not pretend IdP is done.",
    ),
    EngineeringDecision(
      title: "Different state libraries, same contract",
      detail: "Flutter showcase uses BLoC; React Native uses Zustand. The interesting part is the interceptor and refresh behaviour, not a single UI framework.",
    ),
  ],
  relatedRepos: [
    RelatedRepo(
      name: "flutter-iam-package",
      description: "Flutter JWT/OIDC package: login, refresh, Dio interceptors.",
      url: "https://github.com/Krispy145/flutter-iam-package",
    ),
    RelatedRepo(
      name: "flutter-api-showcase",
      description: "BLoC + Dio + Hive showcase against Secure AI API and Pexels.",
      url: "https://github.com/Krispy145/flutter-api-showcase",
    ),
    RelatedRepo(
      name: "react-native-iam-package",
      description: "Zustand + Axios + SecureStore IAM layer.",
      url: "https://github.com/Krispy145/react-native-iam-package",
    ),
    RelatedRepo(
      name: "react-native-api-showcase",
      description: "Expo showcase: login, Pexels, ping, phishing samples.",
      url: "https://github.com/Krispy145/react-native-api-showcase",
    ),
  ],
  endpoints: [
    ShowcaseEndpoint(
      id: "iam-login",
      method: "POST",
      path: "/auth/login",
      group: "AUTH",
      summary: "Package login. Tokens are stored by the IAM layer, not the screen.",
      requestJson: '''
{
  "username": "demo",
  "password": "demo-password"
}''',
      responseMs: 108,
      responseJson: '''
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…",
  "refresh_token": "rt_9c21…",
  "token_type": "bearer"
}''',
    ),
    ShowcaseEndpoint(
      id: "iam-refresh",
      method: "POST",
      path: "/auth/refresh",
      group: "AUTH",
      summary: "Interceptor-driven refresh when a 401 is seen.",
      requestJson: '''
{
  "refresh_token": "rt_9c21…"
}''',
      responseMs: 74,
      responseJson: '''
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9…",
  "refresh_token": "rt_rotated…",
  "token_type": "bearer"
}''',
    ),
    ShowcaseEndpoint(
      id: "iam-samples",
      method: "GET",
      path: "/phishing/samples",
      group: "PHISHING",
      summary: "Authorised list used by both showcase apps.",
      requestJson: "{}",
      responseMs: 91,
      responseJson: '''
{
  "items": [
    {
      "id": "1",
      "url": "https://www.google.com",
      "label": "legitimate",
      "score": 0.12
    },
    {
      "id": "3",
      "url": "https://bit.ly/suspicious-link",
      "label": "phishing",
      "score": 0.88
    }
  ]
}''',
    ),
    ShowcaseEndpoint(
      id: "iam-logout",
      method: "POST",
      path: "/auth/logout",
      group: "AUTH",
      summary: "Revoke refresh and clear secure storage.",
      requestJson: "{}",
      responseStatus: 204,
      responseMs: 52,
      responseJson: "{}",
    ),
  ],
  schema: SchemaGraph(
    caption: "Client-side session, not a new database. Tokens are the only durable client state.",
    entities: [
      SchemaEntity(
        name: "Session",
        fields: ["accessToken", "refreshToken", "expiresAt"],
      ),
      SchemaEntity(
        name: "UserProfile",
        fields: ["id", "username"],
      ),
      SchemaEntity(
        name: "CachedSample",
        fields: ["id", "url", "label", "score"],
      ),
    ],
    relations: [
      SchemaRelation(from: "Session", to: "UserProfile", label: "owns"),
      SchemaRelation(from: "CachedSample", to: "Session", label: "fetched with"),
    ],
  ),
  architecture: ArchitectureGraph(
    caption: "Two IAM packages sit in front of the same FastAPI process.",
    layers: [
      ["flutter-api-showcase", "react-native-api-showcase"],
      ["flutter-iam-package", "react-native-iam-package"],
      ["Secure AI API"],
    ],
  ),
  infrastructure: [
    InfraNote(label: "Clients", detail: "Flutter (BLoC, Dio, Hive) and Expo (Zustand, Axios, SecureStore)."),
    InfraNote(label: "Auth storage", detail: "Platform secure storage on device; localStorage on RN web."),
    InfraNote(label: "Backend", detail: "Same local Secure AI API. This playground uses fixtures, not localhost."),
    InfraNote(label: "Identity providers", detail: "Password JWT works today. Okta/Azure AD is planned, not shipped."),
  ],
);
