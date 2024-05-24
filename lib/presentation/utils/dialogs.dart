import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';
import 'package:ithelpdesk/presentation/common_widgets/alert_dialog_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/image_widget.dart';
import 'package:ithelpdesk/presentation/common_widgets/info_loader_widget.dart';
import '../../../res/drawables/drawable_assets.dart';

class Dialogs {
  static Future<T?> loader<T>(BuildContext context, {bool willPop = true}) {
    return showDialog<T>(
      //prevent outside touch
      barrierDismissible: false,
      context: context,
      builder: (context) {
        //prevent Back button press
        return PopScope(
            canPop: willPop,
            child: const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Center(
                child: CircularProgressIndicator(),
              ),
            ));
      },
    );
  }

  static void dismiss(BuildContext context, {dynamic value}) {
    Navigator.of(context, rootNavigator: true).pop(value);
  }

  static Future<T?> showGenericErrorPopup<T>(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
              onPressed: () => {Navigator.of(context).pop()},
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Okay")),
        ],
      ),
    );
  }

  static Future showInfoDialog(
      BuildContext context, PopupType popupType, String message,
      {String title = ''}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        type: popupType,
        message: message,
        title: title,
      ),
    );
  }

  static Future showInfoLoader(
    BuildContext context,
    String message,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => InfoLoaderWidget(
        message: message,
      ),
    );
  }

  static Future showDialogWithClose(BuildContext context, Widget widget,
      {EdgeInsets insetPadding =
          const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      bool canPop = true,
      bool showClose = true}) async {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: canPop,
        child: Dialog(
          backgroundColor: context.resources.color.appScaffoldBg,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(context.resources.dimen.dp15))),
          insetPadding: insetPadding,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showClose)
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: ImageWidget(
                              path: DrawableAssets.icCross,
                              padding: EdgeInsets.only(
                                  left: isSelectedLocalEn
                                      ? context.resources.dimen.dp5
                                      : 0,
                                  right: isSelectedLocalEn
                                      ? 0
                                      : context.resources.dimen.dp5,
                                  top: context.resources.dimen.dp5,
                                  bottom: context.resources.dimen.dp15))
                          .loadImageWithMoreTapArea,
                    ),
                  ),
                widget,
                SizedBox(
                  height: context.resources.dimen.dp10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static showBottomSheetDialog(BuildContext context, Widget widget) {
    showBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) => Container(
            height: double.infinity,
            padding:
                EdgeInsets.symmetric(vertical: context.resources.dimen.dp10),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(context.resources.dimen.dp5),
                          margin: EdgeInsets.only(
                              right: context.resources.dimen.dp10),
                          child: ImageWidget(
                                  path:
                                      DrawableAssets.getCloseDrawable(context))
                              .loadImage),
                    )),
                widget,
              ],
            )));
  }

  static showContentHeightBottomSheetDialog(BuildContext context, Widget widget,
      {double? radious, Function(dynamic)? callback}) {
    showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radious ?? 0.0),
              topRight: Radius.circular(radious ?? 0.0)),
        ),
        context: context,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: widget,
            )).then((value) {
      if (callback != null) callback(value);
    });
  }

  static showBottomSheetDialogTransperrent(BuildContext context, Widget widget,
      {Function(dynamic)? callback}) {
    showModalBottomSheet(
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(alignment: Alignment.bottomCenter, child: widget),
              ],
            )).then((value) {
      if (callback != null) callback(value);
    });
  }

  Future showiOSDatePickerDialog(BuildContext context, Widget child) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Material(
                        child: Text(
                          context.resources.string.done,
                          style: context.textFontWeight600,
                        ),
                      ),
                    ),
                  )),
              SizedBox(width: double.infinity, height: 250, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
