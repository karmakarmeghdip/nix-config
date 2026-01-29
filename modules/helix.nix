{ config, pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # TypeScript/JavaScript
      vtsls

      # Rust
      rust-analyzer

      # Web (HTML, CSS, JSON, ESLint)
      vscode-langservers-extracted

      # Tailwind CSS
      tailwindcss-language-server

      # TOML
      taplo

      # YAML
      yaml-language-server

      # Nix
      nixd
      nixfmt

      # Markdown
      marksman
    ];

    languages = {
      language-server = {
        vtsls = {
          command = "vtsls";
          args = [ "--stdio" ];
        };

        rust-analyzer = {
          command = "rust-analyzer";
        };

        vscode-html-language-server = {
          command = "vscode-html-language-server";
          args = [ "--stdio" ];
        };

        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = [ "--stdio" ];
        };

        vscode-json-language-server = {
          command = "vscode-json-language-server";
          args = [ "--stdio" ];
        };

        tailwindcss-ls = {
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };

        taplo = {
          command = "taplo";
          args = [
            "lsp"
            "stdio"
          ];
        };

        yaml-language-server = {
          command = "yaml-language-server";
          args = [ "--stdio" ];
        };

        nixd = {
          command = "nixd";
        };

        marksman = {
          command = "marksman";
          args = [ "server" ];
        };
      };

      language = [
        {
          name = "typescript";
          language-servers = [ "vtsls" ];
          auto-format = true;
        }
        {
          name = "tsx";
          language-servers = [
            "vtsls"
            "tailwindcss-ls"
          ];
          auto-format = true;
        }
        {
          name = "javascript";
          language-servers = [ "vtsls" ];
          auto-format = true;
        }
        {
          name = "jsx";
          language-servers = [
            "vtsls"
            "tailwindcss-ls"
          ];
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          auto-format = true;
        }
        {
          name = "html";
          language-servers = [
            "vscode-html-language-server"
            "tailwindcss-ls"
          ];
          auto-format = true;
        }
        {
          name = "css";
          language-servers = [
            "vscode-css-language-server"
            "tailwindcss-ls"
          ];
          auto-format = true;
        }
        {
          name = "json";
          language-servers = [ "vscode-json-language-server" ];
          auto-format = true;
        }
        {
          name = "toml";
          language-servers = [ "taplo" ];
          auto-format = true;
        }
        {
          name = "yaml";
          language-servers = [ "yaml-language-server" ];
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = [ "nixd" ];
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
        }
        {
          name = "markdown";
          language-servers = [ "marksman" ];
          auto-format = true;
        }
      ];
    };
  };
}
