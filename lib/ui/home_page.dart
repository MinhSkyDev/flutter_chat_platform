import 'package:chat_platform/bloc/landing_page/bloc/landing_bloc.dart';
import 'package:chat_platform/component/thread_component.dart';
import 'package:chat_platform/model/message.dart';
import 'package:chat_platform/ui/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<LandingBloc>(context).add(LandingInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LandingBloc, LandingState>(
      listener: (context, state) {
        if (state is LandingNavigateToChatScreenState) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                    value: BlocProvider.of<LandingBloc>(context),
                    child: const ChatPage(),
                  )));
        }
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Thread',
                    style: GoogleFonts.montserrat(
                        fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              BlocBuilder(
                bloc: BlocProvider.of<LandingBloc>(context),
                builder: (context, state) {
                  if (state is LandingLoadingThreadState) {
                    return const getCircularProgress();
                  } else if (state is LandingLoadedThreadState) {
                    List<List<Message>> currentThreads =
                        BlocProvider.of<LandingBloc>(context).threads;
                    return Expanded(
                        flex: 3,
                        child: ListView.builder(
                          itemCount: currentThreads.length,
                          itemBuilder: (context, position) {
                            String threadName = "";
                            if (currentThreads[position].length == 1) {
                              threadName = "How can i help you?";
                            } else {
                              threadName = currentThreads[position][1].content;
                            }
                            return ThreadComponent(
                              index: position,
                              name: threadName,
                              firstMessage: currentThreads[position][0].content,
                              onClick: () {
                                BlocProvider.of<LandingBloc>(context).add(
                                    LandingClickThreadMessageEvent(
                                        threadId: position));
                              },
                            );
                          },
                        ));
                  } else {
                    return const Placeholder();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  getClearFloatingButton(),
                  getFloatingButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getClearFloatingButton() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.redAccent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.clear),
                color: Colors.white,
                onPressed: () {
                  BlocProvider.of<LandingBloc>(context)
                      .add(LandingDeleteAllThreadMessageEvent());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getFloatingButton() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightGreen,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                onPressed: () {
                  BlocProvider.of<LandingBloc>(context)
                      .add(LandingCreateNewThreadMessageEvent());
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class getCircularProgress extends StatelessWidget {
  const getCircularProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
