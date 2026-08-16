/// Logger feature flags for the CV app.
enum CVAppLoggers {
  /// App-level logging.
  cvApp,

  /// Dependency injection logging.
  dependencyInjection,

  /// GitHub integration logging.
  github,
}

/// Logger feature flags carried over from the former `cv_package`.
enum CVPackageLoggers {
  /// Package-level logging.
  cvPackage,
}
