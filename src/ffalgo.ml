open Graph
open Tools

(* Return the max flow and its path from s to t. *)
(*
let find_path g s t =
  let table = Hashtbl.create (nb_nodes g) in
  let () = Hashtbl.add table t (Int.max_int,[t]) in
  let rec loop n = 
    let (flow,path) = Hashtbl.find table n in
    let explore e = 
      (* If we have already explore the source. *)
      if Hashtbl.mem table e.src 
      then 
        let (flow_src,_) = Hashtbl.find table e.src in 
        let new_flow = min flow e.lbl in
        if new_flow > flow_src then
          Hashtbl.replace table e.src (new_flow, e.src::path);
          loop e.src
      else 
        Hashtbl.add table e.src (min flow e.lbl, e.src::path);
        loop e.src

    in 
      List.iter explore (in_arcs g n)
  in
    loop t;
    Hashtbl.find_opt table s*)

(* Return an optional path (list of nodes) from s to t. *)
let find_path g s t = 
  let rec loop path n =
    if path <> [] && List.hd path = t then
      path
    else
      let arcs = out_arcs g n in
      List.fold_left (fun p e -> loop p e.tgt) (n::path) arcs
    in

  let rev_path = loop [] s in

  if List.hd rev_path = t
  then Some (List.rev rev_path)
  else None

(* Return the maximal possible flow along the path. *)
let compute_flow g path =
  let arcs = arcs_of_path g path in
  List.fold_left (fun m e -> min m e.lbl) Int.max_int arcs

(* Compute the next graph using the given path and flow. *)
let next_graph g path flow =
  let arcs = arcs_of_path g path in
  let g1 = List.fold_left (fun g e -> add_arc g e.src e.tgt (-flow)) g arcs in
  let g2 = e_filter g1 (fun e -> e.lbl <> 0) in
  let g3 = List.fold_left (fun g e -> new_arc g {src=e.tgt; tgt=e.src; lbl=flow}) g2 arcs in
  g3

(* Compute the Ford-Fulkerson algorithm on the given capacity graph.
  s and t are respectively the source and the sink.
  Return the the flow graph with the given capacity. *)
  (*
let ford_fulkerson graph s t =
  let rec loop g = 
    try
      let (flow,path) = find_path g s t in 
      loop (next_graph g path flow)
    with Not_found -> g
  in
    let g1 = loop graph in
    let f g e = 

    let g2 = e_fold graph f*)