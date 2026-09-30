def heading:
  {packages: "Packages", programs: "Programs", services: "Services"}[.];

def version: if (.version // "") == "" then .name else .version end;

def pad($width): . + ((" " * ($width - length)) // "");

def changes($old; $new):
  $new
  | to_entries
  | map(
    select($old[.key] != null and ($old[.key] | version) != (.value | version))
    | {label: .key, from: ($old[.key] | version), to: (.value | version)}
  )
  | sort_by(.label);

def render($section):
  (map(.label | length) | max) as $labels
  | (map(.from | length) | max) as $versions
  | ($section | heading) + "\n"
    + (map("  " + (.label | pad($labels)) + "  " + (.from | pad($versions)) + " -> " + .to)
      | join("\n"));

. as [$old, $new]
| ["packages", "programs", "services"]
| map({section: ., rows: changes($old[.] // {}; $new[.] // {})}) as $sections
| ($sections | map(.rows | length) | add) as $changed
| ($new | to_entries | map(.value | length) | add) as $tracked
| if $changed == 0
  then "No version changes in the \($tracked) tracked packages."
  else
    ($sections
      | map(select(.rows | length > 0) | . as $s | $s.rows | render($s.section))
      | join("\n\n"))
    + "\n\n\($changed) of \($tracked) tracked packages changed."
  end
