import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Zenthory'**
  String get app_name;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme_mode;

  /// No description provided for @app_preferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get app_preferences;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark_theme;

  /// No description provided for @follow_device_theme.
  ///
  /// In en, this message translates to:
  /// **'Follow device theme'**
  String get follow_device_theme;

  /// No description provided for @app_lock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get app_lock;

  /// No description provided for @app_lock_description.
  ///
  /// In en, this message translates to:
  /// **'Use your phone\'s PIN, pattern, or biometrics to unlock {app_name}'**
  String app_lock_description(Object app_name);

  /// No description provided for @screenshot.
  ///
  /// In en, this message translates to:
  /// **'Screenshot'**
  String get screenshot;

  /// No description provided for @enable_screenshot_description.
  ///
  /// In en, this message translates to:
  /// **'Allow screenshots within the app interface.'**
  String get enable_screenshot_description;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About {app_name}'**
  String about_app(Object app_name);

  /// No description provided for @share_app.
  ///
  /// In en, this message translates to:
  /// **'Share {app_name}'**
  String share_app(Object app_name);

  /// No description provided for @lock_app_localized_reason.
  ///
  /// In en, this message translates to:
  /// **'Every time you open {app_name}, you will be asked to authenticate.'**
  String lock_app_localized_reason(Object app_name);

  /// No description provided for @unlock_app_localized_reason.
  ///
  /// In en, this message translates to:
  /// **'Authentication will no longer be required to open {app_name}.'**
  String unlock_app_localized_reason(Object app_name);

  /// No description provided for @enable_screenshot_localized_reason.
  ///
  /// In en, this message translates to:
  /// **'Please verify to allow screenshot functionality'**
  String get enable_screenshot_localized_reason;

  /// No description provided for @disable_screenshot_localized_reason.
  ///
  /// In en, this message translates to:
  /// **'Confirm your identity to block screenshots'**
  String get disable_screenshot_localized_reason;

  /// No description provided for @share_app_description.
  ///
  /// In en, this message translates to:
  /// **'Take control of your finances with {app_name} — a smart, modern expense tracker that helps you manage your income, spending, and budgets all in one place. With a clean design, powerful insights, and support for multiple currencies and languages, it’s everything you need to build better financial habits. Download now and start tracking smarter: {url}'**
  String share_app_description(Object app_name, Object url);

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {number}'**
  String version(Object number);

  /// No description provided for @about_app_description_1.
  ///
  /// In en, this message translates to:
  /// **'{app_name} is a modern expense tracking application designed to help you take full control of your personal finances. Whether you\'re managing daily spending, or analyzing financial trends, {app_name} offers a clean, intuitive interface with powerful tools to keep you organized.'**
  String about_app_description_1(Object app_name);

  /// No description provided for @about_app_description_2.
  ///
  /// In en, this message translates to:
  /// **'With features like multi-currency support, biometric app lock, smart categories, income tracking, and real-time reports, {app_name} simplifies the way you manage money — all from your phone.'**
  String about_app_description_2(Object app_name);

  /// No description provided for @about_app_description_3.
  ///
  /// In en, this message translates to:
  /// **'Stay focused. Spend smarter. Live better.'**
  String get about_app_description_3;

  /// No description provided for @powered_by.
  ///
  /// In en, this message translates to:
  /// **'Powered by'**
  String get powered_by;

  /// No description provided for @currency_search.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get currency_search;

  /// No description provided for @icon_search.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search...'**
  String get icon_search;

  /// No description provided for @app_locked_description.
  ///
  /// In en, this message translates to:
  /// **'Access to the application is restricted. Please authenticate to continue.'**
  String get app_locked_description;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @app_locked.
  ///
  /// In en, this message translates to:
  /// **'{app_name} locked'**
  String app_locked(Object app_name);

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get change_language;

  /// No description provided for @change_theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Change theme mode'**
  String get change_theme_mode;

  /// No description provided for @manage_categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get manage_categories;

  /// No description provided for @add_category.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get add_category;

  /// No description provided for @add_category_description.
  ///
  /// In en, this message translates to:
  /// **'Add a new expense or income category.'**
  String get add_category_description;

  /// No description provided for @manage_budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get manage_budgets;

  /// No description provided for @manage_budgets_description.
  ///
  /// In en, this message translates to:
  /// **'Track spending with custom budgets.'**
  String get manage_budgets_description;

  /// No description provided for @manage_tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get manage_tags;

  /// No description provided for @manage_wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get manage_wallets;

  /// No description provided for @manage_wallets_description.
  ///
  /// In en, this message translates to:
  /// **'Track spending and balance across multiple wallets.'**
  String get manage_wallets_description;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @error_failed_to_load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load {name}'**
  String error_failed_to_load(Object name);

  /// No description provided for @error_failed_to_add.
  ///
  /// In en, this message translates to:
  /// **'Failed to add {name}'**
  String error_failed_to_add(Object name);

  /// No description provided for @error_failed_to_update.
  ///
  /// In en, this message translates to:
  /// **'Failed to update {name}'**
  String error_failed_to_update(Object name);

  /// No description provided for @error_failed_to_delete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete {name}'**
  String error_failed_to_delete(Object name);

  /// No description provided for @create_resource.
  ///
  /// In en, this message translates to:
  /// **'Create {resource}'**
  String create_resource(Object resource);

  /// No description provided for @edit_resource.
  ///
  /// In en, this message translates to:
  /// **'Edit {resource}'**
  String edit_resource(Object resource);

  /// No description provided for @update_resource.
  ///
  /// In en, this message translates to:
  /// **'Update {resource}'**
  String update_resource(Object resource);

  /// No description provided for @delete_resource.
  ///
  /// In en, this message translates to:
  /// **'Delete {resource}'**
  String delete_resource(Object resource);

  /// No description provided for @load_resource.
  ///
  /// In en, this message translates to:
  /// **'Load {resource}'**
  String load_resource(Object resource);

  /// No description provided for @resource_updated.
  ///
  /// In en, this message translates to:
  /// **'{resource} has been updated successfully.'**
  String resource_updated(Object resource);

  /// No description provided for @resource_deleted.
  ///
  /// In en, this message translates to:
  /// **'{resource} has been deleted successfully.'**
  String resource_deleted(Object resource);

  /// No description provided for @resource_created.
  ///
  /// In en, this message translates to:
  /// **'{resource} has been created successfully.'**
  String resource_created(Object resource);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @enter_resource_name.
  ///
  /// In en, this message translates to:
  /// **'Enter {resource} name'**
  String enter_resource_name(Object resource);

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @color_picker.
  ///
  /// In en, this message translates to:
  /// **'Color Picker'**
  String get color_picker;

  /// No description provided for @color_picker_description.
  ///
  /// In en, this message translates to:
  /// **'Choose a {resource} color to organize visually.'**
  String color_picker_description(Object resource);

  /// No description provided for @attribute_is_required.
  ///
  /// In en, this message translates to:
  /// **'{attribute} is required.'**
  String attribute_is_required(Object attribute);

  /// No description provided for @this_attribute_is_already_used.
  ///
  /// In en, this message translates to:
  /// **'This {attribute} is already used.'**
  String this_attribute_is_already_used(Object attribute);

  /// No description provided for @attribute_should_be_between_min_to_max_characters.
  ///
  /// In en, this message translates to:
  /// **'{attribute} should be between {min} to {max} characters'**
  String attribute_should_be_between_min_to_max_characters(Object attribute, Object max, Object min);

  /// No description provided for @tags_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Tags Yet'**
  String get tags_empty_screen_title;

  /// No description provided for @tags_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Create your first tag to organize transactions.'**
  String get tags_empty_screen_description;

  /// No description provided for @confirm_delete_resource_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {resource} {name}? This action cannot be undone.'**
  String confirm_delete_resource_message(Object name, Object resource);

  /// No description provided for @categories_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Categories Yet'**
  String get categories_empty_screen_title;

  /// No description provided for @categories_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Create your first category to organize transactions.'**
  String get categories_empty_screen_description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @debts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debts;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @icon_picker.
  ///
  /// In en, this message translates to:
  /// **'Icon Picker'**
  String get icon_picker;

  /// No description provided for @icon_picker_description.
  ///
  /// In en, this message translates to:
  /// **'Pick an icon to represent the {resource}'**
  String icon_picker_description(Object resource);

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @credit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get credit_card;

  /// No description provided for @e_wallet.
  ///
  /// In en, this message translates to:
  /// **'E-Wallet'**
  String get e_wallet;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @wallets_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Wallets Yet'**
  String get wallets_empty_screen_title;

  /// No description provided for @wallets_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Create a wallet to start tracking your balances and transactions.'**
  String get wallets_empty_screen_description;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @default_currency.
  ///
  /// In en, this message translates to:
  /// **'Default Currency'**
  String get default_currency;

  /// No description provided for @attribute_must_be_greater_than_number.
  ///
  /// In en, this message translates to:
  /// **'{attribute} must be greater than {number}.'**
  String attribute_must_be_greater_than_number(Object attribute, Object number);

  /// No description provided for @current_balance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get current_balance;

  /// No description provided for @end_date_must_be_after_start_date.
  ///
  /// In en, this message translates to:
  /// **'End date must be after start date.'**
  String get end_date_must_be_after_start_date;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @budgets_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Budgets Yet'**
  String get budgets_empty_screen_title;

  /// No description provided for @budgets_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a budget to manage your spending and track your goals.'**
  String get budgets_empty_screen_description;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get end_date;

  /// No description provided for @budget_note_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Notes about this budget'**
  String get budget_note_placeholder;

  /// No description provided for @budget_range.
  ///
  /// In en, this message translates to:
  /// **'Budget Range'**
  String get budget_range;

  /// No description provided for @select_resource.
  ///
  /// In en, this message translates to:
  /// **'Select {resource}'**
  String select_resource(Object resource);

  /// No description provided for @attribute_must_not_exceed_number_characters.
  ///
  /// In en, this message translates to:
  /// **'{attribute} must not exceed {number} characters.'**
  String attribute_must_not_exceed_number_characters(Object attribute, Object number);

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @budget_limit.
  ///
  /// In en, this message translates to:
  /// **'Budget limit'**
  String get budget_limit;

  /// No description provided for @spent_of.
  ///
  /// In en, this message translates to:
  /// **'spent of'**
  String get spent_of;

  /// No description provided for @wallet_displayed_balance_message.
  ///
  /// In en, this message translates to:
  /// **'The wallet balance is displayed on the main screen.'**
  String get wallet_displayed_balance_message;

  /// No description provided for @wallet_hidden_balance_message.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance is hidden on the main screen'**
  String get wallet_hidden_balance_message;

  /// No description provided for @wallet_blocked_balance_message.
  ///
  /// In en, this message translates to:
  /// **'The wallet has been blocked from the app.'**
  String get wallet_blocked_balance_message;

  /// No description provided for @wallet_unblocked_balance_message.
  ///
  /// In en, this message translates to:
  /// **'The wallet has been unblocked from the app.'**
  String get wallet_unblocked_balance_message;

  /// No description provided for @select_type.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get select_type;

  /// No description provided for @main_category.
  ///
  /// In en, this message translates to:
  /// **'Main Category'**
  String get main_category;

  /// No description provided for @confirm_message_delete_without_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {resource} \"{name}\"?\n All transactions related to this section will be removed, and the balances of the associated governorates will be restored to their previous state.'**
  String confirm_message_delete_without_sub_category(Object name, Object resource);

  /// No description provided for @confirm_message_delete_has_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the {resource} \"{name}\"?\n All transactions related to this section and its sub-sections will be deleted, and the balances of the associated governorates will be restored to their previous state.'**
  String confirm_message_delete_has_sub_category(Object name, Object resource);

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @transaction_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Transactions Yet'**
  String get transaction_empty_screen_title;

  /// No description provided for @transaction_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Start by adding a new transaction to track your expenses, income, and debts.'**
  String get transaction_empty_screen_description;

  /// No description provided for @confirm_delete_transaction_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction? This action will update the wallet balance to its previous state.'**
  String get confirm_delete_transaction_message;

  /// No description provided for @hint_text_transaction_amount.
  ///
  /// In en, this message translates to:
  /// **'e.g {currency} 5.00'**
  String hint_text_transaction_amount(Object currency);

  /// No description provided for @transaction_note_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Notes about this transaction'**
  String get transaction_note_placeholder;

  /// No description provided for @transaction_date.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transaction_date;

  /// No description provided for @select_category.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get select_category;

  /// No description provided for @select_wallet.
  ///
  /// In en, this message translates to:
  /// **'Select wallet'**
  String get select_wallet;

  /// No description provided for @select_time.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get select_time;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get select_date;

  /// No description provided for @no_impact_on_balance.
  ///
  /// In en, this message translates to:
  /// **'No impact on balance'**
  String get no_impact_on_balance;

  /// No description provided for @no_impact_on_balance_description.
  ///
  /// In en, this message translates to:
  /// **'When enabled, this transaction will be excluded from the selected wallet\'s balance.'**
  String get no_impact_on_balance_description;

  /// No description provided for @currency_rate.
  ///
  /// In en, this message translates to:
  /// **'Currency Rate'**
  String get currency_rate;

  /// No description provided for @currency_rates.
  ///
  /// In en, this message translates to:
  /// **'Currency rates'**
  String get currency_rates;

  /// No description provided for @add_with_resource.
  ///
  /// In en, this message translates to:
  /// **'Add {resource}'**
  String add_with_resource(Object resource);

  /// No description provided for @currency_rates_with_default_currency.
  ///
  /// In en, this message translates to:
  /// **'Currency Rates (Base: {defaultCurrency})'**
  String currency_rates_with_default_currency(Object defaultCurrency);

  /// No description provided for @currency_rates_update_description.
  ///
  /// In en, this message translates to:
  /// **'Manage and update exchange rates for different currencies based on your default currency.'**
  String get currency_rates_update_description;

  /// No description provided for @rate_title_input.
  ///
  /// In en, this message translates to:
  /// **'Rate from ({defaultCurrency}) to ({currency})'**
  String rate_title_input(Object currency, Object defaultCurrency);

  /// No description provided for @hint_text_rate.
  ///
  /// In en, this message translates to:
  /// **'e.g {currency} 0.70'**
  String hint_text_rate(Object currency);

  /// No description provided for @stop_automatic_currency_rate_adjustment.
  ///
  /// In en, this message translates to:
  /// **'Stop automatic currency rate adjustment'**
  String get stop_automatic_currency_rate_adjustment;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @total_balance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get total_balance;

  /// No description provided for @add_income_description.
  ///
  /// In en, this message translates to:
  /// **'Record money you\'ve received.'**
  String get add_income_description;

  /// No description provided for @add_expenses_description.
  ///
  /// In en, this message translates to:
  /// **'Log a new purchase or payment.'**
  String get add_expenses_description;

  /// No description provided for @add_debts_description.
  ///
  /// In en, this message translates to:
  /// **'Track borrowed or owed money.'**
  String get add_debts_description;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @recent_transactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recent_transactions;

  /// No description provided for @dashboard_analytics_title.
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Income vs Expense'**
  String get dashboard_analytics_title;

  /// No description provided for @dashboard_analytics_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily breakdown of financial activity'**
  String get dashboard_analytics_subtitle;

  /// No description provided for @weekly_chart_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No Data to Display'**
  String get weekly_chart_empty_title;

  /// No description provided for @weekly_chart_empty_description.
  ///
  /// In en, this message translates to:
  /// **'Add income or expense transactions to see your weekly chart.'**
  String get weekly_chart_empty_description;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @report_filter.
  ///
  /// In en, this message translates to:
  /// **'Report Filter'**
  String get report_filter;

  /// No description provided for @date_range.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get date_range;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @total_income.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get total_income;

  /// No description provided for @total_expenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get total_expenses;

  /// No description provided for @net_balance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get net_balance;

  /// No description provided for @debts_paid.
  ///
  /// In en, this message translates to:
  /// **'Debts paid'**
  String get debts_paid;

  /// No description provided for @debts_received.
  ///
  /// In en, this message translates to:
  /// **'Debts received'**
  String get debts_received;

  /// No description provided for @financial_summary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financial_summary;

  /// No description provided for @debts_summary.
  ///
  /// In en, this message translates to:
  /// **'Debts Summary'**
  String get debts_summary;

  /// No description provided for @no_data_available.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get no_data_available;

  /// No description provided for @report_categories_income_title.
  ///
  /// In en, this message translates to:
  /// **'Top Income Sources'**
  String get report_categories_income_title;

  /// No description provided for @report_categories_income_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your most frequent and valuable income streams.'**
  String get report_categories_income_subtitle;

  /// No description provided for @report_categories_expenses_title.
  ///
  /// In en, this message translates to:
  /// **'Top Spending Areas'**
  String get report_categories_expenses_title;

  /// No description provided for @report_categories_expenses_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Categories where you spend the most money.'**
  String get report_categories_expenses_subtitle;

  /// No description provided for @monthly_summary_title.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income vs Expenses'**
  String get monthly_summary_title;

  /// No description provided for @monthly_summary_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Track income and expenses month by month.'**
  String get monthly_summary_subtitle;

  /// No description provided for @add_balance.
  ///
  /// In en, this message translates to:
  /// **'Add balance'**
  String get add_balance;

  /// No description provided for @withdraw_balance.
  ///
  /// In en, this message translates to:
  /// **'Withdraw balance'**
  String get withdraw_balance;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @failed_to_add_balance.
  ///
  /// In en, this message translates to:
  /// **'Failed to add balance'**
  String get failed_to_add_balance;

  /// No description provided for @failed_to_withdraw_balance.
  ///
  /// In en, this message translates to:
  /// **'Failed to withdraw balance'**
  String get failed_to_withdraw_balance;

  /// No description provided for @balance_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Balance added successfully!'**
  String get balance_added_successfully;

  /// No description provided for @withdrawal_successfully.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal successfully!'**
  String get withdrawal_successfully;

  /// No description provided for @transactions_filter.
  ///
  /// In en, this message translates to:
  /// **'Transactions Filter'**
  String get transactions_filter;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @top_tags.
  ///
  /// In en, this message translates to:
  /// **'Top Tags'**
  String get top_tags;

  /// No description provided for @top_tags_subtitle.
  ///
  /// In en, this message translates to:
  /// **'View top tags to track spending, income, and debt trends.'**
  String get top_tags_subtitle;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contacts_empty_screen_title.
  ///
  /// In en, this message translates to:
  /// **'No Contacts Yet'**
  String get contacts_empty_screen_title;

  /// No description provided for @contacts_empty_screen_description.
  ///
  /// In en, this message translates to:
  /// **'Start by adding contacts to easily link transactions with people or businesses.'**
  String get contacts_empty_screen_description;

  /// No description provided for @contact_phone_number_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get contact_phone_number_hint_text;

  /// No description provided for @contact_note_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Enter note'**
  String get contact_note_hint_text;

  /// No description provided for @transaction_details.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transaction_details;

  /// No description provided for @show_details.
  ///
  /// In en, this message translates to:
  /// **'Show Details'**
  String get show_details;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
