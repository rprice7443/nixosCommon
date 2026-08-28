{ self }:
{
  default = import ./default.nix { inherit self; };
}
