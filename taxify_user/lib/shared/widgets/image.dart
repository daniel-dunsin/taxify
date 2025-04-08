import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/bouncing_loader.dart';

class AppImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  final BoxFit fit;

  const AppImage({
    super.key,
    required this.image,
    this.width = 40,
    this.height = 40,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      width: width,
      height: height,
      fit: fit,
      useOldImageOnUrlChange: true,
      placeholder: (context, _) {
        return Container(
          width: width,
          height: height,
          color: getColorSchema(context).secondary,
          child: BouncingLoader(),
        );
      },
      errorWidget: (context, _, __) {
        return Icon(
          Icons.warning_outlined,
          color: getColorSchema(context).error,
          size: 12.h,
        );
      },
    );
  }
}

class AppCircularImage extends StatelessWidget {
  final String image;
  final double radius;
  final BoxFit fit;

  const AppCircularImage({
    super.key,
    required this.image,
    this.radius = 30,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius * 2),
      child: CachedNetworkImage(
        imageUrl: image,
        width: radius * 2,
        height: radius * 2,
        fit: fit,
        useOldImageOnUrlChange: true,
        placeholder: (context, _) {
          return Container(
            width: radius * 2,
            height: radius * 2,
            color: getColorSchema(context).secondary,
            child: BouncingLoader(),
          );
        },
        errorWidget: (context, _, __) {
          return Icon(
            Icons.warning_outlined,
            color: getColorSchema(context).error,
            size: 12.h,
          );
        },
      ),
    );
  }
}
