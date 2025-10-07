import "package:cv_package/domain/repositories/github/github_repo.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("GitHubRepo", () {
    test("should format date correctly as dd/mm/yyyy", () {
      // Arrange
      final repo = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime(2023, 12),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act
      final formattedDate = repo.updatedAtDdMMyyyy;

      // Assert
      expect(formattedDate, equals("01/12/2023"));
    });

    test("should format star count correctly", () {
      // Arrange
      final repo1 = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 1500,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final repo2 = GitHubRepo(
        name: "test-repo-2",
        htmlUrl: "https://github.com/user/test-repo-2",
        description: "A test repository",
        stargazersCount: 500,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(repo1.formattedStars, equals("1.5k"));
      expect(repo2.formattedStars, equals("500"));
    });

    test("should format fork count correctly", () {
      // Arrange
      final repo1 = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 2500,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final repo2 = GitHubRepo(
        name: "test-repo-2",
        htmlUrl: "https://github.com/user/test-repo-2",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 50,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(repo1.formattedForks, equals("2.5k"));
      expect(repo2.formattedForks, equals("50"));
    });

    test("should identify roadmap repository correctly", () {
      // Arrange
      final roadmapRepo = GitHubRepo(
        name: "ai-cyber-security-roadmap",
        htmlUrl: "https://github.com/user/ai-cyber-security-roadmap",
        description: "AI Cyber Security Roadmap",
        stargazersCount: 100,
        forksCount: 20,
        updatedAt: DateTime.now(),
        language: "Markdown",
        topics: ["ai", "security", "roadmap"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final regularRepo = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(roadmapRepo.isRoadmap, equals(true));
      expect(regularRepo.isRoadmap, equals(false));
    });

    test("should determine if repository is displayable correctly", () {
      // Arrange
      final publicRepo = GitHubRepo(
        name: "public-repo",
        htmlUrl: "https://github.com/user/public-repo",
        description: "A public repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final privateRepo = GitHubRepo(
        name: "private-repo",
        htmlUrl: "https://github.com/user/private-repo",
        description: "A private repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "private",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final archivedRepo = GitHubRepo(
        name: "archived-repo",
        htmlUrl: "https://github.com/user/archived-repo",
        description: "An archived repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: true,
        disabled: false,
        defaultBranch: "main",
      );

      final disabledRepo = GitHubRepo(
        name: "disabled-repo",
        htmlUrl: "https://github.com/user/disabled-repo",
        description: "A disabled repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: true,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(publicRepo.isDisplayable, equals(true));
      expect(privateRepo.isDisplayable, equals(false));
      expect(archivedRepo.isDisplayable, equals(false));
      expect(disabledRepo.isDisplayable, equals(false));
    });

    test("should handle null language correctly", () {
      // Arrange
      final repo = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(repo.displayLanguage, equals("Other"));
    });

    test("should implement equality correctly", () {
      // Arrange
      final repo1 = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final repo2 = GitHubRepo(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A different description",
        stargazersCount: 100,
        forksCount: 10,
        updatedAt: DateTime.now(),
        language: "JavaScript",
        topics: ["javascript", "web"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      final repo3 = GitHubRepo(
        name: "different-repo",
        htmlUrl: "https://github.com/user/different-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: DateTime.now(),
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act & Assert
      expect(repo1, equals(repo2)); // Same name
      expect(repo1, isNot(equals(repo3))); // Different name
      expect(repo1.hashCode, equals(repo2.hashCode));
      expect(repo1.hashCode, isNot(equals(repo3.hashCode)));
    });
  });
}
