import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class CurrencyRateScreen extends StatelessWidget {
  const CurrencyRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrencyRateCubit, CurrencyRateState>(
      listener: (context, state) {
        if (state is CurrencyRateError) {
          context.read<SharedCubit>().showDialog(
            type: AlertDialogType.error,
            title: state.type.title(
              context,
              context.tr!.currency_rates,
              context.tr!.currency_rate,
            ),
            message: state.type.message(
              context,
              context.tr!.currency_rates,
              context.tr!.currency_rate,
            ),
          );
        } else if (state is CurrencyRateSuccess) {
          context.read<SharedCubit>().showSnackBar(
            message: state.type.message(context, context.tr!.currency_rate),
          );
        }
      },
      buildWhen: (previous, current) => [
        CurrencyRateLoaded,
        CurrencyRateLoading,
        CurrencyRateError,
      ].any((type) => current.runtimeType == type),
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state is CurrencyRateLoaded
                  ? context.tr!.currency_rates_with_default_currency(
                      state.defaultCurrency,
                    )
                  : context.tr!.currency_rates,
            ),
            actions: [
              if (state is CurrencyRateLoaded)
                IconButton(
                  onPressed: state.refresh
                      ? null
                      : () => context.read<CurrencyRateCubit>().refresh(),
                  icon: state.refresh
                      ? SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.refresh_outlined),
                ),
            ],
          ),
          extendBodyBehindAppBar:
              (state is CurrencyRateLoaded && state.rates.isNotEmpty)
              ? false
              : true,
          body: Builder(
            builder: (context) {
              if (state is CurrencyRateLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CurrencyRateLoaded &&
                  state.rates.isNotEmpty) {
                return SafeArea(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 3),
                    itemCount: state.rates.length,
                    itemBuilder: (context, index) => CurrencyRateTile(
                      rate: state.rates[index],
                      onTap: (CurrencyRateModel rate) =>
                          onTap(context, rate, state.defaultCurrency),
                    ),

                    separatorBuilder: (BuildContext context, int index) =>
                        ListViewSeparatorDivider(height: 0.6),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  void onTap(
    BuildContext context,
    CurrencyRateModel currencyRateModel,
    String defaultCurrency,
  ) {
    context.read<SharedCubit>().showModalBottomSheet(
      (_) => BlocProvider.value(
        value: context.read<CurrencyRateCubit>(),
        child: UpdateCurrencyRateModalBottomSheet(
          rate: currencyRateModel,
          defaultCurrency: defaultCurrency,
          onSave: (double rate, bool isLocked) => context
              .read<CurrencyRateCubit>()
              .updateRate(currencyRateModel, rate, isLocked),
        ),
      ),
    );
  }
}
