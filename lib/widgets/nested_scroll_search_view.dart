import 'package:flutter/material.dart';

class NestedScrollSearchView extends StatelessWidget {
  const NestedScrollSearchView({super.key, this.header, required this.body});

  final Widget? header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (header == null) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: body,
      );
    }
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 4,
              ),
              child: header,
            ),
          )
        ];
      },
      body: body,
    );
  }
}
