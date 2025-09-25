import 'package:flutter/material.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({super.key});

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  TextEditingController searchController = TextEditingController();

  List<String> recentSearches = ["Delhi", "Bengaluru"];
  // Top Cities in India (including Odisha highlights)
  List<String> topCities = [
    "Bhubaneswar", // Capital of Odisha
    "Cuttack", // Twin city of Bhubaneswar
    "Puri", // Famous for Jagannath Temple & beach
    "Konark", // Sun Temple
    "Rourkela", // Steel City
    "Sambalpur", // Hirakud Dam
    "Berhampur", // Silk City
    "Kolkata", // Metro city near Odisha
    "Hyderabad",
    "Delhi",
    "Mumbai",
    "Chennai",
    "Bengaluru",
  ];

  // All Cities (broader list, Odisha + major India cities)
  List<String> allCities = [
    "Bhubaneswar",
    "Cuttack",
    "Puri",
    "Konark",
    "Rourkela",
    "Sambalpur",
    "Berhampur",
    "Balasore",
    "Baripada",
    "Jharsuguda",
    "Angul",
    "Kendrapara",
    "Koraput",
    "Rayagada",
    "Kolkata",
    "Delhi",
    "Mumbai",
    "Chennai",
    "Hyderabad",
    "Bengaluru",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
    "Patna",
    "Ranchi",
  ];

  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = allCities;
  }

  void filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = allCities;
      } else {
        filteredCities = allCities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void addRecentSearch(String city) {
    setState(() {
      if (!recentSearches.contains(city)) {
        recentSearches.insert(0, city);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                onChanged: filterCities,
                decoration: InputDecoration(
                  hintText: "Search City...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
        
              // Recent Searches
              if (recentSearches.isNotEmpty) ...[
                const Text(
                  "Recent Searches",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  children: recentSearches.map((city) {
                    return Chip(
                      label: Text(city),
                      onDeleted: () {
                        setState(() {
                          recentSearches.remove(city);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 15),
              ],
        
              // Top Cities
              const Text(
                "Top Cities",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 180,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: topCities.length,
                  itemBuilder: (context, index) {
                    final city = topCities[index];
                    return GestureDetector(
                      onTap: () {
                        addRecentSearch(city);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Selected ${city}")),
                        );
                      },
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    city,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                city,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        
              const SizedBox(height: 15),
        
              // All Cities
              const Text(
                "All Cities",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    final city = filteredCities[index];
                    return ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(city),
                      onTap: () {
                        addRecentSearch(city);
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Selected $city")));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
