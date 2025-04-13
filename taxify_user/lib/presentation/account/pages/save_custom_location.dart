import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/presentation/account/bloc/account_bloc.dart';
import 'package:taxify_user/presentation/account/routes/account_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/extenstions/extensions.dart';
import 'package:taxify_user/shared/network/network_toast.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/utils/validators.dart';
import 'package:taxify_user/shared/widgets/back_button.dart';
import 'package:taxify_user/shared/widgets/button.dart';
import 'package:taxify_user/shared/widgets/dialog_loader.dart';
import 'package:taxify_user/shared/widgets/input_decorator.dart';
import 'package:taxify_user/shared/widgets/text_input.dart';

class SaveCustomLocationPage extends StatefulWidget {
  final AddressModel address;
  final bool isUpdating;
  final PresetAddresses? presetName;

  const SaveCustomLocationPage({
    super.key,
    required this.address,
    required this.isUpdating,
    this.presetName,
  });

  @override
  State<SaveCustomLocationPage> createState() => _SaveCustomLocationPageState();
}

class _SaveCustomLocationPageState extends State<SaveCustomLocationPage> {
  late TextEditingController _nameController;
  AddressModel? newAddress;

  @override
  void initState() {
    _nameController = TextEditingController(
      text:
          widget.presetName != null
              ? widget.presetName!.name
              : widget.address.name,
    );
    super.initState();
  }

  void submit() {
    if (_nameController.text.isEmpty) {
      return NetworkToast.handleError("Name is required");
    }

    AddressModel data =
        newAddress != null
            ? newAddress!.copyWith(id: widget.address.id)
            : widget.address;

    data = data.copyWith(name: _nameController.text);

    if (widget.isUpdating) {
      getIt.get<AccountBloc>().add(UpdateAddressRequested(data));
    } else {
      getIt.get<AccountBloc>().add(CreateAddressRequested(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          checkLightMode(context)
              ? Theme.of(context).scaffoldBackgroundColor
              : AppColors.darkGray,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Divider(color: getColorSchema(context).secondary, height: 0),
          _buildFields(),
          SizedBox(height: 20),
          _buildDeleteButton(),
          SizedBox(height: 50),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  _buildHeader() {
    return Container(
      width: double.maxFinite,
      padding: AppStyles.defaultPagePadding.copyWith(top: 5, bottom: 15),
      decoration: BoxDecoration(color: getColorSchema(context).primary),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBackButton(size: 25),
            SizedBox(height: 5),
            Text(
              widget.isUpdating ? "Edit place" : "Add place",
              style: getTextTheme(context).headlineLarge,
            ),
          ],
        ),
      ),
    );
  }

  _buildFields() {
    return Container(
      color: getColorSchema(context).primary,
      padding: AppStyles.defaultPagePadding.copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextInput(
            labelText: "Name",
            fillColor: getColorSchema(context).primary,
            contentPadding: EdgeInsets.all(0),
            controller: _nameController,
            underline: true,
            disabled: widget.presetName != null,
            labelVerticalGap: 0,
            hintText: "Enter name",
          ),

          AppTextInputDecorator(
            labelText: "Address",
            fillColor: getColorSchema(context).primary,
            hintText: newAddress?.placeFullText ?? widget.address.placeFullText,
            contentPadding: EdgeInsets.all(0),
            labelVerticalGap: 0,
            onClick: () {
              GoRouter.of(context).pushNamed(
                AccountRoutes.addLocation,
                extra: {
                  "onSelect": (AddressModel address) {
                    GoRouter.of(context).pop();
                    setState(() {
                      newAddress = address;
                    });
                  },
                },
              );
            },
          ),
        ],
      ),
    );
  }

  _buildDeleteButton() {
    if (widget.isUpdating) {
      return BlocListener<AccountBloc, AccountState>(
        bloc: getIt.get<AccountBloc>(),
        listener: (context, state) {
          if (state is DeleteAddressLoading) {
            DialogLoader().show(context);
          } else {
            DialogLoader().hide();
            if (state is DeleteAddressSuccess) {
              NetworkToast.handleSuccess("Address deleted");
              GoRouter.of(context).pop();
              getIt.get<AccountBloc>().add(GetAddressesRequested());
            }
          }
        },
        child: Container(
          padding: AppStyles.defaultPagePadding.copyWith(top: 10, bottom: 10),
          color: getColorSchema(context).primary,
          width: double.maxFinite,
          child: GestureDetector(
            onTap: () {
              getIt.get<AccountBloc>().add(
                DeleteAddressRequested(addressId: widget.address.id!),
              );
            },
            child: Text(
              "Delete",
              style: getTextTheme(
                context,
              ).bodyLarge?.copyWith(color: getColorSchema(context).error),
            ),
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  _buildSubmitButton() {
    return BlocListener<AccountBloc, AccountState>(
      bloc: getIt.get<AccountBloc>(),
      listener: (context, state) {
        if (state is UpdateAddressLoading || state is CreateAddressLoading) {
          DialogLoader().show(context);
        } else {
          DialogLoader().hide();

          if (state is UpdateAddressSuccess || state is CreateAddressSuccess) {
            NetworkToast.handleSuccess(
              widget.isUpdating
                  ? "Address updated successfully"
                  : "Address created successfully",
            );

            GoRouter.of(context).pop();
            getIt.get<AccountBloc>().add(GetAddressesRequested());
          }
        }
      },
      child: Padding(
        padding: AppStyles.defaultPagePadding.copyWith(top: 0, bottom: 20),
        child: ContainedButton(
          onPressed: submit,
          width: double.maxFinite,
          child: Text("Save place"),
        ),
      ),
    );
  }
}
