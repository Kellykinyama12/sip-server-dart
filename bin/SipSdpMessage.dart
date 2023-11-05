import 'dart:ffi';

import "SipMessage.dart";
import 'addrPort.dart';
import 'sipMessageHeaders.dart';
import 'SipMessageTypes.dart';
import 'dart:convert';

class SipSdpMessage {
  SipSdpMessage(String message, sockaddr_in src)
      : _messageStr = message,
        _src = src {
    parse();
  }

  void setMedia(String value) {
    int mPos = _messageStr.indexOf(_media);
    //_messageStr.replace(mPos, _media.length(), value);
    _messageStr.replaceFirst(_media, value, mPos);
    _media = value;
  }

  void setRtpPort(int port) {
    String currentRtpPort = _rtpPort.toString();
    String copyM = _media;

    //copyM.replace(_media.indexOf(currentRtpPort), currentRtpPort.length, port.toString());
    copyM.replaceFirst(
        currentRtpPort, port.toString(), _media.indexOf(currentRtpPort));
    _rtpPort = port;
    setMedia(copyM);
  }

  String getVersion() {
    return _version;
  }

  String getOriginator() {
    return _originator;
  }

  String getSessionName() {
    return _sessionName;
  }

  String getConnectionInformation() {
    return _connectionInformation;
  }

  String getTime() {
    return _time;
  }

  String getMedia() {
    return _media;
  }

  int getRtpPort() {
    return _rtpPort;
  }

  UnsignedInt extractRtpPort(String data) {
    //data.erase(0, data.indexOf(" ") + 1);
    data.replaceFirst(" ", "", data.indexOf(" ") + 1);
    String portStr = data.substring(0, data.indexOf(" "));
    return portStr as UnsignedInt;
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
      print("Header not found");
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

  bool sValidMessage() {
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

  void parse() {
    String msg = _messageStr;

    int pos = msg.indexOf(SipMessageHeaders.HEADERS_DELIMETER);
    _header = msg.substring(0, pos);

    msg = msg.substring(pos + SipMessageHeaders.HEADERS_DELIMETER.length);
    //msg.erase(0, pos + std.strlen(SipMessageHeaders.HEADERS_DELIMETER));
    _type = _header.substring(0, _header.indexOf(" "));
    if (_type == "SIP/2.0") {
      _type = _header;
    }

    int npos = -1;
    while ((pos = msg.indexOf(SipMessageHeaders.HEADERS_DELIMETER)) != -1) {
      String line = msg.substring(0, pos);

      if (line.indexOf(SipMessageHeaders.VIA) != npos) {
        _via = line;
      } else if (line.indexOf(SipMessageHeaders.FROM) != npos) {
        _from = line;
        _fromNumber = extractNumber(line);
      } else if (line.indexOf(SipMessageHeaders.TO) != npos) {
        _to = line;
        _toNumber = extractNumber(line);
      } else if (line.indexOf(SipMessageHeaders.CALL_ID) != npos) {
        _callID = line;
      } else if (line.indexOf(SipMessageHeaders.CSEQ) != npos) {
        _cSeq = line;
      } else if (line.indexOf(SipMessageHeaders.CONTACT) != npos) {
        _contact = line;
        _contactNumber = extractNumber(line);
      } else if (line.indexOf(SipMessageHeaders.CONTENT_LENGTH) != npos) {
        _contentLength = line;
      }

      //msg.erase(0, pos + std.strlen(SipMessageHeaders.HEADERS_DELIMETER));
      msg = msg.substring(pos + SipMessageHeaders.HEADERS_DELIMETER.length);
    }
    if (!isValidMessage()) {
      throw Error();
      //throw std.runtime_error("Invalid message.");
    }
    int posOfM = msg.indexOf("v=");
    //msg.erase(0, posOfM);
    // print("Index: $posOfM");

    if (posOfM != -1) {
      msg = msg.substring(posOfM);
      pos = 0;
      while ((pos = msg.indexOf(SipMessageHeaders.HEADERS_DELIMETER)) != npos) {
        String line = msg.substring(0, pos);
        if (line.indexOf("v=") != npos) {
          _version = (line);
        } else if (line.indexOf("o=") != npos) {
          _originator = (line);
        } else if (line.indexOf("s=") != npos) {
          _sessionName = line;
        } else if (line.indexOf("c=") != npos) {
          _connectionInformation = (line);
        } else if (line.indexOf("t=") != npos) {
          _time = (line);
        } else if (line.indexOf("m=") != npos) {
          _media = line;
          _rtpPort = extractRtpPort((line)) as int;
        }
        //msg.erase(0, pos + std::strlen(SipMessageHeaders::HEADERS_DELIMETER));

        msg = msg.substring(pos + SipMessageHeaders.HEADERS_DELIMETER.length);
      }
    }
  }

  //String extractNumber(String header) {}

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

  sockaddr_in _src;

  String _version = "";
  String _originator = "";
  String _sessionName = "";
  String _connectionInformation = "";
  String _time = "";
  String _media = "";
  int _rtpPort = 0;
}
