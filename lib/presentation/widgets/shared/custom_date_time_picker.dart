import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CustomDateTimePicker extends StatefulWidget {
  final String label;
  final String? errorText;
  final DateTime? dateTime;
  final DateTime? lastDate;
  final DateTime? firstDate;
  final Function(DateTime)? onPicked;
  final EdgeInsetsGeometry? margin;
  final bool onlyDate;
  final bool range;
  final bool hasDivider;

  const CustomDateTimePicker({
    super.key,
    required this.label,
    this.errorText,
    this.lastDate,
    this.firstDate,
    this.dateTime,
    this.margin,
    this.range = false,
    this.onlyDate = false,
    this.hasDivider = false,
    this.onPicked,
  });

  @override
  State<CustomDateTimePicker> createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  String? date;
  String? time;

  @override
  void initState() {
    super.initState();
    _setDateTime(newDatetime: widget.dateTime);
  }

  void _setDateTime({DateTime? newDatetime}) {
    if (newDatetime != null) {
      setState(() {
        date = context.read<SharedCubit>().formatDate(newDatetime);
        if (!widget.onlyDate) {
          time = context.read<SharedCubit>().formatTime(newDatetime);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant CustomDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dateTime != widget.dateTime) {
      _setDateTime(newDatetime: widget.dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        margin: widget.margin ?? EdgeInsets.only(bottom: 10),
        color: context.colors.surface,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                width: 33,
                height: 33,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgIcon(
                    icon: AppIcons.dateTime,
                    color: context.colors.primary,
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "$date ${widget.onlyDate ? '' : time}",
                    style: TextStyle(
                      color: context.colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              subtitle: widget.errorText != null
                  ? Text(
                      widget.errorText!,
                      style: TextStyle(
                        color: context.colors.error,
                        fontSize: 12,
                      ),
                    )
                  : null,
            ),
            if (widget.hasDivider)
              Divider(
                height: 0,
                color: context.colors.divider.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      cancelText: context.tr!.cancel,
      confirmText: context.tr!.ok.toUpperCase(),
      helpText: context.tr!.select_date,
      initialDate: widget.dateTime,
      firstDate: widget.firstDate ?? DateTime(2000),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (date == null) return;
    if (!widget.onlyDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final time = await showTimePicker(
          cancelText: context.tr!.cancel,
          confirmText: context.tr!.ok.toUpperCase(),
          helpText: context.tr!.select_time,
          context: context,
          initialTime: TimeOfDay.fromDateTime(widget.dateTime!),
        );

        if (time == null) return;

        if (widget.onPicked != null) {
          final DateTime selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          widget.onPicked!(selectedDate);
          _setDateTime(newDatetime: selectedDate);
        }
      });
    } else {
      if (widget.onPicked != null) {
        final DateTime selectedDate = DateTime(date.year, date.month, date.day);
        widget.onPicked!(selectedDate);
        _setDateTime(newDatetime: selectedDate);
      }
    }
  }
}
