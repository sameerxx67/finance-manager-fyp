// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_name => 'Zenthory';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'موافق';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get transactions => 'المعاملات';

  @override
  String get report => 'تقرير';

  @override
  String get settings => 'الإعدادات';

  @override
  String get management => 'الإدارة';

  @override
  String get language => 'اللغة';

  @override
  String get theme_mode => 'السمة';

  @override
  String get app_preferences => 'تفضيلات التطبيق';

  @override
  String get light_theme => 'فاتح';

  @override
  String get dark_theme => 'داكن';

  @override
  String get follow_device_theme => 'اتباع سمة الجهاز';

  @override
  String get app_lock => 'قفل التطبيق';

  @override
  String app_lock_description(Object app_name) {
    return 'استخدم رمز PIN أو النمط أو القياسات الحيوية لهاتفك لفتح $app_name';
  }

  @override
  String get screenshot => 'لقطة الشاشة';

  @override
  String get enable_screenshot_description => 'السماح بالتقاط لقطات الشاشة داخل واجهة التطبيق.';

  @override
  String get security => 'الأمان';

  @override
  String about_app(Object app_name) {
    return 'حول $app_name';
  }

  @override
  String share_app(Object app_name) {
    return 'مشاركة $app_name';
  }

  @override
  String lock_app_localized_reason(Object app_name) {
    return 'سيُطلب منك المصادقة في كل مرة تفتح فيها $app_name.';
  }

  @override
  String unlock_app_localized_reason(Object app_name) {
    return 'لن تكون المصادقة مطلوبة لفتح $app_name.';
  }

  @override
  String get enable_screenshot_localized_reason => 'يرجى التحقق للسماح بوظيفة لقطة الشاشة';

  @override
  String get disable_screenshot_localized_reason => 'قم بتأكيد هويتك لحظر لقطات الشاشة';

  @override
  String share_app_description(Object app_name, Object url) {
    return 'تحكم في أموالك مع $app_name - أداة تتبع النفقات الذكية والعصرية التي تساعدك في إدارة دخلك وإنفاقك وميزانياتك في مكان واحد. بتصميم أنيق ورؤى قوية ودعم متعدد العملات واللغات، فهو كل ما تحتاجه لبناء عادات مالية أفضل. حمل الآن وابدأ التتبع بذكاء: $url';
  }

  @override
  String version(Object number) {
    return 'الإصدار $number';
  }

  @override
  String about_app_description_1(Object app_name) {
    return '$app_name هو تطبيق حديث لتتبع النفقات مصمم لمساعدتك في السيطرة الكاملة على أموالك الشخصية. سواء كنت تدير الإنفاق اليومي أو تحلل الاتجاهات المالية، يقدم $app_name واجهة سهلة الاستخدام مع أدوات قوية لإبقائك منظمًا.';
  }

  @override
  String about_app_description_2(Object app_name) {
    return 'بميزات مثل دعم العملات المتعددة، وقفل التطبيق البيومتري، والفئات الذكية، وتتبع الدخل، والتقارير الفورية، يبسط $app_name طريقة إدارتك للمال - كل ذلك من هاتفك.';
  }

  @override
  String get about_app_description_3 => 'ابقَ مركزًا. أنفق بذكاء. عش بشكل أفضل.';

  @override
  String get powered_by => 'مدعوم من';

  @override
  String get currency_search => 'ابدأ الكتابة للبحث...';

  @override
  String get icon_search => 'ابدأ الكتابة للبحث...';

  @override
  String get app_locked_description => 'الوصول إلى التطبيق مقيد. يرجى المصادقة للمتابعة.';

  @override
  String get unlock => 'فتح';

  @override
  String app_locked(Object app_name) {
    return '$app_name مقفل';
  }

  @override
  String get change_language => 'تغيير اللغة';

  @override
  String get change_theme_mode => 'تغيير نمط السمة';

  @override
  String get manage_categories => 'الفئات';

  @override
  String get add_category => 'إضافة فئة';

  @override
  String get add_category_description => 'أضف فئة جديدة للنفقات أو الدخل.';

  @override
  String get manage_budgets => 'الميزانيات';

  @override
  String get manage_budgets_description => 'تتبع الإنفاق بميزانيات مخصصة.';

  @override
  String get manage_tags => 'العلامات';

  @override
  String get manage_wallets => 'المحافظ';

  @override
  String get manage_wallets_description => 'تتبع الإنفاق والرصيد عبر محافظ متعددة.';

  @override
  String get tags => 'العلامات';

  @override
  String get tag => 'علامة';

  @override
  String error_failed_to_load(Object name) {
    return 'فشل تحميل $name';
  }

  @override
  String error_failed_to_add(Object name) {
    return 'فشل إضافة $name';
  }

  @override
  String error_failed_to_update(Object name) {
    return 'فشل تحديث $name';
  }

  @override
  String error_failed_to_delete(Object name) {
    return 'فشل حذف $name';
  }

  @override
  String create_resource(Object resource) {
    return 'إنشاء $resource';
  }

  @override
  String edit_resource(Object resource) {
    return 'تعديل $resource';
  }

  @override
  String update_resource(Object resource) {
    return 'تحديث $resource';
  }

  @override
  String delete_resource(Object resource) {
    return 'حذف $resource';
  }

  @override
  String load_resource(Object resource) {
    return 'تحميل $resource';
  }

  @override
  String resource_updated(Object resource) {
    return 'تم تحديث $resource بنجاح.';
  }

  @override
  String resource_deleted(Object resource) {
    return 'تم حذف $resource بنجاح.';
  }

  @override
  String resource_created(Object resource) {
    return 'تم إنشاء $resource بنجاح.';
  }

  @override
  String get create => 'إنشاء';

  @override
  String get update => 'تحديث';

  @override
  String get name => 'الاسم';

  @override
  String get color => 'اللون';

  @override
  String enter_resource_name(Object resource) {
    return 'أدخل اسم $resource';
  }

  @override
  String get done => 'تم';

  @override
  String get cancel => 'إلغاء';

  @override
  String get color_picker => 'منتقي الألوان';

  @override
  String color_picker_description(Object resource) {
    return 'اختر لون $resource لتنظيم مرئيًا.';
  }

  @override
  String attribute_is_required(Object attribute) {
    return '$attribute مطلوب.';
  }

  @override
  String this_attribute_is_already_used(Object attribute) {
    return 'هذا $attribute مستخدم بالفعل.';
  }

  @override
  String attribute_should_be_between_min_to_max_characters(Object attribute, Object max, Object min) {
    return 'يجب أن يكون $attribute بين $min إلى $max حرفًا';
  }

  @override
  String get tags_empty_screen_title => 'لا توجد علامات بعد';

  @override
  String get tags_empty_screen_description => 'أنشئ علامتك الأولى لتنظيم المعاملات.';

  @override
  String confirm_delete_resource_message(Object name, Object resource) {
    return 'هل أنت متأكد أنك تريد حذف $resource $name؟ لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get categories_empty_screen_title => 'لا توجد فئات بعد';

  @override
  String get categories_empty_screen_description => 'أنشئ فئتك الأولى لتنظيم المعاملات.';

  @override
  String get category => 'فئة';

  @override
  String get categories => 'الفئات';

  @override
  String get expenses => 'النفقات';

  @override
  String get income => 'الدخل';

  @override
  String get debts => 'الديون';

  @override
  String get type => 'النوع';

  @override
  String get icon => 'الأيقونة';

  @override
  String get icon_picker => 'منتقي الأيقونات';

  @override
  String icon_picker_description(Object resource) {
    return 'اختر أيقونة لتمثيل $resource';
  }

  @override
  String get cash => 'نقدي';

  @override
  String get bank => 'بنك';

  @override
  String get credit_card => 'بطاقة ائتمان';

  @override
  String get e_wallet => 'محفظة إلكترونية';

  @override
  String get investment => 'استثمار';

  @override
  String get other => 'أخرى';

  @override
  String get wallet => 'محفظة';

  @override
  String get wallets => 'المحافظ';

  @override
  String get wallets_empty_screen_title => 'لا توجد محافظ بعد';

  @override
  String get wallets_empty_screen_description => 'أنشئ محفظة لبدء تتبع أرصدتك ومعاملاتك.';

  @override
  String get balance => 'الرصيد';

  @override
  String get currency => 'العملة';

  @override
  String get default_currency => 'العملة الافتراضية';

  @override
  String attribute_must_be_greater_than_number(Object attribute, Object number) {
    return 'يجب أن يكون $attribute أكبر من $number.';
  }

  @override
  String get current_balance => 'الرصيد الحالي';

  @override
  String get end_date_must_be_after_start_date => 'يجب أن يكون تاريخ الانتهاء بعد تاريخ البدء.';

  @override
  String get budget => 'الميزانية';

  @override
  String get budgets => 'الميزانيات';

  @override
  String get budgets_empty_screen_title => 'لا توجد ميزانيات بعد';

  @override
  String get budgets_empty_screen_description => 'ابدأ بإنشاء ميزانية لإدارة إنفاقك وتتبع أهدافك.';

  @override
  String get note => 'ملاحظة';

  @override
  String get start_date => 'تاريخ البدء';

  @override
  String get end_date => 'تاريخ الانتهاء';

  @override
  String get budget_note_placeholder => 'ملاحظات حول هذه الميزانية';

  @override
  String get budget_range => 'نطاق الميزانية';

  @override
  String select_resource(Object resource) {
    return 'اختر $resource';
  }

  @override
  String attribute_must_not_exceed_number_characters(Object attribute, Object number) {
    return 'يجب ألا يتجاوز $attribute $number حرفًا.';
  }

  @override
  String get amount => 'المبلغ';

  @override
  String get budget_limit => 'حد الميزانية';

  @override
  String get spent_of => 'تم إنفاقه من';

  @override
  String get wallet_displayed_balance_message => 'يتم عرض رصيد المحفظة على الشاشة الرئيسية.';

  @override
  String get wallet_hidden_balance_message => 'رصيد المحفظة مخفي على الشاشة الرئيسية';

  @override
  String get wallet_blocked_balance_message => 'تم حظر المحفظة من التطبيق.';

  @override
  String get wallet_unblocked_balance_message => 'تم إلغاء حظر المحفظة من التطبيق.';

  @override
  String get select_type => 'اختر النوع';

  @override
  String get main_category => 'الفئة الرئيسية';

  @override
  String confirm_message_delete_without_sub_category(Object name, Object resource) {
    return 'هل أنت متأكد أنك تريد حذف $resource \"$name\"؟\n سيتم إزالة جميع المعاملات المتعلقة بهذا القسم، وسيتم استعادة أرصدة المحافظ المرتبطة إلى حالتها السابقة.';
  }

  @override
  String confirm_message_delete_has_sub_category(Object name, Object resource) {
    return 'هل أنت متأكد أنك تريد حذف $resource \"$name\"؟\n سيتم حذف جميع المعاملات المتعلقة بهذا القسم وأقسامه الفرعية، وسيتم استعادة أرصدة المحافظ المرتبطة إلى حالتها السابقة.';
  }

  @override
  String get transaction => 'معاملة';

  @override
  String get transaction_empty_screen_title => 'لا توجد معاملات بعد';

  @override
  String get transaction_empty_screen_description => 'ابدأ بإضافة معاملة جديدة لتتبع نفقاتك ودخلك وديونك.';

  @override
  String get confirm_delete_transaction_message => 'هل أنت متأكد أنك تريد حذف هذه المعاملة؟ سيقوم هذا الإجراء بتحديث رصيد المحفظة إلى حالته السابقة.';

  @override
  String hint_text_transaction_amount(Object currency) {
    return 'مثال $currency 5.00';
  }

  @override
  String get transaction_note_placeholder => 'ملاحظات حول هذه المعاملة';

  @override
  String get transaction_date => 'تاريخ المعاملة';

  @override
  String get select_category => 'اختر فئة';

  @override
  String get select_wallet => 'اختر محفظة';

  @override
  String get select_time => 'اختر الوقت';

  @override
  String get select_date => 'اختر التاريخ';

  @override
  String get no_impact_on_balance => 'لا يؤثر على الرصيد';

  @override
  String get no_impact_on_balance_description => 'عند التمكين، لن يتم تضمين هذه المعاملة في رصيد المحفظة المحددة.';

  @override
  String get currency_rate => 'سعر الصرف';

  @override
  String get currency_rates => 'أسعار الصرف';

  @override
  String add_with_resource(Object resource) {
    return 'إضافة $resource';
  }

  @override
  String currency_rates_with_default_currency(Object defaultCurrency) {
    return 'أسعار الصرف (الأساس: $defaultCurrency)';
  }

  @override
  String get currency_rates_update_description => 'إدارة وتحديث أسعار الصرف للعملات المختلفة بناءً على عملتك الافتراضية.';

  @override
  String rate_title_input(Object currency, Object defaultCurrency) {
    return 'السعر من ($defaultCurrency) إلى ($currency)';
  }

  @override
  String hint_text_rate(Object currency) {
    return 'مثال $currency 0.70';
  }

  @override
  String get stop_automatic_currency_rate_adjustment => 'إيقاف التعديل التلقائي لسعر الصرف';

  @override
  String get save => 'حفظ';

  @override
  String get total_balance => 'إجمالي الرصيد';

  @override
  String get add_income_description => 'تسجيل الأموال التي تلقتها.';

  @override
  String get add_expenses_description => 'تسجيل عملية شراء أو دفعة جديدة.';

  @override
  String get add_debts_description => 'تتبع الأموال المقترضة أو المستحقة.';

  @override
  String get view_all => 'عرض الكل';

  @override
  String get recent_transactions => 'آخر المعاملات';

  @override
  String get dashboard_analytics_title => 'الدخل مقابل النفقات هذا الأسبوع';

  @override
  String get dashboard_analytics_subtitle => 'تفصيل يومي للنشاط المالي';

  @override
  String get weekly_chart_empty_title => 'لا توجد بيانات لعرضها';

  @override
  String get weekly_chart_empty_description => 'أضف معاملات دخل أو نفقات لرؤية الرسم البياني الأسبوعي.';

  @override
  String get mon => 'الإثنين';

  @override
  String get tue => 'الثلاثاء';

  @override
  String get wed => 'الأربعاء';

  @override
  String get thu => 'الخميس';

  @override
  String get fri => 'الجمعة';

  @override
  String get sat => 'السبت';

  @override
  String get sun => 'الأحد';

  @override
  String get report_filter => 'تصفية التقرير';

  @override
  String get date_range => 'نطاق التاريخ';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get total_income => 'إجمالي الدخل';

  @override
  String get total_expenses => 'إجمالي النفقات';

  @override
  String get net_balance => 'صافي الرصيد';

  @override
  String get debts_paid => 'ديون مدفوعة';

  @override
  String get debts_received => 'ديون مستلمة';

  @override
  String get financial_summary => 'ملخص مالي';

  @override
  String get debts_summary => 'ملخص الديون';

  @override
  String get no_data_available => 'لا توجد بيانات متاحة';

  @override
  String get report_categories_income_title => 'أهم مصادر الدخل';

  @override
  String get report_categories_income_subtitle => 'أكثر تدفقات الدخل تكرارًا وقيمة لديك.';

  @override
  String get report_categories_expenses_title => 'أهم مجالات الإنفاق';

  @override
  String get report_categories_expenses_subtitle => 'الفئات التي تنفق فيها معظم أموالك.';

  @override
  String get monthly_summary_title => 'الدخل الشهري مقابل النفقات';

  @override
  String get monthly_summary_subtitle => 'تتبع الدخل والنفقات شهرًا بشهر.';

  @override
  String get add_balance => 'إضافة رصيد';

  @override
  String get withdraw_balance => 'سحب رصيد';

  @override
  String get withdraw => 'سحب';

  @override
  String get add => 'إضافة';

  @override
  String get failed_to_add_balance => 'فشل إضافة الرصيد';

  @override
  String get failed_to_withdraw_balance => 'فشل سحب الرصيد';

  @override
  String get balance_added_successfully => 'تمت إضافة الرصيد بنجاح!';

  @override
  String get withdrawal_successfully => 'تم السحب بنجاح!';

  @override
  String get transactions_filter => 'تصفية المعاملات';

  @override
  String get search => 'بحث...';

  @override
  String get top_tags => 'أهم العلامات';

  @override
  String get top_tags_subtitle => 'عرض أهم العلامات لتتبع اتجاهات الإنفاق والدخل والديون.';

  @override
  String get contacts => 'جهات الاتصال';

  @override
  String get contact => 'جهة اتصال';

  @override
  String get contacts_empty_screen_title => 'لا توجد جهات اتصال بعد';

  @override
  String get contacts_empty_screen_description => 'ابدأ بإضافة جهات اتصال لربط المعاملات بالأشخاص أو الأعمال بسهولة.';

  @override
  String get contact_phone_number_hint_text => 'أدخل رقم الهاتف';

  @override
  String get contact_note_hint_text => 'أدخل ملاحظة';

  @override
  String get transaction_details => 'تفاصيل المعاملة';

  @override
  String get show_details => 'عرض التفاصيل';

  @override
  String get error => 'خطأ';
}
