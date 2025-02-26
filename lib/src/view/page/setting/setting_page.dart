import 'package:flutter/material.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/app_preferences/app_preferences_service.dart';
import 'package:forgelock/src/core/constants.dart';
import 'package:forgelock/src/navigator/navigator_controller.dart';
import 'package:forgelock/src/view/common/custom_scaffold.dart';
import 'package:forgelock/src/view/common/custom_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:forgelock/src/view/page/home/home_page.dart';
import 'package:forgelock/src/view/widget/button.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.appPreferencesController});

  final AppPreferencesController appPreferencesController;

  static const routeName = '/setting';

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: CustomScaffold(
        canPop: true,
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width < 680 ? MediaQuery.of(context).size.width : 680,
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.xLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: AppPadding.xxxLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new),
                          iconSize: 32.0,
                          color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                          onPressed: () {
                            NavigatorController.pushWithoutState(context, HomePage.routeName);
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!.settings,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Container(
                          width: 32.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.xLarge),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.theme,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        DropdownButton<ThemeMode>(
                          value: widget.appPreferencesController.themeMode,
                          onChanged: widget.appPreferencesController.updateThemeMode,
                          items: [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text(AppLocalizations.of(context)!.systemTheme),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text(AppLocalizations.of(context)!.lightTheme),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text(AppLocalizations.of(context)!.darkTheme),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.language,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        DropdownButton<String>(
                          value: widget.appPreferencesController.locale,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              widget.appPreferencesController.updateLocale(newValue);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'ja',
                              child: Text('日本語'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.font,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        DropdownButton<String>(
                          value: widget.appPreferencesController.font.name,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              widget.appPreferencesController.updateFont(FontName.values.byName(newValue));
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              value: FontName.Akeila.name,
                              child: Text(FontName.Akeila.name),
                            ),
                            DropdownMenuItem(
                              value: FontName.Mod20.name,
                              child: Text(FontName.Mod20.name),
                            ),
                            DropdownMenuItem(
                              value: FontName.TimelessMemories.name,
                              child: Text(FontName.TimelessMemories.name),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customSecondaryButton(
                          context,
                          widget.appPreferencesController,
                          text: AppLocalizations.of(context)!.visitWebsite,
                          width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 4,
                          onTap: () {
                            launchUrl(Uri.parse('https://danials.space/'));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customSecondaryButton(
                          context,
                          widget.appPreferencesController,
                          text: AppLocalizations.of(context)!.contactDeveloper,
                          width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 4,
                          onTap: () {
                            launchUrl(Uri.parse('https://danials.space/contact'));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.large),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customSecondaryButton(
                          context,
                          widget.appPreferencesController,
                          text: AppLocalizations.of(context)!.sourceCode,
                          width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 4,
                          onTap: () {
                            launchUrl(Uri.parse('https://github.com/danial2026/forgelock_app'));
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppPadding.xxxLarge),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
