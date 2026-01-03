import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:zenthory/zenthory.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: HomeAppBar(
            icon: AppIcons.settings,
            title: context.tr!.settings,
          ),
          extendBodyBehindAppBar: (state is SettingInitial) ? false : true,
          body: state is SettingInitial
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(AppDimensions.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingCard(
                        wrap: true,
                        title: context.tr!.management,
                        children: [
                          CustomSettingTile(
                            title: context.tr!.manage_wallets,
                            icon: AppIcons.wallets,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => WalletCubit()..loadWallets(),
                                  child: WalletScreen(),
                                ),
                              ),
                            ),
                          ),
                          CustomSettingTile(
                            title: context.tr!.manage_budgets,
                            icon: AppIcons.budgets,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => BudgetCubit()..loadBudgets(),
                                  child: BudgetScreen(),
                                ),
                              ),
                            ),
                          ),
                          CustomSettingTile(
                            title: context.tr!.manage_categories,
                            icon: AppIcons.categories,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => CategoryCubit()
                                    ..loadCategories(
                                      type: TransactionType.income,
                                    ),
                                  child: CategoryScreen(),
                                ),
                              ),
                            ),
                          ),
                          CustomSettingTile(
                            title: context.tr!.manage_tags,
                            icon: AppIcons.tags,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => TagCubit()..loadTags(),
                                  child: TagScreen(),
                                ),
                              ),
                            ),
                          ),
                          CustomSettingTile(
                            title: context.tr!.contacts,
                            icon: AppIcons.contacts,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => ContactCubit()..loadContacts(),
                                  child: ContactScreen(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SettingCard(
                        title: context.tr!.currency,
                        children: [
                          SettingTile(
                            title: context.tr!.default_currency,
                            icon: AppIcons.currency,
                            trailingText: state.currency,
                            trailing: state.currencyProcessing
                                ? SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                            onTap:
                                state.currencyProcessing || state.hasTransaction
                                ? null
                                : () => _showCurrencyPicker(context),
                          ),
                          SettingTile(
                            title: context.tr!.currency_rates,
                            icon: AppIcons.currencyRates,
                            onTap: state.currencyProcessing
                                ? null
                                : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (_) =>
                                            CurrencyRateCubit()..loadRates(),
                                        child: CurrencyRateScreen(),
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SettingCard(
                        title: context.tr!.app_preferences,
                        children: [
                          SettingTile(
                            title: context.tr!.language,
                            icon: AppIcons.language,
                            hasDivider: true,
                            trailingText: context
                                .read<SharedCubit>()
                                .getLanguageNativeName(
                                  state.locale.languageCode,
                                ),
                            onTap: () => context
                                .read<SharedCubit>()
                                .showModalBottomSheet(
                                  (_) => BlocProvider.value(
                                    value: context.read<SettingCubit>(),
                                    child: ChangeLanguageModalBottomSheet(
                                      locale: state.locale,
                                    ),
                                  ),
                                ),
                          ),
                          SettingTile(
                            title: context.tr!.theme_mode,
                            icon: AppIcons.themeMode,
                            trailingText: state.themeMode == ThemeMode.system
                                ? context.tr!.follow_device_theme
                                : (state.themeMode == ThemeMode.dark
                                      ? context.tr!.dark_theme
                                      : context.tr!.light_theme),
                            onTap: () => context
                                .read<SharedCubit>()
                                .showModalBottomSheet(
                                  (_) => BlocProvider.value(
                                    value: context.read<SettingCubit>(),
                                    child: ChangeThemeModeModalBottomSheet(
                                      themeMode: state.themeMode,
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                      SettingCard(
                        title: context.tr!.security,
                        children: [
                          if (state.canAuthenticate)
                            SettingTile(
                              title: context.tr!.app_lock,
                              icon: AppIcons.appLock,
                              subtitle: context.tr!.app_lock_description(
                                context.tr!.app_name,
                              ),
                              hasDivider: true,
                              trailing: Transform.scale(
                                scale: 0.75,
                                child: Switch(
                                  value: state.appLocked,
                                  onChanged: (value) {
                                    context.read<SettingCubit>().switchAppLock(
                                      state.appLocked
                                          ? context.tr!
                                                .unlock_app_localized_reason(
                                                  context.tr!.app_name,
                                                )
                                          : context.tr!
                                                .lock_app_localized_reason(
                                                  context.tr!.app_name,
                                                ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          SettingTile(
                            title: context.tr!.screenshot,
                            icon: AppIcons.mobileScreenshot,
                            subtitle: context.tr!.enable_screenshot_description,
                            trailing: Transform.scale(
                              scale: 0.75,
                              child: Switch(
                                value: state.enableScreenshot,
                                onChanged: (value) {
                                  context.read<SharedCubit>().authenticateIfAvailable(
                                    state.enableScreenshot
                                        ? context
                                              .tr!
                                              .disable_screenshot_localized_reason
                                        : context
                                              .tr!
                                              .enable_screenshot_localized_reason,
                                    context
                                        .read<SettingCubit>()
                                        .switchScreenshot,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SettingCard(
                        title: context.tr!.app_name,
                        children: [
                          SettingTile(
                            title: context.tr!.about_app(context.tr!.app_name),
                            icon: AppIcons.about,
                            hasDivider: true,
                            trailingText: state.packageInfo != null
                                ? context.tr!.version(
                                    state.packageInfo!.version,
                                  )
                                : null,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AboutScreen(
                                  version: state.packageInfo!.version,
                                ),
                              ),
                            ),
                          ),
                          SettingTile(
                            title: context.tr!.share_app(context.tr!.app_name),
                            icon: AppIcons.share,
                            onTap: () {
                              SharePlus.instance.share(
                                ShareParams(
                                  text: context.tr!.share_app_description(
                                    context.tr!.app_name,
                                    context
                                        .read<SettingCubit>()
                                        .getAppDownloadUrl(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _showCurrencyPicker(BuildContext context) async {
    if ((await context.read<SettingCubit>().hasTransaction())) {
      return;
    }
    if (!context.mounted) return;
    showCurrencyPicker(
      context: context,
      theme: CurrencyPickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.11),
          ),
        ),
        flagSize: 30,

        titleTextStyle: TextStyle(fontSize: 15),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.80,
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: context.colors.textSecondary,
        ),
        inputDecoration: InputDecoration(
          hintText: context.tr!.currency_search,
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgIcon(
              icon: AppIcons.searchCurrency,
              color: context.colors.textPrimary,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.inputBorder.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      onSelect: (Currency currency) =>
          context.read<SettingCubit>().setCurrency(currency.code),
    );
  }
}
