import 'package:flutter/material.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/core/constants.dart';
import 'package:forgelock/src/navigator/navigator_controller.dart';
import 'package:forgelock/src/view/common/custom_scaffold.dart';
import 'package:forgelock/src/view/common/custom_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:forgelock/src/view/page/home/home_page.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key, required this.appPreferencesController});

  final AppPreferencesController appPreferencesController;

  static const routeName = '/terms';

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      child: CustomScaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width < 680 ? MediaQuery.of(context).size.width : 680,
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.xLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: AppPadding.xxxLarge),
                    AppBar(
                      title: Text(
                        AppLocalizations.of(context)!.termsOfService,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new),
                        iconSize: 32.0,
                        color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                        onPressed: () {
                          NavigatorController.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppPadding.large),
                        Text(
                          'Welcome to ForgeLock. By accessing and using this application, you agree to the following terms and conditions. If you do not agree, please discontinue use immediately.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '1. Use of the Service',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'ForgeLock is a free tool for generating secure passwords.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'No account or registration is required to use the service.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'You are responsible for ensuring that you have the right to use and process any data entered.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'The service is provided "as is" with no guarantees of uptime or availability.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '2. Data Processing & Privacy',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'All password generation happens on your device (client-side).',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'ForgeLock does not upload, store, or collect any passwords you generate.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'We do not claim ownership of any data you use with our tool.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '3. Limitations and Liability',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'We are not responsible for any loss, damage, or issues resulting from the use of this service.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          'ForgeLock is provided as a free tool with no warranties. Use at your own risk.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '4. Changes to Terms',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'We may update these terms from time to time. Continued use of ForgeLock means you accept any modifications.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.xxxLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
