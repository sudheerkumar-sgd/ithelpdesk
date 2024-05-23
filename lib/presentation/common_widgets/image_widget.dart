import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class ImageWidget {
  String path;
  double? width;
  double? height;
  BoxFit? boxType;
  Color? backgroundTint;
  ColorFilter? colorFilter;
  EdgeInsetsGeometry padding;
  final bool isLocalEn;
  ImageWidget(
      {required this.path,
      this.width,
      this.height,
      this.boxType,
      this.backgroundTint,
      this.colorFilter,
      this.padding = const EdgeInsets.all(5),
      this.isLocalEn = true});

  Widget get loadImage =>
      RotatedBox(quarterTurns: isLocalEn ? 0 : 2, child: getImage());

  Widget get loadImageWithMoreTapArea => getImageWithMoreTapArea();

  Widget getImage() {
    {
      if (path.contains("http://") || path.contains("https://")) {
        return Image.network(width: width, height: height, path);
      } else if (path.contains('assets/')) {
        if (path.contains(".svg")) {
          if (backgroundTint != null) {
            colorFilter = ColorFilter.mode(backgroundTint!, BlendMode.srcIn);
          }
          return SvgPicture.asset(
            path,
            width: width,
            height: height,
            fit: boxType ?? BoxFit.contain,
            colorFilter: colorFilter,
          );
        } else {
          return Image.asset(
            path,
            width: width,
            height: height,
            fit: boxType,
          );
        }
      } else {
        try {
          return Image.memory(
              width: width,
              height: height,
              color: backgroundTint,
              filterQuality: FilterQuality.high,
              base64.decode(path.replaceAll(RegExp(r'\s+'), '')));
        } catch (e) {
          return Image.file(width: width, height: height, File(path));
        }
      }
    }
  }

  Widget getImageWithMoreTapArea() {
    {
      return Padding(
        padding: padding,
        child: getImage(),
      );
    }
  }
}
