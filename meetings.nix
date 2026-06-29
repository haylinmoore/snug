let
  bellevueCityHall = room: rec {
    name = "Bellevue City Hall";
    label = "${name} Room ${room}";
    city = "Bellevue, WA";
    address = "450 110th Ave NE, Bellevue, WA 98004";
  };

  victrola = rec {
    name = "Victrola Coffee Roasters";
    label = "${name} Community Room";
    city = "Seattle, WA";
    address = "2060 NW Market St, Seattle, WA 98107";
  };

  wsecu = rec {
    name = "WSECU";
    label = "${name} Community Space";
    city = "Seattle, WA";
    address = "1121 NE 45th St, Seattle, WA 98105";
  };
in
[
	{ date = "2026-07-08"; location = wsecu; upcoming = true; start = 1800; end = 2000;}
  { date = "2026-06-10"; location = wsecu; start = 1800; end = 2000;}
  { date = "2026-05-13"; location = wsecu; start = 1800; end = 2000;}
  { date = "2026-04-08"; location = wsecu; start = 1800; end = 2000;}
  { date = "2026-03-11"; location = bellevueCityHall "1E-110"; start = 1800; end = 2000;}
  { date = "2026-02-18"; location = bellevueCityHall "1E-110"; start = 1800; end = 2000;}
  { date = "2025-09-27"; location = victrola; start = 1800; end = 2000; }
  { date = "2025-07-27"; location = victrola; start = 1800; end = 2000; }
  { date = "2025-05-24"; location = victrola; start = 1800; end = 2000; }
]
