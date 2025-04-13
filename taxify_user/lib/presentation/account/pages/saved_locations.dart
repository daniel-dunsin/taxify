import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/presentation/account/bloc/account_bloc.dart';
import 'package:taxify_user/presentation/account/routes/account_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/extenstions/extensions.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/back_button%20copy.dart';
import 'package:taxify_user/shared/widgets/dialog_loader.dart';

class SavedLocationsPage extends StatefulWidget {
  const SavedLocationsPage({super.key});

  @override
  State<SavedLocationsPage> createState() => _SavedLocationsPageState();
}

class _SavedLocationsPageState extends State<SavedLocationsPage> {
  List<AddressModel> others = [];
  AddressModel? home;
  AddressModel? work;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getIt.get<AccountBloc>().add(GetAddressesRequested());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          checkLightMode(context)
              ? Theme.of(context).scaffoldBackgroundColor
              : AppColors.darkGray,
      body: BlocListener<AccountBloc, AccountState>(
        bloc: getIt.get<AccountBloc>(),
        listener: (context, state) {
          if (state is GetAddressesLoading) {
            DialogLoader().show(context);
          } else {
            DialogLoader().hide();
            if (state is GetAddressesSuccess) {
              setState(() {
                home = state.home;
                work = state.work;
                others = state.others;
              });
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPresetAddresses(),
                  _buildOtherSavedLocations(),
                ],
              ),
            ),
          ],
        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBackButton(size: 25),
                IconButton(
                  icon: Icon(Icons.add, size: 25),
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AccountRoutes.addLocation);
                  },
                ),
              ],
            ),
            SizedBox(height: 5),
            Text("Saved places", style: getTextTheme(context).headlineLarge),
          ],
        ),
      ),
    );
  }

  _buildPresetAddresses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppStyles.defaultPagePadding.copyWith(bottom: 10),
          child: Text(
            "Favourites",
            style: getTextTheme(
              context,
            ).bodyLarge?.copyWith(color: getColorSchema(context).onSecondary),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          color: getColorSchema(context).primary,
          child: Column(
            children: [
              _buildAddress(presetName: PresetAddresses.home, address: home),
              Divider(height: 0, color: getColorSchema(context).secondary),
              _buildAddress(presetName: PresetAddresses.work, address: work),
            ],
          ),
        ),
      ],
    );
  }

  _buildOtherSavedLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppStyles.defaultPagePadding.copyWith(bottom: 10),
          child: Text(
            "Other saved places",
            style: getTextTheme(
              context,
            ).bodyLarge?.copyWith(color: getColorSchema(context).onSecondary),
            textAlign: TextAlign.start,
          ),
        ),
        Container(
          color: getColorSchema(context).primary,
          child: Column(
            children: [
              ...others.map((adr) => _buildAddress(address: adr)),
              _buildAddSavedPlace(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddSavedPlace() {
    return ListTile(
      onTap: () {
        GoRouter.of(context).pushNamed(AccountRoutes.addLocation);
      },
      title: Text(
        "Add saved place",
        style: getTextTheme(
          context,
        ).labelLarge?.copyWith(color: Colors.blueAccent),
      ),
      subtitle: Text(
        "Get to your favourite destination more quickly.",
        style: getTextTheme(context).labelLarge?.copyWith(
          fontSize: 13.sp,
          color: getColorSchema(context).onSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: getColorSchema(context).onSecondary,
        size: 28,
      ),
    );
  }

  Widget _buildAddress({PresetAddresses? presetName, AddressModel? address}) {
    if (presetName != null && address == null) {
      return ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AccountRoutes.addLocation,
            extra: {"presetName": presetName},
          );
        },
        title: Text(
          "Add ${presetName.name}",
          style: getTextTheme(
            context,
          ).labelLarge?.copyWith(color: Colors.blueAccent),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: getColorSchema(context).onSecondary,
          size: 28,
        ),
      );
    } else {
      return ListTile(
        onTap: () {
          GoRouter.of(context).pushNamed(
            AccountRoutes.saveCustomLocation,
            extra: {
              "address": address,
              "isUpdating": true,
              "presetName": presetName,
            },
          );
        },
        leading: Icon(
          presetName == null
              ? Icons.star_rounded
              : presetName == PresetAddresses.home
              ? Icons.home
              : Icons.cases_rounded,
        ),
        title: Text(
          presetName?.name.capitalize ?? address!.name ?? "",
          style: getTextTheme(context).labelLarge,
        ),
        subtitle: Text(
          address!.placeFullText!,
          style: getTextTheme(context).labelLarge?.copyWith(
            fontSize: 13.sp,
            color: getColorSchema(context).onSecondary,
          ),
        ),
      );
    }
  }
}
