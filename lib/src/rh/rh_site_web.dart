// Flutter web displays the same bundled document in its own viewport.
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

const _viewType = 'royal-one-rh-site';
bool _registered = false;

class RhSiteView extends StatelessWidget {
  const RhSiteView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_registered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        return html.IFrameElement()
          ..src = Uri.base.resolve('assets/assets/rh/index.html').toString()
          ..title = 'Royal Harmonia'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = '0'
          ..style.backgroundColor = '#07100e'
          ..allowFullscreen = true;
      });
      _registered = true;
    }
    return const HtmlElementView(viewType: _viewType);
  }
}
