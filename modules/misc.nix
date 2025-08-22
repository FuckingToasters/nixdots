{ pkgs, inputs, ... }:
{
  environment.systemPackages = [ 
     inputs.bzmenu.packages.${pkgs.system}.default
     inputs.iwmenu.packages.${pkgs.system}.default
     inputs.pwmenu.packages.${pkgs.system}.default
  ];
}
