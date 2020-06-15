import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/helpers/image_placeholder_builder.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class RoundedImageWidget extends StatelessWidget {
  final ImageViewModel imageViewModel;
  final String name;
  final double size;
  final ImagePlaceholder imagePlaceholder;

  RoundedImageWidget({
    @required this.imageViewModel,
    @required this.name,
    this.size,
  }) : imagePlaceholder = ImagePlaceholderBuilder.build(name);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageViewModel>.value(
      value: imageViewModel,
      child: Consumer<ImageViewModel>(
        builder: (context, viewModel, child) {
          if (imageViewModel.file == null &&
              (imageViewModel.imageUrl == null ||
                  imageViewModel.imageUrl.isEmpty)) {
            return _buildPlaceholderWidget();
          } else if (viewModel.file != null) {
            return _buildImageWidget();
          } else {
            viewModel.loadImageFileIfNeeded();
            return _buildPlaceholderWidget();
          }
        },
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        width: size,
        height: size,
        color: imagePlaceholder.color,
        child: Center(
          child: Text(imagePlaceholder.abbreviation),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    var fileExtension = path.extension(imageViewModel.file.path);
    switch (fileExtension) {
      case ".svg":
        return ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Container(
            color: imagePlaceholder.color,
            child: SvgPicture.file(
              imageViewModel.file,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
      default:
        return ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Container(
            color: imagePlaceholder.color,
            child: Image.file(
              imageViewModel.file,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
    }
  }
}
