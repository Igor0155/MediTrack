import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditrack/main.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  final isTablet = getIt.get<bool>(instanceName: 'isTabletDevice');

  User? user;

  @override
  void initState() {
    super.initState();
    try {
      // Verifica se o usuário está autenticado
      user = FirebaseAuth.instance.currentUser;
    } catch (e) {
      // Se ocorrer um erro, o usuário será nulo
      user = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: isTablet ? 500 : null,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                            user?.displayName?.isNotEmpty == true
                                ? user!.displayName!
                                : user?.email?.split('@').first.toUpperCase() ?? 'Usuário não encontrado',
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary))),
                    accountEmail: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text('E-mail: ',
                              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                              overflow: TextOverflow.ellipsis),
                          Expanded(
                              child: Text(user?.email ?? 'Não encontrado',
                                  style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                  overflow: TextOverflow.ellipsis))
                        ],
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: const Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    currentAccountPictureSize: const Size(60, 60),
                    otherAccountsPictures: [
                      IconButton(
                          onPressed: () async {
                            await context.push('/settings');
                            setState(() {});
                          },
                          icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary, size: 20)),
                      IconButton(
                          onPressed: () => context.go('/'),
                          icon: Icon(Icons.logout, size: 20, color: Theme.of(context).colorScheme.onPrimary))
                    ],
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary)),
                ExpansionTile(
                    leading: const Icon(Icons.api_rounded, size: 20),
                    shape: const Border.symmetric(),
                    title: const Text('Remédios'),
                    textColor: Theme.of(context).primaryColor,
                    childrenPadding: const EdgeInsets.only(left: 20),
                    children: [
                      ListTile(
                          leading: const Icon(Icons.history, size: 20),
                          title: const Text('Histórico de Remédios'),
                          onTap: () {
                            context.push('/history_medicaments');
                          },
                          minTileHeight: 40),
                      ListTile(
                          leading: const Icon(Icons.search, size: 20),
                          title: const Text('Consultar Remédios'),
                          onTap: () {
                            context.push('/all_medicaments');
                          },
                          minTileHeight: 40),
                    ]),
                ListTile(
                    leading: const Icon(Icons.search, size: 20),
                    title: const Text('Consultar Farmácias'),
                    subtitle: const Text('Encontre farmácias próximas'),
                    onTap: () {
                      context.push('/mapa_farmacias');
                    },
                    minTileHeight: 40),
              ],
            ),
          ],
        ));
  }
}

////