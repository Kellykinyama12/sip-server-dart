import 'addrPort.dart';
import 'sipMessageHeaders.dart';
import 'SipMessageTypes.dart';

class SipMessage {
  SipMessage(String message, sockaddr_in src)
      : _messageStr = message,
        _src = src {
    // print(message);
    // print(_messageStr);
    //try {
    parse();
    //} catch (error) {
    //  print(error);
    //}
  }

  bool isValidMessage() {
    if (_via.isEmpty ||
        _to.isEmpty ||
        _from.isEmpty ||
        _callID.isEmpty ||
        _cSeq.isEmpty) {
      return false;
    }

    if ((_type == SipMessageTypes.INVITE ||
            _type == SipMessageTypes.REGISTER) &&
        _contact.isEmpty) {
      return false;
    }

    return true;
  }

  void setType(String value) {
    _type = value;
  }

  void setHeader(String value) {
    // print("Setting header");
    int headerPos = _messageStr.indexOf(_header);

    //print("header position $headerPos for $_header to be replaced with $value");
    if (headerPos == -1) {
      // print("Header not found");
      return;
    }
    _messageStr = _messageStr.replaceFirst(_header, value, headerPos);
    _header = value;

    // print(_messageStr);
  }

  void addHeader(String value) {
    // print("Setting header");
    int headerPos = _messageStr.indexOf(_header);

    //print("header position $headerPos for $_header to be replaced with $value");
    if (headerPos == -1) {
      // print("Header not found");
      return;
    }
    _messageStr = _messageStr.replaceFirst(_header, value, headerPos);
    _header = value;

    // print(_messageStr);
  }

  void setVia(String value) {
    int viaPos = _messageStr.indexOf(_via);
    _messageStr.replaceFirst(_header, value, viaPos);
    _via = value;
  }

  void setAuth(String value) {
    int authPos = _messageStr.indexOf(_authorization);
    _messageStr.replaceFirst(_header, value, authPos);
    _authorization = value;
  }

  void setWwwAuth(String value) {
    int authPos = _messageStr.indexOf(_wwwAuthenticate);
    _messageStr.replaceFirst(_header, value, authPos);
    _wwwAuthenticate = value;
  }

  void setFrom(String value) {
    int fromPos = _messageStr.indexOf(_from);
    _messageStr.replaceFirst(_from, value, fromPos);
    _from = value;
  }

  void setTo(String value) {
    int toPos = _messageStr.indexOf(_to);
    _messageStr.replaceFirst(_to, value, toPos);
    _to = value;

    _toNumber = extractNumber(value);
  }

  void setCallID(String value) {
    int toPos = _messageStr.indexOf(_callID);
    _messageStr.replaceFirst(_callID, value, toPos);
    _callID = value;
  }

  void setCSeq(String value) {
    int toPos = _messageStr.indexOf(_cSeq);
    _messageStr.replaceFirst(_cSeq, value, toPos);
    _cSeq = value;
  }

  void setContact(String value) {
    int contactPos = _messageStr.indexOf(_contact);
    _messageStr.replaceFirst(_contact, value, contactPos);
    _contact = value;
  }

  void setContentLength(String value) {
    int contentLengthPos = _messageStr.indexOf(_contentLength);
    _messageStr.replaceFirst(_contact, value, contentLengthPos);
    _contentLength = value;
  }

  String toString() {
    return _messageStr;
  }

  String getType() {
    return _type;
  }

  String getHeader() {
    return _header;
  }

  String getVia() {
    return _via;
  }

  String getWwwAuth() {
    return _wwwAuthenticate;
  }

  String getAuth() {
    return _authorization;
  }

  String getFrom() {
    return _from;
  }

  String getFromNumber() {
    return _fromNumber;
  }

  String getTo() {
    return _to;
  }

  String getToNumber() {
    return _toNumber;
  }

  String getCallID() {
    return _callID;
  }

  String getCSeq() {
    return _cSeq;
  }

  String getContact() {
    return _contact;
  }

  String getContactNumber() {
    return _contactNumber;
  }

  sockaddr_in getSource() {
    return _src;
  }

  String getContentLength() {
    return _contentLength;
  }

  String extractNumber(String header) {
    // print(header);
    int indexOfNumber = header.indexOf("sip:") + 4;
    //print(indexOfNumber);

    //try {
    // return header.substring(
    //     indexOfNumber, header.indexOf("@") - indexOfNumber);

    return header.substring(indexOfNumber, header.indexOf("@"));
    //} catch (error) {
    // print(error);
    //}
    //return "";
  }

  void parse() {
    String msg = _messageStr;
    bool debug = false;

    if (msg.indexOf(SipMessageTypes.UNAUTHORIZED) == -1) {
      //print("parsing unauthorized");
      debug = true;
    }

    int pos = msg.indexOf(SipMessageHeaders.HEADERS_DELIMETER);
    // print(_messageStr);
    //print(msg);
    // print(" index: $pos");
    if (pos == -1) return;
    _header = msg.substring(0, pos);

    msg = msg.substring(pos + SipMessageHeaders.HEADERS_DELIMETER.length);

    if (_header.indexOf(" ") == -1) {
      //print(_header);
      return;
    }

    // if (debug) print("parsing continued");

    //msg.erase(0, pos + std.strlen(SipMessageHeaders.HEADERS_DELIMETER));
    _type = _header.substring(0, _header.indexOf(" "));
    if (_type == "SIP/2.0") {
      _type = _header;
    }
    //if (debug) print("parsing continued");

    int npos = -1;
    while ((pos = msg.indexOf(SipMessageHeaders.HEADERS_DELIMETER)) != -1) {
      String line = msg.substring(0, pos);

      if (line.indexOf(SipMessageHeaders.VIA) != npos) {
        _via = line;
      } else if (line.indexOf(SipMessageHeaders.FROM) != npos) {
        _from = line;
        //print(_from);
        _fromNumber = extractNumber(_from);
        //print(_fromNumber);
      } else if (line.indexOf(SipMessageHeaders.TO) != npos) {
        _to = line;
        _toNumber = extractNumber(_to);
      } else if (line.indexOf(SipMessageHeaders.CALL_ID) != npos) {
        _callID = line;
      } else if (line.indexOf(SipMessageHeaders.CSEQ) != npos) {
        _cSeq = line;
      } else if (line.indexOf(SipMessageHeaders.CONTACT) != npos) {
        _contact = line;

        _contactNumber = extractNumber(_contact);
      } else if (line.indexOf(SipMessageHeaders.CONTENT_LENGTH) != npos) {
        _contentLength = line;
      } else if (line.indexOf(SipMessageHeaders.AUTHORIZATION) != npos) {
        //print(line);
        _authorization = line;
      } else if (line.indexOf(SipMessageHeaders.WWW_Authenticate) != npos) {
        //print(line);
        _wwwAuthenticate = line;
      }

      //msg.erase(0, pos + std.strle

      msg = msg.substring(pos + SipMessageHeaders.HEADERS_DELIMETER.length);
    }
    print("Tesing validity");
    if (!isValidMessage()) {
      print("Invalid message");
      throw "Invalid message";
      //throw std.runtime_error("Invalid message.");
    }

    // if (debug == true &&
    //     _messageStr.indexOf(SipMessageHeaders.WWW_Authenticate) == -1) {
    //   print(_messageStr);
    //   throw "No ${SipMessageHeaders.WWW_Authenticate} header";
    // }

    print("Finished parsing");
  }

  String _type = "";
  String _header = "";
  String _via = "";
  String _from = "";
  String _fromNumber = "";
  String _to = "";
  String _toNumber = "";
  String _callID = "";
  String _cSeq = "";
  String _contact = "";
  String _contactNumber = "";
  String _contentLength = "";
  String _messageStr = "";
  String _authorization = "";
  String _wwwAuthenticate = "";

  sockaddr_in _src;
}
