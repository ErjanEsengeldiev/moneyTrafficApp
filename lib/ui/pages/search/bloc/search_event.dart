part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchingEvent extends SearchEvent {
  final String value;
  SearchingEvent({required this.value});
}
