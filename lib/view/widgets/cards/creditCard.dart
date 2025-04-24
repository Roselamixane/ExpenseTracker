import 'package:app/domain/repository.dart' as repository;
import 'package:app/view/provider/summaryProvider.dart';
import 'package:app/view/widgets/dialogBoxs/balanceBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class creditCard extends StatelessWidget {
  const creditCard({super.key});

  @override
  Widget build(BuildContext context) {
    void modifyBalance() {
      showDialog(
        context: context,
        builder: (context) => const balanceBox(),
      );
    }

    return Consumer<summaryProvider>(builder: (context, provider, child) {
      // ❌ DO NOT reset values here (this was causing the issue)
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance, color: Colors.white),
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
                          repository.formatAmount(provider.user?.balance ?? 0.0),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      child: const Icon(Icons.more_horiz, color: Colors.white),
                      onTap: modifyBalance,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard(
                      title: 'Income',
                      amount: provider.incoming,
                      icon: Icons.arrow_upward,
                      iconColor: const Color.fromARGB(255, 3, 195, 9)),
                  _buildInfoCard(
                      title: 'Expense',
                      amount: provider.outgoing,
                      icon: Icons.arrow_downward,
                      iconColor: Colors.red),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: const Color.fromARGB(255, 74, 147, 196),
                child: Icon(icon, color: iconColor, size: 23),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color.fromARGB(255, 216, 216, 216),
                ),
              ),
            ],
          ),
          Text(
            repository.formatAmount(amount),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
