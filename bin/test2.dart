import 'addrPort.dart';
import 'sipMessage.dart';
import 'SipMessageFactory.dart';

void main() {
  SipMessageFactory smFact = SipMessageFactory();
  String message = "REGISTER sip:127.0.0.1:5080;transport=UDP SIP/2.0\r\n" +
      "Via: SIP/2.0/UDP 127.0.0.1:58086;branch=z9hG4bK-524287-1---a48497ae9a52cae7;rport\r\n" +
      "Max-Forwards: 70\r\n" +
      "Contact: <sip:1000@127.0.0.1:58086;rinstance=af5ed2d299cd0990;transport=UDP>\r\n" +
      "To: <sip:1000@127.0.0.1:5080;transport=UDP>\r\n" +
      "From: <sip:1000@127.0.0.1:5080;transport=UDP>;tag=036b8401\r\n" +
      "Call-ID: VIT-P2aBnPyzIbnAyWShHQ..\r\n" +
      "CSeq: 1 REGISTER\r\n" +
      "Expires: 70\r\n" +
      "Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE\r\n" +
      "Supported: replaces, norefersub, extended-refer, timer, sec-agree, outbound, path, X-cisco-serviceuri\r\n" +
      "User-Agent: Z 5.6.1 v2.10.19.9\r\n" +
      "Allow-Events: presence, kpml, talk, as-feature-event\r\n" +
      "Content-Length: 0\r\n";

  sockaddr_in src = sockaddr_in("127.0.0.1", 5060);

  SipMessage msg = smFact.createSipMessage(message, src);

  //SipMessage msg = SipMessage(message, src);

  // print(msg.getType());
  // print(msg.getVia());
  // print(msg.getContact());
  // print(msg.getTo());
  // print(msg.getFrom());
  // print(msg.getCallID());
  // print(msg.getFromNumber());
  //print(msg.getContentLength());
  //print(msg.getSource().addr);
  //print(msg.getSource().port);
  // print(msg.);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
  // print(msg);
}
