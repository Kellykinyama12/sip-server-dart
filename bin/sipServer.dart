import "RequestsHandler.dart";
import 'SipMessage.dart';
import "SipMessageFactory.dart";
import 'addrPort.dart';
import 'dart:io';
import 'configs/trunks.dart';

class SipServer {
  // SipServer(String ip, {int port = 5060}){

  // }

  SipServer(String ip, int port) {
    //RawDatagramSocket _socket;
    ReqHandler? handler;
    SipMessageFactory messagesFactory = SipMessageFactory();

    RawDatagramSocket.bind(InternetAddress(ip), port)
        .then((RawDatagramSocket socket) {
      print('UDP Echo ready to receive');
      print('${socket.address.address}:${socket.port}');

      handler = ReqHandler(socket.address.address, socket.port, socket);

      // String message = "REGISTER sip:127.0.0.1:5080;transport=UDP SIP/2.0\r\n" +
      //     "Via: SIP/2.0/UDP 127.0.0.1:58086;branch=z9hG4bK-524287-1---a48497ae9a52cae7;rport\r\n" +
      //     "Max-Forwards: 70\r\n" +
      //     "Contact: <sip:1000@127.0.0.1:58086;rinstance=af5ed2d299cd0990;transport=UDP>\r\n" +
      //     "To: <sip:1000@127.0.0.1:5080;transport=UDP>\r\n" +
      //     "From: <sip:1000@127.0.0.1:5080;transport=UDP>;tag=036b8401\r\n" +
      //     "Call-ID: VIT-P2aBnPyzIbnAyWShHQ..\r\n" +
      //     "CSeq: 1 REGISTER\r\n" +
      //     "Expires: 70\r\n" +
      //     "Allow: INVITE, ACK, CANCEL, BYE, NOTIFY, REFER, MESSAGE, OPTIONS, INFO, SUBSCRIBE\r\n" +
      //     "Supported: replaces, norefersub, extended-refer, timer, sec-agree, outbound, path, X-cisco-serviceuri\r\n" +
      //     "User-Agent: Z 5.6.1 v2.10.19.9\r\n" +
      //     "Allow-Events: presence, kpml, talk, as-feature-event\r\n" +
      //     "Content-Length: 0\r\n";

      socket.listen((RawSocketEvent e) {
        dynamic onHandled(sockaddr_in dest, SipMessage message) {
          //_socket.send(dest, message.toString());

          socket.send(message.toString().codeUnits, InternetAddress(dest.addr),
              dest.port);
        }

        onNewMessage(String data, sockaddr_in src) {
          // print(data);
          dynamic msg = messagesFactory.createMessage(data, src) as dynamic;
          if (msg.isValidMessage()) {
            handler!.handle(msg);
          } else {
            // print("Invalid message");
          }
        }

        Datagram? d = socket.receive();
        if (d != null) {
          String message = String.fromCharCodes(d.data);
          //print(
          //    'Datagram from ${d.address.address}:${d.port}: ${message.trim()}');

          // print("\r\n");
          sockaddr_in src = sockaddr_in(d.address.address, d.port);
          // print(
          //     "New message from ${d.address.address}:${d.port} message: $message");

          onNewMessage(message, src);
          //socket.send(message.codeUnits, d.address, d.port);

          // socket.send(message.toString().codeUnits,
          //     InternetAddress(d.address.address), d.port);
        }

        //handler!.register(trunks["1000"]);
        // trunks.forEach((key, value) {
        //   print("Sending registration");
        //   handler!.register(value);
        // });

        // Where:
        // sendStatus(Timer timer) {
        //   //print(resp);
        //   socket.send(
        //       message.toString().codeUnits, InternetAddress("127.0.0.1"), 5080);
        // }
        // var _time2 = Timer.periodic(const Duration(seconds: 5), sendStatus);
      });
      trunks.forEach((key, value) {
        print("Sending registration");
        handler!.register(value);
      });
    });
  }
}
