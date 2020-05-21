
TR_PATH=assets/translations

echo "Generate loader..."
flutter pub run easy_localization:generate -s $TR_PATH

echo "Generate keys..."
flutter pub run easy_localization:generate -s $TR_PATH -f keys -o locale_keys.g.dart
