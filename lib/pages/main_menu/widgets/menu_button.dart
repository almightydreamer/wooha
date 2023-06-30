import 'package:flutter/material.dart';
import 'package:wooha/resources/app_text_styles.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key, required this.onTap, required this.title}) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                title,
                style: AppTextStyles.regular16.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
