import "package:cv_app/dependencies/injection.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:theme/data/repositories/theme_configuration.dart";
import "package:theme/domain/repositories/theme.repository.dart";
import "package:theme/extensions/build_context.dart";
import "package:theme/presentation/changer/changer.dart";
import "package:utilities/sizes/spacers.dart";

/// [DevAppBar] is a class that defines the main app bar of the app.
class DevAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// [DevAppBar] ructor.
  DevAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  final store = Managers.config;
  final appWrapperStore = Managers.appWrapperStore;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return SafeArea(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: store.showDevTools ? preferredSize.height : 0,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: preferredSize.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: Managers.themeStateStore.toggleThemeMode,
                        icon: Icon(
                          Icons.brightness_4,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => ThemeChanger.currentColorThemeChanger(
                          context: context,
                        ),
                        icon: Icon(
                          Icons.palette,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Colors",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => ThemeChanger.currentColorThemeFromImageChanger(
                          context: context,
                        ),
                        icon: Icon(
                          Icons.upload_file_outlined,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Colors from Image",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () => ThemeChanger.currentTextStylesThemeChanger(
                          context: context,
                        ),
                        icon: Icon(
                          Icons.text_fields_rounded,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Text Styles",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: () {
                          ThemeChanger.currentThemeChanger(context: context);
                        },
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Components",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: ThemeChanger.updateThemeInRepository,
                        icon: Icon(
                          Icons.save,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Save Theme to DB",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: appWrapperStore.updateUserDetails,
                        icon: Icon(
                          Icons.save,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Save User Details to DB",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      TextButton.icon(
                        onPressed: ThemeChanger.saveJsonToFile,
                        icon: Icon(
                          Icons.download,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                        label: Text(
                          "Download",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      // TextButton.icon(
                      //   onPressed: () => ThemeChanger.saveJsonToDatabase(context),
                      //   i Icon(Icons.upload,size: store.showDevTools?24:0,),
                      //   label:  Text("Upload to DO",style: context.textTheme.bodySmall?.copyWith(color:context.colorScheme.onSurfacee),),
                      // ),

                      // / Uncomment the following code to enable the upload button.
                      // / This button will upload the current theme to the repository.
                      // / NB: Useful only when uploading from assets to a backend database.
                      Sizes.s.spacer(axis: Axis.horizontal),
                      IconButton(
                        onPressed: () => ThemeChanger.updateThemeInRepository(
                          repository: ThemeRepository(
                            baseThemeConfiguration: const ThemeConfiguration.firestore(
                              collectionPath: "baseThemes",
                            ),
                            componentThemesConfiguration: const ThemeConfiguration.firestore(
                              collectionPath: "componentsThemes",
                            ),
                          ),
                        ),
                        icon: Icon(
                          Icons.upload,
                          size: store.showDevTools ? 24 : 0,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
