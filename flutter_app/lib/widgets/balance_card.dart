import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String accountNo;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.accountNo,
  });

  String maskAccountNumber(String accountNo) {
    if (accountNo.length <= 4) return accountNo;

    final last4 = accountNo.substring(accountNo.length - 4);

    return "**** **** **** $last4";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Balance",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "PKR ${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                maskAccountNumber(accountNo),
                style: const TextStyle(
                  color: Colors.white,
                  letterSpacing: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}