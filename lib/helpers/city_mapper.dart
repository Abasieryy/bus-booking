int mapCityToBlueBusId(String cityName) {
  return cityNameToId[cityName] ?? -1; // Return -1 or throw error if not found
}

final Map<String, int> cityNameToId = {
  'Hurghada': 13,
  'Sharm El Sheikh': 14,
  'Giza\\Cairo': 15,
  'GizaCairo': 15,
  'Giza Cairo': 15,
  'Alexandria': 16,
  'Dahab': 17,
  'Sohag': 18,
  'North Coast': 19,
  'Luxor': 20,
  'Ain El Sokhna': 22,
  'Qena': 23,
  'Tanta': 24,
  'Matrouh': 25,
  'Asyout': 26,
  'El Tor': 27,
  'Ras Ghareb': 28,
  'Cairo': 29,
  'Sahl Hasheesh': 30,
  'Qus': 31,
  'Sub-Agent': 32,
  'Fayoum': 33,
  'Nuweibaa': 34,
  'Zafarana': 35,
  'Armant': 36,
};

final Map<String, Map<String, int>> cityLocationIdMap = {
  'Hurghada': {
    'El Nasr Street': 18,
    'Watanya-HRG': 24,
    'Sheraton ST.': 36,
    'Senzo Mall': 58,
    'Al Ahyaa': 61,
  },
  'Sharm El Sheikh': {
    'Watanya-SSH': 19,
    'El Ruwaysat': 21,
  },
  'Giza\\Cairo': {
    '6 October - El Shiekh Zayed': 17,
    '6 October - El Hussary': 23,
    'Mehawar ElMoshier': 26,
    'Ramsis': 46,
    'Maadi Ring Rd Watanya': 49,
    'Sekka Club': 50,
    'Emtedad Ramses': 52,
    'Maadi Emarat Misr ': 53,
    'Zayed Chillout Khamayel': 69,
    'Giza': 71,
    'zayed dandy': 129,
  },
  'Alexandria': {
    'Moharam Bek': 22,
    'Sidi Gaber': 41,
  },
  'Dahab': {
    'Dahab': 28,
  },
  'Sohag': {
    'Dar ElTeb': 29,
    'El Ray': 76,
  },
  'North Coast': {
  },
  'Luxor': {
    'Railway station': 47,
    'Esna': 117,
  },
  'Ain El Sokhna': {
  },
  'Qena': {
    'Qena': 51,
    'Qift': 121,
  },
  'Tanta': {
  },
  'Matrouh': {
  },
  'Asyout': {
    'Elmoalmien': 66,
    'ELHILALEY': 101,
  },
  'El Tor': {
    'El Tor': 70,
    'El Tor new road': 116,
    'TOR': 128,
  },
  'Ras Ghareb': {
    'Ras Ghareb': 62,
  },
  'Cairo': {
  },
  'Sahl Hasheesh': {
    'Sahl Hasheesh': 48,
  },
  'Qus': {
    'Qus': 74,
  },
  'Sub-Agent': {
  },
  'Fayoum': {
  },
  'Nuweibaa': {
    'Nuweibaa': 106,
  },
  'Zafarana': {
    'Zafarana': 130,
  },
  'Armant': {
    'Armant': 77,
  },
};