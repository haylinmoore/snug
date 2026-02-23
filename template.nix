meetings:

let
  # Date parsing: "YYYY-MM-DD" -> { year, month, day }
  stripZero = s:
    if builtins.stringLength s > 1 && builtins.substring 0 1 s == "0"
    then builtins.substring 1 1 s
    else s;

  parseDate = s: let
    parts = builtins.split "-" s;
  in {
    year = builtins.fromJSON (builtins.elemAt parts 0);
    month = builtins.fromJSON (stripZero (builtins.elemAt parts 2));
    day = builtins.fromJSON (stripZero (builtins.elemAt parts 4));
  };

  # Day of week via Sakamoto's algorithm (0=Sun .. 6=Sat)
  mod = a: b: a - (a / b) * b;
  dayOfWeek = year: month: day: let
    t = [0 3 2 5 0 3 5 1 4 6 2 4];
    y = if month < 3 then year - 1 else year;
  in mod (y + y / 4 - y / 100 + y / 400 + builtins.elemAt t (month - 1) + day) 7;

  dayNames = ["Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat"];
  monthNamesFull = ["January" "February" "March" "April" "May" "June"
                    "July" "August" "September" "October" "November" "December"];
  monthNamesShort = ["Jan" "Feb" "Mar" "Apr" "May" "Jun"
                     "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"];

  # "March 11, 2026"
  formatDateLong = dateStr: let
    d = parseDate dateStr;
    month = builtins.elemAt monthNamesFull (d.month - 1);
  in "${month} ${toString d.day}, ${toString d.year}";

  # "Wed, Feb 18, 2026"
  formatDateShort = dateStr: let
    d = parseDate dateStr;
    dow = builtins.elemAt dayNames (dayOfWeek d.year d.month d.day);
    month = builtins.elemAt monthNamesShort (d.month - 1);
  in "${dow}, ${month} ${toString d.day}, ${toString d.year}";

  # Sort by date (oldest first), then number from 1
  sorted = builtins.sort (a: b: a.date < b.date) meetings;
  len = builtins.length sorted;
  numbered = builtins.genList (i:
    (builtins.elemAt sorted i) // { number = i + 1; }
  ) len;

  upcomingMeetings = builtins.filter (m: m.upcoming or false) numbered;
  pastMeetings = builtins.filter (m: !(m.upcoming or false)) numbered;
  # Past meetings newest-first for display
  pastMeetingsReversed = builtins.sort (a: b: a.date > b.date) pastMeetings;

  nextMeeting = builtins.head upcomingMeetings;

  renderNextMeeting = m: let
    d = parseDate m.date;
    dow = builtins.elemAt dayNames (dayOfWeek d.year d.month d.day);
    dateFmt = formatDateLong m.date;
    loc = m.location;
  in ''
    <h2>NEXT MEETING</h2>
    <div class="next">
      <dl>
        <dt>#${toString m.number} — ${dow}, ${dateFmt}</dt>
        <dd>Room ${loc.room}, ${loc.name}<br>${loc.address}</dd>
      </dl>
    </div>
  '';

  renderPastRow = m: let
    dateFmt = formatDateShort m.date;
    loc = m.location;
  in ''
      <tr><td>${toString m.number}</td><td>${dateFmt}</td><td>${loc.name}, ${loc.city}</td></tr>'';

  renderPastMeetings = ms: ''
    <h2>PAST MEETINGS</h2>
    <table>
      <tr><th>#</th><th>Date</th><th>Location</th></tr>
  ${builtins.concatStringsSep "\n" (map renderPastRow ms)}
    </table>'';

in
''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Seattle NIX User Group</title>
  <style>
    body {
      font-family: monospace;
      background: #1a1a1a;
      color: #ddd;
      max-width: 600px;
      margin: 2em auto;
      padding: 0 1em;
    }
    pre {
      font-size: clamp(0.5em, 2.5vw, 1em);
      overflow-x: auto;
    }
    h1 {
      font-size: 1.5em;
      font-weight: normal;
      margin-bottom: 0;
    }
    h2 {
      font-size: 1.2em;
      font-weight: normal;
      margin-top: 1.5em;
      margin-bottom: 0.5em;
    }
    p { margin: 0.5em 0; }
    hr {
      border: none;
      border-top: 1px solid #333;
      margin: 1em 0;
    }
    .next {
      border: 1px solid #444;
      border-left: 3px solid #5fb8f2;
      padding: 1em;
      margin-top: 1em;
    }
    .next dt { font-weight: bold; }
    .accent { color: #5fb8f2; }
    dt {
      color: #888;
      margin-top: 0.5em;
    }
    dd { margin-left: 2em; }
    table {
      border-collapse: collapse;
      margin-top: 0.5em;
      width: 100%;
    }
    th, td {
      text-align: left;
      padding: 0.25em 1.5em 0.25em 0;
    }
    th {
      color: #888;
      border-bottom: 1px solid #333;
    }
  </style>
</head>
<body>
  <h1>Seattle <span class="accent">NIX</span> User Group</h1>
  <p>A casual meetup for Nix users and the Nix-curious in the Seattle area.</p>
  <p>We meet the second Wednesday of each month, 6:00-8:00 PM.</p>
  <hr>

${renderNextMeeting nextMeeting}
  <hr>

${renderPastMeetings pastMeetingsReversed}
</body>
</html>
''
