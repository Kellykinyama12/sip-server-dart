import 'sipServer.dart';
import 'wsSipServer.dart';

//Function(dynamic resp)
void main() {
  // ignore: unused_local_variable
  SipServer sipServer = SipServer("192.168.0.90", 5081);
  // wsSipServer wsServer =
  //     wsSipServer("192.168.0.90", 8088, "192.168.0.90", 5080);
}
