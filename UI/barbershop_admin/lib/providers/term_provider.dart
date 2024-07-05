import '../models/term.dart';
import 'base_provider.dart';

class TermProvider extends BaseProvider<Term> {
  TermProvider() : super("Terms");

  @override Term fromJson(item) {
    return Term.fromJson(item);
  }
}
