let
  bellevueCityHall = room: {
    name = "Bellevue City Hall";
    city = "Bellevue, WA";
    inherit room;
    address = "450 110th Ave NE, Bellevue, WA 98004";
  };

  victrola = {
    name = "Victrola Coffee Roasters";
    city = "Seattle, WA";
    room = "Community Room";
    address = "2060 NW Market St, Seattle, WA 98107";
  };
in
[
  { date = "2026-03-11"; location = bellevueCityHall "1E-110"; upcoming = true; }
  { date = "2026-02-18"; location = bellevueCityHall "1E-110"; }
  { date = "2025-09-27"; location = victrola; }
  { date = "2025-07-27"; location = victrola; }
  { date = "2025-05-24"; location = victrola; }
]
