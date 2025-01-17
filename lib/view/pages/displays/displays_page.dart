import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/constants.dart';
import 'package:settings/l10n/l10n.dart';
import 'package:settings/services/display/display_service.dart';
import 'package:settings/view/common/title_bar_tab.dart';
import 'package:settings/view/pages/displays/displays_configuration.dart';
import 'package:settings/view/pages/displays/displays_model.dart';
import 'package:settings/view/pages/displays/nightlight_page.dart';
import 'package:settings/view/pages/displays/widgets/monitor_section.dart';
import 'package:settings/view/pages/settings_page.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

class DisplaysPage extends StatefulWidget {
  /// private as we have to pass from create method below
  const DisplaysPage._();

  static Widget createTitle(BuildContext context) =>
      Text(context.l10n.displaysPageTitle);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DisplaysModel(di<DisplayService>()),
      child: const DisplaysPage._(),
    );
  }

  static bool searchMatches(String value, BuildContext context) =>
      value.isNotEmpty
          ? context.l10n.displaysPageTitle
              .toLowerCase()
              .contains(value.toLowerCase())
          : false;

  @override
  State<DisplaysPage> createState() => _DisplaysPageState();
}

class _DisplaysPageState extends State<DisplaysPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(length: DisplaysPageSection.values.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DisplaysModel>();

    return ValueListenableBuilder<DisplaysConfiguration?>(
      valueListenable: model.configuration,
      builder: (context, configurations, _) {
        return Scaffold(
          appBar: YaruWindowTitleBar(
            titleSpacing: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            border: BorderSide.none,
            title: Text(context.l10n.displaysPageTitle),
          ),
          body: Column(
            children: [
              SizedBox(
                width: 300,
                child: YaruTabBar(
                  tabController: _controller,
                  tabs: DisplaysPageSection.values
                      .map(
                        (e) => TitleBarTab(
                          text: e.name(context),
                          iconData: e.icon(context),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: DisplaysPageSection.values
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(top: kYaruPagePadding),
                          child: _buildPage(e, model, configurations),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPage(
    DisplaysPageSection section,
    DisplaysModel model,
    DisplaysConfiguration? configurations,
  ) {
    switch (section) {
      case DisplaysPageSection.displays:
        return SettingsPage(
          children: [
            SizedBox(
              width: kDefaultWidth,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: configurations?.configurations.length ?? 0,
                itemBuilder: (context, index) => MonitorSection(
                  index: index,
                ),
              ),
            ),
          ],
        );
      case DisplaysPageSection.night:
        return SettingsPage(
          children: [
            NightlightPage.create(context),
          ],
        );
      default:
        return Container();
    }
  }
}

enum DisplaysPageSection {
  displays,
  night,
}

extension DisplaysPageSectionExtension on DisplaysPageSection {
  String name(BuildContext context) {
    switch (this) {
      case DisplaysPageSection.displays:
        return context.l10n.displays;
      case DisplaysPageSection.night:
        return context.l10n.nightMode;
      default:
        return '';
    }
  }

  IconData icon(BuildContext context) {
    switch (this) {
      case DisplaysPageSection.displays:
        return YaruIcons.display_layout;
      case DisplaysPageSection.night:
        return YaruIcons.clear_night;
      default:
        return Icons.check_box_outline_blank;
    }
  }
}
