gnome-terminal -- bash -c "mix run lib/receive.exs '#' 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs '#' 200 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs 'karl.#' 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs 'roland.#' 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs 'roland.#' 200 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs '#.positive' 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs '#.negative' 100 3000"
gnome-terminal -- bash -c "mix run lib/receive.exs '*.relationships.*' 100 3000"

gnome-terminal -- bash -c "mix run lib/send.exs roland.concerts.positive 100 100"
gnome-terminal -- bash -c "mix run lib/send.exs roland.relationships.negative 100 100"
gnome-terminal -- bash -c "mix run lib/send.exs karl.relationships.positive 100 100"
