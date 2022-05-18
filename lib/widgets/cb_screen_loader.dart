import 'package:mobileapp_utils/resources/party_size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CBLoader extends StatelessWidget {
  final bool show;
  final Widget body;
  final Widget? substitute;
  final bool indexStack;

  const CBLoader({
    Key? key,
    required this.body,
    this.substitute,
    this.show = true,
    this.indexStack = true,
  }) : super(key: key);

  static Widget wave() {
    return Container(
      margin: EdgeInsets.only(top: kToolbarHeight),
      child: Center(
        child: SpinKitWave(
          color: Colors.orange,
          size: PSizeConfig.width(50),
          duration: Duration(milliseconds: 1200),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late Widget loader;

    if (indexStack) {
      loader = IndexedStack(
        index: show ? 0 : 1,
        children: [
          AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: body,
          ),
          substitute ??
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(bottom: kToolbarHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CBLoader.wave()],
                ),
              )
        ],
      );
    } else {
      loader = Stack(
        children: [
          body,
          if (!show)
            substitute ??
                Container(
                  width: double.maxFinite,
                  color: Colors.black.withOpacity(0.1),
                  padding: EdgeInsets.only(bottom: kToolbarHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CBLoader.wave()],
                  ),
                )
        ],
      );
    }

    // if (!show) FocusManager.instance.primaryFocus?.unfocus();

    return loader;
  }
}
