{ pkgs ? import <nixpkgs> {} }:

let
  meetings = import ./meetings.nix;
  html = import ./template.nix meetings;
  ical = import ./calendar.nix meetings;
in
pkgs.symlinkJoin {
  name = "snug-site";
  paths = [
    (pkgs.writeTextDir "index.html" html)
    (pkgs.writeTextDir "calendar.ics" ical)
  ];
}
