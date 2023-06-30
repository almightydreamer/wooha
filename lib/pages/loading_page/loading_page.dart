import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.future, required this.onLoaded}) : super(key: key);

  final Future<void> future;
  final VoidCallback onLoaded;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    widget.future.then((value) { widget.onLoaded.call();});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(color: CupertinoColors.lightBackgroundGray,),);
  }
}
