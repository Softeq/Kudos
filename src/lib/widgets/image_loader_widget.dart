import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class ImageLoaderWidget extends StatelessWidget {
  final String url;
  final File file;

  ImageLoaderWidget({this.url, this.file});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ImageLoaderViewModel>(
      create: (context) {
        return _ImageLoaderViewModel().._initialize(url, file);
      },
      child: Consumer<_ImageLoaderViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.file == null) {
            return Container();
          } else {
            return _buildImage(viewModel.file);
          }
        },
      ),
    );
  }

  Widget _buildImage(File imageFile) {
    var fileExtension = path.extension(imageFile.path);
    switch (fileExtension) {
      case ".svg":
        return SvgPicture.file(imageFile);
      default:
        return Image.file(imageFile);
    }
  }
}

class _ImageLoaderViewModel extends BaseViewModel {
  File _file;

  File get file => _file;

  void _initialize(String url, File file) async {
    _file = file;
    if (_file == null && url != null) {
      _file = await DefaultCacheManager().getSingleFile(url);
    }
    notifyListeners();
  }
}
