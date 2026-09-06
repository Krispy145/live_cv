Yes. I think there is a significantly better way to present your portfolio than a conventional developer site with screenshots and GitHub links.

Given your background, I'd make the portfolio itself a **Flutter Web application** that demonstrates your engineering ability while presenting individual projects as **case studies**.

## 1. Overall concept: an interactive engineering portfolio

Rather than:

> Home → About → Projects → Contact

I'd build something closer to a polished **developer workspace / product showcase**.

### Hero

```text
┌──────────────────────────────────────────────────────────────────────┐
│  DAVID KISBEY-GREEN                                      Contact ↗  │
│                                                                      │
│  Software Engineer                                                   │
│  Mobile • Full Stack • Cloud                                         │
│                                                                      │
│  I build production-grade applications from                          │
│  Flutter interfaces through to cloud infrastructure.                 │
│                                                                      │
│  [ Explore my work ]     [ GitHub ↗ ]                                │
│                                                                      │
│     Flutter     Dart     TypeScript     AWS     PostgreSQL            │
└──────────────────────────────────────────────────────────────────────┘
```

Then immediately transition into **selected engineering projects**.

The site itself becomes evidence that you can build responsive Flutter Web applications.

---

# 2. Don't just show Flutter screenshots — let people use the apps

This is where using Flutter Web for the portfolio gives you an interesting opportunity.

For each compatible Flutter project, have:

**Live Demo** | **Case Study** | **Architecture** | **Source**

For example:

```text
┌─────────────────────────────────────────────────────────────────────┐
│  Kisbey POS                                              2026       │
│                                                                     │
│  Modern point-of-sale platform for retail                           │
│  and hospitality businesses.                                        │
│                                                                     │
│  Flutter • Dart • AWS • PostgreSQL • GraphQL                        │
│                                                                     │
│  ┌────────────────────────────┐      THE CHALLENGE                   │
│  │                            │                                     │
│  │       LIVE APP             │      Multi-device POS requiring     │
│  │       PREVIEW              │      offline operation, reliable    │
│  │                            │      synchronisation and...          │
│  │                            │                                     │
│  └────────────────────────────┘      [ Launch Demo ↗ ]               │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

If possible, create **portfolio/demo builds** of your Flutter applications containing seeded data.

A recruiter can click:

> **Launch interactive demo**

and actually interact with the application.

That's much stronger evidence than six screenshots.

For mobile-only apps, create a simulated device frame:

```text
                     ┌─────────────────┐
                     │                 │
                     │                 │
                     │   YOUR FLUTTER  │
                     │      APP        │
                     │                 │
                     │                 │
                     └─────────────────┘

              ← click / scroll / interact →
```

You can even have controls:

**iPhone** | **Android** | **Tablet** | **Desktop**

and dynamically resize the demo where appropriate.

---

# 3. Make each project an engineering case study

This is probably the most important part.

Don't make projects:

> **My POS App**
>
> This is a POS application I created using Flutter and AWS.
>
> Flutter • AWS • GraphQL
>
> [GitHub]

Instead tell me **what you engineered**.

I'd use six sections:

**Overview → Problem → Solution → Architecture → Engineering Decisions → Result**

For example:

### Kisbey POS

**Problem**

> Retail POS systems need to remain operational despite unreliable connectivity while maintaining consistent cloud state across multiple terminals.

**Solution**

> Designed an offline-first Flutter client backed by a cloud synchronization architecture on AWS.

Then:

### Architecture

```text
Flutter Desktop
      │
      ├── Local Database
      │
      └── Sync Engine
             │
             ▼
        API / GraphQL
             │
        ┌────┴────┐
        ▼         ▼
     Lambda    AppSync
        │
        ▼
   PostgreSQL
```

Then describe **your decisions**.

That's what distinguishes an engineer from somebody who followed a tutorial.

---

# 4. Backend projects: Swagger screenshots aren't enough

To your specific question:

> Is having a Swagger doc screenshot a good idea?

**Yes — but only as one component.**

A screenshot of Swagger essentially proves:

> "An API exists."

It doesn't demonstrate much engineering.

Instead I'd create a dedicated **Backend/API case-study format**.

For example:

# Restaurant Management API

```text
REST API • TypeScript • Node.js • PostgreSQL • AWS
```

Then show four things.

### ① Architecture

This should be the primary visual.

```text
                 Client
                    │
                    ▼
              API Gateway
                    │
                    ▼
             Lambda / Node
                    │
             ┌──────┴──────┐
             ▼             ▼
        PostgreSQL         S3
             │
          Prisma
```

A recruiter understands the system in about five seconds.

---

### ② Interactive API documentation

Rather than **only showing a Swagger screenshot**, actually host the Swagger/OpenAPI documentation.

Have:

> **Explore API Documentation →**

You can still include an attractive cropped screenshot:

```text
┌─────────────────────────────────────────────┐
│ Restaurant API                     v1.2.0   │
│                                             │
│ AUTH                                        │
│ POST   /auth/login                          │
│ POST   /auth/refresh                        │
│                                             │
│ PRODUCTS                                    │
│ GET    /products                            │
│ POST   /products                            │
│ GET    /products/{id}                       │
│ PATCH  /products/{id}                       │
│                                             │
│ ORDERS                                      │
│ POST   /orders                              │
│ GET    /orders/{id}                         │
└─────────────────────────────────────────────┘
```

Then:

**View documentation ↗**

That's much better.

---

# 5. Show actual request → response examples

This is especially useful for backend work.

Have a small interactive component on the portfolio:

```text
POST /api/v1/orders

REQUEST
─────────────────────────────────────

{
  "tableId": "tbl_102",
  "items": [
    {
      "productId": "prd_481",
      "quantity": 2
    }
  ]
}

                         [ Send Request ]
```

Then animate/display:

```text
201 Created                           143ms

{
  "id": "ord_7281",
  "status": "OPEN",
  "total": 284.00,
  "createdAt": "2026-09-06T07:14:22Z"
}
```

Now you're demonstrating:

**API design + HTTP semantics + data modelling + frontend integration.**

Much stronger.

You don't necessarily even need to send a real request. A deterministic portfolio simulation can communicate the concept without keeping demo infrastructure running.

---

# 6. Show your database design

For backend/full-stack positions, I'd absolutely include this.

For example:

```text
┌──────────────┐          ┌──────────────┐
│ Restaurant   │          │ Product      │
├──────────────┤          ├──────────────┤
│ id           │───┐      │ id           │
│ name         │   │      │ name         │
│ tenantId     │   │      │ price        │
└──────────────┘   │      │ restaurantId │
                   │      └──────┬───────┘
                   │             │
                   ▼             ▼
              ┌─────────────────────┐
              │       Order         │
              ├─────────────────────┤
              │ id                  │
              │ restaurantId        │
              │ status              │
              │ total               │
              └─────────────────────┘
```

Again, don't dump the entire production schema.

Show enough to demonstrate:

* relational modelling
* foreign keys
* multi-tenancy
* indexes
* constraints
* normalization
* scalability decisions

---

# 7. Infrastructure deserves its own section

This is particularly important if you're trying to broaden yourself beyond Flutter.

Have an **Infrastructure** tab on appropriate projects.

For example:

```text
                    AWS
                     │
        ┌────────────┼────────────┐
        │            │            │
     Cognito      AppSync         S3
        │            │
        │         Lambda
        │            │
        └────────────┤
                     ▼
              Aurora PostgreSQL
```

Underneath:

> **Infrastructure as Code**
>
> AWS CDK / Terraform

> **Authentication**
>
> Cognito + JWT

> **API**
>
> AppSync GraphQL

> **Compute**
>
> Lambda

> **Database**
>
> Aurora PostgreSQL

> **Storage**
>
> S3

That immediately makes you look considerably broader than a Flutter developer.

---

# 8. Have an "Engineering" view rather than a Skills page

I'd avoid the typical:

### Skills

██████████ Flutter 95%
████████░░ AWS 80%
███████░░░ TypeScript 70%

Those percentages are meaningless.

Instead:

## Engineering Stack

```text
APPLICATION
Flutter    Dart    React    TypeScript

BACKEND
Node.js    GraphQL    REST    Prisma

CLOUD
AWS    Lambda    AppSync    Cognito    S3

DATA
PostgreSQL    Aurora    Firebase

INFRASTRUCTURE
Docker    CDK    Terraform    CI/CD
```

Each technology can optionally link to **projects where you actually used it**.

Click:

> AWS Lambda

and the site shows:

**Used in 4 projects**

That's much more credible.

---

# 9. Your projects should demonstrate different competencies

Don't put ten Flutter applications on there.

I'd rather see **4 excellent case studies**.

For you, I'd aim for something like:

| Project                              | What it proves                                       |
| ------------------------------------ | ---------------------------------------------------- |
| **Kisbey POS**                       | Flutter + architecture + serious product engineering |
| **Production-style AWS application** | Full-stack + AWS + infrastructure                    |
| **AI/RAG application**               | Modern AI application engineering                    |
| **API/backend project**              | TypeScript + API design + PostgreSQL + Docker        |

Then perhaps a smaller:

**Other Work**

section containing additional Flutter applications.

That prevents the portfolio screaming:

> MOBILE DEVELOPER ONLY

which is precisely what I'd try to get away from in your job search.

---

# 10. I'd make the UI fairly sophisticated

Given your recent Kisbey Technologies UI work, I'd go for a restrained engineering/product aesthetic rather than the clichéd developer portfolio with neon gradients and giant code snippets.

Something like:

```text
DAVID KISBEY-GREEN                           Work   Engineering   About

─────────────────────────────────────────────────────────────────────


Software Engineer

Building applications from
interface to infrastructure.

Flutter / TypeScript / AWS / PostgreSQL


[ Explore my work ↓ ]


─────────────────────────────────────────────────────────────────────


SELECTED WORK


01     KISBEY POS                                      FEATURED

       Point-of-sale infrastructure for
       modern hospitality and retail.

       Flutter     AWS     PostgreSQL     GraphQL

       ┌────────────────────────────────────────────┐
       │                                            │
       │            PRODUCT VISUAL                  │
       │                                            │
       └────────────────────────────────────────────┘

       View case study  →


─────────────────────────────────────────────────────────────────────


02     CLOUD PLATFORM

       Serverless application architecture
       built on AWS.

       TypeScript     Lambda     Cognito     Aurora

                                      View architecture  →


─────────────────────────────────────────────────────────────────────
```

Lots of whitespace. Strong typography. Very little decoration. Let the **products** provide the visual complexity.

---

## And there's one feature I'd particularly recommend

At the top of each case study:

```text
KISBEY POS

Modern point-of-sale infrastructure
for hospitality and retail.

ROLE
Software Engineer

PLATFORM
Desktop / Mobile / Cloud

STACK
Flutter • AWS • PostgreSQL • GraphQL

YEAR
2026


[ Live Demo ]   [ GitHub ]   [ Architecture ]
```

Then have a sticky sub-navigation:

```text
Overview   Product   Architecture   API   Engineering   Results
```

Now a recruiter can either spend **30 seconds looking at the product** or a technical interviewer can spend **10 minutes examining how you built it**.

That's exactly the two audiences your portfolio needs to serve.

And yes, put Swagger in there — just don't make **Swagger the backend portfolio**. **Architecture diagram + API documentation + request/response examples + data model + deployment/infrastructure + technical decisions** is a much stronger demonstration of backend competence.

If you build this properly in Flutter Web, the portfolio itself becomes **project #0**: responsive design, routing, animations, reusable components, state management, performance, accessibility and deployment are all being demonstrated before anyone even opens one of your projects.
