import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phr/widgets/button.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: ButtonWidget(
        //   text: 'H',
        //   onPress: () {},
        // ),
        appBar: AppBar(
          title: Text(
            'PHR',
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        // backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                surfaceTintColor: Colors.white,
                // color: Theme.of(context).colorScheme.background,
                // color: Colors.black,
                // color: Color.fromARGB(155, 47, 47, 47),
                // color: Color.fromARGB(255, 48, 48, 48),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  // horizontal: 15,
                  vertical: 15,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/LoginImage.jpg'),
                        radius: 40,
                      ),
                      Column(
                        children: [
                          Text(
                            'Mohd Touseef',
                            style: Theme.of(context).textTheme.headline3,
                            // maxLines: 5,
                            // softWrap: true,
                            // overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Age: 22',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'Weight: 62',
                          ),
                          Text(
                            'Height: 5.9ft',
                          ),
                        ],
                      )
                      // Image.asset(
                      //   'assets/images/LoginImage.jpg',
                      //   height: 500,
                      //   width: 200,
                      //   fit: BoxFit.cover,
                      // ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 5,
                        ),
                        elevation: 1,
                        surfaceTintColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 18,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Blood Group',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19,
                                    ),
                              ),
                              Icon(
                                Icons.bloodtype,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text(
                                'A+',
                                style: Theme.of(context).textTheme.displaySmall,
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    child: Card(
                      surfaceTintColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Weight',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                            ),
                            Icon(
                              Icons.monitor_weight,
                              color: Colors.white,
                              size: 40,
                            ),
                            Text(
                              '80 Kg',
                              style: Theme.of(context).textTheme.displaySmall,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'My Health',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                // textAlign: TextAlign.left,
              )
            ],
          ),
        ));
  }
}
