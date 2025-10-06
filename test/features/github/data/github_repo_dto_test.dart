import "package:cv_app/features/github/data/github_repo_dto.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("GitHubRepoDto", () {
    test("should create DTO from JSON correctly", () {
      // Arrange
      final json = {
        "name": "test-repo",
        "html_url": "https://github.com/user/test-repo",
        "description": "A test repository",
        "stargazers_count": 42,
        "forks_count": 5,
        "updated_at": "2023-12-01T10:00:00Z",
        "language": "Dart",
        "topics": ["flutter", "dart", "test"],
        "visibility": "public",
        "archived": false,
        "disabled": false,
      };

      // Act
      final dto = GitHubRepoDto.fromJson(json);

      // Assert
      expect(dto.name, equals("test-repo"));
      expect(dto.htmlUrl, equals("https://github.com/user/test-repo"));
      expect(dto.description, equals("A test repository"));
      expect(dto.stargazersCount, equals(42));
      expect(dto.forksCount, equals(5));
      expect(dto.updatedAt, equals("2023-12-01T10:00:00Z"));
      expect(dto.language, equals("Dart"));
      expect(dto.topics, equals(["flutter", "dart", "test"]));
      expect(dto.visibility, equals("public"));
      expect(dto.archived, equals(false));
      expect(dto.disabled, equals(false));
    });

    test("should handle null values correctly", () {
      // Arrange
      final json = {
        "name": "test-repo",
        "html_url": "https://github.com/user/test-repo",
        "description": null,
        "stargazers_count": 0,
        "forks_count": 0,
        "updated_at": "2023-12-01T10:00:00Z",
        "language": null,
        "topics": null,
        "visibility": "public",
        "archived": false,
        "disabled": false,
      };

      // Act
      final dto = GitHubRepoDto.fromJson(json);

      // Assert
      expect(dto.description, isNull);
      expect(dto.language, isNull);
      expect(dto.topics, equals([]));
    });

    test("should convert to domain model correctly", () {
      // Arrange
      const dto = GitHubRepoDto(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: "2023-12-01T10:00:00Z",
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.name, equals("test-repo"));
      expect(domain.htmlUrl, equals("https://github.com/user/test-repo"));
      expect(domain.description, equals("A test repository"));
      expect(domain.stargazersCount, equals(42));
      expect(domain.forksCount, equals(5));
      expect(domain.language, equals("Dart"));
      expect(domain.topics, equals(["flutter", "dart"]));
      expect(domain.visibility, equals("public"));
      expect(domain.archived, equals(false));
      expect(domain.disabled, equals(false));
      expect(domain.isDisplayable, equals(true));
    });

    test("should handle roadmap repository correctly", () {
      // Arrange
      const dto = GitHubRepoDto(
        name: "ai-cyber-security-roadmap",
        htmlUrl: "https://github.com/user/ai-cyber-security-roadmap",
        description: "AI Cyber Security Roadmap",
        stargazersCount: 100,
        forksCount: 20,
        updatedAt: "2023-12-01T10:00:00Z",
        language: "Markdown",
        topics: ["ai", "security", "roadmap"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act
      final domain = dto.toDomain();

      // Assert
      expect(domain.isRoadmap, equals(true));
    });

    test("should serialize to JSON correctly", () {
      // Arrange
      const dto = GitHubRepoDto(
        name: "test-repo",
        htmlUrl: "https://github.com/user/test-repo",
        description: "A test repository",
        stargazersCount: 42,
        forksCount: 5,
        updatedAt: "2023-12-01T10:00:00Z",
        language: "Dart",
        topics: ["flutter", "dart"],
        visibility: "public",
        archived: false,
        disabled: false,
        defaultBranch: "main",
      );

      // Act
      final json = dto.toJson();

      // Assert
      expect(json["name"], equals("test-repo"));
      expect(json["html_url"], equals("https://github.com/user/test-repo"));
      expect(json["description"], equals("A test repository"));
      expect(json["stargazers_count"], equals(42));
      expect(json["forks_count"], equals(5));
      expect(json["updated_at"], equals("2023-12-01T10:00:00Z"));
      expect(json["language"], equals("Dart"));
      expect(json["topics"], equals(["flutter", "dart"]));
      expect(json["visibility"], equals("public"));
      expect(json["archived"], equals(false));
      expect(json["disabled"], equals(false));
    });
  });
}
