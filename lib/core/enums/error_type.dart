import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

enum ErrorType {
  failedToLoad,
  failedToAdd,
  failedToAddBalance,
  failedToWithdrawBalance,
  failedToUpdate,
  failedToDelete;

  String title(BuildContext context, String pluralName, String singularName) {
    switch (this) {
      case ErrorType.failedToLoad:
        return context.tr!.load_resource(pluralName);
      case ErrorType.failedToAdd:
        return context.tr!.create_resource(singularName);
      case ErrorType.failedToUpdate:
        return context.tr!.edit_resource(singularName);
      case ErrorType.failedToDelete:
        return context.tr!.delete_resource(singularName);
      case ErrorType.failedToAddBalance:
        return context.tr!.add_balance;
      case ErrorType.failedToWithdrawBalance:
        return context.tr!.withdraw_balance;
    }
  }

  String message(BuildContext context, String pluralName, String singularName) {
    switch (this) {
      case ErrorType.failedToLoad:
        return context.tr!.error_failed_to_load(pluralName);
      case ErrorType.failedToAdd:
        return context.tr!.error_failed_to_add(singularName);
      case ErrorType.failedToUpdate:
        return context.tr!.error_failed_to_update(singularName);
      case ErrorType.failedToDelete:
        return context.tr!.error_failed_to_delete(singularName);
      case ErrorType.failedToAddBalance:
        return context.tr!.failed_to_add_balance;
      case ErrorType.failedToWithdrawBalance:
        return context.tr!.failed_to_withdraw_balance;
    }
  }
}
