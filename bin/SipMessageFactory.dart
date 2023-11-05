import 'addrPort.dart';
import 'SipSdpMessage.dart';
import 'sipMessage.dart';

class SipMessageFactory {
  createMessage(String message, sockaddr_in src) {
    // print(message);
    // print("createMessage in SipMessageFactory");
    //try {
    if (containsSdp(message)) {
      // print("createMessage in SipMessageFactory");
      SipSdpMessage sdpMsg = SipSdpMessage(message, src);
      // print(sdpMsg.toString());
      return sdpMsg;
    }

    SipMessage sipMsg = SipMessage(message, src);
    // print(sipMsg.toString());
    return sipMsg;
    // } catch (error) {
    //   print(error);
    //   print("failed createMessage in SipMessageFactory");
    //   return {};
    // }
  }

  SipMessage createSipMessage(String message, sockaddr_in src) {
    // print(message);
    // print("createMessage in SipMessageFactory");
    //try {
    // if (containsSdp(message)) {
    //   // print("createMessage in SipMessageFactory");
    //   return SipSdpMessage(message, src);
    // }

    SipMessage sipMsg = SipMessage(message, src);
    // print(sipMsg.toString());
    return sipMsg;
    // } catch (error) {
    //   print(error);
    //   print("failed createMessage in SipMessageFactory");
    //   return {};
    // }
  }

  static String SDP_CONTENT_TYPE = "application/sdp";

  bool containsSdp(String message) {
    return message.indexOf(SDP_CONTENT_TYPE) != -1;
  }
}
