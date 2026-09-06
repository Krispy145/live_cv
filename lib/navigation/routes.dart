import "package:auto_route/auto_route.dart";

import "routes.gr.dart";

/// [AppRouter] is the router of the app.
@AutoRouterConfig(replaceInRouteName: "View,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          initial: true,
          page: AppWrapperRoute.page,
          children: [
            AutoRoute(
              path: "",
              initial: true,
              page: LandingRoute.page,
            ),
            AutoRoute(
              path: "work/:slug",
              page: CaseStudyRoute.page,
            ),
            AutoRoute(
              path: "engineering",
              page: EngineeringRoute.page,
            ),
            AutoRoute(
              path: "about",
              page: AboutRoute.page,
            ),
            AutoRoute(
              path: "projects",
              page: ProjectsRoute.page,
            ),
          ],
        ),
      ];
}
