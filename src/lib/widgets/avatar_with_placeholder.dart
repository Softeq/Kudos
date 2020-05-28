import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/helpers/avatar_placeholder_builder.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class AvatarWithPlaceholder extends StatelessWidget {
  final double size;
  final ImageViewModel imageViewModel;
  final AvatarPlaceholder avatarPlaceholder;

  AvatarWithPlaceholder(this.imageViewModel, String name, [this.size])
      : avatarPlaceholder = AvatarPlaceholderBuilder.build(name);

  AvatarWithPlaceholder.withUrl(String imageUrl, String name, [this.size])
      : imageViewModel = ImageViewModel()..initialize(imageUrl, null, false),
        avatarPlaceholder = AvatarPlaceholderBuilder.build(name);

  AvatarWithPlaceholder.withFile(File imageFile, String name, [this.size])
      : imageViewModel = ImageViewModel()..initialize(null, imageFile, false),
        avatarPlaceholder = AvatarPlaceholderBuilder.build(name);

  @override
  Widget build(BuildContext context) {
    if (imageViewModel.file == null &&
        (imageViewModel.imageUrl == null || imageViewModel.imageUrl.isEmpty))
      return CircleAvatar(
          radius: size,
          backgroundColor: avatarPlaceholder.color,
          child: Text(avatarPlaceholder.abbreviation));
    else if (imageViewModel.file != null) {
      return CircleAvatar(
        radius: size,
        backgroundImage: FileImage(imageViewModel.file),
      );
    } else {
      return CircleAvatar(
        radius: size,
        backgroundImage: CachedNetworkImageProvider(imageViewModel.imageUrl),
      );
    }
  }
}
