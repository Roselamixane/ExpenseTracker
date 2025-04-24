import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/widgets/dialogBoxs/balanceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class creditCard extends StatelessWidget {
  const creditCard({super.key});

  @override
  Widget build(BuildContext context) {
    //final userProvider = Provider.of<Userdataprovider>(context, listen: true);

    void modifyBalance() {
      showDialog(
          context: context,
          builder: (context) {
            return balanceBox();
          });
    }

    return Consumer<summaryProvider>(builder: (context, provider, child) {
      provider.defaultValues(0, 0);
      return Container(
        height: 200,
        width: 360,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(47, 125, 121, 0.3),
              offset: Offset(0, 6),
              blurRadius: 12,
              spreadRadius: 6,
            ),
          ],
          color: const Color.fromARGB(255, 14, 119, 172),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.account_balance,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Balance',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          repository.formatAmount((provider.incoming + provider.outgoing)),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                      onTap: () {
                        modifyBalance();
                      },
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                              Color.fromARGB(255, 74, 147, 196),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Color.fromARGB(255, 3, 195, 9),
                                size: 23,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Income',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 85, 89, 89),
                              ),
                            )
                          ],
                        ),
                        Text(
                          repository.formatAmount(provider.incoming),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                              Color.fromARGB(255, 74, 147, 196),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: 23,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Expense',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 216, 216, 216),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          repository.formatAmount(provider.outgoing),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}