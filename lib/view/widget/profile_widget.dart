import 'package:flutter/material.dart';
import 'package:urecycle_app/constants.dart';

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap; // Add this line

  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    this.onTap, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Update this line
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Constants.blackColor.withOpacity(.5),
                  size: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.blackColor.withOpacity(.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
