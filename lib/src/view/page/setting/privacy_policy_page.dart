import 'package:flutter/material.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/core/constants.dart';
import 'package:forgelock/src/navigator/navigator_controller.dart';
import 'package:forgelock/src/view/common/custom_scaffold.dart';
import 'package:forgelock/src/view/common/custom_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key, required this.appPreferencesController});

  final AppPreferencesController appPreferencesController;

  static const routeName = '/privacy-policy';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(height: AppPadding.xxxLarge),
                    AppBar(
                      title: Text(
                        AppLocalizations.of(context)!.privacyPolicy,
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
                          'At ForgeLock, we prioritize your privacy and security. Here\'s how we handle your data:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '1. Data Processing',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          '✓ All password generation happens locally on your device',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          '✓ No data is ever stored or transmitted to external servers',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          '✓ Complete independence from cloud storage or third-party services',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '2. Data Collection',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'ForgeLock does not:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.small),
                        Text(
                          '• Store or collect any passwords you generate\n'
                          '• Track your usage or behavior\n'
                          '• Require account creation or registration\n'
                          '• Use cookies or similar tracking technologies',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '3. Security',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'Our local-only approach means your data never leaves your device, providing maximum security and privacy. All password generation operations are performed entirely on your device.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppPadding.large),
                        Text(
                          '4. Updates to Privacy Policy',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppPadding.medium),
                        Text(
                          'We may update this privacy policy from time to time. Continued use of ForgeLock indicates acceptance of any modifications.',
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
