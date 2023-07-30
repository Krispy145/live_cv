import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/footers/details/desktop.dart';
import 'package:live_cv_serverpod_flutter/architecture/footers/details/mobile.dart';
import 'package:live_cv_serverpod_flutter/enums/description.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/helpers/wrappers/scroll_index/wrapper.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/views/home/params.dart';
import 'package:live_cv_serverpod_flutter/views/home/view_model.dart';
import 'package:live_cv_serverpod_flutter/widgets/expandable_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/image_description_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/image_description_list_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/read_more_container.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final HomeParams? params;
  final Widget? footer;
  HomeView({Key? key, this.params, this.footer}) : super(key: key);

  final viewModel = HomeViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>.value(
        value: viewModel,
        builder: (context, w) => Consumer<HomeViewModel>(
              builder: (context, viewModel, _) => ScreenSize.valueForScreen(
                  mobile: viewModel.busy
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ScrollIndexWrapper(
                          itemsCount: 5,
                          bodyItemsBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return ImageDescriptionContainer.network(
                                  backgroundColor: Colors.blueGrey[700],
                                  textColor: Colors.white,
                                  padding: AppEdgeInsets.symmetric(vertical: Sizes.s),
                                  imageDescription: viewModel.profile,
                                );
                              case 1:
                                return ImageDescriptionListContainer(
                                  responsiveLayout: true,
                                  readMoreDialog: true,
                                  imageDescriptions: viewModel.porfolios,
                                );
                              case 2:
                                return ReadMoreContainer(
                                  textColor: Colors.white,
                                  backgroundColor: Colors.blueGrey[700],
                                  header: viewModel.about.header,
                                  subheader: viewModel.about.subheader,
                                  paragraph: viewModel.about.paragraph,
                                  type: DescriptionType.values.firstWhere((type) => type.name == viewModel.about.type),
                                  maxCharacters: 800,
                                );
                              case 3:
                                return Column(
                                  children: [
                                    ExpandableContainer(
                                      title: "Experience",
                                      textColor: Colors.white,
                                      information: viewModel.experienceItems,
                                    ),
                                    ExpandableContainer(
                                      title: "Education",
                                      textColor: Colors.white,
                                      information: viewModel.educationItems,
                                    ),
                                    ExpandableContainer(
                                      title: "Additional Software Courses",
                                      textColor: Colors.white,
                                      information: viewModel.courseItems,
                                    ),
                                    ExpandableContainer(
                                      title: "References",
                                      textColor: Colors.white,
                                      information: viewModel.referenceItems,
                                    ),
                                  ],
                                );
                              case 4:
                                return ScreenSize.isDesktop
                                    ? DetailsFooterDesktop(
                                        backgroundColor: Colors.blueGrey[700],
                                        details: viewModel.details,
                                      )
                                    : DetailsFooterMobile(
                                        backgroundColor: Colors.blueGrey[700],
                                        details: viewModel.details,
                                      );
                              default:
                                return Container(
                                  height: 400,
                                  color: Colors.blueGrey[700],
                                  child: Center(
                                    child: Text("$index Index"),
                                  ),
                                );
                            }
                          },
                        )),
            ));
  }
}
