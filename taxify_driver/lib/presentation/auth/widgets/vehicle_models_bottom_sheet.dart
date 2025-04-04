import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/data/vehicles/nhtsa_vehicle_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/shared/extenstions/extensions.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class VehicleModelsBottomSheet extends StatefulWidget {
  final List<NHTSAVehicleModel> models;
  final VehicleCategoryModel? vehicleCategory;
  final String? vehicleMake;
  final int? vehicleYear;
  final Function(String vehicleModel) onSelect;

  const VehicleModelsBottomSheet({
    super.key,
    required this.models,
    required this.onSelect,
    this.vehicleCategory,
    this.vehicleMake,
    this.vehicleYear,
  });

  @override
  State<VehicleModelsBottomSheet> createState() =>
      _VehicleModelsBottomSheetState();
}

class _VehicleModelsBottomSheetState extends State<VehicleModelsBottomSheet> {
  late TextEditingController _searchController;
  List<NHTSAVehicleModel> vehicleModels = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      vehicleModels = widget.models;
    });

    _searchController =
        TextEditingController()..addListener(() {
          setState(() {
            vehicleModels =
                widget.models
                    .where(
                      (v) => getModelFullName(v.name).toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      ),
                    )
                    .toList();
          });
        });
  }

  String getModelFullName(String vehicleModel) {
    return '${widget.vehicleMake} $vehicleModel${widget.vehicleYear != null ? " (${widget.vehicleYear})" : ""}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .8.sh,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          AppTextInput(
            hintText: "Search vehicle models",
            suffixIcon: Icon(Icons.search_outlined),
            controller: _searchController,
            fillColor: checkLightMode(context) ? Colors.grey[200] : null,
          ),

          SizedBox(height: 20),

          Visibility(
            visible: vehicleModels.isNotEmpty,
            replacement: SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Center(
                child: Text(
                  "No vehicle models found",
                  style: getTextTheme(context).bodyLarge,
                ),
              ),
            ),
            child: Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final vehicleModel = vehicleModels[index];
                  return ListTile(
                    onTap: () {
                      widget.onSelect(vehicleModel.name);
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
                      getModelFullName(vehicleModel.name).captalize,
                      style: getTextTheme(context).bodyMedium?.copyWith(),
                    ),
                  );
                },
                itemCount: vehicleModels.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
