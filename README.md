# Pearl

A home asset management application built with Flutter. Pearl helps users track and manage appliances, systems, and fixtures across their homes — organizing assets by category with details like manufacturer, warranty dates, and notes.

**Live demo:** https://pearl-wheat.vercel.app/


| Web | Mobile |
| :-: | :-: |
| <video src=https://github.com/user-attachments/assets/197010f1-0b3b-44bb-bbc7-f160213b5b1f /> | <video src=https://github.com/user-attachments/assets/243098c3-b163-49ea-ad4c-2f950faacddf /> |










## Table of Contents

- [Setup and Running](#setup-and-running)
- [Design Choices](#design-choices)
- [Running Tests](#running-tests)
- [CI/CD](#cicd)
- [What I Would Do Next](#what-i-would-do-next)

---

## Setup and Running

This project requires **Flutter 3.38.9**. The recommended way to manage Flutter versions is through [FVM (Flutter Version Management)](https://fvm.app/). The project includes an `.fvmrc` file that pins the correct version automatically.

```bash
# Install the pinned Flutter version
fvm install

# Install dependencies
fvm flutter pub get

# Generate Hive adapters (required before first run)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Run on a connected device or emulator
fvm flutter run

# Run as a web app
fvm flutter run -d chrome
```

---

## Design Choices

### Project Structure — No Feature/Module Separation

The project follows a flat layered structure (`core/`, `domain/`, `data/`, `presentation/`, `infra/`) rather than a feature-based or modular architecture. This was a deliberate decision: the app has a small and well-defined scope (managing homes and their assets), with only a handful of screens and a single bounded context. Introducing feature folders or module boundaries would add indirection and boilerplate without any real benefit — there are no independent feature teams, no lazy-loading requirements, and no risk of cross-feature coupling at this scale. A layered structure keeps navigation simple and the dependency rules clear enough on its own.

This choice does have downstream consequences. Because there are no module boundaries, all dependency registration lives in a single function (see [What I Would Do Next](#what-i-would-do-next) for more on this trade-off).

### Domain Models vs Hive DTOs

The domain layer defines its own pure model classes (`HomeModel`, `AssetModel`, `AddressModel`) that have no knowledge of Hive. The data layer has separate Hive DTOs (`HomeHiveDto`, `AssetHiveDto`, `AddressHiveDto`) annotated with `@HiveType` and `@HiveField`, along with extension-based mappers to convert between the two.

This separation exists to keep the domain layer completely independent of the persistence mechanism. Hive annotations, generated adapters, and `HiveObject` inheritance are all data-layer concerns. If the storage solution were ever replaced (e.g., with a remote API or SQLite), the domain models and all business logic built on top of them would remain untouched. The mapping cost is minimal and the boundary it enforces is worth it.

### SubjectNotifier — Cross-Controller Communication

The `SubjectNotifier` is a lightweight pub/sub mechanism that allows controllers to react to changes in other controllers without depending on each other directly. For example, when a home is updated in the `HomeDetailController`, it dispatches a `Subject.home` event. The `HomeController` (which lists all homes) listens to that subject and refreshes its data automatically.

This arose from a concrete need: two independent screens needed to stay in sync, but having one controller reference another would create tight coupling and complicate testing. The `SubjectNotifier` acts as a simple event bus — controllers declare which subjects they listen to via the `SubjectListener` mixin and which they publish via the `SubjectDispatcher` mixin, keeping them fully decoupled.

### Fuzzy Search

The asset template catalog includes a fuzzy matching utility for searching. Instead of requiring exact substring matches, the search tolerates typos and partial input by scoring candidates based on character-sequence proximity. This provides a more forgiving search experience when users are browsing the asset catalog and may not remember exact names.

### Data Layer — Repository and Datasource Considerations

The repository currently accesses Hive directly because the requirement is strictly local persistence, so reducing layers was a deliberate choice to keep the codebase simple.
In a production scenario with a backend, I would introduce a datasource layer (Local/Hive and Remote/API). The repository would then coordinate between these sources, applying caching strategies, offline fallback, and synchronization logic.

---

## Running Tests

```bash
# Run all tests
fvm flutter test

# Run a specific test file
fvm flutter test test/domain/usecases/create_home_use_case_test.dart
```

### Test Structure

Tests mirror the `lib/` layout and cover all layers:

```
test/
├── core/              # SubjectNotifier, list extensions, fuzzy match
├── data/
│   ├── mappers/       # DTO <-> Model conversion tests
│   └── repositories/  # Hive repository implementation tests
├── domain/
│   └── usecases/      # All use case unit tests
├── presentation/
│   └── views/         # Controller unit tests
└── helpers/
    ├── fixtures.dart          # Factory functions for fake models/DTOs
    ├── mocks.dart             # mocktail mock classes
    └── hive_test_helper.dart  # Hive initialization for tests
```

- **Mocking:** Uses [mocktail](https://pub.dev/packages/mocktail) for creating mocks without code generation.
- **Either coverage:** Every use case and repository test covers both the success (`Right`) and failure (`Left`) paths.
- **Scope:** Unit tests for use cases, repositories, mappers, controllers, and core utilities.

---

## CI/CD

The project is deployed to [Vercel](https://vercel.com/), but **Vercel's automatic deploy on push is not used**. Instead, a custom GitHub Actions pipeline controls the deployment. This was done intentionally so that deployments only happen after all tests and static analysis have passed — Vercel's built-in auto-deploy has no awareness of test results and would deploy broken code.

### How It Works

Two workflows run in sequence:

**1. Tests Workflow** (`.github/workflows/tests.yml`)

Triggered on every push to `main` and on pull requests targeting `main`.

- Checks out the code
- Sets up Flutter 3.38.9 with dependency caching
- Runs `flutter pub get`
- Runs `flutter analyze` (static analysis / linting)
- Runs `flutter test`

If any step fails, the workflow fails and deployment is blocked.

**2. Deploy Workflow** (`.github/workflows/deploy.yml`)

Triggered **only** when the Tests workflow completes successfully on `main`. It uses the `workflow_run` event filtered by `conclusion == 'success'`, ensuring that a failed test run never results in a deployment.

- Creates a GitHub Deployment record (for audit trail and status tracking)
- Builds Flutter for web (`flutter build web`)
- Installs the Vercel CLI and pulls the project configuration
- Deploys to Vercel with the `--prod` flag
- Updates the GitHub Deployment status to `success` or `failure`

**Required repository secrets:** `VERCEL_TOKEN`, `VERCEL_PROJECT_ID`, `VERCEL_ORG_ID`.

### Pipeline Flow

```
Push to main / PR
       |
       v
  Tests Workflow
  (analyze + test)
       |
       v  (on success, main branch only)
  Deploy Workflow
  (build + deploy to Vercel)
```

---

## What I Would Do Next

- **Golden tests** — add screenshot-based widget tests to catch unintended UI regressions.
- **End-to-end tests** — use [Maestro](https://maestro.mobile.dev/) for full user-flow testing across platforms, covering real navigation, persistence, and interaction scenarios.
- **Rethink the service locator approach** — this is a direct trade-off of the flat layered structure described above. Since the project has no feature or module boundaries, all dependencies are registered in a single `setupServiceLocator()` function. For a small app this is straightforward, but it does not scale. As the project grows, that function becomes a monolithic registration list where every new use case, repository, and controller must be manually wired. There is no compile-time safety — if a dependency is missing or registered with the wrong type, the error only surfaces at runtime. It is also easy to introduce ordering bugs since registrations that depend on other registrations must come after them, and nothing enforces that. In a larger project with feature/module separation, each module would register its own dependencies, and I would move to a solution like `injectable` (code-generated DI based on annotations) to get compile-time guarantees and eliminate the manual wiring entirely.
