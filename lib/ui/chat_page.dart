import 'package:chat_platform/bloc/chat_page/bloc/chat_bloc.dart';
import 'package:chat_platform/bloc/landing_page/bloc/landing_bloc.dart';
import 'package:chat_platform/model/message.dart';
import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChatPage> {
  late ChatBloc chatBloc;
  final _textController = TextEditingController();

  bool _showEmoji = false, _isUploading = false;
  ScrollController messageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc();
    chatBloc.add(ChatInitialEvent(
      currentThread: BlocProvider.of<LandingBloc>(context).currentActiveThreads,
      currentIndex:
          BlocProvider.of<LandingBloc>(context).currentActiveThreadsIndex,
    ));
  }

  CollapsibleItem getCollapsibleItemFromMessage(List<Message> message, index) {
    return CollapsibleItem(
      text: "${message[0].content.substring(0, 15)}...",
      onPressed: () {
        chatBloc.add(ChatOnChangeThreadsEvent(
          newThread: BlocProvider.of<LandingBloc>(context).threads[index],
          newIndex: index,
        ));
        BlocProvider.of<LandingBloc>(context).currentActiveThreadsIndex =
            chatBloc.currentThreadsIndex;
      },
      icon: Icons.pentagon_outlined,
      isSelected:
          BlocProvider.of<LandingBloc>(context).currentActiveThreadsIndex ==
              index,
    );
  }

  List<CollapsibleItem> getCollapsibleItemListFromThreads() {
    List<CollapsibleItem> items = [];
    List<List<Message>> currentThreads =
        BlocProvider.of<LandingBloc>(context).threads;

    for (var i = 0; i < currentThreads.length; i++) {
      items.add(getCollapsibleItemFromMessage(currentThreads[i], i));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chat'),
        titleTextStyle: GoogleFonts.montserrat(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: BlocListener<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {
          if (state is ChatStableMesssageState) {
            //Trigger event to save all current data
            BlocProvider.of<LandingBloc>(context)
                .add(LandingSaveAllThreadsEvent());
          }
        },
        child: chatScreen(mq),
      ),
    );
  }

  Widget chatScreen(Size mq) {
    return CollapsibleSidebar(
        iconSize: 20,
        selectedTextColor: Colors.white70,
        title: "Threads",
        isCollapsed: true,
        textStyle: GoogleFonts.montserrat(fontSize: 15),
        titleStyle:
            GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w700),
        toggleTitleStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        items: getCollapsibleItemListFromThreads(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Column(
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                bloc: chatBloc,
                builder: (context, state) {
                  if (state is ChatStableMesssageState) {
                    return Expanded(
                      flex: 7,
                      child: ListView.builder(
                          controller: messageScrollController,
                          itemCount: chatBloc.currentThreads.length,
                          itemBuilder: (context, position) {
                            if (position < chatBloc.currentThreads.length) {
                              String role =
                                  chatBloc.currentThreads[position].role;
                              String content =
                                  chatBloc.currentThreads[position].content;
                              if (role == "user") {
                                return getSenderView(
                                    ChatBubbleClipper5(
                                        type: BubbleType.sendBubble),
                                    context,
                                    content);
                              } else if (role == "assistant") {
                                return getReceiverView(
                                    ChatBubbleClipper5(
                                        type: BubbleType.receiverBubble),
                                    context,
                                    content);
                              } else {
                                return getReceiverView(
                                    ChatBubbleClipper5(
                                        type: BubbleType.receiverBubble),
                                    context,
                                    "How can i help you?");
                              }
                            }
                            return null;
                          }),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              BlocBuilder<ChatBloc, ChatState>(
                bloc: chatBloc,
                builder: (context, state) {
                  if (state is ChatStableMesssageState) {
                    return _chatInput(mq);
                  } else {
                    return const SizedBox(
                      height: 10,
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }

  Widget _chatInput(Size mq) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          //input field & buttons
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w300, fontSize: 15),
                          border: InputBorder.none),
                    )),

                    //adding some space
                    SizedBox(width: mq.width * .02),
                    MaterialButton(
                      onPressed: () {
                        String inputContent = _textController.text;
                        Message newMessage =
                            Message(role: "user", content: inputContent);
                        chatBloc.add(ChatSendMessageEvent(message: newMessage));
                        messageScrollController.animateTo(
                          messageScrollController.position.maxScrollExtent,
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      minWidth: 0,
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, right: 5, left: 10),
                      shape: const CircleBorder(),
                      color: Colors.green,
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 28),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getSenderView(CustomClipper clipper, BuildContext context, String content) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
          child: Text(
            content,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  getReceiverView(
          CustomClipper clipper, BuildContext context, String content) =>
      ChatBubble(
        clipper: clipper,
        backGroundColor: const Color(0xffE7E7ED),
        margin: const EdgeInsets.only(top: 20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            content,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
}
