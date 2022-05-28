part of 'theme_bloc.dart';

@immutable
abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeChangedState extends ThemeState {
  final ThemeData theme;
  ThemeChangedState({required this.theme});
}
