part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent {}

class ChangeThemeEvent extends ThemeEvent {
  final String theme;
  ChangeThemeEvent({required this.theme});
}
