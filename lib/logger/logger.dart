import 'package:logger/logger.dart';

class EventStatePrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.levelColors[event.level];
    var emoji = PrettyPrinter.levelEmojis[event.level];
    print(event.level);
    var message = event.message;
    print(color('$emoji $message'));
    return List()..add(event.message.toString());
  }
}

Logger getLogger() => Logger(printer: EventStatePrinter());
