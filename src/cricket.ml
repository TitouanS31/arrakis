open Graph
open Ffalgo

let source_index = -1
let sink_index = -2

(*
let rec string_repeat str n = 
  let rec loop acu = function 
  | 0 -> acu
  | k -> loop (str ^ acu) (k-1)
  in
    loop str n
*)

let list_combine la lb =
  let comb list x = List.map (fun e -> (x,e)) list in
  List.fold_left (fun l x -> l @ (comb la x)) [] lb

(* Reads a line and return the tuple associated *)
let get_line file =
  let line = input_line file in
  let tokens = String.split_on_char ' ' line in
  let team = List.hd tokens in
  let wins = int_of_string (List.nth tokens 1) in
  let remainingList = List.map (int_of_string) (List.tl (List.tl tokens)) in
  (team,wins,remainingList)

(* Reads the list of all teams and stats. *)
let get_cricket file = 
  let n = int_of_string (input_line file) in 
  let rec loop acu = function
    | 0 -> acu
    | i -> loop ((get_line file)::acu) (i-1)
  in
    List.rev (loop [] n)

(* Return index of the match a vs b among n teams. *)
let rec get_match_index a b n = 
  if a < b
  then a + n*b + n
  else get_match_index b a n

(* Return the graph associated with the team t of the cricket data. *)
let graph_of_cricket data t = 
  let n = List.length data in

  (* All teams except team t. *)
  let teams = List.filter (fun x -> x <> t) (List.init n (fun x -> x)) in

  (* Number of wins of team t. *)
  let (_,wins_t,remainingList_t) = List.nth data t in

  (* Number of remaining matches of team t. *)
  let nbRemainingMatches_t = List.fold_left (+) 0 remainingList_t in

  (* All matches (a,b) without team t, a < b.*)
  let matches = List.filter (fun (a,b) -> a < b) (list_combine teams teams) in
  let graph = empty_graph in
  let graph = new_node graph (source_index) in (*source*)
  let graph = new_node graph (sink_index) in (*sink*)
  let graph = List.fold_left (fun g i -> new_node g i) graph teams in

  (* Add nodes for remaining matches. *)
  let f1 g (a,b) = 
    new_node g (get_match_index a b n)
  in
  let graph = List.fold_left f1 graph matches in 

  (* Add arcs starting from source. *)
  let f2 g (a,b) =
    let (_,_,remainingList) = List.nth data a in
    let rem = List.nth remainingList b in
    let match_index = get_match_index a b n in
    new_arc g {src=source_index; tgt=match_index; lbl=rem}
  in
  let graph = List.fold_left f2 graph matches in 
  
  (* Add infinte arcs from matches to teams involved in the matches. *)
  let f3 g (a,b) =
    let match_index = get_match_index a b n in
    let gtemp = new_arc g {src=match_index; tgt=a; lbl=Int.max_int} in
    new_arc gtemp {src=match_index; tgt=b; lbl=Int.max_int}
  in
  let graph = List.fold_left f3 graph matches in

  (* Add arcs from teams to sink. *)
  let f4 g a = 
    let (_,wins_a,_) = List.nth data a in
    let arc = {src=a; tgt=sink_index; lbl = wins_t + nbRemainingMatches_t - wins_a} in
    new_arc g arc
  in
  let graph = List.fold_left f4 graph teams in
  graph


(* Return true if the source s is saturated. *)
let check_sat graph s = 
  let arcs = out_arcs graph s in
  List.for_all (fun a -> match a.lbl with (x,y) -> x=y) arcs


let analyze_cricket path = 
  let file = open_in path in
  let data = get_cricket file in
  let n = List.length data in
  let teams = List.init n (fun x -> x) in
  let f t = 
    let (name,_,_) = List.nth data t in
    let graph = graph_of_cricket data t in
    let final_graph = ford_fulkerson graph source_index sink_index in
    let can_win = check_sat final_graph source_index in
    (name,can_win,final_graph)
  in
  List.map f teams
