import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/presentation/account/bloc/account_bloc.dart';
import 'package:taxify_user/presentation/account/routes/account_routes.dart';
import 'package:taxify_user/shared/network/network_toast.dart';
import 'package:taxify_user/shared/utils/location.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/back_button.dart';
import 'package:taxify_user/shared/widgets/dialog_loader.dart';
import 'package:taxify_user/shared/widgets/text_input.dart';

class AddLocationPage extends StatefulWidget {
  final AddressModel? address;
  final PresetAddresses? presetName;
  final bool isUpdating;
  final Function(AddressModel address)? onSelect;

  const AddLocationPage({
    super.key,
    this.isUpdating = false,
    this.address,
    this.presetName,
    this.onSelect,
  });

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  bool isLoadingPredictions = false;
  List<Prediction> predictions = [];
  late TextEditingController searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController()..addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () async {
      setState(() {
        isLoadingPredictions = true;
      });
      final query = searchController.text;

      if (query.isEmpty) {
        predictions = [];
      } else {
        predictions = await LocationUtils().getPredictions(query);
      }

      isLoadingPredictions = false;

      setState(() {});
    });
    setState(() {});
  }

  void onSelectAddress(Prediction place) async {
    final router = GoRouter.of(context);

    DialogLoader().show(context);
    final location = await LocationUtils().getPlace(place.placeId ?? "");

    DialogLoader().hide();

    if (location.hasNoResults) {
      NetworkToast.handleError("Unable to find location");
    } else {
      final AddressModel addressModel = AddressModel(
        id: widget.address?.id,
        isHomeAddress: widget.presetName == PresetAddresses.home,
        isWorkAddress: widget.presetName == PresetAddresses.work,
        name: widget.presetName?.name ?? widget.address?.name,
        placeDescription: place.description,
        streetAddress: place.structuredFormatting?.mainText,
        placeId: place.placeId,
        placeFullText: place.structuredFormatting?.mainText,
        state: LocationUtils().getAddressComponent(
          location.result.addressComponents,
          AddressType.state,
        ),
        city: LocationUtils().getAddressComponent(
          location.result.addressComponents,
          AddressType.city,
        ),
        country: LocationUtils().getAddressComponent(
          location.result.addressComponents,
          AddressType.country,
        ),
        location: LocationModel(
          type: "Point",
          coordinates: LatLng(
            location.result.geometry?.location.lat,
            location.result.geometry?.location.lng,
          ),
        ),
      );

      if (widget.onSelect != null) {
        widget.onSelect!(addressModel);
      } else {
        if (widget.presetName != null) {
          if (widget.address == null) {
            getIt.get<AccountBloc>().add(CreateAddressRequested(addressModel));
          } else {
            getIt.get<AccountBloc>().add(UpdateAddressRequested(addressModel));
          }
        } else {
          router.pushNamed(
            AccountRoutes.saveCustomLocation,
            extra: {"isUpdating": widget.isUpdating, "address": addressModel},
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: AppBackButton(),
        actions: [SizedBox(width: 20)],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${widget.isUpdating ? "Update" : "Add"} ${widget.address?.name ?? widget.presetName?.name ?? "Place"}",
              style: getTextTheme(context).labelLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            AppTextInput(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              hintText: "Enter an address",
              controller: searchController,
            ),
          ],
        ),
      ),

      body: BlocListener<AccountBloc, AccountState>(
        bloc: getIt.get<AccountBloc>(),
        listener: (context, state) {
          if (state is CreateAddressLoading || state is UpdateAddressLoading) {
            DialogLoader().show(context);
          } else {
            DialogLoader().hide();
            if (state is CreateAddressSuccess) {
              NetworkToast.handleSuccess("Address created");
              GoRouter.of(context).pop();
            } else if (state is UpdateAddressSuccess) {
              NetworkToast.handleSuccess("Address updated");
              GoRouter.of(context).pop();
              getIt.get<AccountBloc>().add(GetAddressesRequested());
            }
          }
        },
        child: Column(
          children: [
            ...(isLoadingPredictions
                ? [Text("Fetching predictions..."), SizedBox(height: 10)]
                : []),
            Expanded(child: _buildPredictions()),
          ],
        ),
      ),
    );
  }

  _buildPredictions() {
    return ListView.separated(
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        final bool isSelected = widget.address?.placeId == prediction.placeId;
        return ListTile(
          onTap: () => onSelectAddress(prediction),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          titleAlignment: ListTileTitleAlignment.threeLine,
          minLeadingWidth: 50,
          leading: SizedBox(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isSelected ? Icon(Icons.star) : Icon(Icons.location_pin),
                ...(prediction.distanceMeters != null
                    ? [
                      SizedBox(height: 2),
                      Expanded(
                        child: Text(
                          LocationUtils.formatDistance(
                            prediction.distanceMeters!,
                          ),
                          style: getTextTheme(context).labelLarge,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ]
                    : []),
              ],
            ),
          ),
          title: Text(
            "${prediction.description}",
            overflow: TextOverflow.ellipsis,
            style: getTextTheme(context).bodyLarge,
          ),
          subtitle: Text("${prediction.structuredFormatting?.secondaryText}"),
        );
      },
      separatorBuilder: (context, index) {
        if (index != predictions.length - 1) {
          return Divider(color: getColorSchema(context).secondary);
        }
        return SizedBox.shrink();
      },
      itemCount: predictions.length,
    );
  }
}
