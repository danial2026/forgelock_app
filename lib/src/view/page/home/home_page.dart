import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forgelock/src/app_preferences/app_preferences_controller.dart';
import 'package:forgelock/src/bloc/generate_password/generate_password_get_bloc.dart';
import 'package:forgelock/src/core/constants.dart';
import 'package:forgelock/src/navigator/navigator_controller.dart';
import 'package:forgelock/src/view/common/custom_scaffold.dart';
import 'package:forgelock/src/view/common/custom_screen.dart';
import 'package:forgelock/src/view/page/setting/setting_page.dart';
import 'package:forgelock/src/view/widget/button.dart';
import 'package:forgelock/src/view/widget/loading_widget.dart';
import 'package:forgelock/src/view/widget/snackbar_widget.dart';
import 'package:forgelock/src/view/widget/text.dart';
import 'package:forgelock/src/view/widget/textfield_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.appPreferencesController});

  static const routeName = '/home';

  final AppPreferencesController appPreferencesController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in textFieldControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool hasSpecialChars = true;

  List<TextEditingController> textFieldControllers = [];
  int textFieldCount = 3;

  List<DateTime?> dateTimeList = [];
  int dateTimeCount = 0;

  List<TextEditingController> numberFieldControllers = [];
  int numberCount = 0;

  double _passwordLength = 16;

  @override
  Widget build(BuildContext context) {
    final passwordGeneratorBloc = BlocProvider.of<PasswordGeneratorBloc>(context);

    return CustomScreen(
      child: CustomScaffold(
        canPop: false,
        body: BlocConsumer<PasswordGeneratorBloc, PasswordGeneratorState>(
          bloc: passwordGeneratorBloc,
          listener: (context, state) {
            if (state is PasswordGeneratorFailure) {
              showLoaderDialog(context);
            } else if (state is PasswordGeneratorFailure) {
              showSnackBarWidget(
                context: context,
                backgroundColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
                text: state.error.toString(),
                isError: true,
              );
            } else if (state is PasswordGeneratorSuccess) {
              bool showPassword = false;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.password),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              showPassword ? state.item.password : '•' * state.item.password.length,
                              softWrap: true,
                              style: widget.appPreferencesController.getThemeData().textTheme.bodySmall,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: state.item.password));
                                  showSnackBarWidget(
                                    context: context,
                                    backgroundColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
                                    text: AppLocalizations.of(context)!.passwordCopiedToClipboard,
                                    isError: false,
                                  );
                                },
                                icon: Icon(
                                  Icons.copy,
                                  color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showPassword = !showPassword;
                                  (context as Element).markNeedsBuild();
                                },
                                icon: Icon(
                                  showPassword ? Icons.visibility_off : Icons.visibility,
                                  color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppPadding.large),
                      Text(AppLocalizations.of(context)!.generatedInMs(state.item.time)),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        NavigatorController.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.done),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) => Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width < 680 ? MediaQuery.of(context).size.width : 680,
              ),
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: AppPadding.xLarge),
                    children: [
                      const SizedBox(height: AppPadding.xxxLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(right: AppPadding.medium),
                              child: IconButton(
                                icon: const Icon(Icons.settings),
                                iconSize: 32.0,
                                color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                                onPressed: () {
                                  NavigatorController.pushWithoutState(context, SettingPage.routeName);
                                },
                              )),
                          Text(
                            AppLocalizations.of(context)!.appName,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: AppPadding.medium),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  textFieldCount = 3;
                                  textFieldControllers.clear();
                                  numberCount = 0;
                                  numberFieldControllers.clear();
                                  dateTimeCount = 0;
                                  dateTimeList.clear();
                                  hasSpecialChars = true;
                                  _passwordLength = 16;
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.reset,
                                style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium?.copyWith(
                                      color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                                    ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: AppPadding.xLarge),
                      _buildHasSpecialChars(),
                      const SizedBox(height: AppPadding.xLarge),
                      _buildLengthPicker(),
                      const SizedBox(height: AppPadding.xLarge),
                      Text(
                        AppLocalizations.of(context)!.textFields,
                        style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
                      ),
                      ..._buildTextFieldList(),
                      const SizedBox(height: AppPadding.xLarge),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          iconSize: 42.0,
                          color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                          onPressed: () {
                            setState(() {
                              textFieldCount++;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: AppPadding.xLarge),
                      Text(
                        AppLocalizations.of(context)!.dateFields,
                        style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
                      ),
                      ..._buildDateTimeList(),
                      const SizedBox(height: AppPadding.xLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            iconSize: 42.0,
                            color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                            onPressed: () {
                              setState(() {
                                dateTimeCount++;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppPadding.xLarge),
                      Text(
                        AppLocalizations.of(context)!.numberFields,
                        style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
                      ),
                      ..._buildNumberList(),
                      const SizedBox(height: AppPadding.xLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            iconSize: 42.0,
                            color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                            onPressed: () {
                              setState(() {
                                numberCount++;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppPadding.xxxLarge),
                      const SizedBox(height: AppPadding.xxxLarge),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.large),
                      child: customPrimaryButton(
                        context,
                        widget.appPreferencesController,
                        text: AppLocalizations.of(context)!.generatePassword,
                        width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 4,
                        onTap: () {
                          dateTimeList.removeWhere((element) => element == null);
                          passwordGeneratorBloc.requested(
                            strings: textFieldControllers.map((e) => e.text).toList(),
                            dates: dateTimeList.map((e) => e!).toList(),
                            numbers: numberFieldControllers.map((e) => int.parse(e.text)).toList(),
                            length: _passwordLength.toInt(),
                            hasSpecialChars: hasSpecialChars,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLengthPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.passwordLength,
          style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _passwordLength,
                min: 6,
                max: 58,
                divisions: 26,
                activeColor: widget.appPreferencesController.getThemeData().colorScheme.primary,
                inactiveColor: widget.appPreferencesController.getThemeData().colorScheme.primary.withOpacity(0.3),
                onChanged: (value) {
                  setState(() {
                    _passwordLength = value;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.medium,
                vertical: AppPadding.small,
              ),
              decoration: BoxDecoration(
                borderRadius: AppBorderRadius.large,
                color: widget.appPreferencesController.getThemeData().colorScheme.surface,
              ),
              child: Text(
                _passwordLength.toInt().toString(),
                style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHasSpecialChars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.hasSpecialChars,
          style: widget.appPreferencesController.getThemeData().textTheme.bodyMedium,
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppPadding.medium),
          child: Switch(
            value: hasSpecialChars,
            onChanged: (value) => setState(() => hasSpecialChars = value),
            activeColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
            activeTrackColor: widget.appPreferencesController.getThemeData().colorScheme.primary,
            inactiveTrackColor: widget.appPreferencesController.getThemeData().colorScheme.primary.withOpacity(0.4),
            inactiveThumbColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTextFieldList() {
    var list = <Widget>[];
    for (var i = 0; i < textFieldCount; i++) {
      if (textFieldControllers.length <= i) {
        textFieldControllers.add(TextEditingController());
      }

      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: AppPadding.medium),
            labelTextField(
                context: context,
                text: i == 0
                    ? AppLocalizations.of(context)!.firstWordOrPhrase
                    : i == 1
                        ? AppLocalizations.of(context)!.secondWordOrPhrase
                        : AppLocalizations.of(context)!.nthWordOrPhrase(i + 1)),
            const SizedBox(height: AppPadding.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: NormalTextField(
                    appPreferencesController: widget.appPreferencesController,
                    controller: textFieldControllers[i],
                    hintText: AppLocalizations.of(context)!.customWordOrPhrase,
                    keyboardType: TextInputType.name,
                    width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 2,
                  ),
                ),
                if (i > 2)
                  IconButton(
                    icon: const Icon(Icons.remove),
                    iconSize: 36.0,
                    color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                    onPressed: () {
                      setState(() {
                        textFieldCount--;
                        textFieldControllers.removeAt(i);
                      });
                    },
                  ),
              ],
            ),
          ],
        ),
      );
    }
    return list;
  }

  List<Widget> _buildDateTimeList() {
    var list = <Widget>[];
    for (var i = 0; i < dateTimeCount; i++) {
      if (dateTimeList.length <= i) {
        dateTimeList.add(null);
      }
      list.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.large,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.medium, horizontal: AppPadding.large),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: dateTimeList[i] ?? DateTime.now(),
                    firstDate: DateTime(1700),
                    lastDate: DateTime(2200),
                    locale: Locale(AppLocalizations.of(context)?.localeName ?? 'en'),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: widget.appPreferencesController.getThemeData().colorScheme.primary,
                            onPrimary: widget.appPreferencesController.getThemeData().colorScheme.surface,
                            surface: widget.appPreferencesController.getThemeData().colorScheme.surface,
                            onSurface: widget.appPreferencesController.getThemeData().colorScheme.primary,
                          ),
                          dialogBackgroundColor: widget.appPreferencesController.getThemeData().colorScheme.surface,
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: widget.appPreferencesController.getThemeData().colorScheme.primary,
                          ),
                        ),
                        child: child ?? Container(),
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      if (dateTimeList[i] == null) {
                        dateTimeList[i] = picked;
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: AppPadding.large, horizontal: AppPadding.large),
                  child: Text(
                    dateTimeList[i] != null
                        ? '${dateTimeList[i]?.day.toString().padLeft(2, '0')} / ${dateTimeList[i]?.month.toString().padLeft(2, '0')} / ${dateTimeList[i]?.year}'
                        : AppLocalizations.of(context)!.selectDate,
                    style: widget.appPreferencesController.getThemeData().textTheme.titleMedium,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              iconSize: 36.0,
              color: widget.appPreferencesController.getThemeData().colorScheme.primary,
              onPressed: () {
                setState(() {
                  dateTimeCount--;
                  dateTimeList.removeAt(i);
                });
              },
            ),
          ],
        ),
      );
    }
    return list;
  }

  List<Widget> _buildNumberList() {
    var list = <Widget>[];
    for (var i = 0; i < numberCount; i++) {
      if (numberFieldControllers.length <= i) {
        numberFieldControllers.add(TextEditingController());
      }
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: AppPadding.medium),
            labelTextField(
                context: context,
                text: i == 0
                    ? AppLocalizations.of(context)!.firstNumber
                    : i == 1
                        ? AppLocalizations.of(context)!.secondNumber
                        : AppLocalizations.of(context)!.nthNumber(i + 1)),
            const SizedBox(height: AppPadding.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: NormalTextField(
                    appPreferencesController: widget.appPreferencesController,
                    controller: numberFieldControllers[i],
                    hintText: AppLocalizations.of(context)!.customNumber,
                    keyboardType: TextInputType.number,
                    width: MediaQuery.of(context).size.width - AppPadding.xxLarge * 2 - 48,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  iconSize: 36.0,
                  color: widget.appPreferencesController.getThemeData().colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      numberCount--;
                      numberFieldControllers.removeAt(i);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
    return list;
  }
}
