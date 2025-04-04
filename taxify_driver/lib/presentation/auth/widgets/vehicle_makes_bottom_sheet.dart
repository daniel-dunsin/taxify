import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_make_model.dart';
import 'package:taxify_driver/shared/extenstions/extensions.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class VehicleMakesBottomSheet extends StatefulWidget {
  final List<VehicleMakeModel> makes;
  final VehicleCategoryModel? vehicleCategory;
  final Function(String vehicleMake) onSelect;
  const VehicleMakesBottomSheet({
    super.key,
    required this.makes,
    required this.onSelect,
    this.vehicleCategory,
  });

  @override
  State<VehicleMakesBottomSheet> createState() =>
      _VehicleMakesBottomSheetState();
}

class _VehicleMakesBottomSheetState extends State<VehicleMakesBottomSheet> {
  late TextEditingController _searchController;
  List<VehicleMakeModel> vehicleMakes = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      vehicleMakes = widget.makes;
    });

    _searchController =
        TextEditingController()..addListener(() {
          setState(() {
            vehicleMakes =
                widget.makes
                    .where(
                      (v) => v.name.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .8.sh,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          AppTextInput(
            hintText: "Search vehicle makes",
            suffixIcon: Icon(Icons.search_outlined),
            controller: _searchController,
            fillColor: checkLightMode(context) ? Colors.grey[200] : null,
          ),

          SizedBox(height: 20),

          Visibility(
            visible: vehicleMakes.isNotEmpty,
            replacement: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Center(
                child: Text(
                  "No vehicle makes found",
                  style: getTextTheme(context).bodyLarge,
                ),
              ),
            ),
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final vehicleMake = vehicleMakes[index];
                  return ListTile(
                    onTap: () {
                      widget.onSelect(vehicleMake.name);
                      GoRouter.of(context).pop();
                    },
                    leading:
                        widget.vehicleCategory != null
                            ? CachedNetworkImage(
                              imageUrl: widget.vehicleCategory!.image!,
                              width: 35,
                            )
                            : null,

                    title: Text(
                      vehicleMake.name.captalize,
                      style: getTextTheme(context).bodyMedium?.copyWith(),
                    ),
                  );
                },
                itemCount: vehicleMakes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
