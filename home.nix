{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  programs.git = {
  	enable = true;
	userName = "ben-hampson";
	userEmail = "email@email.com";
  };

  programs.gh = {
  	enable = true;
	gitCredentialHelper.enable = true;
  };

  programs.firefox = {
    enable = true;
    profiles.ben = {
 # #  Unable to get pkgs so far.
 #      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
	# ublock-origin
	# vimium
	# translate-web-pages
 #      ];
    };
  };
  

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neovim
    alacritty
    stow
    thunderbird
    wget
    python38
    unzip
    gcc11
    neofetch
    rofi
    spice-vdagent
    ripgrep

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];



  programs = {
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
    };
  };

  programs = {
    tmux = {
      enable = true;
      clock24 = true;
      plugins = with pkgs; [
	      tmuxPlugins.catppuccin	
      ];
      extraConfig = ''
	# Set true colour
	set -g default-terminal "$TERM"
	set -ga terminal-overrides ",$TERM:Tc"

	# Shift + Alt + Vim keys to switch back and forth between windows
	bind -n M-H previous-window
	bind -n M-L next-window

	set -g @plugin 'tmux-plugins/tpm'
	set -g @plugin 'tmux-plugins/tmux-sensible'
	set -g @plugin 'christoomey/vim-tmux-navigator'
	set -g @plugin 'dreamsofcode-io/catppuccin-tmux'
	set -g @plugin 'tmux-plugins/tmux-yank'

	# Start windows and panes at 1, not 0
	set -g base-index 1
	set -g pane-base-index 1
	set-window-option -g pane-base-index 1
	set-option -g renumber-windows on

	set -g @catppuccin_flavour 'mocha'

	# Rename window to current dir
	set-option -g status-interval 5
	set-option -g automatic-rename on
	set-option -g automatic-rename-format '#{b:pane_current_path}'

	# Set vi-mode
	set-window-option -g mode-keys vi

	# Reload config file (change file location to your the tmux.conf you want to use)
	bind r source-file ~/.config/tmux/tmux.conf

	# -- Keybindings --
	# Set prefix
	unbind C-b
	set -g prefix C-Space
	bind C-Space send-prefix

	# Split panes using | and -
	# In new panes, use current path as dir
	# bind | split-window -h -c "#{pane_current_path}"
	# bind - split-window -v -c "#{pane_current_path}"

	# Split panes using \ and '
	# In new panes, use current path as dir
	bind \\ split-window -h -c "#{pane_current_path}"
	bind \' split-window -v -c "#{pane_current_path}"
	unbind '"'
	unbind %

	# vi mode:
	# 1. Enter copy mode: <prefix>, [
	# 2. Move around with vim keys
	# 3. Select mode: v
	# 	- Toggle select / rectangle-select using Ctrl + v
	# 	- Yank: y
	bind-key -T copy-mode-vi v send-keys -X begin-selection
	bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
	bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

	# kill window without confirmation
	bind-key x kill-pane
      '';
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = dotfiles/.zshrc;
    ".config/alacritty" =
      { 
	source = dotfiles/.config/alacritty;
	recursive = true;
      };

    ".config/i3" =
      { 
	source = dotfiles/.config/i3;
	recursive = true;
      };

    # mkOutOfStoreSymLink means lazy-lock.json is not read-only, so it can be updated when packages update 
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/etc/nixos/dotfiles/.config/nvim";
    ".config/nvim".recursive = true;

    ".local".source = dotfiles/.local;
    ".local".recursive = true;

    ".gitconfig".source = dotfiles/.gitconfig;

    ".background-image".source = dotfiles/.background-image;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ben/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
