{pkgs, ...}:
  pkgs.stdenv.mkDerivation {
    name = "aisession";
    src = ./.;
    
    installPhase = ''
      mkdir -p $out/bin $out/share/aisession
      cp aisession.py $out/share/aisession/
      cp aisession-instructions.md $out/share/aisession/
      
      cat > $out/bin/aisession <<EOF
#!/bin/sh
exec ${pkgs.python3}/bin/python3 $out/share/aisession/aisession.py "\$@"
EOF
      chmod +x $out/bin/aisession
    '';
  }
