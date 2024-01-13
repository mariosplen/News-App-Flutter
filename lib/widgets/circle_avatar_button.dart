import 'package:flutter/material.dart';

class CircleAvatarButton extends StatelessWidget {
  const CircleAvatarButton(
      {super.key,
      this.size = 140,
      required this.imageUrl,
      required this.onTap,
      required this.color,
      required this.iconColor});

  final String imageUrl;
  final double size;
  final Function onTap;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70.0),
                topRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            child: Material(
              color: color,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70.0),
                topRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(70.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: InkWell(
                  onTap: () {
                    onTap();
                  },
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2, right: 2),
                            child: Icon(
                              Icons.cached,
                              size: 22,
                              color: iconColor,
                            ),
                          ),
                        ]),
                  )),
            ),
          ),
          CircleAvatar(
            radius: double.infinity,
            backgroundImage: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ).image,
          ),
        ],
      ),
    );
  }
}
