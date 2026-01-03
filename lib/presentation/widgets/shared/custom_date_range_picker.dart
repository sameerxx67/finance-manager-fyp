import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CustomDateRangePicker extends StatefulWidget {
  final String label;
  final String? errorText;
  final Function(DateTimeRange range)? onPicked;
  final EdgeInsetsGeometry? margin;
  final DateTime? startDate;
  final DateTime? endDate;

  const CustomDateRangePicker({
    super.key,
    required this.label,
    this.errorText,
    this.startDate,
    this.endDate,
    this.margin,
    this.onPicked,
  });

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTimeRange? dateTimeRange;

  @override
  void initState() {
    super.initState();
    if (widget.startDate != null && widget.endDate != null) {
      setState(() {
        dateTimeRange = DateTimeRange(
          start: widget.startDate!,
          end: widget.endDate!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPicker,
      child: Container(
        margin: widget.margin ?? EdgeInsets.only(bottom: 10),
        color: context.colors.surface,
        child: ListTile(
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
              Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold)),
              if (dateTimeRange != null)
                Text(
                  context.read<SharedCubit>().formatRange(
                    dateTimeRange!.start,
                    dateTimeRange!.end,
                  ),
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
                  style: TextStyle(color: context.colors.error, fontSize: 12),
                )
              : null,
        ),
      ),
    );
  }

  Future<void> _openPicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: widget.startDate ?? DateTime.now(),
        end:
            widget.endDate ??
            DateTime.now().add(
              const Duration(days: AppStrings.defaultBudgetDurationDays),
            ),
      ),
    );

    if (picked != null) {
      setState(() {
        dateTimeRange = picked;
      });
      if (widget.onPicked != null) {
        widget.onPicked!(picked);
      }
    }
  }
}
