meetings:

let
  formatIcalDate = dateStr:
    builtins.replaceStrings ["-"] [""] dateStr;

  escapeIcal = s:
    builtins.replaceStrings ["\\" ";" ","] ["\\\\" "\\;" "\\,"] s;

  sorted = builtins.sort (a: b: a.date < b.date) meetings;
  len = builtins.length sorted;
  numbered = builtins.genList (i:
    (builtins.elemAt sorted i) // { number = i + 1; }
  ) len;

  formatIcalTime = t: let
    hours = t / 100;
    minutes = t - (hours * 100);
    hStr = if hours < 10 then "0${toString hours}" else toString hours;
    mStr = if minutes < 10 then "0${toString minutes}" else toString minutes;
  in "${hStr}${mStr}00";

  renderEvent = m: let
    date = formatIcalDate m.date;
    loc = m.location;
    location = escapeIcal "Room ${loc.room}, ${loc.name}, ${loc.address}";
    dtstart = formatIcalTime m.start;
    dtend = formatIcalTime m.end;
  in ''
    BEGIN:VEVENT
    UID:meeting-${toString m.number}@seattlenix.org
    DTSTART;TZID=America/Los_Angeles:${date}T${dtstart}
    DTEND;TZID=America/Los_Angeles:${date}T${dtend}
    SUMMARY:SNUG #${toString m.number}
    LOCATION:${location}
    END:VEVENT'';

in
''
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//SNUG//Seattle NIX User Group//EN
X-WR-CALNAME:Seattle NIX User Group
${builtins.concatStringsSep "\n" (map renderEvent numbered)}
END:VCALENDAR
''
