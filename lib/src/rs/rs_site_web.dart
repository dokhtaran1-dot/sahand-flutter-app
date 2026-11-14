import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
const _viewType = 'royal-one-rs-jafar-offline';
bool _registered = false;
class RsSiteView extends StatelessWidget {
  const RsSiteView({super.key});
  @override
  Widget build(BuildContext context) {
    if (!_registered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        return html.IFrameElement()
          ..src = Uri.base.resolve('assets/assets/rs/index.html').toString()
          ..title = 'Jafar Dargahi — Beyond Gravity'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = '0';
      });
      _registered = true;
    }
    return const HtmlElementView(viewType: _viewType);
  }
}
