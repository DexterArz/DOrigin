if status is-interactive
set fish_greeting 
  # Commands to run in interactive sessions can go here
starship init fish | source  
end
export PATH="$HOME/.local/bin:$PATH"
