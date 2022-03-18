import 'package:HackRU/styles.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/animated_drawer_content.dart';

class CustomHiddenMenu extends StatefulWidget {
  /// Decocator that allows us to add backgroud in the menu(img)
  final Widget? background;

  /// that allows us to add shadow above menu items
  final bool? enableShadowItensMenu;

  /// that allows us to add backgroud in the menu(color)
  final Color? backgroundColorMenu;

  /// Items of the menu
  final List<ItemHiddenMenu>? menuItems;

  /// Callback to recive item selected for user
  final Function(int)? selectedListern;

  /// position to set initial item selected in menu
  final int? initPositionSelected;

  final TypeOpen? typeOpen;

  CustomHiddenMenu(
      {Key? key,
      this.background,
      this.menuItems,
      this.selectedListern,
      this.initPositionSelected,
      this.backgroundColorMenu,
      this.enableShadowItensMenu = false,
      this.typeOpen = TypeOpen.FROM_LEFT})
      : super(key: key);

  @override
  _CustomHiddenMenuState createState() => _CustomHiddenMenuState();
}

class _CustomHiddenMenuState extends State<CustomHiddenMenu> {
  int? _indexSelected;
  SimpleHiddenDrawerController? controller;

  @override
  void initState() {
    _indexSelected = widget.initPositionSelected;
    super.initState();
  }

  void _listenerController() {
    setState(() {
      _indexSelected = controller?.position;
    });
  }

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    controller?.addListener(_listenerController);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller?.removeListener(_listenerController);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: widget.background,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                decoration: BoxDecoration(
                    boxShadow: widget.enableShadowItensMenu!
                        ? [
                            BoxShadow(
                              color: const Color(0x44000000),
                              offset: const Offset(0.0, 5.0),
                              blurRadius: 50.0,
                              spreadRadius: 30.0,
                            ),
                          ]
                        : []),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (scroll) {
                    scroll.disallowIndicator();
                    return false;
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0.0),
                    itemCount: widget.menuItems?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        selectedColor: HackRUColors.yellow,
                        textColor: Colors.white30,
                        leading: Text(
                          widget.menuItems![index].name,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        selected: index == _indexSelected,
                        onTap: () {
                          if (widget.menuItems![index].onTap != null) {
                            widget.menuItems![index].onTap!();
                          }
                          controller?.setSelectedMenuPosition(index);
                        },
                      );
                      // return HiddenMenuWidget(
                      //   name: widget.menuItems![index].name,
                      //   selected: index == _indexSelected,
                      //   colorLineSelected:
                      //       widget.menuItems![index].colorLineSelected,
                      //   baseStyle: widget.menuItems![index].baseStyle,
                      //   selectedStyle: widget.menuItems![index].selectedStyle,
                      //   typeOpen: widget.typeOpen,
                      //   onTap: () {
                      //     if (widget.menuItems![index].onTap != null) {
                      //       widget.menuItems![index].onTap!();
                      //     }
                      //     controller?.setSelectedMenuPosition(index);
                      //   },
                      // );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
