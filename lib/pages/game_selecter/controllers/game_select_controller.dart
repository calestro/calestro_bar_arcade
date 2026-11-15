




import 'package:rxdart/rxdart.dart';

class GameSelectController {

  final BehaviorSubject<int> _selectedIndexSubject = BehaviorSubject<int>.seeded(0);
  Stream<int> get selectedIndexStream => _selectedIndexSubject.stream;
  int get index => _selectedIndexSubject.value;


  void updateSelectedIndex() {
    _selectedIndexSubject.add();
  }







}