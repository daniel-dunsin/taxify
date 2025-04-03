import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_make_model.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/image.dart';

class SignUpStep4 extends StatefulWidget {
  const SignUpStep4({super.key});

  @override
  State<SignUpStep4> createState() => _SignUpStep4State();
}

class _SignUpStep4State extends State<SignUpStep4> {
  List<VehicleCategoryModel> categories = [];
  List<VehicleMakeModel> makes = [];
  VehicleCategoryModel? vehicleCategory;
  String? vehicleMake;
  String? vehicleModel;
  int? vehicleYear;

  @override
  void initState() {
    super.initState();

    getIt.get<AuthBloc>().add(GetVehicleCategoriesRequested());

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;
    setState(() {
      vehicleCategory = data.vehicleCategory;
      vehicleMake = data.vehicleMake;
      vehicleModel = data.vehicleModel;
      vehicleYear = data.vehicleYear;

      if (vehicleCategory != null) {
        getMakesForVehicleCategory(vehicleCategory!.name);
      }
    });
  }

  void getMakesForVehicleCategory(String vehicleType) {
    getIt.get<AuthBloc>().add(
      GetVehicleMakesRequested(
        vehicleType:
            vehicleType == "Car"
                ? "car"
                : vehicleType == "Truck"
                ? "truck"
                : "motorcycle",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () async =>
              getIt.get<AuthBloc>().add(GetVehicleCategoriesRequested()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Vehicle", style: getTextTheme(context).headlineLarge),
          SizedBox(height: 8),
          Text(
            "Add your first vehicle.",
            style: getTextTheme(
              context,
            ).bodyLarge?.copyWith(color: AppColors.lightGray),
          ),
          SizedBox(height: 20),

          BlocConsumer<AuthBloc, AuthState>(
            bloc: getIt.get<AuthBloc>(),
            listener: (context, state) {
              if (state is GetVehicleCategoriesLoading ||
                  state is GetVehicleMakesLoading) {
                DialogLoader().show(context);
              } else if (state is GetVehicleCategoriesFailed ||
                  state is GetVehicleMakesFailed) {
                DialogLoader().hide();
              } else if (state is GetVehicleCategoriesSuccess) {
                DialogLoader().hide();
                setState(() {
                  categories = state.data;
                  vehicleCategory = categories.firstOrNull;
                  if (vehicleCategory != null) {
                    getMakesForVehicleCategory(vehicleCategory!.name);
                  }
                });
              } else if (state is GetVehicleMakesSuccess) {
                DialogLoader().hide();
                setState(() {
                  makes = state.data;
                });
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildVehicleCategories()],
              );
            },
          ),
        ],
      ),
    );
  }

  buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppStyles.shimmerBaseColor,
      highlightColor: AppStyles.shipmmerHighlightColor,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.light,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.light,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.light,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),
          Container(
            width: double.maxFinite,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.light,
            ),
          ),

          SizedBox(height: 40),
          Container(
            width: double.maxFinite,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColors.light,
            ),
          ),
        ],
      ),
    );
  }

  _buildVehicleCategories() {
    return Row(
      children:
          categories.map((c) {
            final isSelected = c.id == vehicleCategory?.id;

            return Expanded(
              child: GestureDetector(
                onTap:
                    () => setState(() {
                      vehicleCategory = c;
                      getMakesForVehicleCategory(c.name);
                    }),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: getColorSchema(context).primary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1.5,
                      color:
                          isSelected
                              ? checkLightMode(context)
                                  ? getColorSchema(context).onPrimary
                                  : AppColors.accent
                              : checkLightMode(context)
                              ? AppColors.lightGray
                              : getColorSchema(context).onPrimary,
                    ),
                  ),
                  child: Column(
                    children: [
                      AppImage(
                        image: c.image!,
                        width: double.maxFinite,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10),
                      Text(c.name, style: getTextTheme(context).labelLarge),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
