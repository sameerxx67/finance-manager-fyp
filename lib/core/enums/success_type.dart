import 'package:flutter/material.dart';
import 'package:zenthory/core/core.dart';

enum SuccessType {
  created,
  updated,
  deleted;

  String message(BuildContext context, String name) {
    switch (this) {
      case SuccessType.created:
        return context.tr!.resource_created(name);
      case SuccessType.updated:
        return context.tr!.resource_updated(name);
      case SuccessType.deleted:
        return context.tr!.resource_deleted(name);
    }
  }
}
