import 'package:flutter/services.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:forgelock/src/view/page/home/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:forgelock/src/navigator/navigator_controller.dart';
import 'package:forgelock/src/view/common/custom_scaffold.dart';
import 'package:forgelock/src/view/common/custom_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.appPreferencesController});

  final AppPreferencesController appPreferencesController;

  static const routeName = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late String _version = "";

  void _dismissKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _initPackageInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'version ${packageInfo.version} + ${packageInfo.buildNumber}';
    });
  }

  @override
  void initState() {
    super.initState();
    _dismissKeyboard();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      onInit: () {
        Future.delayed(const Duration(seconds: 2)).then((value) async {
          NavigatorController.pushReplacementWithoutState(context, HomePage.routeName);
        });
      },
      child: CustomScaffold(
        canPop: false,
        backgroundColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: AppBorderRadius.large,
                    child: Image.asset(
                      AppIcon.appIcon,
                      width: 160,
                      height: 160,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: widget.appPreferencesController.getThemeData().textTheme.displaySmall,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  _version,
                  style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
