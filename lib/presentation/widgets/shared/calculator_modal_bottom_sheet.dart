import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:zenthory/core/core.dart';
import 'package:zenthory/presentation/presentation.dart';

class CalculatorModalBottomSheet extends StatefulWidget {
  final String defaultInput;
  final Function(double value) onPressOk;

  const CalculatorModalBottomSheet({
    super.key,
    required this.onPressOk,
    this.defaultInput = '',
  });

  @override
  State<CalculatorModalBottomSheet> createState() =>
      _CalculatorModalBottomSheetState();
}

class _CalculatorModalBottomSheetState
    extends State<CalculatorModalBottomSheet> {
  String input = '';
  String result = '';
  List<String> history = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    input = widget.defaultInput;
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheet(
      padding: EdgeInsets.all(AppDimensions.padding * 1.5),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (history.isNotEmpty)
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(bottom: 20),
              itemCount: history.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  history[index],
                  textAlign: TextAlign.right,
                  style: TextStyle(color: context.colors.textPlaceholder),
                ),
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (input.isNotEmpty)
                Text(
                  input,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              if (input.isEmpty)
                Text(
                  "0",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              if (result.isNotEmpty)
                Text(
                  '= $result',
                  style: TextStyle(
                    fontSize: 24,
                    color: context.colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 11,
          runSpacing: 11,
          children: AppStrings.calculatorButtons
              .map(
                (String symbol) =>
                    CalculatorButton(label: symbol, onTap: onButtonPressed),
              )
              .toList(),
        ),
        SizedBox(height: 20),
        FormBottomNavigationBar(
          primaryColor: context.colors.secondary,
          padding: EdgeInsets.zero,
          okButtonText: context.tr!.ok,
          paddingCancelButton: EdgeInsets.only(
            left: context.isRtl ? 15 : 0,
            right: context.isRtl ? 0 : 15,
          ),
          paddingOkButton: EdgeInsets.only(
            left: context.isRtl ? 0 : 15,
            right: context.isRtl ? 15 : 0,
          ),
          okButtonOnPressed: isError || result.isEmpty
              ? null
              : () {
                  widget.onPressOk(double.tryParse(result) ?? 0.0);
                  Navigator.pop(context);
                },
        ),
      ],
    );
  }

  void onButtonPressed(String symbol) {
    setState(() {
      if (symbol == 'C') {
        input = '';
        result = '';
        history = [];
        isError = false;
      } else if (symbol == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (symbol == '=') {
        try {
          final parser = ShuntingYardParser();
          final expression = parser.parse(
            input
                .replaceAll('×', '*')
                .replaceAll('÷', '/')
                .replaceAll('%', '*0.01'),
          );

          final evaluator = RealEvaluator();

          final evalResult = evaluator.evaluate(expression);
          result = evalResult.toString();
          history.insert(0, '$input = $result');
          input = result;
          isError = false;
        } catch (e) {
          result = context.tr!.error;
          isError = true;
        }
      } else {
        input += symbol;
      }
    });
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final Function(String symbol) onTap;

  const CalculatorButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.19;
    return GestureDetector(
      onTap: label.isEmpty ? null : () => onTap(label),
      child: Container(
        width: width,
        height: width * 0.85,
        decoration: BoxDecoration(
          color: bgTransparent
              ? Colors.transparent
              : (bgReversed
                    ? context.colors.secondary
                    : context.colors.surface),
          borderRadius: BorderRadius.circular(width * 0.20),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: bgReversed
                  ? Colors.white
                  : (labelColored
                        ? context.colors.secondary
                        : context.colors.textPrimary),
            ),
          ),
        ),
      ),
    );
  }

  bool get labelColored =>
      ['C', 'DEL', '%', '/', '*', '-', '+'].contains(label);

  bool get bgReversed => "=" == label;

  bool get bgTransparent => label.isEmpty;
}
