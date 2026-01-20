import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final NotchBottomBarController controller;
  final ValueChanged<int> onTap;
  final int selectedIndex;

  const CustomBottomNavBar({
    super.key,
    required this.controller,
    required this.onTap,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedNotchBottomBar(
      /// Controller for the bottom bar
      notchBottomBarController: controller,

      /// Color of the bottom bar
      color: Colors.white,

      /// Show shadow above the bottom bar
      showShadow: true,

      /// Shadow elevation
      shadowElevation: 8,

      /// Elevation of the bottom bar
      elevation: 8,

      /// Bottom padding for safe area
      bottomBarHeight: 65,

      /// Notch color (center elevated part)
      notchColor: Theme.of(context).colorScheme.primary,

      /// Show label or not
      showLabel: true,

      /// Show blur effect
      showBlurBottomBar: false,

      /// Blur filter intensity
      blurOpacity: 0.0,

      /// Blur filter color
      blurFilterX: 5.0,
      blurFilterY: 5.0,

      /// Animation duration
      durationInMilliSeconds: 300,

      /// Item label style
      itemLabelStyle: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),

      /// Notch shape
      notchShader: SweepGradient(
        startAngle: 0,
        endAngle: 3.14 * 2,
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.primary,
        ],
        tileMode: TileMode.mirror,
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8.0)),

      /// Remove margin
      removeMargins: false,

      /// Bottom bar items
      bottomBarItems: [
        /// Home
        BottomBarItem(
          inActiveItem: Icon(
            Icons.home_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
          activeItem: Icon(Icons.home, color: Colors.white),
          itemLabel: 'Home',
        ),

        /// Categories
        BottomBarItem(
          inActiveItem: Icon(
            Icons.event,
            color: Theme.of(context).colorScheme.outline,
          ),
          activeItem: Icon(Icons.event, color: Colors.white),
          itemLabel: 'Create Events',
        ),

        /// Orders
        BottomBarItem(
          inActiveItem: Icon(
            Icons.wallet_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
          activeItem: Icon(Icons.wallet, color: Colors.white),
          itemLabel: 'Wallet',
        ),

        /// Profile
        BottomBarItem(
          inActiveItem: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.outline,
          ),
          activeItem: Icon(Icons.settings, color: Colors.white),
          itemLabel: 'Settings',
        ),
      ],

      /// On tap callback
      onTap: onTap,

      /// Knotch gradient
      kIconSize: 24.0,
      kBottomRadius: 28.0,
    );
  }
}
