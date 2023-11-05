import 'addrPort.dart';

class SipClient {
  SipClient(String number, sockaddr_in address)
      : _number = number,
        _address = address {}

  // bool operator ==(SipClient other) {
  //   if (_number == other.getNumber()) {
  //     return true;
  //   }

  //   return false;
  // }

  String getNumber() {
    return _number;
  }

  sockaddr_in getAddress() {
    return _address;
  }

  String _number;
  sockaddr_in _address;
}
