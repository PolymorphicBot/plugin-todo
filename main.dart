import "package:polymorphic_bot/api.dart";

main(args, port) => polymorphic(args, port);

@BotInstance()
BotConnector bot;

@PluginInstance()
Plugin plugin;

@PluginStorage("todos")
Storage todos;

@Command("add-todo")
addToDo(CommandEvent event) {
  if (event.args.isEmpty) {
    event.reply("> Usage: add-todo <message>");
    return;
  }

  todos.addToList("${event.network}:${event.user}", event.args.join(" "));
  event.replyNotice("[${Color.BLUE}TODO${Color.RESET}] Added to TODO list as #${todos.getList("${event.network}:${event.user}").length}");
}

@Command("todos")
listToDos(CommandEvent event) {
  var l = todos.getList("${event.network}:${event.user}", defaultValue: []);

  if (l.isEmpty) {
    event.replyNotice("[${Color.BLUE}TODO${Color.RESET}] No TODOs.");
  } else {
    int i = 0;
    for (var t in l) {
      i++;
      event.replyNotice("[${Color.BLUE}TODO${Color.RESET}] ${i}. ${t}");
    }
  }
}

@Command("remove-todo")
removeToDo(CommandEvent event) {
  if (event.args.length != 1) {
    event.reply("> Usage: remove-todo <number>");
  }

  var l = todos.getList("${event.network}:${event.user}");
  try {
    l.removeAt(int.parse(event.args[0]) - 1);
  } catch (e) {
    event.replyNotice("[${Color.BLUE}TODO${Color.RESET}] Invalid TODO Number");
    return;
  }
  todos.setList("${event.network}:${event.user}", l);

  event.replyNotice("[${Color.BLUE}TODO${Color.RESET}] Item #${event.args[0]} removed");
}