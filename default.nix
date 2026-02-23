{ pkgs ? import <nixpkgs> {} }:

let
  meetings = import ./meetings.nix;
  html = import ./template.nix meetings;
in
pkgs.writeTextDir "index.html" html
