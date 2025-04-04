import 'dart:io';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/vehicles/nhtsa_vehicle_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_category_model.dart';
import 'package:taxify_driver/data/vehicles/vehicle_make_model.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/presentation/auth/widgets/vehicle_makes_bottom_sheet.dart';
import 'package:taxify_driver/presentation/auth/widgets/vehicle_models_bottom_sheet.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/extenstions/extensions.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/bottom_sheet.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/date_picker.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/file_uploader.dart';
import 'package:taxify_driver/shared/widgets/image.dart';
import 'package:taxify_driver/shared/widgets/input_decorator.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

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
  Color? vehicleColor;
  File? vehicleRegistrationCertificate;
  DateTime? vehicleRegistrationDate;
  List<String> vehicleRules = [];
  late TextEditingController passengersCountController;
  late TextEditingController vehicleYearController;
  late TextEditingController plateNumberController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    getIt.get<AuthBloc>().add(GetVehicleCategoriesRequested());

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;
    setState(() {
      vehicleCategory = data.vehicleCategory;
      vehicleMake = data.vehicleMake;
      vehicleModel = data.vehicleModel;
      vehicleRegistrationCertificate = data.vehicleRegistrationCertificate;
      vehicleRegistrationDate = data.vehicleRegistrationDate;
      vehicleColor = data.vehicleColor;
      vehicleRules = [...data.vehicleRules];

      if (vehicleCategory != null) {
        getMakesForVehicleCategory(vehicleCategory!.name);
      }
    });

    vehicleYearController = TextEditingController(
      text: data.vehicleYear?.toString(),
    );

    plateNumberController = TextEditingController(
      text: data.vehiclePlateNumber,
    );

    passengersCountController = TextEditingController(
      text: data.vehiclePassengersCount?.toString(),
    );
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

    setState(() {
      vehicleMake = null;
      vehicleModel = null;
      vehicleYearController.text = "";
    });
  }

  void getModelsForVehicleMake() {
    getIt.get<AuthBloc>().add(
      GetVehicleModelsRequested(
        vehicleYear: vehicleYearInt,
        vehicleType:
            vehicleCategory?.name == "Car"
                ? "car"
                : vehicleCategory?.name == "Truck"
                ? "truck"
                : "motorcycle",
        vehicleMake: vehicleMake!,
      ),
    );
  }

  int? get vehicleYearInt {
    return vehicleYearController.text.trim().isEmpty
        ? null
        : int.tryParse(vehicleYearController.text.trim());
  }

  int? get passengersCountInt {
    return passengersCountController.text.trim().isEmpty
        ? null
        : int.tryParse(passengersCountController.text.trim());
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      if (![
        vehicleMake,
        vehicleModel,
        vehicleRegistrationDate,
        vehicleRegistrationCertificate,
      ].every((e) => e != null)) {
        return NetworkToast.handleError("Fill all fields");
      }

      getIt.get<SignUpStepsBloc>().add(
        UpdateSignUpStepsData(
          getIt.get<SignUpStepsBloc>().state.signUpModel.copyWith(
            vehicleCategory: vehicleCategory,
            vehicleMake: vehicleMake,
            vehicleModel: vehicleModel,
            vehiclePlateNumber: plateNumberController.text,
            vehicleRegistrationDate: vehicleRegistrationDate,
            vehicleRegistrationCertificate: vehicleRegistrationCertificate,
            vehicleYear: vehicleYearInt,
            vehicleColor: vehicleColor,
            vehiclePassengersCount: passengersCountInt,
            vehicleRules: vehicleRules,
          ),
        ),
      );

      getIt.get<SignUpStepsBloc>().add(IncreaseSignUpSteps());
    }
  }

  @override
  void dispose() {
    super.dispose();
    vehicleYearController.dispose();
    plateNumberController.dispose();
    passengersCountController.dispose();
    _formKey.currentState?.dispose();
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
                  state is GetVehicleMakesLoading ||
                  state is GetVehicleModelsLoading) {
                DialogLoader().show(context);
              } else if (state is GetVehicleCategoriesFailed ||
                  state is GetVehicleMakesFailed ||
                  state is GetVehicleModelsFailed) {
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
              } else if (state is GetVehicleModelsSuccess) {
                DialogLoader().hide();
                _openVehicleModelsBottomSheet(state.data);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVehicleCategories(),
                    SizedBox(height: 20),
                    _buildVehicleMake(),
                    SizedBox(height: 10),
                    _buildVehicleYear(),
                    SizedBox(height: 10),
                    _buildVehicleModel(),
                    SizedBox(height: 10),
                    _buildVehicleColor(),
                    SizedBox(height: 10),
                    _buildPlateNumber(),
                    SizedBox(height: 10),
                    _buildRegistrationDate(),
                    SizedBox(height: 10),
                    _buildRegistrationCertificate(),
                    SizedBox(height: 10),
                    _buildPassengersCount(),
                    SizedBox(height: 10),
                    _buildRules(),
                    SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              );
            },
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
                    !isSelected
                        ? () => setState(() {
                          vehicleCategory = c;
                          getMakesForVehicleCategory(c.name);
                        })
                        : () => {},
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

  _buildVehicleMake() {
    return AppTextInputDecorator(
      hintText: "Select vehicle Make",
      labelText: "Vehicle Make",
      value: vehicleMake?.captalize,
      onClick: () {
        AppBottomSheet.displayStatic(
          context,
          child: VehicleMakesBottomSheet(
            makes: makes,
            vehicleCategory: vehicleCategory,
            onSelect: (make) {
              if (vehicleMake != make) {
                setState(() {
                  vehicleMake = make;
                  vehicleModel = null;
                  vehicleYearController.text = "";
                });
              }
            },
          ),
          height: .8.sh,
        );
      },
      onCancel: () {
        setState(() {
          vehicleMake = null;
        });
      },
    );
  }

  _buildVehicleYear() {
    return AppTextInput(
      controller: vehicleYearController,
      labelText: "Vehicle Year",
      hintText:
          vehicleMake == null
              ? "Select vehicle make first"
              : "Enter vehicle year",
      keyboardType: TextInputType.number,
      disabled: vehicleMake == null,
    );
  }

  _buildVehicleModel() {
    return AppTextInputDecorator(
      hintText: "Select vehicle model",
      labelText: "Vehicle Model",
      value: vehicleMake == null ? "Select vehicle make first" : vehicleModel,
      disabled: vehicleMake == null,
      onClick: getModelsForVehicleMake,
      onCancel: () {
        setState(() {
          vehicleModel = null;
        });
      },
    );
  }

  _openVehicleModelsBottomSheet(List<NHTSAVehicleModel> models) {
    AppBottomSheet.displayStatic(
      context,
      child: VehicleModelsBottomSheet(
        models: models,
        vehicleCategory: vehicleCategory,
        vehicleMake: vehicleMake,
        vehicleYear: vehicleYearInt,
        onSelect: (model) {
          if (vehicleModel != model) {
            setState(() {
              vehicleModel = model;
            });
          }
        },
      ),
      height: .8.sh,
    );
  }

  _buildVehicleColor() {
    return AppTextInputDecorator(
      labelText: "Vehicle Color",
      hintText: "Select vehicle color",
      value: vehicleColor == null ? null : colorToHex(vehicleColor!),
      onCancel: () => setState(() => vehicleColor = null),
      onClick: () async {
        final color = await showColorPickerDialog(
          showColorName: true,
          showColorCode: true,
          context,
          vehicleColor ?? AppColors.accent,
          backgroundColor: getColorSchema(context).primary,
          barrierColor: const Color.fromARGB(106, 114, 114, 114),
          actionButtons: ColorPickerActionButtons(
            okButton: true,
            closeButton: false,
            dialogActionButtons: false,
            toolIconsThemeData: IconThemeData(
              color: getColorSchema(context).onPrimary,
            ),
          ),
        );

        setState(() {
          vehicleColor = color;
        });
      },
    );
  }

  _buildPlateNumber() {
    return AppTextInput(
      controller: plateNumberController,
      labelText: "Vehicle Plate Number",
      hintText: "Enter plate number",
      validator: (value) => AppValidators.defaultValidator(value),
    );
  }

  _buildRegistrationDate() {
    return AppTextInputDecorator(
      hintText: "Select Date",
      labelText: "Vehicle Registration Date",
      value:
          vehicleRegistrationDate == null
              ? null
              : DateFormat.yMMMMd().format(vehicleRegistrationDate!),
      onCancel: () {
        setState(() {
          vehicleRegistrationDate = null;
        });
      },
      onClick: () async {
        final date = await AppDatePicker.adaptive(
          context,
          initialDate: vehicleRegistrationDate,
          firstDate: DateTime(1990),
          lastDate: DateTime(DateTime.now().year + 1),
        );

        if (date != null) {
          setState(() {
            vehicleRegistrationDate = date;
          });
        }
      },
    );
  }

  _buildRegistrationCertificate() {
    return FileUploader(
      onUploadFile: (file) {
        setState(() {
          vehicleRegistrationCertificate = file;
        });
      },
      onRemoveFile: () {
        setState(() {
          vehicleRegistrationCertificate = null;
        });
      },
      uploadedFile: vehicleRegistrationCertificate,
      label: "Vehicle Registration Certificate",
    );
  }

  _buildPassengersCount() {
    return AppTextInput(
      controller: passengersCountController,
      labelText: "No. of passengers",
      hintText: "How many passengers can you carry?",
      keyboardType: TextInputType.number,
      validator: (value) => AppValidators.defaultValidator(value),
    );
  }

  _buildRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vehicle Rules",
          style: getTextTheme(
            context,
          ).bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
        ...appVehicleRules.map((rule) {
          final isSelected = vehicleRules.contains(rule);
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(rule, style: getTextTheme(context).bodyMedium),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    side: BorderSide(
                      width: 1.5,
                      color: getColorSchema(context).onPrimary,
                    ),
                    checkColor: getColorSchema(context).onPrimary,
                    value: isSelected,
                    onChanged: (checked) {
                      setState(() {
                        if (!isSelected) {
                          vehicleRules.add(rule);
                        } else {
                          vehicleRules.remove(rule);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  _buildSubmitButton() {
    return ContainedButton(
      onPressed: submit,
      width: double.maxFinite,
      child: Text("Continue"),
    );
  }
}
