import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class VyblnUser extends Equatable {
  const VyblnUser({
    @required this.email,
    @required this.id,
    @required this.name,
    @required this.photo,
  })  : assert(email != null),
        assert(id != null);

  final String email;
  final String id;
  final String name;
  final String photo;

  static const empty = VyblnUser(email: '', id: '', name: null, photo: null);

  @override
  List<Object> get props => [email, id, name, photo];
}
