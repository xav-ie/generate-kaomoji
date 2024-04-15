{
  description = "Generate a random kaomoji";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    # Create system-specific outputs for the standard Nix systems
    # https://github.com/numtide/flake-utils/blob/main/default.nix#L3-L9
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        kaomojiJson = pkgs.copyPathToStore (self + "/kaomoji.json");
        myprogram = pkgs.writeShellApplication {
          name = "generate-kaomoji";
          runtimeInputs = [ pkgs.jq ];
          text = ''
            if [[ " $* " == *" --help "* ]]; then
              echo "Usage: $(basename "$0") [options] [JQ filter]"
              echo ""
              echo "Options:"
              echo "  --help            Show this help message and exit"
              echo "  -r, --raw-output  Output raw strings, not JSON texts"
              echo "  [JQ filter]       Apply a custom jq filter to the selected kaomoji"
              echo ""
              echo "Examples:"
              echo ""
              echo "# generate a kaomoji object"
              example1=$("$0")
              echo "> $(basename "$0")"
              echo "$example1"
              echo ""
              echo "# select the raw kaomoji string"
              example2=$(echo "$example1" | jq -r ".value") 
              echo "> $(basename "$0") -r .value"
              echo "$example2"
              exit 0
            fi

            ARRAY=$(cat ${kaomojiJson})
            LENGTH=$(echo "$ARRAY" | jq '.kaomoji | length')
            RAND_INDEX=$((RANDOM % LENGTH))

            RAW_OUTPUT=""
            if [[ " $* " == *" -r "* ]] || [[ " $* " == *" --raw-output "* ]]; then
              RAW_OUTPUT="-r"
            fi

            EXTRA_ARGS=$(echo "$*" | sed -e 's/--raw-output//g' -e 's/-r//g')
            if [[ -z "$EXTRA_ARGS" ]]; then
              EXTRA_ARGS="."
            fi

            echo "$ARRAY" | jq --argjson index $RAND_INDEX '.kaomoji[$index]' | jq $RAW_OUTPUT "$EXTRA_ARGS"
          '';
        };
      in
      {
        packages.default = myprogram;

        apps.default = {
          type = "app";
          program = "${myprogram}/bin/generate-kaomoji";
        };
      });
}
