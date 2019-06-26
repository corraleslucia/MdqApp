import 'package:flutter/material.dart';
import 'package:mdq/pages/root_page.dart';

class SliverAppBarCustom extends StatefulWidget {

  bool pinned;
  bool snap;
  bool floating;
//  String tittle;
  String background_image;
  List<Widget> actions;
  IconButton backButton;
  SliverAppBarCustom({this.actions, this.pinned, this.snap, this.floating, this.background_image, this.backButton});

  @override
  State<StatefulWidget> createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<SliverAppBarCustom> {

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      snap: widget.snap,
      pinned: widget.pinned,
      floating: widget.floating,
      expandedHeight: 130.0,
      leading: widget.backButton,
      flexibleSpace: FlexibleSpaceBar(

        centerTitle: false,
        titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 90),
        background: Image.asset(
            widget.background_image,
            fit: BoxFit.fill
            ),
        ),
      actions: widget.actions,
    );
  }



}