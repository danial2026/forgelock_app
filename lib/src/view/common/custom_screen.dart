import 'package:flutter/material.dart';

class CustomScreen extends StatefulWidget {
  const CustomScreen({
    super.key,
    required this.child,
    this.onInit,
    this.onClose,
  });

  final Widget child;
  final VoidCallback? onInit;
  final VoidCallback? onClose;

  @override
  CustomScreenState createState() => CustomScreenState();
}

class CustomScreenState extends State<CustomScreen> {
  @override
  void initState() {
    super.initState();
    if (null != widget.onInit) {
      widget.onInit!();
    }
  }

  @override
  void dispose() {
    if (null != widget.onClose) {
      widget.onClose!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
