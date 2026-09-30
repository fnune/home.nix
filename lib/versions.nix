home:
let
  inherit (home) config pkgs;
  inherit (pkgs) lib;
  inherit (builtins)
    attrNames
    concatMap
    elem
    filter
    isAttrs
    isString
    listToAttrs
    ;

  orElse =
    fallback: expr:
    let
      attempt = builtins.tryEval expr;
    in
    if attempt.success && attempt.value != null then attempt.value else fallback;

  entry =
    label: package:
    let
      name = orElse null (
        if isAttrs package && isString (package.name or null) then package.name else null
      );
    in
    lib.optional (name != null) {
      name = label;
      value = {
        inherit name;
        version = orElse "" (package.version or "");
      };
    };

  enabledPackages =
    attribute:
    concatMap (
      name:
      let
        submodule = orElse null config.${attribute}.${name};
        enabled = orElse false ((submodule.enable or false) == true);
      in
      lib.optionals enabled (entry name (submodule.package or null))
    ) (attrNames config.${attribute});

  packages = concatMap (package: entry (orElse "?" (package.pname or package.name)) package) (
    orElse [ ] config.home.packages
  );

  installed = map (item: item.value.name) packages;

  notInstalled =
    attribute: filter (item: !elem item.value.name installed) (enabledPackages attribute);
in
{
  packages = listToAttrs packages;
  programs = listToAttrs (notInstalled "programs");
  services = listToAttrs (notInstalled "services");
}
