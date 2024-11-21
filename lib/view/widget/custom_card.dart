import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth;

        return SizedBox(
          width: cardWidth,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            clipBehavior: Clip.hardEdge,
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: backgroundColor,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: onTap,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
