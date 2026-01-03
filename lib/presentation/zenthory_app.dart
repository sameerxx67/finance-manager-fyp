import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zenthory/zenthory.dart';

class ZenthoryApp extends StatelessWidget {
  final Locale locale;
  final ThemeMode themeMode;

  const ZenthoryApp({super.key, required this.locale, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => SharedCubit(locale, themeMode),
        ),
        BlocProvider(create: (BuildContext context) => HomeCubit()),
      ],
      child: BlocBuilder<SharedCubit, SharedState>(
        buildWhen: (previous, current) => current.runtimeType == SharedInitial,
        builder: (BuildContext context, SharedState state) {
          if (state is SharedInitial) {
            return MaterialApp(
              title: context.tr?.app_name,
              theme: lightThemeData,
              darkTheme: darkThemeData,
              themeMode: state.themeMode,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppStrings.supportedLocales,
              locale: state.locale,
              localeResolutionCallback: (locale, supportedLocales) {
                return supportedLocales.contains(locale)
                    ? locale
                    : supportedLocales.first;
              },
              home: BlocListener<SharedCubit, SharedState>(
                listener: (context, state) {
                  if (state is ShowModalBottomSheet) {
                    _showModalBottomSheet(
                      context,
                      state.builder,
                      backgroundColor: state.backgroundColor,
                    );
                  } else if (state is ShowDialog) {
                    _showDialog(
                      context: context,
                      type: state.type,
                      title: state.title,
                      message: state.message,
                      icon: state.icon,
                      callbackConfirm: state.callbackConfirm,
                    );
                  } else if (state is ShowSnackBar) {
                    _showSnackBar(
                      context: context,
                      message: state.message,
                      duration: state.duration,
                    );
                  }
                },
                child: const HomeScreen(),
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  void _showModalBottomSheet(
    BuildContext context,
    WidgetBuilder builder, {
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: context.isRtl
              ? Radius.zero
              : Radius.circular(MediaQuery.of(context).size.width * 0.11),
          topLeft: !context.isRtl
              ? Radius.zero
              : Radius.circular(MediaQuery.of(context).size.width * 0.11),
        ),
      ),
      constraints: BoxConstraints(minHeight: 0),
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: builder,
    );
  }

  void _showDialog({
    required BuildContext context,
    required AlertDialogType type,
    required String title,
    required String message,
    VoidCallback? callbackConfirm,
    String? icon,
  }) {
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: isRtl ? Radius.circular(25) : Radius.circular(2),
              topRight: !isRtl ? Radius.circular(25) : Radius.circular(2),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          icon: icon != null || type != AlertDialogType.confirm
              ? SvgIcon(
                  icon:
                      icon ??
                      (type == AlertDialogType.error
                          ? AppImages.error
                          : (type == AlertDialogType.success
                                ? AppImages.success
                                : AppImages.warning)),
                  width: MediaQuery.of(context).size.width * 0.15,
                  color: icon != null ? context.colors.textSecondary : null,
                )
              : null,
          title: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: type == AlertDialogType.error
                  ? context.colors.error
                  : (type == AlertDialogType.success
                        ? context.colors.success
                        : (type == AlertDialogType.confirm
                              ? context.colors.textPrimary
                              : context.colors.warning)),
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.padding,
            ),
            child: Text(message, textAlign: TextAlign.center),
          ),
          actionsPadding: EdgeInsets.zero,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.padding),
              child: Row(
                children: [
                  if (type == AlertDialogType.confirm)
                    Expanded(
                      child: FullElevatedButton(
                        width: null,
                        height: 55,
                        label: context.tr!.no,
                        borderRadius: BorderRadius.only(
                          bottomLeft: !isRtl
                              ? Radius.circular(25)
                              : Radius.zero,
                          bottomRight: isRtl
                              ? Radius.circular(25)
                              : Radius.zero,
                        ),
                        isGrayColor: true,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  Expanded(
                    child: FullElevatedButton(
                      width: null,
                      height: 55,
                      color: type == AlertDialogType.error
                          ? context.colors.error
                          : (type == AlertDialogType.success
                                ? context.colors.success
                                : type == AlertDialogType.warning
                                ? context.colors.warning
                                : null),
                      label: type == AlertDialogType.confirm
                          ? context.tr!.yes
                          : context.tr!.ok,
                      borderRadius: BorderRadius.only(
                        bottomLeft: isRtl
                            ? Radius.circular(25)
                            : (type == AlertDialogType.confirm
                                  ? Radius.zero
                                  : Radius.circular(25)),
                        bottomRight: isRtl
                            ? type == AlertDialogType.confirm
                                  ? Radius.zero
                                  : Radius.circular(25)
                            : Radius.circular(25),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (callbackConfirm != null) {
                          callbackConfirm();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        content: Row(
          children: [
            Image.asset(AppImages.logo, width: 25),
            SizedBox(width: 3),
            Text(message),
          ],
        ),
        duration: duration ?? Duration(milliseconds: 1500),
      ),
    );
  }
}
