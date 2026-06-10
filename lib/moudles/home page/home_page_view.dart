import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:masrofe/data/transaction_repository.dart';

import 'package:masrofe/moudles/home page/cubit/home_page_cubit.dart';

import 'package:masrofe/moudles/home page/widgets/add_transaction_sheet.dart';

import 'package:masrofe/moudles/home page/widgets/currency_section.dart';

import 'package:masrofe/moudles/home page/widgets/transaction_tile.dart';



class HomePageView extends StatelessWidget {

  const HomePageView({super.key});



  @override

  Widget build(BuildContext context) {

    return BlocProvider(

      create: (_) => HomePageCubit(TransactionRepository()),

      child: BlocBuilder<HomePageCubit, HomePageState>(

        builder: (context, state) {

          if (state is HomePageLoaded) {

            return _HomePageContent(state: state);

          }

          return const Scaffold(

            body: Center(child: CircularProgressIndicator()),

          );

        },

      ),

    );

  }

}



class _HomePageContent extends StatelessWidget {

  final HomePageLoaded state;



  const _HomePageContent({required this.state});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F6FA),

      body: CustomScrollView(

        slivers: [

          _buildSliverAppBar(),

          SliverToBoxAdapter(

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  CurrencySection(currencies: state.currencies),

                  const SizedBox(height: 28),

                  const Text(

                    'آخر المعاملات',

                    style: TextStyle(

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                      color: Color(0xFF2D3142),

                    ),

                  ),

                  const SizedBox(height: 12),

                  ...state.recentTransactions.map((t) => TransactionTile(transaction: t)),

                ],

              ),

            ),

          ),

        ],

      ),

      floatingActionButton: _buildFAB(context),

    );

  }



  Widget _buildSliverAppBar() {

    return const SliverAppBar(

      expandedHeight: 120,

      floating: false,

      pinned: true,

      backgroundColor: Color(0xFF6C63FF),

      elevation: 0,

      flexibleSpace: FlexibleSpaceBar(

        title: Text(

          'مصروفي',

          style: TextStyle(

            color: Colors.white,

            fontWeight: FontWeight.bold,

            fontSize: 20,

          ),

        ),

      ),

    );

  }



  FloatingActionButton _buildFAB(BuildContext context) {

    return FloatingActionButton(

      backgroundColor: const Color(0xFF6C63FF),

      onPressed: () {

        showModalBottomSheet(

          context: context,

          isScrollControlled: true,

          shape: const RoundedRectangleBorder(

            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

          ),

          builder: (_) => BlocProvider.value(

            value: context.read<HomePageCubit>(),

            child: const AddTransactionSheet(),

          ),

        );

      },

      child: const Icon(Icons.add, color: Colors.white),

    );

  }

}

