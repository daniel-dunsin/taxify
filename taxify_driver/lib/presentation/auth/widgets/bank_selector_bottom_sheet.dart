import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/data/payment/bank_model.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class BankSelectorBottomSheet extends StatefulWidget {
  final List<BankModel> banks;
  final Function(BankModel bank) onSelectBank;

  const BankSelectorBottomSheet({
    super.key,
    required this.banks,
    required this.onSelectBank,
  });

  @override
  State<BankSelectorBottomSheet> createState() =>
      _BankSelectorBottomSheetState();
}

class _BankSelectorBottomSheetState extends State<BankSelectorBottomSheet> {
  late TextEditingController _searchController = TextEditingController();
  late List<BankModel> banks = [];

  @override
  void initState() {
    banks = widget.banks;
    _searchController =
        TextEditingController()..addListener(() {
          setState(() {
            banks =
                widget.banks
                    .where(
                      (b) => b.name.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();
          });
        });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: AppTextInput(
            hintText: "Search banks",
            suffixIcon: Icon(
              Icons.search,
              color: getColorSchema(context).onPrimary,
            ),
            fillColor: checkLightMode(context) ? Colors.grey[200] : null,
            controller: _searchController,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final bank = banks[index];
              return ListTile(
                onTap: () {
                  widget.onSelectBank(bank);
                  GoRouter.of(context).pop();
                },
                title: Text(bank.name),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(bank.logo),
                  radius: 20,
                ),
              );
            },
            itemCount: banks.length,
          ),
        ),
      ],
    );
  }
}
