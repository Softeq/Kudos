import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:provider/provider.dart';

class ImageLoader extends StatelessWidget {
  final String _url;

  ImageLoader(this._url);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ImageLoaderViewModel>(
      create: (context) {
        return _ImageLoaderViewModel().._load(_url);
      },
      child: Consumer<_ImageLoaderViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.file == null) {
            return Container();
          } else {
            return SvgPicture.file(viewModel.file);
          }
        },
      ),
    );
  }
}

class _ImageLoaderViewModel extends BaseViewModel {
  File _file;

  File get file => _file;

  void _load(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    _file = file;
    notifyListeners();
  }
}
