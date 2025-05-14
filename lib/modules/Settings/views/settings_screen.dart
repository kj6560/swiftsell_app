part of settings_library;

class SettingsScreen
    extends WidgetView<SettingsScreen, SettingsControllerState> {
  SettingsScreen(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Settings",

      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          BluetoothInfo? printer;
          if (state is PrintersLoaded) {
            printer = state.selectedPrinter;
            print(printer);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                leading: Icon(Icons.print, color: Colors.teal),
                title: Text("Connected Printer"),
                subtitle: Text(printer?.name ?? "None selected"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PrinterSelectionScreen(),
                    ),
                  );
                },
              ),
              // You can add more settings here
            ],
          );
        },
      ),
    );
  }
}
