part of scheme_list_library;

class SchemeListScreen
    extends WidgetView<SchemeListScreen, SchemeListControllerState> {
  SchemeListScreen(super.controllerState, {super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: "Schemes",

      onFabPressed: () {
        Navigator.popAndPushNamed(context, AppRoutes.newScheme);
      },
      body: BlocBuilder<SchemeBloc, SchemeState>(
        builder: (context, state) {
          if (state is LoadingSchemeList) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 6),
                  Text("Loading"),
                ],
              ),
            );
          } else if (state is LoadSchemeListSuccess) {
            List<Scheme> allSchemes = state.response;
            List<Scheme> filteredSchemes = List.from(allSchemes);

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Schemes',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (value) {
                          value = value.toLowerCase();
                          setState(() {
                            filteredSchemes = allSchemes.where((scheme) {
                              return scheme.schemeName
                                  .toLowerCase()
                                  .contains(value);
                            }).toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: filteredSchemes.isEmpty
                          ? Center(child: Text("No schemes found"))
                          : ListView.builder(
                              itemCount: filteredSchemes.length,
                              itemBuilder: (context, index) {
                                final scheme = filteredSchemes[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        Navigator.popAndPushNamed(
                                          context,
                                          AppRoutes.schemeDetails,
                                          arguments: {"scheme_id": scheme.id},
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor:
                                                  Colors.teal.shade100,
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal.shade900,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    scheme.schemeName,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    scheme.type,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text("Unable to load schemes"));
          }
        },
      ),
    );
  }
}
