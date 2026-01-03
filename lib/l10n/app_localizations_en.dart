// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Zenthory';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'Ok';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get transactions => 'Transactions';

  @override
  String get report => 'Report';

  @override
  String get settings => 'Settings';

  @override
  String get management => 'Management';

  @override
  String get language => 'Language';

  @override
  String get theme_mode => 'Theme';

  @override
  String get app_preferences => 'App Preferences';

  @override
  String get light_theme => 'Light';

  @override
  String get dark_theme => 'Dark';

  @override
  String get follow_device_theme => 'Follow device theme';

  @override
  String get app_lock => 'App lock';

  @override
  String app_lock_description(Object app_name) {
    return 'Use your phone\'s PIN, pattern, or biometrics to unlock $app_name';
  }

  @override
  String get screenshot => 'Screenshot';

  @override
  String get enable_screenshot_description => 'Allow screenshots within the app interface.';

  @override
  String get security => 'Security';

  @override
  String about_app(Object app_name) {
    return 'About $app_name';
  }

  @override
  String share_app(Object app_name) {
    return 'Share $app_name';
  }

  @override
  String lock_app_localized_reason(Object app_name) {
    return 'Every time you open $app_name, you will be asked to authenticate.';
  }

  @override
  String unlock_app_localized_reason(Object app_name) {
    return 'Authentication will no longer be required to open $app_name.';
  }

  @override
  String get enable_screenshot_localized_reason => 'Please verify to allow screenshot functionality';

  @override
  String get disable_screenshot_localized_reason => 'Confirm your identity to block screenshots';

  @override
  String share_app_description(Object app_name, Object url) {
    return 'Take control of your finances with $app_name — a smart, modern expense tracker that helps you manage your income, spending, and budgets all in one place. With a clean design, powerful insights, and support for multiple currencies and languages, it’s everything you need to build better financial habits. Download now and start tracking smarter: $url';
  }

  @override
  String version(Object number) {
    return 'Version $number';
  }

  @override
  String about_app_description_1(Object app_name) {
    return '$app_name is a modern expense tracking application designed to help you take full control of your personal finances. Whether you\'re managing daily spending, or analyzing financial trends, $app_name offers a clean, intuitive interface with powerful tools to keep you organized.';
  }

  @override
  String about_app_description_2(Object app_name) {
    return 'With features like multi-currency support, biometric app lock, smart categories, income tracking, and real-time reports, $app_name simplifies the way you manage money — all from your phone.';
  }

  @override
  String get about_app_description_3 => 'Stay focused. Spend smarter. Live better.';

  @override
  String get powered_by => 'Powered by';

  @override
  String get currency_search => 'Start typing to search...';

  @override
  String get icon_search => 'Start typing to search...';

  @override
  String get app_locked_description => 'Access to the application is restricted. Please authenticate to continue.';

  @override
  String get unlock => 'Unlock';

  @override
  String app_locked(Object app_name) {
    return '$app_name locked';
  }

  @override
  String get change_language => 'Change Language';

  @override
  String get change_theme_mode => 'Change theme mode';

  @override
  String get manage_categories => 'Categories';

  @override
  String get add_category => 'Add Category';

  @override
  String get add_category_description => 'Add a new expense or income category.';

  @override
  String get manage_budgets => 'Budgets';

  @override
  String get manage_budgets_description => 'Track spending with custom budgets.';

  @override
  String get manage_tags => 'Tags';

  @override
  String get manage_wallets => 'Wallets';

  @override
  String get manage_wallets_description => 'Track spending and balance across multiple wallets.';

  @override
  String get tags => 'Tags';

  @override
  String get tag => 'Tag';

  @override
  String error_failed_to_load(Object name) {
    return 'Failed to load $name';
  }

  @override
  String error_failed_to_add(Object name) {
    return 'Failed to add $name';
  }

  @override
  String error_failed_to_update(Object name) {
    return 'Failed to update $name';
  }

  @override
  String error_failed_to_delete(Object name) {
    return 'Failed to delete $name';
  }

  @override
  String create_resource(Object resource) {
    return 'Create $resource';
  }

  @override
  String edit_resource(Object resource) {
    return 'Edit $resource';
  }

  @override
  String update_resource(Object resource) {
    return 'Update $resource';
  }

  @override
  String delete_resource(Object resource) {
    return 'Delete $resource';
  }

  @override
  String load_resource(Object resource) {
    return 'Load $resource';
  }

  @override
  String resource_updated(Object resource) {
    return '$resource has been updated successfully.';
  }

  @override
  String resource_deleted(Object resource) {
    return '$resource has been deleted successfully.';
  }

  @override
  String resource_created(Object resource) {
    return '$resource has been created successfully.';
  }

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get name => 'Name';

  @override
  String get color => 'Color';

  @override
  String enter_resource_name(Object resource) {
    return 'Enter $resource name';
  }

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get color_picker => 'Color Picker';

  @override
  String color_picker_description(Object resource) {
    return 'Choose a $resource color to organize visually.';
  }

  @override
  String attribute_is_required(Object attribute) {
    return '$attribute is required.';
  }

  @override
  String this_attribute_is_already_used(Object attribute) {
    return 'This $attribute is already used.';
  }

  @override
  String attribute_should_be_between_min_to_max_characters(Object attribute, Object max, Object min) {
    return '$attribute should be between $min to $max characters';
  }

  @override
  String get tags_empty_screen_title => 'No Tags Yet';

  @override
  String get tags_empty_screen_description => 'Create your first tag to organize transactions.';

  @override
  String confirm_delete_resource_message(Object name, Object resource) {
    return 'Are you sure you want to delete the $resource $name? This action cannot be undone.';
  }

  @override
  String get categories_empty_screen_title => 'No Categories Yet';

  @override
  String get categories_empty_screen_description => 'Create your first category to organize transactions.';

  @override
  String get category => 'Category';

  @override
  String get categories => 'Categories';

  @override
  String get expenses => 'Expenses';

  @override
  String get income => 'Income';

  @override
  String get debts => 'Debts';

  @override
  String get type => 'Type';

  @override
  String get icon => 'Icon';

  @override
  String get icon_picker => 'Icon Picker';

  @override
  String icon_picker_description(Object resource) {
    return 'Pick an icon to represent the $resource';
  }

  @override
  String get cash => 'Cash';

  @override
  String get bank => 'Bank';

  @override
  String get credit_card => 'Credit Card';

  @override
  String get e_wallet => 'E-Wallet';

  @override
  String get investment => 'Investment';

  @override
  String get other => 'Other';

  @override
  String get wallet => 'Wallet';

  @override
  String get wallets => 'Wallets';

  @override
  String get wallets_empty_screen_title => 'No Wallets Yet';

  @override
  String get wallets_empty_screen_description => 'Create a wallet to start tracking your balances and transactions.';

  @override
  String get balance => 'Balance';

  @override
  String get currency => 'Currency';

  @override
  String get default_currency => 'Default Currency';

  @override
  String attribute_must_be_greater_than_number(Object attribute, Object number) {
    return '$attribute must be greater than $number.';
  }

  @override
  String get current_balance => 'Current Balance';

  @override
  String get end_date_must_be_after_start_date => 'End date must be after start date.';

  @override
  String get budget => 'Budget';

  @override
  String get budgets => 'Budgets';

  @override
  String get budgets_empty_screen_title => 'No Budgets Yet';

  @override
  String get budgets_empty_screen_description => 'Start by creating a budget to manage your spending and track your goals.';

  @override
  String get note => 'Note';

  @override
  String get start_date => 'Start Date';

  @override
  String get end_date => 'End Date';

  @override
  String get budget_note_placeholder => 'Notes about this budget';

  @override
  String get budget_range => 'Budget Range';

  @override
  String select_resource(Object resource) {
    return 'Select $resource';
  }

  @override
  String attribute_must_not_exceed_number_characters(Object attribute, Object number) {
    return '$attribute must not exceed $number characters.';
  }

  @override
  String get amount => 'Amount';

  @override
  String get budget_limit => 'Budget limit';

  @override
  String get spent_of => 'spent of';

  @override
  String get wallet_displayed_balance_message => 'The wallet balance is displayed on the main screen.';

  @override
  String get wallet_hidden_balance_message => 'Wallet balance is hidden on the main screen';

  @override
  String get wallet_blocked_balance_message => 'The wallet has been blocked from the app.';

  @override
  String get wallet_unblocked_balance_message => 'The wallet has been unblocked from the app.';

  @override
  String get select_type => 'Select Type';

  @override
  String get main_category => 'Main Category';

  @override
  String confirm_message_delete_without_sub_category(Object name, Object resource) {
    return 'Are you sure you want to delete the $resource \"$name\"?\n All transactions related to this section will be removed, and the balances of the associated governorates will be restored to their previous state.';
  }

  @override
  String confirm_message_delete_has_sub_category(Object name, Object resource) {
    return 'Are you sure you want to delete the $resource \"$name\"?\n All transactions related to this section and its sub-sections will be deleted, and the balances of the associated governorates will be restored to their previous state.';
  }

  @override
  String get transaction => 'Transaction';

  @override
  String get transaction_empty_screen_title => 'No Transactions Yet';

  @override
  String get transaction_empty_screen_description => 'Start by adding a new transaction to track your expenses, income, and debts.';

  @override
  String get confirm_delete_transaction_message => 'Are you sure you want to delete this transaction? This action will update the wallet balance to its previous state.';

  @override
  String hint_text_transaction_amount(Object currency) {
    return 'e.g $currency 5.00';
  }

  @override
  String get transaction_note_placeholder => 'Notes about this transaction';

  @override
  String get transaction_date => 'Transaction Date';

  @override
  String get select_category => 'Select category';

  @override
  String get select_wallet => 'Select wallet';

  @override
  String get select_time => 'Select Time';

  @override
  String get select_date => 'Select Date';

  @override
  String get no_impact_on_balance => 'No impact on balance';

  @override
  String get no_impact_on_balance_description => 'When enabled, this transaction will be excluded from the selected wallet\'s balance.';

  @override
  String get currency_rate => 'Currency Rate';

  @override
  String get currency_rates => 'Currency rates';

  @override
  String add_with_resource(Object resource) {
    return 'Add $resource';
  }

  @override
  String currency_rates_with_default_currency(Object defaultCurrency) {
    return 'Currency Rates (Base: $defaultCurrency)';
  }

  @override
  String get currency_rates_update_description => 'Manage and update exchange rates for different currencies based on your default currency.';

  @override
  String rate_title_input(Object currency, Object defaultCurrency) {
    return 'Rate from ($defaultCurrency) to ($currency)';
  }

  @override
  String hint_text_rate(Object currency) {
    return 'e.g $currency 0.70';
  }

  @override
  String get stop_automatic_currency_rate_adjustment => 'Stop automatic currency rate adjustment';

  @override
  String get save => 'Save';

  @override
  String get total_balance => 'Total balance';

  @override
  String get add_income_description => 'Record money you\'ve received.';

  @override
  String get add_expenses_description => 'Log a new purchase or payment.';

  @override
  String get add_debts_description => 'Track borrowed or owed money.';

  @override
  String get view_all => 'View All';

  @override
  String get recent_transactions => 'Recent Transactions';

  @override
  String get dashboard_analytics_title => 'This Week\'s Income vs Expense';

  @override
  String get dashboard_analytics_subtitle => 'Daily breakdown of financial activity';

  @override
  String get weekly_chart_empty_title => 'No Data to Display';

  @override
  String get weekly_chart_empty_description => 'Add income or expense transactions to see your weekly chart.';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get report_filter => 'Report Filter';

  @override
  String get date_range => 'Date Range';

  @override
  String get reset => 'Reset';

  @override
  String get total_income => 'Total Income';

  @override
  String get total_expenses => 'Total Expenses';

  @override
  String get net_balance => 'Net Balance';

  @override
  String get debts_paid => 'Debts paid';

  @override
  String get debts_received => 'Debts received';

  @override
  String get financial_summary => 'Financial Summary';

  @override
  String get debts_summary => 'Debts Summary';

  @override
  String get no_data_available => 'No Data Available';

  @override
  String get report_categories_income_title => 'Top Income Sources';

  @override
  String get report_categories_income_subtitle => 'Your most frequent and valuable income streams.';

  @override
  String get report_categories_expenses_title => 'Top Spending Areas';

  @override
  String get report_categories_expenses_subtitle => 'Categories where you spend the most money.';

  @override
  String get monthly_summary_title => 'Monthly Income vs Expenses';

  @override
  String get monthly_summary_subtitle => 'Track income and expenses month by month.';

  @override
  String get add_balance => 'Add balance';

  @override
  String get withdraw_balance => 'Withdraw balance';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get add => 'Add';

  @override
  String get failed_to_add_balance => 'Failed to add balance';

  @override
  String get failed_to_withdraw_balance => 'Failed to withdraw balance';

  @override
  String get balance_added_successfully => 'Balance added successfully!';

  @override
  String get withdrawal_successfully => 'Withdrawal successfully!';

  @override
  String get transactions_filter => 'Transactions Filter';

  @override
  String get search => 'Search...';

  @override
  String get top_tags => 'Top Tags';

  @override
  String get top_tags_subtitle => 'View top tags to track spending, income, and debt trends.';

  @override
  String get contacts => 'Contacts';

  @override
  String get contact => 'Contact';

  @override
  String get contacts_empty_screen_title => 'No Contacts Yet';

  @override
  String get contacts_empty_screen_description => 'Start by adding contacts to easily link transactions with people or businesses.';

  @override
  String get contact_phone_number_hint_text => 'Enter phone number';

  @override
  String get contact_note_hint_text => 'Enter note';

  @override
  String get transaction_details => 'Transaction Details';

  @override
  String get show_details => 'Show Details';

  @override
  String get error => 'Error';
}
