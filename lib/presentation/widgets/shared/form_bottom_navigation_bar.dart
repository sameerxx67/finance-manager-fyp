import 'package:flutter/material.dart';
import 'package:zenthory/zenthory.dart';

class FormBottomNavigationBar extends StatelessWidget {
  final String? okButtonText;
  final String? cancelButtonText;
  final bool hasCancelButton;
  final VoidCallback? okButtonOnPressed;
  final VoidCallback? cancelButtonOnPressed;
  final bool okButtonLoading;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? paddingCancelButton;
  final EdgeInsetsGeometry? paddingOkButton;
  final Color? primaryColor;

  const FormBottomNavigationBar({
    super.key,
    this.okButtonText,
    this.cancelButtonText,
    this.okButtonOnPressed,
    this.cancelButtonOnPressed,
    this.paddingCancelButton,
    this.paddingOkButton,
    this.hasCancelButton = true,
    this.okButtonLoading = false,
    this.padding,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    paddingCancelButton ??
                    const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (!okButtonLoading) {
                      if (cancelButtonOnPressed != null) {
                        cancelButtonOnPressed!();
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Colors.grey[200]!,
                    ),
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.black,
                    ),
                    elevation: WidgetStateProperty.all<double>(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(cancelButtonText ?? context.tr!.cancel),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    paddingOkButton ??
                    const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (okButtonOnPressed != null && !okButtonLoading) {
                      okButtonOnPressed!();
                    }
                  },
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all<double>(0),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      primaryColor ?? Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: okButtonLoading ? 6 : 4,
                    ),
                    child: okButtonLoading
                        ? SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(okButtonText ?? context.tr!.done),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
