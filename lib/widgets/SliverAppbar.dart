import 'package:flutter/material.dart';

class SliverAppBarCustom extends StatefulWidget {

  bool pinned;
  bool snap;
  bool floating;
//  String tittle;
  String background_image;
  List<Widget> actions;

  SliverAppBarCustom({this.actions, this.pinned, this.snap, this.floating, this.background_image});

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
      flexibleSpace: FlexibleSpaceBar(

//        title: Text(
//            widget.tittle,
//            style: TextStyle(
//                fontSize: 15,
//            ),
//        ),
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