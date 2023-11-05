import "SipClient.dart";

enum State {
  // ignore: constant_identifier_names
  Invited,
  // ignore: constant_identifier_names
  Busy,
  // ignore: constant_identifier_names
  Unavailable,
  // ignore: constant_identifier_names
  Cancel,
  // ignore: constant_identifier_names
  Bye,
  // ignore: constant_identifier_names
  Connected,
}

class Session {
  Session(String callID, SipClient src, int srcRtpPort)
      : _callID = callID,
        _src = src,
        _srcRtpPort = srcRtpPort {}

  void setState(State state) {
    if (state == _state) {
      return;
    }
    _state = state;
    if (state == State.Connected) {
      print(
          "Session Created between  ${_src.getNumber()} and  _dest->getNumber()");
    }
  }

  void setDest(SipClient dest, int destRtpPort) {
    _dest = dest;
    _destRtpPort = destRtpPort;
  }

  String getCallID() {
    return _callID;
  }

  SipClient getSrc() {
    return _src;
  }

  SipClient getDest() {
    return _dest!;
  }

  State? getState() {
    return _state;
  }

  String _callID;
  SipClient _src;
  SipClient? _dest;
  State? _state;

  int _srcRtpPort;
  int? _destRtpPort;
}
