open Graph

let rec string_repeat str n = 
  let rec loop acu = function 
  | 0 -> acu
  | k -> loop (str ^ acu) (k-1)
  in
    loop str n


(* Reads a line with a node. *)
let read_line n =
  let line = read_line () in
  let tokens = String.split_on_char ' ' line in
  let team = List.hd tokens in
  let wins = List.nth tokens 1 in
  let remainingList = List.map (int_of_string) (List.tl (List.tl tokens)) in
  (team,wins,remainingList)

(* let graph_of_string s =  *)