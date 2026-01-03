import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenthory/zenthory.dart';

class WalletFormScreen extends StatefulWidget {
  final WalletModel? wallet;

  const WalletFormScreen({super.key, this.wallet});

  @override
  State<WalletFormScreen> createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends State<WalletFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.wallet != null) {
      _nameController.text = widget.wallet!.name;
      _balanceController.text = widget.wallet!.balance.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      buildWhen: (previous, current) =>
          current.runtimeType == WalletFormInitial,
      builder: (context, state) {
        if (state is WalletFormInitial) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.wallet == null
                    ? context.tr!.create_resource(context.tr!.wallet)
                    : context.tr!.update_resource(context.tr!.wallet),
              ),
            ),
            bottomNavigationBar: FormBottomNavigationBar(
              okButtonOnPressed: () async {
                if (await context.read<WalletCubit>().submit(
                  {
                    "name_is_required": context.tr!.attribute_is_required(
                      context.tr!.name,
                    ),
                    "name_should_be_between_min_to_max_characters": context.tr!
                        .attribute_should_be_between_min_to_max_characters(
                          context.tr!.name,
                          50,
                          2,
                        ),
                    "this_name_is_already_used": context.tr!
                        .this_attribute_is_already_used(context.tr!.name),
                    "type_is_required": context.tr!.attribute_is_required(
                      context.tr!.type,
                    ),
                  },
                  widget.wallet,
                  _nameController.text,
                  double.tryParse(_balanceController.text),
                )) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              okButtonLoading: state.processing,
              okButtonText: widget.wallet == null
                  ? context.tr!.create
                  : context.tr!.update,
            ),
            body: Column(
              children: [
                CustomDropdownMenu(
                  label: context.tr!.type,
                  defaultIcon: AppIcons.wallets,
                  selectedId: state.type,
                  options: WalletType.values
                      .map(
                        (WalletType type) => CustomDropdownMenuOption(
                          id: type,
                          name: type.toTrans(context),
                          icon: type.icon,
                          color: type.color,
                        ),
                      )
                      .toList(),
                  onSelect: (dynamic id) =>
                      context.read<WalletCubit>().setData(type: id),
                ),
                ContainerForm(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: context.tr!.name,
                        controller: _nameController,
                        hintText: context.tr!.enter_resource_name(
                          context.tr!.wallet,
                        ),
                        errorText: state.errors['name'],
                        maxLength: 50,
                      ),
                      CustomTextFormField(
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        paddingBottom: 0,
                        label:
                            "${context.tr!.current_balance} ( ${state.currency} )",
                        controller: _balanceController,
                        hintText: Money.inDefaultCurrency(
                          0.00,
                        ).format(currency: state.currency),
                        errorText: state.errors['balance'],
                        suffixIcon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () => _showCurrencyPicker(context),
                            icon: Text(
                              state.currency,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showCurrencyPicker(
      context: context,
      theme: CurrencyPickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(MediaQuery.of(context).size.width * 0.11),
          ),
        ),
        flagSize: 30,
        titleTextStyle: TextStyle(fontSize: 15),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.70,
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: context.colors.textSecondary,
        ),
        inputDecoration: InputDecoration(
          hintText: context.tr!.currency_search,
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SvgIcon(
              icon: AppIcons.searchCurrency,
              color: context.colors.textPrimary,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colors.inputBorder.withValues(alpha: 0.2),
            ),
          ),
        ),
      ),
      onSelect: (Currency currency) =>
          context.read<WalletCubit>().setData(currency: currency.code),
    );
  }
}
