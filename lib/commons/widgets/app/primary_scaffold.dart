import 'package:cook_with_nhee/commons/style/colors.dart';
import 'package:flutter/material.dart';

class PrimaryScaffold extends StatelessWidget {
  final Widget? body;
  final ScrollController? scrollController;
  final Widget? footer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Function? onBack;
  final double loadingBackgroundOpacity;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final BoxDecoration? backgroundColor;

  const PrimaryScaffold({
    super.key,
    this.body,
    this.scrollController,
    this.footer,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.onBack,
    this.floatingActionButton,
    this.loadingBackgroundOpacity = 0.5,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        final currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        backgroundColor: Colors.transparent,
        drawer: drawer,
        body: Container(
          decoration: backgroundColor ?? BoxDecoration(
            color: UIColors.backgroundColor,
          ),
          child: body!,
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );

    return Material(
      child: scaffold,
    );
  }
}
