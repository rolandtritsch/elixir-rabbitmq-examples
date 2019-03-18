gnome-terminal -- bash -c "mix run lib/receive.exs roland 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs roland 200 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs karl 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs karl 200 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs karl 500 3000"

gnome-terminal -- bash -c "mix run lib/send.exs roland 100 100"
gnome-terminal -- bash -c "mix run lib/send.exs karl 100 100"
