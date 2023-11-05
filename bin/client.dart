import "RequestsHandler.dart";
import "Session.dart";
import 'SipMessage.dart';
import "SipMessageFactory.dart";
import 'addrPort.dart';
import 'dart:io';
import 'dart:async';

class Client {
  // SipServer(String ip, {int port = 5060}){

  // }

  Client(String ip, int port) {
    RawDatagramSocket.bind(InternetAddress(ip), 0)
        .then((RawDatagramSocket socket) {
      print('UDP Echo ready to receive');
      print('${socket.address.address}:${socket.port}');

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

      Where:
      sendStatus(Timer timer) {
        //print(resp);
        socket.send(
            message.toString().codeUnits, InternetAddress("127.0.0.1"), 5080);
      }
      var _time2 = Timer.periodic(const Duration(seconds: 1), sendStatus);
    });

    //_socket.startReceive();
  }

  //RawDatagramSocket _socket;
  RequestsHandler? _handler;
  SipMessageFactory _messagesFactory = SipMessageFactory();
}
