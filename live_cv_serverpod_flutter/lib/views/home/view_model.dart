// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/enums/description.dart';
import 'package:live_cv_serverpod_flutter/enums/icon.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:live_cv_serverpod_flutter/widgets/description_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/svg_image.dart';

class HomeViewModel extends ChangeNotifier {
  final double sectionWidth = screenWidth / 3;

  late final List<ImageDescription> porfolios;
  late final List<SourceIcon> moreItems;
  late final List<Description> experienceItems;
  late final List<Description> educationItems;
  late final List<Description> courseItems;
  late final List<Description> referenceItems;

  late final ImageDescription profile;
  late final Description about;
  late final Description location;
  late final List<Description> contactItems;
  bool _busy = false;
  bool get busy => _busy;
  HomeViewModel() {
    setupViewModel();
  }

  setupViewModel() async {
    setBusy();
    await getProfile();
    await getPortfolios();
    await getExperienceItems();
    await getEducationItems();
    await getCourseItems();
    await getreferenceItems();
    await getAbout();
    await getLocation();
    await getMoreItems();
    await getContactItems();
    setBusy();
  }

  void setBusy() {
    _busy = !_busy;
    notifyListeners();
  }

  Future<void> getPortfolios() async {
    porfolios = await Managers.api.imageDescription.fetchListByType(DescriptionType.portfolio.name);
  }

  Future<void> getExperienceItems() async {
    experienceItems = await Managers.api.description.fetchListByType(DescriptionType.experience.name);
  }

  Future<void> getEducationItems() async {
    educationItems = await Managers.api.description.fetchListByType(DescriptionType.education.name);
  }

  Future<void> getCourseItems() async {
    courseItems = await Managers.api.description.fetchListByType(DescriptionType.courses.name);
  }

  Future<void> getreferenceItems() async {
    referenceItems = await Managers.api.description.fetchListByType(DescriptionType.references.name);
  }

  Future<void> getProfile() async {
    List<ImageDescription> result = await Managers.api.imageDescription.fetchListByType(DescriptionType.profile.name);
    profile = result.first;
  }

  Future<void> getAbout() async {
    List<Description> result = await Managers.api.description.fetchListByType(DescriptionType.about.name);
    about = result.first;
  }

  Future<void> getContactItems() async {
    contactItems = await Managers.api.description.fetchListByType(DescriptionType.contact.name);
  }

  Future<void> getLocation() async {
    List<Description> result = await Managers.api.description.fetchListByType(DescriptionType.location.name);
    location = result.first;
  }

  Future<void> getMoreItems() async {
    moreItems = await Managers.api.icon.fetchListByType(IconType.more.name);
  }

  List<Widget> get details => [
        DescriptionContainer(
          description: location,
          textColor: Colors.white,
        ),
        SingleChildScrollView(
          child: Column(
            children: contactItems
                .map(
                  (e) => DescriptionContainer(
                    description: e,
                    padding: const AppEdgeInsets.zero(),
                    textColor: Colors.white,
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
            padding: AppEdgeInsets.all(Sizes.xs),
            child: Column(
              children: [
                Sizes.m.spacer(),
                Text(
                  "MORE ABOUT ME",
                  style: AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                Sizes.s.spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: moreItems.map((e) => SVGImage(sourceIcon: e)).toList(),
                )
              ],
            ))
      ];
}
